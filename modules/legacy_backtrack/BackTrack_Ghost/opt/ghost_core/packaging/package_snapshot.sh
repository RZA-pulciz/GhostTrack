#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/var/state/packages"
mkdir -p "$OUT"
NAME="ghost_$(date +%Y%m%d_%H%M%S)_$RANDOM.tar.gz"
tar --exclude='.git' --exclude='var/logs' -czf "$OUT/$NAME" -C "$ROOT" .
echo "[PACKAGE] Creato: $NAME"
