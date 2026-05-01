#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting recently modified file information..."

{
echo "==== RECENTLY MODIFIED FILES IN /etc ===="
find /etc -type f -mtime -7 -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" 2>/dev/null | sort

echo ""
echo "==== RECENTLY MODIFIED FILES IN /var/log ===="
find /var/log -type f -mtime -7 -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" 2>/dev/null | sort

echo ""
echo "==== WORLD-WRITABLE FILES IN COMMON LOCATIONS ===="
find /tmp /var/tmp /dev/shm -type f -perm -0002 -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" 2>/dev/null
} > "$OUTDIR/recent_files.txt"

{
echo "timestamp,path"
find /etc /var/log -type f -mtime -7 -printf "%TY-%Tm-%Td_%TH:%TM:%TS,%p\n" 2>/dev/null | sort
} > "$OUTDIR/recent_files.csv"

echo "[+] Recent file collection complete"
