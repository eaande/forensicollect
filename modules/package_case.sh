#!/bin/bash

OUTDIR="$1"
CASE_DIR=$(dirname "$OUTDIR")
CASE_NAME=$(basename "$OUTDIR")
ARCHIVE="$CASE_DIR/$CASE_NAME.tar.gz"

echo "[+] Packaging case archive..."

tar -czf "$ARCHIVE" -C "$CASE_DIR" "$CASE_NAME" 2>/dev/null

if [[ -f "$ARCHIVE" ]]; then
    sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"
    echo "[+] Archive created: $ARCHIVE"
    echo "[+] Archive hash created: $ARCHIVE.sha256"
else
    echo "[!] Failed to create archive"
fi
