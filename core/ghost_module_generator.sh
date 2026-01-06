#!/usr/bin/env bash
set -e

MODULE=$1

if [ -z "$MODULE" ]; then
  echo "Uso: ./ghost_module_generator.sh nome_modulo"
  exit 1
fi

echo "[GHOST] Creo modulo: $MODULE"

mkdir -p ghost_os/$MODULE
mkdir -p var/heartbeat
mkdir -p var/logs

cat > ghost_os/$MODULE/module.py << EOF
import json
import time
import os

def heartbeat():
    data = {
        "module": "$MODULE",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/$MODULE.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/$MODULE.log", "a") as f:
        f.write(f"[{time.time()}] $MODULE run executed\n")

if __name__ == "__main__":
    run()
EOF

cat > ghost_os/$MODULE/README.md << EOF
# $MODULE

Modulo attivo di Ghost_OS.
- heartbeat automatico
- log automatico
- entrypoint: module.py
EOF

echo "[GHOST] Modulo $MODULE creato."
