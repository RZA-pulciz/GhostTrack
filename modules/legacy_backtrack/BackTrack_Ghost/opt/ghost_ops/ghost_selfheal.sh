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
