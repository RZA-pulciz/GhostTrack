#!/usr/bin/env bash
sync_ritual() {
  local BASE_DIR="${BASE_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
  echo "✦ Sync Ritual — Allineamento Orbitale GhostTrack_OS"
  if [ -d "$BASE_DIR/.git" ]; then
    git -C "$BASE_DIR" add . >/dev/null 2>&1 || true
    git -C "$BASE_DIR" commit -m "GHOSTTRACK_OS: sync ritual" >/dev/null 2>&1 || true
    git -C "$BASE_DIR" pull --rebase || true
    git -C "$BASE_DIR" push || true
  else
    echo "Nessun repository Git rilevato. Sync locale."
  fi
  integrity_build
  echo "Rituale di sincronizzazione completato."
}
