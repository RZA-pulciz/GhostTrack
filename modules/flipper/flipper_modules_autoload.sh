#!/usr/bin/env bash
set -e

ROOT="$(pwd)"

mkdir -p missions var/state

echo "[FLIPPER_AUTOLOAD] Creo/aggiorno moduli Flipper..."

# FLIPPER SYNC – copia dati dal Flipper (solo tuoi)
cat > missions/flipper_sync.sh << 'EOM'
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
EOM

# FLIPPER ANALYZE – analizza i file sincronizzati (solo lettura)
cat > missions/flipper_analyze.sh << 'EOM'
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
EOM

# FLIPPER GUARDIAN – monitora stato base (spazio, presenza, struttura)
cat > missions/flipper_guardian.sh << 'EOM'
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
EOM

chmod +x missions/flipper_sync.sh missions/flipper_analyze.sh missions/flipper_guardian.sh

echo "[FLIPPER_AUTOLOAD] Moduli creati. Puoi usarli con:"
echo "  ghost_mission missions/flipper_sync.sh flipper_sync"
echo "  ghost_mission missions/flipper_analyze.sh flipper_analyze"
echo "  ghost_mission missions/flipper_guardian.sh flipper_guardian"

