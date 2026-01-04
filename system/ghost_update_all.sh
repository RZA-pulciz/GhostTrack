#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "[GHOST_UPDATE] Avvio aggiornamento completo..."

###############################################
# 1. AUTO-RIPARAZIONE (SELFHEAL)
###############################################
bash ops/ghost_selfheal.sh || echo "[GHOST_UPDATE] Selfheal non trovato, ignorato."

###############################################
# 2. DIAGNOSTICA (DOCTOR)
###############################################
bash ops/ghost_doctor.sh || echo "[GHOST_UPDATE] Doctor non trovato, ignorato."

###############################################
# 3. AGGIORNA ALIAS .bashrc
###############################################
if ! grep -q "ghost_mission" ~/.bashrc 2>/dev/null; then
  echo "[GHOST_UPDATE] Aggiorno alias in ~/.bashrc..."
  {
    echo "alias ghost='bash ~/Ghost_Ops_Unit/rituals/init_ritual.sh'"
    echo "alias ghost_status='bash ~/Ghost_Ops_Unit/ops/ghost_status.sh'"
    echo "alias ghost_summary='bash ~/Ghost_Ops_Unit/ops/ghost_summary.sh'"
    echo "alias ghost_mission='bash ~/Ghost_Ops_Unit/missions/run_mission.sh'"
    echo "alias ghost_tmux='bash ~/Ghost_Ops_Unit/ops/ghost_tmux.sh'"
    echo "alias ghost_push='bash ~/Ghost_Ops_Unit/ops/ghost_push.sh'"
    echo "alias ghost_doctor='bash ~/Ghost_Ops_Unit/ops/ghost_doctor.sh'"
    echo "alias ghost_selfheal='bash ~/Ghost_Ops_Unit/ops/ghost_selfheal.sh'"
  } >> ~/.bashrc
fi

###############################################
# 4. PERMESSI
###############################################
chmod -R +x rituals ops missions core 2>/dev/null || true
echo "[GHOST_UPDATE] Permessi aggiornati."

###############################################
# 5. PUSH AUTOMATICO SU GITHUB
###############################################
if [[ -f ops/ghost_push.sh ]]; then
  bash ops/ghost_push.sh "Ghost_OS full update $(date +%Y-%m-%d_%H:%M:%S)"
else
  echo "[GHOST_UPDATE] ghost_push.sh non trovato, salto push."
fi

###############################################
# 6. LOG
###############################################
if [[ -f core/logging/eco_log.py ]]; then
  python3 core/logging/eco_log.py ops "ghost_update_all completed"
fi

echo "[GHOST_UPDATE] Aggiornamento completo eseguito."
