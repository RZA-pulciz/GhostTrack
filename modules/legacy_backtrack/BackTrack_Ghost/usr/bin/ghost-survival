#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"
mkdir -p "$SURV_DIR"

while true; do
  clear
  echo "====================================="
  echo " GHOST SURVIVAL CONSOLE"
  echo "====================================="
  echo "1) Invia messaggio"
  echo "2) Ricevi messaggi"
  echo "3) Terminale CB/Seriale"
  echo "4) Stato sistema"
  echo "5) Rituali essenziali"
  echo "6) Esci"
  echo "-------------------------------------"
  read -rp "Scelta: " CHOICE

  case "$CHOICE" in
    1) bash "$BASE_DIR/ghost_msg_send.sh"; read -rp "Premi invio…" ;;
    2) bash "$BASE_DIR/ghost_msg_recv.sh"; read -rp "Premi invio…" ;;
    3)
      read -rp "Porta seriale: " PORT
      read -rp "Baud: " BAUD
      bash "$BASE_DIR/ghost_cb_terminal.sh" "$PORT" "$BAUD"
      read -rp "Premi invio…" ;;
    4)
      echo "---- STATO ----"
      date
      tail -n 10 "$SURV_DIR/comms.log" 2>/dev/null || echo "Nessun log."
      read -rp "Premi invio…" ;;
    5)
      bash "$BASE_DIR/rituals/init_ritual.sh" 2>/dev/null || true
      bash "$BASE_DIR/rituals/closure_ritual.sh" 2>/dev/null || true
      bash "$BASE_DIR/rituals/purge_ritual.sh" 2>/dev/null || true
      read -rp "Premi invio…" ;;
    6) exit 0 ;;
  esac
done
