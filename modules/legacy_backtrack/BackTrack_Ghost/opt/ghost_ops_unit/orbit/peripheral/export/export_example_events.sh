#!/usr/bin/env bash
set -e
OUT_FILE="ghost_peripheral/logs/example_events.json"
mkdir -p "$(dirname "$OUT_FILE")"

cat > "$OUT_FILE" << JSON
{
  "type": "wifi_scan",
  "timestamp": "$(date +%s)",
  "networks": [
    {"ssid": "FreeWiFi", "rssi": -60},
    {"ssid": "Biblioteca", "rssi": -72}
  ]
}
JSON

echo "[PERIPHERAL] Eventi di esempio esportati in $OUT_FILE"
