#!/usr/bin/env bash
sys_monastery() {
  banner
  echo "✦ SYS MONASTERY — Monastero di Integrità ✦"
  df -h
  echo ""
  free -h 2>/dev/null || true
}
