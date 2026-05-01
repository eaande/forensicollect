#!/bin/bash

OUTDIR="$1"

echo "[+] Collecting network information..."

{
echo "==== IP ADDRESSES ===="
ip addr

echo ""
echo "==== ROUTES ===="
ip route

echo ""
echo "==== LISTENING PORTS ===="
ss -tulpen

echo ""
echo "==== ACTIVE CONNECTIONS ===="
ss -antp

echo ""
echo "==== DNS CONFIGURATION ===="
cat /etc/resolv.conf 2>/dev/null

echo ""
echo "==== ARP / NEIGHBOR TABLE ===="
ip neigh
} > "$OUTDIR/network.txt"

{
echo "state,local_address,peer_address,process"
ss -antp | awk 'NR>1 {print $1 "," $4 "," $5 "," $0}'
} > "$OUTDIR/network_connections.csv"

echo "[+] Network collection complete"
