#!/usr/bin/env bash
set -e
ORBIT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GHOST_DIR="$ORBIT_DIR/../../rootfs"
cp "$ORBIT_DIR/logs/events.json"   "$GHOST_DIR/var/heartbeat/orbit_events.json"   2>/dev/null || true
cp "$ORBIT_DIR/logs/context.json"  "$GHOST_DIR/var/heartbeat/orbit_context.json"  2>/dev/null || true
cp "$ORBIT_DIR/logs/missions.json" "$GHOST_DIR/var/heartbeat/orbit_missions.json" 2>/dev/null || true
cp "$ORBIT_DIR/logs/rituals.json"  "$GHOST_DIR/var/heartbeat/orbit_rituals.json"  2>/dev/null || true
