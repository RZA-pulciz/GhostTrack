#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="$ROOT/var/state/ghost_doctor_$(date +%Y%m%d_%H%M%S).txt"

{
  echo "=== GHOST_DOCTOR REPORT ==="
  date
  echo
  echo "[*] Directory principali:"
  for d in core rituals ops missions var/logs var/state; do
    if [[ -d "$ROOT/$d" ]]; then
      echo "  [+] $d OK"
    else
      echo "  [!] $d MANCANTE"
    fi
  done
  echo
  echo "[*] File chiave:"
  for f in core/logging/eco_log.py rituals/init_ritual.sh missions/run_mission.sh; do
    if [[ -f "$ROOT/$f" ]]; then
      echo "  [+] $f OK"
    else
      echo "  [!] $f MANCANTE"
    fi
  done
  echo
  echo "[*] Alias suggeriti (.bashrc):"
  echo "  alias ghost='bash ~/Ghost_Ops_Unit/rituals/init_ritual.sh'"
  echo "  alias ghost_status='bash ~/Ghost_Ops_Unit/ops/ghost_status.sh'"
  echo "  alias ghost_summary='bash ~/Ghost_Ops_Unit/ops/ghost_summary.sh'"
  echo "  alias ghost_mission='bash ~/Ghost_Ops_Unit/missions/run_mission.sh'"
  echo "  alias ghost_tmux='bash ~/Ghost_Ops_Unit/ops/ghost_tmux.sh'"
  echo
  echo "[*] Missioni disponibili:"
  find "$ROOT/missions" -maxdepth 1 -type f -name '*.sh' -printf '  - %f\n' 2>/dev/null || echo "  (nessuna)"
} > "$REPORT"

if [[ -f "$ROOT/core/logging/eco_log.py" ]]; then
  python3 "$ROOT/core/logging/eco_log.py" ops "ghost_doctor REPORT=$REPORT"
fi

echo "[GHOST_DOCTOR] Report generato: $REPORT"
