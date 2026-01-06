#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="$ROOT/var/state/anon_bus.state"
case "$1" in
  init) echo "BUS_ID=$(date +%s)_$RANDOM" > "$STATE";;
  status) [[ -f "$STATE" ]] && cat "$STATE" || echo "Nessun bus";;
esac
