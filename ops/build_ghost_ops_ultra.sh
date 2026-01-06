#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$BASE_DIR/ghost_ops_unit.sh"

cat > "$TARGET" << 'EOF'
#!/usr/bin/env bash

# ============================================================
#   GHOST OPS UNIT — VERSIONE ULTRA FULL COLOR (C1)
#   Sistema Orbitale di Difesa, Analisi e Sincronizzazione
# ============================================================

set -e

# === ANSI COLORS ===
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# === PATHS ===
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$BASE_DIR/var/logs"
mkdir -p "$LOG_DIR"

# === BANNER ULTRA FULL COLOR ===
banner() {
  echo -e "${MAGENTA}"
  echo "╔═══════════════════════════════════════════════════════╗"
  echo "║       ✦ GHOST OPS UNIT — ORBITAL ULTRA ENGINE ✦       ║"
  echo "╠═══════════════════════════════════════════════════════╣"
  echo "║   Sistema di Difesa, Analisi, Sincronizzazione e Arte ║"
  echo "║   Modalità: ULTRA FULL COLOR (C1)                     ║"
  echo "╚═══════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# === LOGGING ===
log() {
  echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')]${RESET} $1"
}

# ============================================================
#   SEZIONE 2 — CONFIG, DIRECTORY CHECK, INTEGRITY ENGINE
# ============================================================

# === DIRECTORY CHECK ===
check_directories() {
  echo -e "${BLUE}➤ Verifica directory essenziali...${RESET}"

  REQUIRED_DIRS=(
    "$BASE_DIR"
    "$BASE_DIR/var"
    "$BASE_DIR/var/logs"
    "$BASE_DIR/modules"
  )

  for d in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$d" ]; then
      echo -e "${YELLOW}[CREO]${RESET} Directory mancante: $d"
      mkdir -p "$d"
    else
      echo -e "${GREEN}[OK]${RESET} $d"
    fi
  done
}

# === INTEGRITY ENGINE (ULTRA) ===
integrity_build() {
  echo -e "${MAGENTA}✦ Rigenerazione Manifest di Integrità ✦${RESET}"

  MANIFEST="$BASE_DIR/var/integrity.manifest"
  echo "# Ghost_Ops_Unit Integrity Manifest" > "$MANIFEST"
  echo "# Generated: $(date)" >> "$MANIFEST"
  echo "" >> "$MANIFEST"

  find "$BASE_DIR" -type f ! -path "*/.git/*" | while read -r f; do
    HASH=$(sha256sum "$f" | awk '{print $1}')
    echo "$HASH  $f" >> "$MANIFEST"
  done

  echo -e "${GREEN}Integrità aggiornata.${RESET}"
}

integrity_check() {
  echo -e "${BLUE}➤ Controllo integrità file...${RESET}"

  MANIFEST="$BASE_DIR/var/integrity.manifest"
  if [ ! -f "$MANIFEST" ]; then
    echo -e "${RED}Manifest non trovato. Generarlo con: integrity-build${RESET}"
    return 1
  fi

  while read -r line; do
    HASH_EXPECTED=$(echo "$line" | awk '{print $1}')
    FILE_PATH=$(echo "$line" | awk '{print $2}')

    if [ ! -f "$FILE_PATH" ]; then
      echo -e "${RED}[MANCANTE]${RESET} $FILE_PATH"
      continue
    fi

    HASH_REAL=$(sha256sum "$FILE_PATH" | awk '{print $1}')

    if [ "$HASH_EXPECTED" != "$HASH_REAL" ]; then
      echo -e "${RED}[ALTERATO]${RESET} $FILE_PATH"
    else
      echo -e "${GREEN}[OK]${RESET} $FILE_PATH"
    fi
  done < "$MANIFEST"
}

# === HEALTHCHECK BASE ===
healthcheck() {
  echo -e "${CYAN}✦ HEALTHCHECK — Diagnostica Orbitale ✦${RESET}"

  echo -e "${BLUE}➤ Verifica directory...${RESET}"
  check_directories

  echo -e "${BLUE}➤ Verifica integrità...${RESET}"
  integrity_check || true

  echo -e "${BLUE}➤ Verifica permessi...${RESET}"
  find "$BASE_DIR" -maxdepth 1 -type f | while read -r f; do
    if [ ! -x "$f" ]; then
      echo -e "${YELLOW}[FIX]${RESET} Permessi esecuzione aggiunti a $f"
      chmod +x "$f"
    else
      echo -e "${GREEN}[OK]${RESET} $f"
    fi
  done

  echo -e "${GREEN}Healthcheck completato.${RESET}"
}

# ============================================================
#   SEZIONE 3 — INFO, MAPPA ORBITALE ULTRA, TRACE SHIELD
# ============================================================

# === INFO SYSTEM ===
info_system() {
  banner
  echo -e "${CYAN}✦ INFO SISTEMA — Ghost Ops Unit ULTRA ✦${RESET}"
  echo -e "${BLUE}Percorso Base:${RESET} $BASE_DIR"
  echo -e "${BLUE}Log Directory:${RESET} $LOG_DIR"
  echo -e "${BLUE}Data:${RESET} $(date)"
  echo -e "${BLUE}Kernel:${RESET} $(uname -a)"
  echo -e "${BLUE}Shell:${RESET} $SHELL"
  echo -e "${BLUE}Utente:${RESET} $USER"
  echo -e "${GREEN}Sistema operativo pronto.${RESET}"
}

# === MAPPA ORBITALE ULTRA FULL COLOR ===
map_orbit() {
  banner
  echo -e "${MAGENTA}✦ MAPPA ORBITALE — VERSIONE ULTRA FULL COLOR ✦${RESET}"
  echo -e "${CYAN}"
  echo "                 .        *        ."
  echo "        ✦ GHOST ORBITAL NETWORK — ULTRA MODE ✦"
  echo ""
  echo "                     ☾  NODO CENTRALE  ☽"
  echo "                          (GHOST_OS)"
  echo ""
  echo "        ┌───────────────┬───────────────┬───────────────┐"
  echo "        │               │               │               │"
  echo "   [TRACE SHIELD]   [NET GUARD]   [SYS WATCH]   [SYNC ENGINE]"
  echo "        │               │               │               │"
  echo "        └───────────────┴───────────────┴───────────────┘"
  echo ""
  echo "                 ✦  ORBITA DI SICUREZZA ATTIVA  ✦"
  echo -e "${RESET}"
}

# === TRACE SHIELD WRAPPER ===
trace_shield() {
  banner
  echo -e "${MAGENTA}✦ GHOST TRACE SHIELD — Analisi Tracce ✦${RESET}"

  MODULE="$BASE_DIR/ghost_trace_shield.sh"

  if [ ! -f "$MODULE" ]; then
    echo -e "${RED}Modulo ghost_trace_shield.sh non trovato.${RESET}"
    echo -e "${YELLOW}Posizionalo nella root del progetto.${RESET}"
    return 1
  fi

  chmod +x "$MODULE"
  bash "$MODULE"
}

# === WRAPPER PER ALTRI MODULI (FUTURI) ===
run_module() {
  MODULE="$BASE_DIR/modules/$1.sh"

  if [ ! -f "$MODULE" ]; then
    echo -e "${RED}Modulo non trovato:${RESET} $1"
    return 1
  fi

  chmod +x "$MODULE"
  bash "$MODULE"
}

# ============================================================
#   SEZIONE 4 — SYNC ENGINE ULTRA FULL COLOR
# ============================================================

# === SYNC STANDARD ===
sync_repo() {
  banner
  echo -e "${CYAN}✦ SYNC — Sincronizzazione Standard ✦${RESET}"

  echo -e "${BLUE}➤ Pull con rebase...${RESET}"
  git pull --rebase || {
    echo -e "${RED}Errore durante il pull. Intervento manuale richiesto.${RESET}"
    return 1
  }

  echo -e "${BLUE}➤ Aggiunta modifiche...${RESET}"
  git add .

  echo -e "${BLUE}➤ Commit...${RESET}"
  git commit -m "SYNC: aggiornamento automatico Ghost_Ops_Unit" || {
    echo -e "${YELLOW}Nessuna modifica da committare.${RESET}"
  }

  echo -e "${BLUE}➤ Push...${RESET}"
  git push || {
    echo -e "${RED}Push fallito. Controllare conflitti o permessi.${RESET}"
    return 1
  }

  echo -e "${BLUE}➤ Rigenerazione manifest...${RESET}"
  integrity_build

  echo -e "${BLUE}➤ Healthcheck...${RESET}"
  healthcheck

  echo -e "${GREEN}SYNC completato.${RESET}"
}

# === SYNC HARD (FORZATO) ===
sync_hard() {
  banner
  echo -e "${MAGENTA}✦ SYNC-HARD — Riallineamento Forzato ✦${RESET}"

  echo -e "${BLUE}➤ Fetch remoto...${RESET}"
  git fetch --all

  echo -e "${BLUE}➤ Reset locale su origin/main...${RESET}"
  git reset --hard origin/main

  echo -e "${BLUE}➤ Aggiunta modifiche locali...${RESET}"
  git add .

  echo -e "${BLUE}➤ Commit...${RESET}"
  git commit -m "SYNC-HARD: riallineamento forzato" || true

  echo -e "${BLUE}➤ Push forzato...${RESET}"
  git push --force

  echo -e "${BLUE}➤ Rigenerazione manifest...${RESET}"
  integrity_build

  echo -e "${BLUE}➤ Healthcheck...${RESET}"
  healthcheck

  echo -e "${GREEN}SYNC-HARD completato.${RESET}"
}

# === SYNC QUIET (SILENZIOSO) ===
sync_quiet() {
  git pull --rebase >/dev/null 2>&1 || true
  git add . >/dev/null 2>&1
  git commit -m "SYNC-QUIET: aggiornamento silenzioso" >/dev/null 2>&1 || true
  git push >/dev/null 2>&1 || true
  integrity_build >/dev/null 2>&1
  healthcheck >/dev/null 2>&1
}

# === SYNC RITUAL (ESTETICO) ===
sync_ritual() {
  banner
  echo -e "${MAGENTA}🜁  Avvio del Rituale Orbitale di Sincronizzazione${RESET}"
  echo -e "${CYAN}🜂  Allineamento delle orbite Git${RESET}"
  echo -e "${BLUE}🜃  Purificazione dei delta${RESET}"
  echo -e "${YELLOW}🜄  Sigillatura del commit${RESET}"

  git pull --rebase
  git add .
  git commit -m "SYNC-RITUAL: rituale orbitale completato" || true
  git push

  integrity_build
  healthcheck

  echo -e "${GREEN}✦ Rituale completato — Ghost_Ops_Unit risplende ✦${RESET}"
}

# ============================================================
#   SEZIONE 5 — DISPATCHER + USAGE + FOOTER
# ============================================================

usage() {
  banner
  echo -e "${CYAN}✦ USO — Comandi Disponibili ✦${RESET}"
  echo ""
  echo -e "${GREEN}info${RESET}             — Mostra informazioni di sistema"
  echo -e "${GREEN}map${RESET}              — Mostra la mappa orbitale ULTRA"
  echo -e "${GREEN}trace${RESET}            — Avvia Ghost Trace Shield"
  echo ""
  echo -e "${GREEN}integrity-build${RESET}  — Rigenera il manifest di integrità"
  echo -e "${GREEN}integrity-check${RESET}  — Controlla l’integrità del sistema"
  echo -e "${GREEN}health${RESET}           — Esegue un healthcheck completo"
  echo ""
  echo -e "${GREEN}sync${RESET}             — Sincronizzazione standard"
  echo -e "${GREEN}sync-hard${RESET}        — Sincronizzazione forzata"
  echo -e "${GREEN}sync-quiet${RESET}       — Sincronizzazione silenziosa"
  echo -e "${GREEN}sync-ritual${RESET}      — Sincronizzazione estetica rituale"
  echo ""
  echo -e "${GREEN}module <nome>${RESET}    — Esegue un modulo in /modules"
  echo ""
  echo -e "${YELLOW}Esempio:${RESET} ./ghost_ops_unit.sh sync"
  echo ""
}

cmd="$1"
arg="$2"

case "$cmd" in
  info)
    info_system
    ;;
  map)
    map_orbit
    ;;
  trace)
    trace_shield
    ;;
  integrity-build)
    integrity_build
    ;;
  integrity-check)
    integrity_check
    ;;
  health)
    healthcheck
    ;;
  sync)
    sync_repo
    ;;
  sync-hard)
    sync_hard
    ;;
  sync-quiet)
    sync_quiet
    ;;
  sync-ritual)
    sync_ritual
    ;;
  module)
    run_module "$arg"
    ;;
  ""|help|--help|-h)
    usage
    ;;
  *)
    echo -e "${RED}Comando sconosciuto:${RESET} $cmd"
    usage
    ;;
esac

echo -e "${MAGENTA}✦ Ghost Ops Unit ULTRA — Operazione completata ✦${RESET}"
EOF

chmod +x "$TARGET"

echo "Generato: $TARGET"
