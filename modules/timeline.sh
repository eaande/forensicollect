#!/bin/bash

OUTDIR="$1"
TIMELINE="$OUTDIR/timeline.txt"

echo "[+] Generating timeline..."

echo "==== FORENSIC TIMELINE ====" > "$TIMELINE"
echo "Generated: $(date)" >> "$TIMELINE"
echo "" >> "$TIMELINE"

if [[ -f "$OUTDIR/auth_events.txt" ]]; then
    grep -E "Failed password|Accepted password|sudo:" "$OUTDIR/auth_events.txt" \
    | sort >> "$TIMELINE"
else
    echo "No auth_events.txt file found." >> "$TIMELINE"
fi

echo "[+] Timeline created: $TIMELINE"
