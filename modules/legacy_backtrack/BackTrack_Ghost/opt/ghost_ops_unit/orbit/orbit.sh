#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$1" in
  bridge)
    bash "$BASE_DIR/engine/sync_bridge.sh"
    ;;

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
