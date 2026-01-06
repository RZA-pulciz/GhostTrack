#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
export BASE_DIR

RED="\033[1;31m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"
BLUE="\033[1;34m"; MAGENTA="\033[1;35m"; CYAN="\033[1;36m"
RESET="\033[0m"

source "$BASE_DIR/core/integrity.sh"
source "$BASE_DIR/core/health.sh"
source "$BASE_DIR/core/sync.sh"
source "$BASE_DIR/core/ritual.sh"

source "$BASE_DIR/modules/ghost/trace_oracle.sh"
source "$BASE_DIR/modules/ghost/net_sentinel.sh"
source "$BASE_DIR/modules/ghost/sys_monastery.sh"
source "$BASE_DIR/modules/ghost/sync_rituals.sh"

source "$BASE_DIR/modules/bt_legacy/recon.sh"
source "$BASE_DIR/modules/bt_legacy/wireless.sh"
source "$BASE_DIR/modules/bt_legacy/exploit.sh"
source "$BASE_DIR/modules/bt_legacy/forensic.sh"
source "$BASE_DIR/modules/bt_legacy/network.sh"

source "$BASE_DIR/modules/extensions/osint.sh"
source "$BASE_DIR/modules/extensions/malware.sh"
source "$BASE_DIR/modules/extensions/dfir.sh"
source "$BASE_DIR/modules/extensions/sdr.sh"

usage() {
  banner
  echo -e "${CYAN}✦ GHOSTTRACK_OS — Comandi Disponibili ✦${RESET}"
  echo -e "${GREEN}health${RESET}        — Healthcheck orbitale"
  echo -e "${GREEN}trace${RESET}         — Trace Oracle (contesto)"
  echo -e "${GREEN}net${RESET}           — Net Sentinel (rete)"
  echo -e "${GREEN}sys${RESET}           — Sys Monastery (sistema)"
  echo -e "${GREEN}sync-ritual${RESET}   — Rituale di sincronizzazione"
  echo -e "${GREEN}bt-recon${RESET}      — BackTrack Legacy: Recon"
  echo -e "${GREEN}bt-wireless${RESET}   — BackTrack Legacy: Wireless"
  echo -e "${GREEN}bt-exploit${RESET}    — BackTrack Legacy: Exploit"
  echo -e "${GREEN}bt-forensic${RESET}   — BackTrack Legacy: Forensic"
  echo -e "${GREEN}bt-network${RESET}    — BackTrack Legacy: Network"
  echo -e "${GREEN}osint${RESET}         — Modulo OSINT"
  echo -e "${GREEN}malware${RESET}       — Modulo Malware"
  echo -e "${GREEN}dfir${RESET}          — Modulo DFIR"
  echo -e "${GREEN}sdr${RESET}           — Modulo SDR"
  echo -e "${GREEN}map${RESET}           — Mappa orbitale"
  echo ""
  echo -e "${YELLOW}Esempio:${RESET} ./ghosttrack.sh health"
}

cmd="$1"
case "$cmd" in
  health) healthcheck ;;
  trace) trace_oracle ;;
  net) net_sentinel ;;
  sys) sys_monastery ;;
  sync-ritual) sync_ritual ;;
  bt-recon) bt_recon ;;
  bt-wireless) bt_wireless ;;
  bt-exploit) bt_exploit ;;
  bt-forensic) bt_forensic ;;
  bt-network) bt_network ;;
  osint) osint_module ;;
  malware) malware_module ;;
  dfir) dfir_module ;;
  sdr) sdr_module ;;
  map) ritual_map ;;
  ""|help|--help|-h) usage ;;
  *) usage ;;
esac

echo -e "${MAGENTA}✦ GhostTrack_OS — Ciclo completato ✦${RESET}"
