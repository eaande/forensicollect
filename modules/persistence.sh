#!/bin/bash

OUTDIR="$1"

echo "[+] Checking common Linux persistence locations..."

{
echo "==== SSH AUTHORIZED KEYS ===="
find /home /root -name authorized_keys -type f -exec echo "--- {} ---" \; -exec cat {} \; 2>/dev/null

echo ""
echo "==== SYSTEMD SERVICE FILES ===="
ls -la /etc/systemd/system 2>/dev/null

echo ""
echo "==== RC.LOCAL ===="
cat /etc/rc.local 2>/dev/null

echo ""
echo "==== SHELL STARTUP FILES ===="
find /home /root -maxdepth 2 \( -name ".bashrc" -o -name ".profile" -o -name ".bash_profile" \) -exec echo "--- {} ---" \; -exec cat {} \; 2>/dev/null

echo ""
echo "==== SUID FILES ===="
find / -perm -4000 -type f -printf "%p\n" 2>/dev/null
} > "$OUTDIR/persistence_checks.txt"

echo "[+] Persistence checks complete"
