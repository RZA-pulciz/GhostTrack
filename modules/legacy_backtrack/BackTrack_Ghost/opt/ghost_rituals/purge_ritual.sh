#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
find "$ROOT/var/state" -type d -name 'ghost_env_*' -exec rm -rf {} +
