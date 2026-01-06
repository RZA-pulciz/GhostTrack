#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST ORBIT SYSTEM — RELEASE RITUAL"
echo "====================================="

BASE_DIR="$(pwd)"

###############################################
# 1. README PRINCIPALE (MINIMALE MA VIVO)
###############################################

cat > "$BASE_DIR/README.md" << 'EOF'
# Ghost_Ops_Unit — Ghost Orbit System

Questa repo contiene:

- **Ghost Onion Node** → nodo centrale (Tor-only, concettuale)
- **Ghost Orbit Client** → satellite mobile (Android/Linux)
- **Ghost Peripheral** → sensori (es. Flipper Zero, in modalità passiva)
- **Ghost Orbit Engine** → motore di orchestrazione
- **Ghost Rituals** → rituali difensivi e simbolici
- **Ghost Dashboard** → vista HTML (scheletro)
- **Ghost Superguardian** → protezione della repo

Tutto è progettato in modo:

- difensivo  
- etico  
- non intrusivo  
- orientato a Tor/onion come modello di privacy  

Questa è una **versione scheletro viva**:  
la struttura è completa, i moduli sono presenti, pronti per essere riempiti e potenziati.
EOF

echo "[RITUAL] README.md aggiornato."

###############################################
# 2. GITHUB ACTIONS WORKFLOW (CHECK MINIMALE)
###############################################

WORKFLOW_DIR="$BASE_DIR/.github/workflows"
mkdir -p "$WORKFLOW_DIR"

cat > "$WORKFLOW_DIR/ghost_orbit_check.yml" << 'EOF'
name: Ghost Orbit System — Basic Check

on:
  push:
  pull_request:

jobs:
  basic-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: List tree
        run: |
          echo "=== Repo tree ==="
          ls -R

      - name: Check core directories
        run: |
          for d in ghost_onion_node ghost_orbit_client ghost_peripheral ghost_orbit_engine ghost_rituals ghost_dashboard ghost_superguardian; do
            if [ ! -d "$d" ]; then
              echo "Missing directory: $d"
              exit 1
            else
              echo "Found: $d"
            fi
          done

      - name: Check main scripts exist
        run: |
          for f in ghost_orbit_bootstrap.sh ghost_orbit_compile_all.sh ghost_orbit_demo_ritual.sh; do
            if [ ! -f "$f" ]; then
              echo "Missing script: $f"
              exit 1
            else
              echo "Found: $f"
            fi
          done
EOF

echo "[RITUAL] Workflow GitHub Actions creato: .github/workflows/ghost_orbit_check.yml"

###############################################
# 3. COMMIT RITUALE + TAG
###############################################

echo "[RITUAL] Aggiungo tutti i file al commit…"
git add .

echo "[RITUAL] Creo commit rituale…"
git commit -m "RITUAL: Ghost Orbit System v0.1 — struttura viva, moduli e rituali"

TAG_NAME="v0.1-GHOST_ORBIT_SYSTEM"

if git tag | grep -q "$TAG_NAME"; then
  echo "[RITUAL] Tag $TAG_NAME esiste già, non lo ricreo."
else
  echo "[RITUAL] Creo tag: $TAG_NAME"
  git tag "$TAG_NAME"
fi

###############################################
# 4. PUSH CODICE + TAG
###############################################

echo "[RITUAL] Push codice…"
git push

echo "[RITUAL] Push tag…"
git push origin "$TAG_NAME"

echo
echo "====================================="
echo " GHOST ORBIT SYSTEM — RELEASE COMPLETATA"
echo " Tag: $TAG_NAME"
echo "====================================="
