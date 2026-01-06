#!/usr/bin/env bash
set -e

PORT=9999
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[GHOST_ONION_NODE] Nodo locale in ascolto su http://localhost:$PORT"
echo "[GHOST_ONION_NODE] (scheletro) Risponde solo a /api/heartbeat"

while true; do
  # Attende una connessione HTTP e risponde solo a /api/heartbeat
  { 
    read REQUEST_LINE
    echo "$REQUEST_LINE" | grep -q "GET /api/heartbeat" || {
      # Consuma il resto della richiesta e risponde 404
      while read line && [ "$line" != $'\r' ]; do :; done
      echo -e "HTTP/1.1 404 Not Found\r"
      echo -e "Content-Type: text/plain\r"
      echo -e "\r"
      echo "Not Found"
      continue
    }

    # Consuma header
    while read line && [ "$line" != $'\r' ]; do :; done

    RESPONSE="$("$BASE_DIR/api/heartbeat.sh")"

    echo -e "HTTP/1.1 200 OK\r"
    echo -e "Content-Type: application/json\r"
    echo -e "\r"
    echo "$RESPONSE"
  } | nc -l -p "$PORT" -q 1
done
