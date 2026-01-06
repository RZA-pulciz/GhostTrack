#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST TOTAL INTEGRATION"
echo " Survival Pack + War Mode + Orbit↔Ghost_OS Bridge"
echo "====================================="

BASE_DIR="$(pwd)"
ORBIT_DIR="$BASE_DIR/ghost_ops_unit/orbit"
GHOST_DIR="$BASE_DIR/rootfs"
SURV_DIR="$BASE_DIR/var/survival"
WAR_DIR="$BASE_DIR/var/logs_war"

mkdir -p "$SURV_DIR" "$WAR_DIR"

###############################################
# 1) INSTALLA SURVIVAL PACK
###############################################

echo "[1] Installo Survival Pack…"

# Survival Console
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
EOF

chmod +x "$BASE_DIR/ghost_survival_console.sh"

# CB Terminal
cat > "$BASE_DIR/ghost_cb_terminal.sh" << 'EOF'
#!/usr/bin/env bash
set -e
PORT="$1"
BAUD="$2"
if [ -z "$PORT" ] || [ -z "$BAUD" ]; then
  echo "Uso: ghost_cb_terminal.sh /dev/ttyS0 9600"
  exit 1
fi
stty -F "$PORT" "$BAUD" cs8 -cstopb -parenb -ixon -ixoff -crtscts 2>/dev/null || true
echo "Terminale aperto su $PORT a $BAUD baud."
echo "CTRL+C per uscire."
while true; do
  if read -r LINE; then printf "%s\n" "$LINE" > "$PORT"; fi &
  cat "$PORT"
done
EOF

chmod +x "$BASE_DIR/ghost_cb_terminal.sh"

# Message Send
cat > "$BASE_DIR/ghost_msg_send.sh" << 'EOF'
#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"
mkdir -p "$SURV_DIR"
read -rp "ID mittente: " FROM
read -rp "ID destinatario: " TO
read -rp "Messaggio: " MSG
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LINE="FROM=$FROM|TO=$TO|TS=$TS|MSG=$MSG"
echo "$LINE" >> "$SURV_DIR/comms.log"
echo "Messaggio formattato:"
echo "$LINE"
EOF

chmod +x "$BASE_DIR/ghost_msg_send.sh"

# Message Receive
cat > "$BASE_DIR/ghost_msg_recv.sh" << 'EOF'
#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"
mkdir -p "$SURV_DIR"
echo "Incolla messaggio ricevuto (CTRL+D per finire):"
RECV="$(cat)"
echo "$RECV" >> "$SURV_DIR/comms.log"
echo "Registrato."
EOF

chmod +x "$BASE_DIR/ghost_msg_recv.sh"

# Text-only mode
cat > "$BASE_DIR/ghost_text_only_mode.sh" << 'EOF'
#!/usr/bin/env bash
set -e
export GHOST_TEXT_ONLY=1
echo "Modalità SOLO TESTO attiva."
EOF

chmod +x "$BASE_DIR/ghost_text_only_mode.sh"

touch "$SURV_DIR/comms.log" "$SURV_DIR/events.log" "$SURV_DIR/rituals.log"

###############################################
# 2) INSTALLA WAR MODE
###############################################

echo "[2] Installo War Mode…"

cat > "$BASE_DIR/ghost_war_mode.sh" << 'EOF'
#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
WAR_DIR="$BASE_DIR/var/logs_war"
mkdir -p "$WAR_DIR"
echo "[WAR MODE] Attivo isolamento…"
export GHOST_WAR_MODE=1
echo "[WAR MODE] Integrità…"
bash "$BASE_DIR/core/integrity/verify_and_heal.sh" || true
echo "[WAR MODE] Ritual Engine…"
python3 "$BASE_DIR/ghost_os/ritual_engine/ritual_engine.py" --trigger war_mode 2>/dev/null || true
echo "[WAR MODE] Logging…"
echo "$(date) — WAR MODE ACTIVE" >> "$WAR_DIR/war_mode.log"
echo "[WAR MODE] Orbit Context…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" context || true
echo "[WAR MODE] Bridge…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" bridge || true
echo "[WAR MODE] Protezione…"
bash "$BASE_DIR/rituals/init_ritual.sh" || true
echo "[WAR MODE] Blackout etico attivo."
EOF

chmod +x "$BASE_DIR/ghost_war_mode.sh"

###############################################
# 3) INSTALLA BRIDGE ORBIT ↔ GHOST_OS
###############################################

echo "[3] Installo Bridge Orbit ↔ Ghost_OS…"

mkdir -p "$ORBIT_DIR/engine"

cat > "$ORBIT_DIR/engine/sync_bridge.sh" << 'EOF'
#!/usr/bin/env bash
set -e
ORBIT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GHOST_DIR="$ORBIT_DIR/../../rootfs"
cp "$ORBIT_DIR/logs/events.json"   "$GHOST_DIR/var/heartbeat/orbit_events.json"   2>/dev/null || true
cp "$ORBIT_DIR/logs/context.json"  "$GHOST_DIR/var/heartbeat/orbit_context.json"  2>/dev/null || true
cp "$ORBIT_DIR/logs/missions.json" "$GHOST_DIR/var/heartbeat/orbit_missions.json" 2>/dev/null || true
cp "$ORBIT_DIR/logs/rituals.json"  "$GHOST_DIR/var/heartbeat/orbit_rituals.json"  2>/dev/null || true
EOF

chmod +x "$ORBIT_DIR/engine/sync_bridge.sh"

# Add "bridge" command to orbit.sh if missing
if ! grep -q "bridge)" "$ORBIT_DIR/orbit.sh"; then
  sed -i '/case "\$1" in/a \
  bridge)\n    bash "$BASE_DIR/engine/sync_bridge.sh"\n    ;;\n' "$ORBIT_DIR/orbit.sh"
fi

# Ritual Sync
mkdir -p "$ORBIT_DIR/rituals/scripts"

cat > "$ORBIT_DIR/rituals/scripts/ritual_sync.sh" << 'EOF'
#!/usr/bin/env bash
set -e
BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$BASE_DIR/../../ghost_os/ritual_engine/ritual_engine.py" --trigger orbit_sync 2>/dev/null || true
EOF

chmod +x "$ORBIT_DIR/rituals/scripts/ritual_sync.sh"

# Ghost_OS hook
cat > "$BASE_DIR/ghost_os/ritual_engine/orbit_hook.sh" << 'EOF'
#!/usr/bin/env bash
set -e
bash "$(pwd)/ghost_ops_unit/orbit/orbit.sh" ritual sync
EOF

chmod +x "$BASE_DIR/ghost_os/ritual_engine/orbit_hook.sh"

echo
echo "====================================="
echo " INSTALLAZIONE COMPLETATA"
echo " Survival Pack + War Mode + Bridge attivi"
echo " Avvia con: ./ghost_survival_console.sh"
echo "====================================="
