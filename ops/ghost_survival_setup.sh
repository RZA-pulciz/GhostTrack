#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST SURVIVAL PACK — INSTALLER"
echo "====================================="

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

echo "[1] Creo ghost_survival_console.sh…"

cat > "$BASE_DIR/ghost_survival_console.sh" << 'EOF'
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
    1)
      bash "$BASE_DIR/ghost_msg_send.sh"
      read -rp "Premi invio per continuare…" ;;
    2)
      bash "$BASE_DIR/ghost_msg_recv.sh"
      read -rp "Premi invio per continuare…" ;;
    3)
      read -rp "Porta seriale (es. /dev/ttyS0): " PORT
      read -rp "Baud (es. 9600): " BAUD
      bash "$BASE_DIR/ghost_cb_terminal.sh" "$PORT" "$BAUD"
      read -rp "Premi invio per continuare…" ;;
    4)
      echo "---- STATO SISTEMA ----"
      date
      echo "Directory: $BASE_DIR"
      echo "Survival dir: $SURV_DIR"
      echo "Log comunicazioni:"
      tail -n 10 "$SURV_DIR/comms.log" 2>/dev/null || echo "Nessun log."
      echo "------------------------"
      read -rp "Premi invio per continuare…" ;;
    5)
      echo "---- RITUALI ESSENZIALI ----"
      if [ -x "$BASE_DIR/rituals/init_ritual.sh" ]; then
        echo "Eseguo init_ritual.sh…"
        bash "$BASE_DIR/rituals/init_ritual.sh" || true
      fi
      if [ -x "$BASE_DIR/rituals/closure_ritual.sh" ]; then
        echo "Eseguo closure_ritual.sh…"
        bash "$BASE_DIR/rituals/closure_ritual.sh" || true
      fi
      if [ -x "$BASE_DIR/rituals/purge_ritual.sh" ]; then
        echo "Eseguo purge_ritual.sh…"
        bash "$BASE_DIR/rituals/purge_ritual.sh" || true
      fi
      echo "-----------------------------"
      read -rp "Premi invio per continuare…" ;;
    6)
      echo "Uscita dalla Survival Console."
      exit 0 ;;
    *)
      echo "Scelta non valida."
      sleep 1 ;;
  esac
done
EOF

chmod +x "$BASE_DIR/ghost_survival_console.sh"

echo "[2] Creo ghost_cb_terminal.sh…"

cat > "$BASE_DIR/ghost_cb_terminal.sh" << 'EOF'
#!/usr/bin/env bash
set -e

PORT="$1"
BAUD="$2"

if [ -z "$PORT" ] || [ -z "$BAUD" ]; then
  echo "Uso: ghost_cb_terminal.sh /dev/ttyS0 9600"
  exit 1
fi

echo "Apro terminale su $PORT a $BAUD baud."
echo "CTRL+C per uscire."

stty -F "$PORT" "$BAUD" cs8 -cstopb -parenb -ixon -ixoff -crtscts 2>/dev/null || true

while true; do
  if read -r LINE; then
    printf "%s\n" "$LINE" > "$PORT"
  fi &
  cat "$PORT"
done
EOF

chmod +x "$BASE_DIR/ghost_cb_terminal.sh"

echo "[3] Creo ghost_msg_send.sh…"

cat > "$BASE_DIR/ghost_msg_send.sh" << 'EOF'
#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

read -rp "ID mittente: " FROM
read -rp "ID destinatario: " TO
read -rp "Canale (telnet/seriale): " CH
read -rp "Messaggio: " MSG

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LINE="FROM=$FROM|TO=$TO|TS=$TS|MSG=$MSG"

echo "$LINE" >> "$SURV_DIR/comms.log"

echo "Messaggio formattato:"
echo "$LINE"

echo "Invio manuale richiesto:"
echo "- Se telnet: incolla questa riga nella sessione."
echo "- Se seriale: usa ghost_cb_terminal.sh e incolla la riga."
EOF

chmod +x "$BASE_DIR/ghost_msg_send.sh"

echo "[4] Creo ghost_msg_recv.sh…"

cat > "$BASE_DIR/ghost_msg_recv.sh" << 'EOF'
#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

echo "Incolla qui il messaggio ricevuto (CTRL+D per terminare):"
RECV="$(cat)"

if [ -z "$RECV" ]; then
  echo "Nessun input ricevuto."
  exit 0
fi

echo "$RECV" >> "$SURV_DIR/comms.log"

echo "Messaggio registrato in comms.log"
echo "Contenuto:"
echo "$RECV"
EOF

chmod +x "$BASE_DIR/ghost_msg_recv.sh"

echo "[5] Creo ghost_text_only_mode.sh…"

cat > "$BASE_DIR/ghost_text_only_mode.sh" << 'EOF'
#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"

echo "Attivo modalità SOLO TESTO…"

export GHOST_TEXT_ONLY=1

echo "Disattivo componenti non essenziali (solo logico, nessun servizio viene toccato automaticamente)."
echo "Usa solo:"
echo "- ghost_survival_console.sh"
echo "- ghost_cb_terminal.sh"
echo "- ghost_msg_send.sh / ghost_msg_recv.sh"

echo "Modalità solo testo attiva."
EOF

chmod +x "$BASE_DIR/ghost_text_only_mode.sh"

echo "[6] Creo directory survival e log base…"

touch "$SURV_DIR/comms.log"
touch "$SURV_DIR/events.log"
touch "$SURV_DIR/rituals.log"

echo
echo "====================================="
echo " GHOST SURVIVAL PACK INSTALLATO"
echo " Avvia con: ./ghost_survival_console.sh"
echo "====================================="
