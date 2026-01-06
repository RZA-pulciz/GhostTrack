#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tail -n 10 "$ROOT/var/logs/rituals.log" 2>/dev/null
tail -n 10 "$ROOT/var/logs/missions.log" 2>/dev/null
