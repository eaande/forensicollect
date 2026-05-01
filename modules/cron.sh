#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting cron and scheduled task information..."

{
echo "==== SYSTEM CRONTAB ===="
cat /etc/crontab 2>/dev/null

echo ""
echo "==== CRON.D ===="
ls -la /etc/cron.d 2>/dev/null
cat /etc/cron.d/* 2>/dev/null

echo ""
echo "==== HOURLY CRON ===="
ls -la /etc/cron.hourly 2>/dev/null

echo ""
echo "==== DAILY CRON ===="
ls -la /etc/cron.daily 2>/dev/null

echo ""
echo "==== WEEKLY CRON ===="
ls -la /etc/cron.weekly 2>/dev/null

echo ""
echo "==== MONTHLY CRON ===="
ls -la /etc/cron.monthly 2>/dev/null

echo ""
echo "==== USER CRONTABS ===="
for user in $(cut -f1 -d: /etc/passwd); do
    echo "--- $user ---"
    crontab -l -u "$user" 2>/dev/null
done
} > "$OUTDIR/cron.txt"

echo "[+] Cron collection complete"
