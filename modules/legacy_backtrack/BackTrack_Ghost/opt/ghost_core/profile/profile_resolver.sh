#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
case "${GHOST_PROFILE:-DEV}" in DEV|LAB|FIELD) echo "$GHOST_PROFILE";; *) echo "DEV";; esac
