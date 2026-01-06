#!/usr/bin/env bash
# Ghost Onion Node — heartbeat endpoint (scheletro operativo)
set -e

NOW_TS=$(date +%s)

cat <<JSON
{
  "status": "ok",
  "component": "ghost_onion_node",
  "timestamp": "$NOW_TS",
  "message": "Ghost Orbit Node heartbeat (scheletro operativo)"
}
JSON
