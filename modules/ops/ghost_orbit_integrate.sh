#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST ORBIT SYSTEM — INTEGRAZIONE COMPLETA"
echo "====================================="

BASE_DIR="$(pwd)"
ORBIT_DIR="$BASE_DIR/ghost_ops_unit/orbit"

echo "[1] Creo struttura interna…"
mkdir -p "$ORBIT_DIR"/{node,client,peripheral,engine,rituals,dashboard,config,logs,superguardian}

echo "[2] Sposto moduli esistenti nella struttura interna…"

mv ghost_onion_node/*        "$ORBIT_DIR/node/"        2>/dev/null || true
mv ghost_orbit_client/*      "$ORBIT_DIR/client/"      2>/dev/null || true
mv ghost_peripheral/*        "$ORBIT_DIR/peripheral/"  2>/dev/null || true
mv ghost_orbit_engine/*      "$ORBIT_DIR/engine/"      2>/dev/null || true
mv ghost_rituals/*           "$ORBIT_DIR/rituals/"     2>/dev/null || true
mv ghost_dashboard/*         "$ORBIT_DIR/dashboard/"   2>/dev/null || true
mv ghost_superguardian/*     "$ORBIT_DIR/superguardian/" 2>/dev/null || true

echo "[3] Creo bus interno di comunicazione…"
mkdir -p "$ORBIT_DIR/logs"
touch "$ORBIT_DIR/logs/events.json"
touch "$ORBIT_DIR/logs/context.json"
touch "$ORBIT_DIR/logs/missions.json"
touch "$ORBIT_DIR/logs/rituals.json"

echo "[4] Creo entrypoint orbit.sh…"

cat > "$ORBIT_DIR/orbit.sh" << 'EOF'
#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$1" in
  node)
    bash "$BASE_DIR/node/run_local_node.sh"
    ;;
  sync)
    bash "$BASE_DIR/client/bin/orbit_sync.sh"
    ;;
  flipper)
    bash "$BASE_DIR/client/bin/orbit_flipper.sh"
    ;;
  context)
    bash "$BASE_DIR/client/bin/orbit_context.sh"
    ;;
  engine)
    bash "$BASE_DIR/engine/run_engine.sh"
    ;;
  ritual)
    bash "$BASE_DIR/rituals/scripts/$2.sh"
    ;;
  dashboard)
    echo "Dashboard HTML: $BASE_DIR/dashboard/html/index.html"
    ;;
  start)
    echo "[ORBIT] Avvio completo:"
    bash "$BASE_DIR/node/run_local_node.sh" &
    bash "$BASE_DIR/client/bin/orbit_sync.sh"
    bash "$BASE_DIR/engine/run_engine.sh"
    ;;
  *)
    echo "Comandi disponibili:"
    echo "  node       → avvia nodo locale"
    echo "  sync       → sincronizza con nodo"
    echo "  flipper    → importa eventi"
    echo "  context    → analizza contesto"
    echo "  engine     → avvia motore"
    echo "  ritual X   → esegui rituale X"
    echo "  dashboard  → mostra percorso dashboard"
    echo "  start      → avvio completo locale"
    ;;
esac
EOF

chmod +x "$ORBIT_DIR/orbit.sh"

echo "[5] Pulizia moduli esterni…"
rm -rf ghost_onion_node ghost_orbit_client ghost_peripheral ghost_orbit_engine ghost_rituals ghost_dashboard ghost_superguardian 2>/dev/null || true

echo
echo "====================================="
echo " GHOST ORBIT SYSTEM — INTEGRAZIONE COMPLETATA"
echo " Entry point: ghost_ops_unit/orbit/orbit.sh"
echo "====================================="
