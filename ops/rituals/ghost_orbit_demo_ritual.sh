#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST ORBIT SYSTEM — DEMO RITUAL"
echo "====================================="

BASE_DIR="$(pwd)"

echo "[DEMO] 1) Esporto eventi di esempio dal Peripheral…"
if [ -x "$BASE_DIR/ghost_peripheral/export/export_example_events.sh" ]; then
  "$BASE_DIR/ghost_peripheral/export/export_example_events.sh"
else
  echo "[DEMO] export_example_events.sh non trovato o non eseguibile."
fi

echo
echo "[DEMO] 2) Avvio (scheletro) dell'Orbit Engine…"
if [ -x "$BASE_DIR/ghost_orbit_engine/run_engine.sh" ]; then
  "$BASE_DIR/ghost_orbit_engine/run_engine.sh"
else
  echo "[DEMO] run_engine.sh non trovato o non eseguibile."
fi

echo
echo "[DEMO] 3) Eseguo rituale di protezione…"
if [ -x "$BASE_DIR/ghost_rituals/scripts/ritual_protection.sh" ]; then
  "$BASE_DIR/ghost_rituals/scripts/ritual_protection.sh"
else
  echo "[DEMO] ritual_protection.sh non trovato o non eseguibile."
fi

echo
echo "[DEMO] 4) Eseguo rituale di sincronizzazione…"
if [ -x "$BASE_DIR/ghost_rituals/scripts/ritual_sync.sh" ]; then
  "$BASE_DIR/ghost_rituals/scripts/ritual_sync.sh"
else
  echo "[DEMO] ritual_sync.sh non trovato o non eseguibile."
fi

echo
echo "[DEMO] 5) Provo la sincronizzazione Orbit Client → Onion Node…"
if [ -x "$BASE_DIR/ghost_orbit_client/bin/orbit_sync.sh" ]; then
  "$BASE_DIR/ghost_orbit_client/bin/orbit_sync.sh"
else
  echo "[DEMO] orbit_sync.sh non trovato o non eseguibile."
fi

echo
echo "[DEMO] 6) Dashboard HTML disponibile in:"
echo "       $BASE_DIR/ghost_dashboard/html/index.html"

echo
echo "====================================="
echo " GHOST ORBIT SYSTEM — DEMO COMPLETATA"
echo "====================================="
