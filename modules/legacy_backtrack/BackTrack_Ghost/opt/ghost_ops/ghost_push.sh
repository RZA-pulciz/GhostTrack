#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MSG="${1:-"Ritual commit $(date +%Y-%m-%d_%H:%M:%S)"}"

git add .
if git diff --cached --quiet; then
  echo "[GHOST_PUSH] Nessuna modifica da committare."
  exit 0
fi

git commit -m "$MSG" || { echo "[GHOST_PUSH] Commit fallito."; exit 1; }

BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
git push origin "$BRANCH"

if [[ -f "$ROOT/core/logging/eco_log.py" ]]; then
  python3 "$ROOT/core/logging/eco_log.py" ops "ghost_push BRANCH=$BRANCH MSG=$MSG"
fi

echo "[GHOST_PUSH] Push completato su branch: $BRANCH"
