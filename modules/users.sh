#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting user and group information..."

{
echo "==== USER ACCOUNTS ===="
cat /etc/passwd

echo ""
echo "==== GROUPS ===="
cat /etc/group

echo ""
echo "==== UID 0 ACCOUNTS ===="
awk -F: '($3 == 0) { print }' /etc/passwd

echo ""
echo "==== USERS WITH LOGIN SHELLS ===="
awk -F: '($7 ~ /(bash|sh|zsh)$/) { print }' /etc/passwd

echo "'
echo "==== CURRENTLY LOGGED IN USERS ===="
who

echo ""
echo "==== LAST LOGINS ===="
last -a | head -n 25
} > "$OUTDIR/users.txt"

{
echo "username,uid,gid,home,shell"
awk -F: '{print $1 "," $3 "," $4 "," $6 "," $7}' /etc/passwd
} > "$OUTDIR/users.csv"

echo "[+] User collection complete"
