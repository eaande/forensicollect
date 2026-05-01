#!/bin/bash

OUTDIR="$1"
REPORT="$OUTDIR/risk_report.txt"
SCORE=0

FAILED_COUNT=$(grep -c "Failed password" "$OUTDIR/auth_events.txt" 2>/dev/null)
ROOT_LOGIN_COUNT=$(grep -c "Accepted password for root" "$OUTDIR/auth_events.txt" 2>/dev/null)
NEW_USER_COUNT=$(grep -Ei "new user|useradd|adduser" "$OUTDIR/auth_events.txt" 2>/dev/null | wc -l)
SUDO_COUNT=$(grep -c "sudo:" "$OUTDIR/auth_events.txt" 2>/dev/null)
UID0_COUNT=$(awk -F: '($3 == 0) { print }' /etc/passwd 2>/dev/null | wc -l)
SUSPICIOUS_PORT_COUNT=$(grep -E ":(4444|5555|6666|7777|8888|9999)" "$OUTDIR/network.txt" 2>/dev/null | wc -l)
CRON_COUNT=$(grep -Ev "^#|^$" "$OUTDIR/cron.txt" 2>/dev/null | wc -l)

if [[ "$FAILED_COUNT" -gt 10 ]]; then
    SCORE=$((SCORE + 20))
fi

if [[ "$ROOT_LOGIN_COUNT" -gt 0 ]]; then
    SCORE=$((SCORE + 50))
fi

if [[ "$NEW_USER_COUNT" -gt 0 ]]; then
    SCORE=$((SCORE + 40))
fi

if [[ "$SUDO_COUNT" -gt 5 ]]; then
    SCORE=$((SCORE + 20))
fi

if [[ "$UID0_COUNT" -gt 1 ]]; then
    SCORE=$((SCORE + 80))
fi

if [[ "$SUSPICIOUS_PORT_COUNT" -gt 0 ]]; then
    SCORE=$((SCORE + 30))
fi

if [[ "$CRON_COUNT" -gt 20 ]]; then
    SCORE=$((SCORE + 15))
fi

if [[ "$SCORE" -ge 80 ]]; then
    LEVEL="HIGH"
elif [[ "$SCORE" -ge 40 ]]; then
    LEVEL="MEDIUM"
else
    LEVEL="LOW"
fi

{
echo "==== FORENSIC RISK REPORT ===="
echo "Generated: $(date)"
echo ""
echo "Risk Score: $SCORE / 100"
echo "Risk Level: $LEVEL"
echo ""
echo "==== SIGNALS REVIEWED ===="
echo "Failed SSH attempts: $FAILED_COUNT"
echo "Successful root SSH logins: $ROOT_LOGIN_COUNT"
echo "New user events: $NEW_USER_COUNT"
echo "Sudo activity count: $SUDO_COUNT"
echo "UID 0 account count: $UID0_COUNT"
echo "Suspicious listening/active ports: $SUSPICIOUS_PORT_COUNT"
echo "Cron activity indicators: $CRON_COUNT"
echo ""
echo "==== RECOMMENDED ACTIONS ===="
echo "- Review auth_events.txt and auth_events.csv for suspicious login behavior."
echo "- Investigate any successful root SSH logins."
echo "- Verify all UID 0 accounts are legitimate."
echo "- Review sudo activity for unauthorized privilege escalation."
echo "- Check persistence_checks.txt for suspicious SSH keys, services, startup scripts, or SUID files."
echo "- Preserve the output directory and hash_manifest.txt for evidence integrity."
} > "$REPORT"

echo "[+] Risk scoring complete"
