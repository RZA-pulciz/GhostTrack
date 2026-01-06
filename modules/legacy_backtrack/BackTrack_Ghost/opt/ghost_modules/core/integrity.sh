#!/usr/bin/env bash
integrity_build() {
  local BASE_DIR="${BASE_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
  local MANIFEST="$BASE_DIR/var/integrity.manifest"
  mkdir -p "$BASE_DIR/var"
  echo "# GhostTrack_OS Integrity Manifest" > "$MANIFEST"
  echo "# Generated: $(date)" >> "$MANIFEST"
  echo "" >> "$MANIFEST"
  find "$BASE_DIR" -type f ! -path "*/.git/*" | while read -r f; do
    sha256sum "$f" | awk '{print $1"  "$2}' >> "$MANIFEST"
  done
}
