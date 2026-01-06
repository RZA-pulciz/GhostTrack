#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST ORBIT SYSTEM — BRIDGE INSTALLER"
echo "====================================="

BASE_DIR="$(pwd)"
ORBIT_DIR="$BASE_DIR/ghost_ops_unit/orbit"
GHOST_DIR="$BASE_DIR/rootfs"

echo "[1] Verifica directory…"
if [ ! -d "$ORBIT_DIR" ]; then
  echo "Errore: ghost_ops_unit/orbit non trovato."
  exit 1
fi

if [ ! -d "$GHOST_DIR" ]; then
  echo "Errore: rootfs non trovato."
  exit 1
fi

echo "[2] Creo sync_bridge.sh…"

cat > "$ORBIT_DIR/engine/sync_bridge.sh" << 'EOF'
#!/usr/bin/env bash
set -e

ORBIT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GHOST_DIR="$ORBIT_DIR/../../rootfs"

echo "[SYNC_BRIDGE] Orbit → Ghost_OS"

cp "$ORBIT_DIR/logs/events.json"   "$GHOST_DIR/var/heartbeat/orbit_events.json"   2>/dev/null || true
cp "$ORBIT_DIR/logs/context.json"  "$GHOST_DIR/var/heartbeat/orbit_context.json"  2>/dev/null || true
cp "$ORBIT_DIR/logs/missions.json" "$GHOST_DIR/var/heartbeat/orbit_missions.json" 2>/dev/null || true
cp "$ORBIT_DIR/logs/rituals.json"  "$GHOST_DIR/var/heartbeat/orbit_rituals.json"  2>/dev/null || true

echo "[SYNC_BRIDGE] Ghost_OS → Orbit"

cp "$GHOST_DIR/var/heartbeat/ghost_beacon_v2.json" "$ORBIT_DIR/logs/context.json" 2>/dev/null || true

echo "[SYNC_BRIDGE] Completato."
EOF

chmod +x "$ORBIT_DIR/engine/sync_bridge.sh"

echo "[3] Aggiorno orbit.sh con comando 'bridge'…"

if ! grep -q "bridge)" "$ORBIT_DIR/orbit.sh"; then
  sed -i '/case "\$1" in/a \
  bridge)\n    bash "$BASE_DIR/engine/sync_bridge.sh"\n    ;;\n' "$ORBIT_DIR/orbit.sh"
  echo "[OK] Comando 'bridge' aggiunto a orbit.sh"
else
  echo "[OK] Comando 'bridge' già presente"
fi

echo "[4] Creo rituale Orbit → Ghost_OS…"

mkdir -p "$ORBIT_DIR/rituals/scripts"

cat > "$ORBIT_DIR/rituals/scripts/ritual_sync.sh" << 'EOF'
#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "[RITUAL_SYNC] Attivo ritual engine Ghost_OS…"

python3 "$BASE_DIR/../../ghost_os/ritual_engine/ritual_engine.py" --trigger orbit_sync 2>/dev/null || true

echo "[RITUAL_SYNC] Completato."
EOF

chmod +x "$ORBIT_DIR/rituals/scripts/ritual_sync.sh"

echo "[5] Creo hook Ghost_OS → Orbit…"

HOOK_FILE="$BASE_DIR/ghost_os/ritual_engine/orbit_hook.sh"

cat > "$HOOK_FILE" << 'EOF'
#!/usr/bin/env bash
set -e

echo "[ORBIT_HOOK] Attivo rituale Orbit da Ghost_OS…"

bash "$(pwd)/ghost_ops_unit/orbit/orbit.sh" ritual sync
EOF

chmod +x "$HOOK_FILE"

echo "[6] Installazione completata."
echo "====================================="
echo " Il ponte Orbit ↔ Ghost_OS è attivo."
echo " Usa: bash ghost_ops_unit/orbit/orbit.sh bridge"
echo "====================================="
