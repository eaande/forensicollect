#!/bin/bash

echo "[+] ForensiCollect starting..."

CASE_NAME="case_$(date +%Y%m%d_%H%M%S)"
OUTDIR="output/$CASE_NAME"

mkdir -p "$OUTDIR"

echo "[+] Output directory: $OUTDIR"

# Basic system info
echo "[+] Collecting system info..."
uname -a > "$OUTDIR/system_info.txt"
whoami > "$OUTDIR/current_user.txt"
uptime > "$OUTDIR/uptime.txt"

echo "[+] Collection complete."
