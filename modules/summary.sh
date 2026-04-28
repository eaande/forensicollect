#!/bin/bash

OUTDIR="$1"
SUMMARY_FILE="$OUTDIR/summary.txt"
RISK_FILE="$OUTDIR/high_risk_events.txt"

echo "[+] Creating investigation summary..."

FAILED_COUNT=$(grep -c "Failed password" "$OUTDIR/auth_events.txt" 2>/dev/null)
SUCCESS_COUNT=$(grep -c "Accepted password" "$OUTDIR/auth_events.txt" 2>/dev/null)
SUDO_COUNT=$(grep -c "sudo:" "$OUTDIR/auth_events.txt" 2>/dev/null)
ROOT_LOGIN_COUNT=$(grep -c "Accepted password for root" "$OUTDIR/auth_events.txt" 2>/dev/null)

{
echo "==== FORENSIC SUMMARY ===="
echo "Generated: $(date)"
echo ""
echo "KEY FINDINGS:"
echo "- Failed SSH login attempts detected: $FAILED_COUNT"
echo "- Successful SSH logins detected: $SUCCESS_COUNT"
echo "- Sudo / privilege escalation events detected: $SUDO_COUNT"
echo "- Successful root SSH logins detected: $ROOT_LOGIN_COUNT"
echo ""

echo "RISK LEVEL:"
if [[ "$ROOT_LOGIN_COUNT" -gt 0 ]]; then
    echo "HIGH"
elif [[ "$FAILED_COUNT" -gt 5 || "$SUDO_COUNT" -gt 3 ]]; then
    echo "MEDIUM"
else
    echo "LOW"
fi

echo ""
echo "RECOMMENDED ACTIONS:"
echo "- Review high_risk_events.txt for suspicious authentication activity."
echo "- Investigate repeated failed SSH attempts and unknown source IP addresses."
echo "- Verify sudo activity was performed by authorized users."
echo "- Confirm no unauthorized users or root logins occurred."
echo "- Preserve output folder and hash_manifest.txt as evidence."
} > "$SUMMARY_FILE"

echo "[+] Summary created: $SUMMARY_FILE"
