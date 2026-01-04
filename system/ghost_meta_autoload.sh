#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "[GHOST_META] Creazione meta-moduli: push, doctor, selfheal..."

mkdir -p ops var/logs var/state

# 1) GHOST PUSH – add + commit + push + log
cat > ops/ghost_push.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MSG="${1:-"Ritual commit $(date +%Y-%m-%d_%H:%M:%S)"}"

git add .
if git diff --cached --quiet; then
  echo "[GHOST_PUSH] Nessuna modifica da committare."
  exit 0
fi

git commit -m "$MSG" || { echo "[GHOST_PUSH] Commit fallito."; exit 1; }

BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
git push origin "$BRANCH"

if [[ -f "$ROOT/core/logging/eco_log.py" ]]; then
  python3 "$ROOT/core/logging/eco_log.py" ops "ghost_push BRANCH=$BRANCH MSG=$MSG"
fi

echo "[GHOST_PUSH] Push completato su branch: $BRANCH"
EOM

# 2) GHOST DOCTOR – diagnostica completa
cat > ops/ghost_doctor.sh << 'EOM'
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
EOM

# 3) GHOST SELFHEAL – auto-riparazione minima
cat > ops/ghost_selfheal.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[GHOST_SELFHEAL] Avvio auto-riparazione minima..."

# Struttura base
for d in core rituals ops missions var/logs var/state; do
  mkdir -p "$ROOT/$d"
done

# run_mission.sh minimo ma corretto
if [[ ! -f "$ROOT/missions/run_mission.sh" ]]; then
  cat > "$ROOT/missions/run_mission.sh" << 'EOS'
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "Uso: ghost_mission <script> [nome]"
  exit 1
fi
MISSION="$1"
NAME="\${2:-$MISSION}"
if [[ ! -f "$MISSION" ]]; then
  echo "[ERRORE] Missione non trovata: $MISSION"
  exit 1
fi
bash "$MISSION" "$NAME"
EOS
  chmod +x "$ROOT/missions/run_mission.sh"
  echo "[GHOST_SELFHEAL] Ricreato missions/run_mission.sh"
fi

# eco_log.py minimo
if [[ ! -f "$ROOT/core/logging/eco_log.py" ]]; then
  mkdir -p "$ROOT/core/logging"
  cat > "$ROOT/core/logging/eco_log.py" << 'EOS'
#!/usr/bin/env python3
import os, sys, json
from datetime import datetime, timezone
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"..",".."))
LOG=os.path.join(ROOT,"var","logs")
os.makedirs(LOG,exist_ok=True)
entry={"ts":datetime.now(timezone.utc).isoformat(),"channel":sys.argv[1],"msg":" ".join(sys.argv[2:])}
with open(os.path.join(LOG,f"{sys.argv[1]}.log"),"a") as f: f.write(json.dumps(entry)+"\n")
print(entry)
EOS
  echo "[GHOST_SELFHEAL] Ricreato core/logging/eco_log.py"
fi

# init_ritual minimo
if [[ ! -f "$ROOT/rituals/init_ritual.sh" ]]; then
  mkdir -p "$ROOT/rituals"
  cat > "$ROOT/rituals/init_ritual.sh" << 'EOS'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/var/logs" "$ROOT/var/state"
python3 "$ROOT/core/logging/eco_log.py" rituals "init_selfheal"
EOS
  chmod +x "$ROOT/rituals/init_ritual.sh"
  echo "[GHOST_SELFHEAL] Ricreato rituals/init_ritual.sh"
fi

# Permessi base
chmod -R +x "$ROOT/rituals" "$ROOT/ops" "$ROOT/missions" 2>/dev/null || true

if [[ -f "$ROOT/core/logging/eco_log.py" ]]; then
  python3 "$ROOT/core/logging/eco_log.py" ops "ghost_selfheal completed"
fi

echo "[GHOST_SELFHEAL] Completato."
EOM

chmod +x ops/ghost_push.sh ops/ghost_doctor.sh ops/ghost_selfheal.sh

echo "[GHOST_META] Meta-moduli creati:"
echo "  bash ops/ghost_push.sh \"Messaggio\""
echo "  bash ops/ghost_doctor.sh"
echo "  bash ops/ghost_selfheal.sh"
