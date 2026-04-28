#!/bin/bash

echo "[+] ForensiCollect starting..."

CASE_NAME="case_$(date +%Y%m%d_%H%M%S)"
OUTDIR="output/$CASE_NAME"

mkdir -p "$OUTDIR"

echo "[+] Output directory: $OUTDIR"

# System info collection
echo "[+] Collecting system information..."
uname -a > "$OUTDIR/system_info.txt"
whoami > "$OUTDIR/current_user.txt"
uptime > "$OUTDIR/uptime.txt"
hostnamectl > "$OUTDIR/host_info.txt" 2>/dev/null

# Run DFIR modules
bash modules/auth_parser.sh "$OUTDIR"
bash modules/risk_flags.sh "$OUTDIR"
bash modules/timeline.sh "$OUTDIR"
bash modules/summary.sh "$OUTDIR"

# Evidence integrity
sha256sum "$OUTDIR"/* > "$OUTDIR/hash_manifest.txt" 2>/dev/null

echo "[+] Collection complete."
echo "[+] Results saved to: $OUTDIR"
echo ""
echo "Generated files:"
ls -lh "$OUTDIR"
