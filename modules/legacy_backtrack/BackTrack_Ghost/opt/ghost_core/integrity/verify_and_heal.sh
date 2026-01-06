#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for d in core rituals ops var/logs var/state missions; do mkdir -p "$ROOT/$d"; done
echo "[INTEGRITY] OK"
