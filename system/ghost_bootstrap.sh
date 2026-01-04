#!/usr/bin/env bash
set -e

REPO_RAW="https://raw.githubusercontent.com/HighKali/Ghost_Ops_Unit/main"

echo "[GHOST_BOOTSTRAP] Scarico Ghost Beacon + README rituale..."

curl -fsSL "$REPO_RAW/flipper/ghost_beacon/application.fam" -o flipper/ghost_beacon/application.fam
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/ghost_beacon.c" -o flipper/ghost_beacon/ghost_beacon.c
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/ghost_beacon.h" -o flipper/ghost_beacon/ghost_beacon.h
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/ghost_beacon_ui.c" -o flipper/ghost_beacon/ghost_beacon_ui.c
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/ghost_beacon_logic.c" -o flipper/ghost_beacon/ghost_beacon_logic.c
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/ghost_beacon_export.c" -o flipper/ghost_beacon/ghost_beacon_export.c
curl -fsSL "$REPO_RAW/flipper/ghost_beacon/README.md" -o flipper/ghost_beacon/README.md

curl -fsSL "$REPO_RAW/ghost_os/ghost_beacon_receiver.py" -o ghost_os/ghost_beacon_receiver.py
curl -fsSL "$REPO_RAW/README.md" -o README.md

echo "[GHOST_BOOTSTRAP] Fatto. Ora:"
echo "  git add flipper/ghost_beacon ghost_os/ghost_beacon_receiver.py README.md"
echo "  git commit -m \"Sync Ghost Beacon + README rituale\""
echo "  git push"
