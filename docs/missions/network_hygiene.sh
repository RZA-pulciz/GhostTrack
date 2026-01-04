#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ip addr show > "$ROOT/var/state/ip_info.txt"
python3 "$ROOT/core/logging/eco_log.py" missions "network_hygiene"
