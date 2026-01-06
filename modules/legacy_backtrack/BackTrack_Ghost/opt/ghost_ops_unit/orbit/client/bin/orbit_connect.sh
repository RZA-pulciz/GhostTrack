#!/usr/bin/env bash
set -e
CONF_DIR="$(dirname "$0")/../config"
ONION_NODE=$(grep ONION_NODE "$CONF_DIR/orbit_client.conf" | cut -d= -f2)

echo "[ORBIT_CONNECT] (scheletro) Nodo configurato: $ONION_NODE"
echo "[ORBIT_CONNECT] Qui in futuro useremo torsocks/curl per contattare il nodo onion."
