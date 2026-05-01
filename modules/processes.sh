#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting process information..."

{
echo "==== RUNNING PROCESSES ===="
ps aux

echo ""
echo "==== PROCESS TREE ===="
pstree -a 2>/dev/null || ps -ef --forest

echo ""
echo "==== TOP CPU PROCESSES ===="
ps aux --sort=-%cpu | head -n 15

echo ""
echo "==== TOP MEMORY PROCESSES ===="
ps aux --sort=-%mem | head -n 15
} > "$OUTDIR/processes.txt"

{
echo "user,pid,cpu,mem,command"
ps aux | awk 'NR>1 {print $1 "," $2 "," $3 "," $4 "," substr($0, index($0,$11))}'
} > "$OUTDIR/processes.csv"

echo "[+] Process collection complete"
