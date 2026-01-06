#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
[[ "$1" == "$NODE_RECEIVE_SECRET" ]] && exit 0 || exit 1
