#!/bin/bash

OUTDIR="$1"
AUTH_LOG="/var/log/auth.log"
OUTFILE="$OUTDIR/auth_events.txt"

echo "[+] Parsing auth.log..."

if [[ ! -f "$AUTH_LOG" ]]; then
    echo "auth.log not found" > "$OUTFILE"
    exit 0
fi

echo "==== FAILED SSH LOGINS ====" > "$OUTFILE"
grep "Failed password" "$AUTH_LOG" >> "$OUTFILE"

echo "" >> "$OUTFILE"
echo "==== SUCCESSFUL SSH LOGINS ====" >> "$OUTFILE"
grep "Accepted password" "$AUTH_LOG" >> "$OUTFILE"

echo "" >> "$OUTFILE"
echo "==== SUDO ACTIVITY ====" >> "$OUTFILE"
grep "sudo:" "$AUTH_LOG" >> "$OUTFILE"

echo "[+] Auth parsing complete"
