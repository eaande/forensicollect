#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting service information..."

{
echo "==== RUNNING SERVICES ===="
systemctl list-units --type=service --state=running 2>/dev/null

echo ""
echo "==== ENABLED SERVICES ===="
systemctl list-unit-files --type=service --state=enabled 2>/dev/null

echo ""
echo "==== FAILED SERVICES ===="
systemctl --failed 2>/dev/null
} > "$OUTDIR/services.txt"

echo "[+] Service collection complete"
