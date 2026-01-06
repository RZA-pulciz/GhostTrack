#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
WAR_DIR="$BASE_DIR/var/logs_war"
mkdir -p "$WAR_DIR"
echo "[WAR MODE] Attivo isolamento…"
export GHOST_WAR_MODE=1
echo "[WAR MODE] Integrità…"
bash "$BASE_DIR/core/integrity/verify_and_heal.sh" || true
echo "[WAR MODE] Ritual Engine…"
python3 "$BASE_DIR/ghost_os/ritual_engine/ritual_engine.py" --trigger war_mode 2>/dev/null || true
echo "[WAR MODE] Logging…"
echo "$(date) — WAR MODE ACTIVE" >> "$WAR_DIR/war_mode.log"
echo "[WAR MODE] Orbit Context…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" context || true
echo "[WAR MODE] Bridge…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" bridge || true
echo "[WAR MODE] Protezione…"
bash "$BASE_DIR/rituals/init_ritual.sh" || true
echo "[WAR MODE] Blackout etico attivo."
