#!/bin/bash

VERSION="1.0"

MODE="full"
ARCHIVE=true

for arg in "$@"; do
    case "$arg" in
        --quick)
            MODE="quick"
            ;;
        --full)
            MODE="full"
            ;;
        --auth-only)
            MODE="auth-only"
            ;;
        --no-archive)
            ARCHIVE=false
            ;;
        --help)
            echo "ForensiCollect v$VERSION"
            echo ""
            echo "Usage:"
            echo "  sudo ./forensicollect.sh --full"
            echo "  sudo ./forensicollect.sh --quick"
            echo "  sudo ./forensicollect.sh --auth-only"
            echo "  sudo ./forensicollect.sh --no-archive"
            exit 0
            ;;
        *)
            echo "[!] Unknown option: $arg"
            echo "Use --help for options."
            exit 1
            ;;
    esac
done

CASE_NAME="case_$(date +%Y%m%d_%H%M%S)"
OUTDIR="output/$CASE_NAME"
LOGFILE="$OUTDIR/collection_log.txt"

mkdir -p "$OUTDIR"

echo "[+] ForensiCollect v$VERSION starting..."
echo "[+] Mode: $MODE"
echo "[+] Output directory: $OUTDIR"

{
echo "ForensiCollect Collection Log"
echo "Started: $(date)"
echo "Mode: $MODE"
echo "Collector user: $(whoami)"
echo ""
} > "$LOGFILE"

run_module() {
    MODULE="$1"

    if [[ -f "$MODULE" ]]; then
        echo "[+] Running $MODULE"
        echo "[+] Running $MODULE" >> "$LOGFILE"
        bash "$MODULE" "$OUTDIR" >> "$LOGFILE" 2>&1
    else
        echo "[!] Missing module: $MODULE"
        echo "[!] Missing module: $MODULE" >> "$LOGFILE"
    fi
}

echo "[+] Collecting base system information..."

uname -a > "$OUTDIR/system_info.txt"
hostnamectl > "$OUTDIR/host_info.txt" 2>/dev/null
whoami > "$OUTDIR/current_user.txt"
uptime > "$OUTDIR/uptime.txt"
date > "$OUTDIR/collection_time.txt"

if [[ "$MODE" == "auth-only" ]]; then
    run_module "modules/auth_parser.sh"
    run_module "modules/risk_score.sh"
elif [[ "$MODE" == "quick" ]]; then
    run_module "modules/auth_parser.sh"
    run_module "modules/users.sh"
    run_module "modules/processes.sh"
    run_module "modules/network.sh"
    run_module "modules/risk_score.sh"
else
    run_module "modules/auth_parser.sh"
    run_module "modules/users.sh"
    run_module "modules/processes.sh"
    run_module "modules/network.sh"
    run_module "modules/cron.sh"
    run_module "modules/services.sh"
    run_module "modules/files.sh"
    run_module "modules/persistence.sh"
    run_module "modules/risk_score.sh"
fi

echo "[+] Creating hash manifest..."
sha256sum "$OUTDIR"/* > "$OUTDIR/hash_manifest.txt" 2>/dev/null

if [[ "$ARCHIVE" == true ]]; then
    run_module "modules/package_case.sh"
fi

{
echo ""
echo "Completed: $(date)"
} >> "$LOGFILE"

echo "[+] Collection complete."
echo "[+] Results saved to: $OUTDIR"
echo ""
echo "Generated files:"
ls -lh "$OUTDIR"
