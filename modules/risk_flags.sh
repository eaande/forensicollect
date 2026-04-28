#!/bin/bash

OUTDIR="$1"
AUTH_FILE="$OUTDIR/auth_events.txt"
RISK_FILE="$OUTDIR/high_risk_events.txt"

echo "[+] Flagging high-risk events..."

echo "==== HIGH-RISK EVENTS ====" > "$RISK_FILE"
echo "Generated: $(date)" >> "$RISK_FILE"
echo "" >> "$RISK_FILE"

if [[ ! -f "$AUTH_FILE" ]]; then
    echo "No auth_events.txt file found." >> "$RISK_FILE"
    exit 0
fi

echo "[HIGH] Successful root SSH logins:" >> "$RISK_FILE"
grep "Accepted password for root" "$AUTH_FILE" >> "$RISK_FILE"
echo "" >> "$RISK_FILE"

echo "[MEDIUM] Failed SSH login attempts:" >> "$RISK_FILE"
grep "Failed password" "$AUTH_FILE" >> "$RISK_FILE"
echo "" >> "$RISK_FILE"

echo "[MEDIUM] Sudo activity / privilege escalation:" >> "$RISK_FILE"
grep "sudo:" "$AUTH_FILE" >> "$RISK_FILE"
echo "" >> "$RISK_FILE"

echo "[+] Risk flagging complete: $RISK_FILE"
