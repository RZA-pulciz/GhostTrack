#!/usr/bin/env bash
healthcheck() {
  local BASE_DIR="${BASE_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
  for d in "$BASE_DIR" "$BASE_DIR/var" "$BASE_DIR/var/logs" "$BASE_DIR/modules" "$BASE_DIR/assets"; do
    [ -d "$d" ] || mkdir -p "$d"
  done
  integrity_build
  echo "Healthcheck completato."
}
