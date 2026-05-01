#!/bin/bash

OUTDIR="$1"
AUTH_LOG="/var/log/auth.log"
ALT_AUTH_LOG="/var/log/secure"

AUTH_OUT="$OUTDIR/auth_events.txt"
AUTH_CSV="$OUTDIR/auth_events.csv"

echo "[+] Parsing authentication logs..."

if [[ -f "$AUTH_LOG" ]]; then
    LOGFILE="$AUTH_LOG"
elif [[ -f "$ALT_AUTH_LOG" ]]; then
    LOGFILE="$ALT_AUTH_LOG"
else
    echo "No supported authentication log found." > "$AUTH_OUT"
    echo "timestamp,event_type,user,source_ip,raw_event" > "$AUTH_CSV"
    exit 0
fi

{
echo "==== AUTHENTICATION EVENTS ===="
echo "Source log: $LOGFILE"
echo ""

echo "==== FAILED SSH LOGINS ===="
grep "Failed password" "$LOGFILE"

echo ""
echo "==== SUCCESSFUL SSH LOGINS ===="
grep "Accepted password" "$LOGFILE"

echo ""
echo "==== NEW USER EVENTS ===="
grep -Ei "new user|useradd|adduser" "$LOGFILE"

echo ""
echo "==== SUDO / PRIVILEGE ESCALATION EVENTS ===="
grep "sudo:" "$LOGFILE"

echo ""
echo "==== SU COMMAND EVENTS ===="
grep -Ei "su:|session opened for user root" "$LOGFILE"
} > "$AUTH_OUT"

echo "timestamp,event_type,user,source_ip,raw_event" > "$AUTH_CSV"

grep "Failed password" "$LOGFILE" | while read -r line; do
    timestamp=$(echo "$line" | awk '{print $1" "$2" "$3}')
    user=$(echo "$line" | grep -oP 'for( invalid user)? \K\S+' 2>/dev/null)
    ip=$(echo "$line" | grep -oP 'from \K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' 2>/dev/null)
    echo "\"$timestamp\",\"FAILED_SSH\",\"$user\",\"$ip\",\"$line\"" >> "$AUTH_CSV"
done

grep "Accepted password" "$LOGFILE" | while read -r line; do
    timestamp=$(echo "$line" | awk '{print $1" "$2" "$3}')
    user=$(echo "$line" | grep -oP 'for \K\S+' 2>/dev/null)
    ip=$(echo "$line" | grep -oP 'from \K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' 2>/dev/null)
    echo "\"$timestamp\",\"SUCCESSFUL_SSH\",\"$user\",\"$ip\",\"$line\"" >> "$AUTH_CSV"
done

grep -Ei "new user|useradd|adduser" "$LOGFILE" | while read -r line; do
    timestamp=$(echo "$line" | awk '{print $1" "$2" "$3}')
    user=$(echo "$line" | grep -oP 'name=\K[^, ]+' 2>/dev/null)
    echo "\"$timestamp\",\"NEW_USER\",\"$user\",\"N/A\",\"$line\"" >> "$AUTH_CSV"
done

grep "sudo:" "$LOGFILE" | while read -r line; do
    timestamp=$(echo "$line" | awk '{print $1" "$2" "$3}')
    user=$(echo "$line" | awk -F'sudo: ' '{print $2}' | awk '{print $1}')
    echo "\"$timestamp\",\"SUDO_ACTIVITY\",\"$user\",\"N/A\",\"$line\"" >> "$AUTH_CSV"
done

echo "[+] Authentication parsing complete"
