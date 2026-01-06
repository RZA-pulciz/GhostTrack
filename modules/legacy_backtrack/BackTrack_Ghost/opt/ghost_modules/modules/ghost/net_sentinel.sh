#!/usr/bin/env bash
net_sentinel() {
  banner
  echo "✦ NET SENTINEL — Sentinella Orbitale di Rete ✦"
  if command -v ip >/dev/null 2>&1; then
    ip a
  else
    ifconfig 2>/dev/null || echo "Comando rete non disponibile."
  fi
}
