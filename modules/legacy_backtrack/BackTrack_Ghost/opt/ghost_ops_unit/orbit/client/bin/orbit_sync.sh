#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONF_FILE="$BASE_DIR/config/orbit_client.conf"

if [ ! -f "$CONF_FILE" ]; then
  echo "[ORBIT_SYNC] Config non trovata: $CONF_FILE"
  exit 1
fi

ONION_NODE=$(grep '^ONION_NODE=' "$CONF_FILE" | cut -d= -f2)
TOR_PROXY=$(grep '^TOR_PROXY=' "$CONF_FILE" | cut -d= -f2)

if [ -z "$ONION_NODE" ]; then
  echo "[ORBIT_SYNC] ONION_NODE non definito in $CONF_FILE"
  exit 1
fi

echo "[ORBIT_SYNC] Nodo onion configurato: $ONION_NODE"
echo "[ORBIT_SYNC] Proxy Tor (intenzione): $TOR_PROXY"

CMD="curl -s http://$ONION_NODE/api/heartbeat"

if command -v torsocks >/dev/null 2>&1; then
  echo "[ORBIT_SYNC] Uso torsocks per la chiamata (se Tor è attivo)."
  CMD="torsocks $CMD"
else
  echo "[ORBIT_SYNC] torsocks non trovato. Eseguo comunque il comando (solo ambiente di test)."
fi

echo "[ORBIT_SYNC] Eseguo: $CMD"
RESPONSE=$(eval "$CMD" || echo "")

if [ -n "$RESPONSE" ]; then
  echo "[ORBIT_SYNC] Risposta dal nodo:"
  echo "$RESPONSE"
else
  echo "[ORBIT_SYNC] Nessuna risposta (nodo non raggiungibile o Tor non attivo)."
fi
