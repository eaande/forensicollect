#!/bin/bash

echo "[+] ForensiCollect starting..."

CASE_NAME="case_$(date +%Y%m%d_%H%M%S)"
OUTDIR="output/$CASE_NAME"

mkdir -p "$OUTDIR"

echo "[+] Output directory: $OUTDIR"

# System info
uname -a > "$OUTDIR/system_info.txt"
whoami > "$OUTDIR/current_user.txt"
uptime > "$OUTDIR/uptime.txt"

# Run modules
bash modules/auth_parser.sh "$OUTDIR"

echo "[+] Collection complete."
