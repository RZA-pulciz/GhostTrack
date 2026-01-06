#!/usr/bin/env bash
set -e

echo "===> [GHOSTTRACK] Avvio rituale di ristrutturazione completa..."

# 1. Creazione struttura canonica
mkdir -p core system ops ops/rituals ops/git modules modules/orbit modules/msg modules/flipper modules/legacy manifest docs var

echo "[OK] Struttura canonica verificata."

# 2. Spostamento file principali
mv ghost_bootstrap.sh . 2>/dev/null || true
mv ghost_ops_unit.sh . 2>/dev/null || true
mv ghost_update_all.sh . 2>/dev/null || true

echo "[OK] File principali posizionati."

# 3. Spostamento script operativi
mv build_ghost_ops_ultra.sh ops/ 2>/dev/null || true
mv ghost_cb_terminal.sh core/ 2>/dev/null || true
mv ghost_module_generator.sh core/ 2>/dev/null || true
mv ghost_orbit_bridge_install.sh modules/orbit/ 2>/dev/null || true

echo "[OK] Script operativi organizzati."

# 4. Spostamento moduli legacy
mv BackTrack_Ghost modules/legacy/ 2>/dev/null || true
mv GhostBacktrack_Lab modules/legacy/ 2>/dev/null || true

echo "[OK] Moduli legacy archiviati."

# 5. Pulizia root
rm -f "eval \"\$(ssh-agent -s)\"" "eval \"\$(ssh-agent -s)\".pub" 2>/dev/null || true

echo "[OK] File spazzatura rimossi."

# 6. Aggiornamento GitHub
echo "===> [GIT] Preparazione commit..."
git add .
git commit -m "GhostTrack: struttura perfetta, orbite definite, root pulito, moduli organizzati"
git push

echo "===> [GHOSTTRACK] Ristrutturazione completata e sincronizzata con GitHub."
