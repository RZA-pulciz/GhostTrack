#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
FLIPPER_PATH="${FLIPPER_MOUNT_PATH:-}"
if [[ -z "$FLIPPER_PATH" || ! -d "$FLIPPER_PATH" ]]; then
  echo "[FLIPPER_SYNC] FLIPPER_MOUNT_PATH non valido. Configuralo in .env"
  exit 1
fi
DEST="$ROOT/var/state/flipper_sync_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$DEST"
cp -r "$FLIPPER_PATH"/* "$DEST"/ 2>/dev/null || true
python3 "$ROOT/core/logging/eco_log.py" missions "flipper_sync DEST=$DEST"
echo "[FLIPPER_SYNC] Dati copiati in: $DEST"
