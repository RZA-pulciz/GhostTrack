#!/usr/bin/env bash
set -e

echo "[AUTOLOAD] Generazione completa Ghost_OS..."

# === STRUTTURA ===
mkdir -p core/{ghost_boot,integrity,anon_bus,notify,packaging,security,logging,profile}
mkdir -p rituals ops missions/templates docs var/logs var/state

# === FILE + CONTENUTO COMPATTO ===

# MANIFESTO
cat > MANIFESTO.md << 'EOM'
# Ghost Ops Unit – Ordine Fantasma
Sistema operativo rituale per cyber difesa, resilienza e automazione etica.
EOM

# README
cat > README.md << 'EOM'
# Ghost_Ops_Unit – Ghost Cyber Defence OS
Sistema operativo effimero, modulare e rituale per cyber difesa legale.
EOM

# ENV
cat > .env.example << 'EOM'
GHOST_PROFILE="DEV"
GHOST_NODE_ID="ghost-node-001"
NODE_RECEIVE_SECRET=""
FLIPPER_MOUNT_PATH=""
EOM

# PROFILE RESOLVER
cat > core/profile/profile_resolver.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
case "${GHOST_PROFILE:-DEV}" in DEV|LAB|FIELD) echo "$GHOST_PROFILE";; *) echo "DEV";; esac
EOM

# INTEGRITY
cat > core/integrity/verify_and_heal.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for d in core rituals ops var/logs var/state missions; do mkdir -p "$ROOT/$d"; done
echo "[INTEGRITY] OK"
EOM

# GHOST BOOT
cat > core/ghost_boot/ghost_boot.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP="$(mktemp -d -p "$ROOT/var/state" ghost_env_XXXX)"
mkdir -p "$TMP/runtime" "$TMP/tmp"
echo "[GHOST_BOOT] Ambiente: $TMP"
EOM

# ANON BUS
cat > core/anon_bus/anon_bus.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="$ROOT/var/state/anon_bus.state"
case "$1" in
  init) echo "BUS_ID=$(date +%s)_$RANDOM" > "$STATE";;
  status) [[ -f "$STATE" ]] && cat "$STATE" || echo "Nessun bus";;
esac
EOM

# NOTIFY
cat > core/notify/notify_startup.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
echo "[NOTIFY] Avvio Ghost_OS"
EOM

# PACKAGING
cat > core/packaging/package_snapshot.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/var/state/packages"
mkdir -p "$OUT"
NAME="ghost_$(date +%Y%m%d_%H%M%S)_$RANDOM.tar.gz"
tar --exclude='.git' --exclude='var/logs' -czf "$OUT/$NAME" -C "$ROOT" .
echo "[PACKAGE] Creato: $NAME"
EOM

# SECURITY
cat > core/security/validate_node_receive.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
[[ "$1" == "$NODE_RECEIVE_SECRET" ]] && exit 0 || exit 1
EOM

# LOGGING
cat > core/logging/eco_log.py << 'EOM'
#!/usr/bin/env python3
import os, sys, json
from datetime import datetime
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"..",".."))
LOG=os.path.join(ROOT,"var","logs")
os.makedirs(LOG,exist_ok=True)
entry={"ts":datetime.utcnow().isoformat()+"Z","channel":sys.argv[1],"msg":" ".join(sys.argv[2:])}
with open(os.path.join(LOG,f"{sys.argv[1]}.log"),"a") as f: f.write(json.dumps(entry)+"\n")
print(entry)
EOM

# INIT RITUAL
cat > rituals/init_ritual.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$ROOT/core/integrity/verify_and_heal.sh"
bash "$ROOT/core/ghost_boot/ghost_boot.sh"
bash "$ROOT/core/anon_bus/anon_bus.sh" init
python3 "$ROOT/core/logging/eco_log.py" rituals "init"
EOM

# CLOSURE
cat > rituals/closure_ritual.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/core/logging/eco_log.py" rituals "closure"
EOM

# PURGE
cat > rituals/purge_ritual.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
find "$ROOT/var/state" -type d -name 'ghost_env_*' -exec rm -rf {} +
EOM

# OPS
cat > ops/ghost_status.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ls -1t "$ROOT/var/logs" | head -n 5
EOM

cat > ops/ghost_summary.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tail -n 10 "$ROOT/var/logs/rituals.log" 2>/dev/null
tail -n 10 "$ROOT/var/logs/missions.log" 2>/dev/null
EOM

cat > ops/ghost_tmux.sh << 'EOM'
#!/usr/bin/env bash
tmux new-session -d -s ghost "ghost"
tmux attach -t ghost
EOM

# DASHBOARD CLI
cat > ops/dashboard_cli.py << 'EOM'
#!/usr/bin/env python3
print("Dashboard CLI attiva")
EOM

# DASHBOARD API
cat > ops/dashboard_api.py << 'EOM'
#!/usr/bin/env python3
print("Dashboard API attiva")
EOM

# MISSION RUNNER
cat > missions/run_mission.sh << 'EOM'
#!/usr/bin/env bash
bash "$1"
EOM

# NETWORK HYGIENE
cat > missions/network_hygiene.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ip addr show > "$ROOT/var/state/ip_info.txt"
python3 "$ROOT/core/logging/eco_log.py" missions "network_hygiene"
EOM

# FLIPPER SYNC (legale)
cat > missions/flipper_sync.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
[[ -z "$FLIPPER_MOUNT_PATH" ]] && { echo "Configura FLIPPER_MOUNT_PATH"; exit 1; }
DEST="$ROOT/var/state/flipper_sync_$(date +%s)"
mkdir -p "$DEST"
cp -r "$FLIPPER_MOUNT_PATH"/* "$DEST"/ 2>/dev/null || true
python3 "$ROOT/core/logging/eco_log.py" missions "flipper_sync"
EOM

# PERMESSI
chmod -R +x core rituals ops missions

echo "[AUTOLOAD] Completato."
