#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAST_DIR="$(ls -1dt "$ROOT"/var/state/flipper_sync_* 2>/dev/null | head -n 1 || true)"
if [[ -z "$LAST_DIR" ]]; then
  echo "[FLIPPER_ANALYZE] Nessuna sincronizzazione trovata."
  exit 0
fi
REPORT="$ROOT/var/state/flipper_report_$(date +%Y%m%d_%H%M%S).txt"
{
  echo "=== FLIPPER ANALYZE REPORT ==="
  echo "Sorgente: $LAST_DIR"
  echo
  echo "[*] Struttura directory:"
  find "$LAST_DIR" -maxdepth 3 -type f | sed "s|$LAST_DIR||"
} > "$REPORT"
python3 "$ROOT/core/logging/eco_log.py" missions "flipper_analyze REPORT=$REPORT"
echo "[FLIPPER_ANALYZE] Report generato: $REPORT"
