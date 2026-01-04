#!/data/data/com.termux/files/usr/bin/bash
set -e

FUSION_ROOT="GhostBacktrack_Lab"

echo "[*] Creazione ambiente ibrido: $FUSION_ROOT"

# 1. Struttura generale
mkdir -p "$FUSION_ROOT"/{system/{etc,usr/bin,usr/sbin,var/log,var/tmp,opt,home/ghost,tmp},framework,lab/{workflows,logs,scripts},manifest}

#######################################
# 2. Ambiente concettuale "OS-like"
#######################################

# Manifesto concettuale
cat > "$FUSION_ROOT/manifest/00_CONCEPT_MANIFEST.txt" << 'EOM'
GhostBacktrack_Lab
Ambiente concettuale ispirato a una distro, ma puramente simbolico.
Nessun tool offensivo, solo struttura, orchestrazione e rituali di automazione.
EOM

# Prompt minimale di "shell concettuale"
cat > "$FUSION_ROOT/system/usr/bin/g-shell" << 'EOM'
#!/data/data/com.termux/files/usr/bin/bash
echo "=== GhostBacktrack Shell Concettuale ==="
echo "Questo non è un sistema operativo reale."
echo "Usa: g-framework, g-lab, g-ritual-list"
exec /data/data/com.termux/files/usr/bin/bash --noprofile --norc
EOM
chmod +x "$FUSION_ROOT/system/usr/bin/g-shell"

#######################################
# 3. Framework modulare (usa il cuore Ghost)
#######################################

# Copia blocchi Ghost solo come framework
copy_if_exists() {
  [ -e "$1" ] && cp -r "$1" "$2"
}

echo "[*] Innesto componenti Ghost nel framework..."
copy_if_exists core           "$FUSION_ROOT/framework/core"
copy_if_exists ghost_os       "$FUSION_ROOT/framework/ghost_os"
copy_if_exists ghost_ops_unit "$FUSION_ROOT/framework/ghost_ops_unit"
copy_if_exists modules        "$FUSION_ROOT/framework/modules"
copy_if_exists ops            "$FUSION_ROOT/framework/ops"
copy_if_exists rituals        "$FUSION_ROOT/framework/rituals"
copy_if_exists docs           "$FUSION_ROOT/framework/docs"
copy_if_exists var            "$FUSION_ROOT/framework/var"

# Wrapper per caricare il framework
cat > "$FUSION_ROOT/system/usr/bin/g-framework" << 'EOM'
#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FRAMEWORK="$ROOT/framework"

echo "[*] Caricamento GhostBacktrack Framework..."
echo "Root: $ROOT"

if [ -d "$FRAMEWORK/core" ]; then
  export GHOST_FRAMEWORK_ROOT="$FRAMEWORK"
  echo "[OK] Framework disponibile in: $GHOST_FRAMEWORK_ROOT"
else
  echo "[!] Framework non trovato."
fi
EOM
chmod +x "$FUSION_ROOT/system/usr/bin/g-framework"

#######################################
# 4. Laboratorio di automazione
#######################################

# Script di orchestrazione laboratorio
cat > "$FUSION_ROOT/system/usr/bin/g-lab" << 'EOM'
#!/data/data/com.termux/files/usr/bin/bash
LAB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/lab"
LOG_DIR="$LAB_ROOT/logs"
WF_DIR="$LAB_ROOT/workflows"
SCR_DIR="$LAB_ROOT/scripts"

mkdir -p "$LOG_DIR" "$WF_DIR" "$SCR_DIR"

echo "=== GhostBacktrack Automation Lab ==="
echo "Root laboratorio: $LAB_ROOT"
echo
echo "Comandi:"
echo "  g-lab list        - elenca workflow"
echo "  g-lab run <nome>  - esegue workflow"
echo "  g-lab log         - mostra log recenti"
echo

cmd="$1"
case "$cmd" in
  list)
    echo "[*] Workflow disponibili in: $WF_DIR"
    ls -1 "$WF_DIR" 2>/dev/null || echo "(nessuno)"
    ;;
  run)
    WF="$2"
    if [ -z "$WF" ]; then
      echo "Uso: g-lab run <workflow>"
      exit 1
    fi
    FILE="$WF_DIR/$WF"
    if [ ! -f "$FILE" ]; then
      echo "[!] Workflow non trovato: $FILE"
      exit 1
    fi
    LOG="$LOG_DIR/${WF}_$(date +%Y%m%d_%H%M%S).log"
    echo "[*] Esecuzione workflow: $WF"
    echo "[*] Log: $LOG"
    bash "$FILE" | tee "$LOG"
    ;;
  log)
    echo "[*] Log in: $LOG_DIR"
    ls -1 "$LOG_DIR" 2>/dev/null || echo "(nessuno)"
    ;;
  *)
    echo "Uso:"
    echo "  g-lab list"
    echo "  g-lab run <workflow>"
    echo "  g-lab log"
    ;;
esac
EOM
chmod +x "$FUSION_ROOT/system/usr/bin/g-lab"

#######################################
# 5. Registro rituali & combinazioni
#######################################

cat > "$FUSION_ROOT/system/usr/bin/g-ritual-list" << 'EOM'
#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "=== Registro rituali GhostBacktrack ==="
echo
echo "[Ambiente concettuale]"
echo "  g-shell        - entra nella shell concettuale"
echo
echo "[Framework]"
echo "  g-framework    - inizializza variabili del framework GhostBacktrack"
echo
echo "[Laboratorio]"
echo "  g-lab          - gestore workflow di automazione"
echo
echo "[Posizioni chiave]"
echo "  Framework: $ROOT/framework"
echo "  Lab:       $ROOT/lab"
EOM
chmod +x "$FUSION_ROOT/system/usr/bin/g-ritual-list"

#######################################
# 6. Script di attivazione PATH
#######################################

cat > "$FUSION_ROOT/activate_env.sh" << 'EOM'
#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$ROOT/system/usr/bin:$ROOT/system/usr/sbin:$PATH"
echo "[OK] PATH esteso con GhostBacktrack_Lab:"
echo "  $ROOT/system/usr/bin"
echo "  $ROOT/system/usr/sbin"
echo
echo "Comandi disponibili:"
echo "  g-shell"
echo "  g-framework"
echo "  g-lab"
echo "  g-ritual-list"
EOM
chmod +x "$FUSION_ROOT/activate_env.sh"

echo "[OK] Ambiente GhostBacktrack_Lab creato in: $FUSION_ROOT"
echo "Per attivare:"
echo "  source $FUSION_ROOT/activate_env.sh"
