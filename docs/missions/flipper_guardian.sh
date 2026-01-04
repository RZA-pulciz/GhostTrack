#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
FLIPPER_PATH="${FLIPPER_MOUNT_PATH:-}"
STATUS="$ROOT/var/state/flipper_guardian_status.txt"
{
  echo "=== FLIPPER GUARDIAN STATUS ==="
  date
  if [[ -z "$FLIPPER_PATH" || ! -d "$FLIPPER_PATH" ]]; then
    echo "[!] Flipper non rilevato o percorso non valido."
  else
    echo "[+] Flipper rilevato in: $FLIPPER_PATH"
    df -h "$FLIPPER_PATH" 2>/dev/null || echo "Spazio non disponibile."
    echo
    echo "[*] Directory principali:"
    find "$FLIPPER_PATH" -maxdepth 2 -type d
  fi
} > "$STATUS"
python3 "$ROOT/core/logging/eco_log.py" missions "flipper_guardian STATUS=$STATUS"
echo "[FLIPPER_GUARDIAN] Stato scritto in: $STATUS"
