#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$ROOT/core/integrity/verify_and_heal.sh"
bash "$ROOT/core/ghost_boot/ghost_boot.sh"
bash "$ROOT/core/anon_bus/anon_bus.sh" init
python3 "$ROOT/core/logging/eco_log.py" rituals "init"
