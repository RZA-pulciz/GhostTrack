#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$BASE_DIR/var/logs"
TRACE_LOG="$LOG_DIR/trace_shield.log"

mkdir -p "$LOG_DIR"

banner() {
  echo "===================================================="
  echo "        GHOST TRACE SHIELD — OSINT DIFENSIVO"
  echo "===================================================="
  echo "Base: $BASE_DIR"
  echo "Log:  $TRACE_LOG"
  echo "===================================================="
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$TRACE_LOG"
}

scan_wifi_history() {
  log "[WIFI] Analisi reti Wi-Fi memorizzate..."

  # Info connessione attuale (Termux)
  if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
    termux-wifi-connectioninfo >> "$TRACE_LOG" 2>/dev/null
  fi

  # File storico Android (se accessibile)
  WIFI_CONF="/data/misc/wifi/WifiConfigStore.xml"
  if [ -f "$WIFI_CONF" ]; then
    log "[WIFI] Reti storiche trovate:"
    grep -E "SSID|BSSID|PreSharedKey" "$WIFI_CONF" >> "$TRACE_LOG" 2>/dev/null
  else
    log "[WIFI] Nessun file storico trovato o accesso negato."
  fi
}

scan_ip_history() {
  log "[IP] Analisi IP attuali..."
  ip addr show >> "$TRACE_LOG" 2>/dev/null

  log "[IP] Routing..."
  ip route >> "$TRACE_LOG" 2>/dev/null

  log "[IP] DNS configurati..."
  getprop | grep dns >> "$TRACE_LOG" 2>/dev/null
}

scan_system_logs() {
  log "[LOG] Analisi log di sistema..."

  # Log standard Linux
  for f in /var/log/*; do
    if [ -f "$f" ]; then
      echo "[LOG] $f" >> "$TRACE_LOG"
    fi
  done

  # Log app Termux/Android
  find /data/data -type f -name "*.log" 2>/dev/null | while read -r f; do
    echo "[LOG] $f" >> "$TRACE_LOG"
  done
}

scan_metadata() {
  log "[META] Analisi metadati immagini..."

  find "$BASE_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | while read -r img; do
    echo "[META] File: $img" >> "$TRACE_LOG"

    if command -v exiftool >/dev/null 2>&1; then
      exiftool "$img" >> "$TRACE_LOG" 2>/dev/null
    else
      echo "[META] exiftool non installato, salto." >> "$TRACE_LOG"
    fi
  done
}

scan_apps() {
  log "[APPS] Analisi app installate..."

  if command -v pm >/dev/null 2>&1; then
    pm list packages -3 >> "$TRACE_LOG" 2>/dev/null
  else
    log "[APPS] pm non disponibile (non ambiente Android)."
  fi
}

report_summary() {
  echo "" | tee -a "$TRACE_LOG"
  echo "====================================================" | tee -a "$TRACE_LOG"
  echo "   GHOST TRACE SHIELD — REPORT COMPLETATO" | tee -a "$TRACE_LOG"
  echo "====================================================" | tee -a "$TRACE_LOG"
  echo "Log completo salvato in: $TRACE_LOG" | tee -a "$TRACE_LOG"
  echo "====================================================" | tee -a "$TRACE_LOG"
}

# Esecuzione
banner
scan_wifi_history
scan_ip_history
scan_system_logs
scan_metadata
scan_apps
report_summary
