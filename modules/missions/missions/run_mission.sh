#!/usr/bin/env bash
set -euo pipefail

# Se non hai passato parametri, mostra l'uso
if [[ $# -lt 1 ]]; then
  echo "Uso: ghost_mission <script> [nome]"
  exit 1
fi

MISSION="$1"
NAME="${2:-$MISSION}"

# Controllo che il file esista
if [[ ! -f "$MISSION" ]]; then
  echo "[ERRORE] Missione non trovata: $MISSION"
  exit 1
fi

# Esecuzione missione
bash "$MISSION" "$NAME"
