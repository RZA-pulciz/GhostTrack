#!/usr/bin/env bash
set -e

echo "==============================="
echo " GHOST_GIT_DOCTOR — DIAGNOSTICA"
echo "==============================="

echo
echo "[1] Stato generale della repo"
git status
echo

echo "[2] File tracciati che NON dovrebbero essere tracciati"
BAD=$(git ls-files | grep -E "ghost_os.img|rootfs|tar.gz" || true)
if [ -z "$BAD" ]; then
    echo "✔ Nessun file pesante tracciato"
else
    echo "$BAD"
fi
echo

echo "[3] File ignorati ma ancora nello staging"
BAD2=$(git ls-files -i -o --exclude-from=.gitignore || true)
if [ -z "$BAD2" ]; then
    echo "✔ Nessun file ignorato nello staging"
else
    echo "$BAD2"
fi
echo

echo "[4] Controllo file > 100MB nella repo"
find . -type f -size +100M -print || echo "✔ Nessun file >100MB nella repo"
echo

echo "[5] Controllo se ghost_os.img è nella cronologia"
if git rev-list --objects --all | grep -q "ghost_os.img"; then
    echo "❌ ghost_os.img è ANCORA nella cronologia Git!"
else
    echo "✔ ghost_os.img NON è nella cronologia"
fi
echo

echo "[6] Contenuto di .gitignore"
echo "------------------------"
cat .gitignore
echo "------------------------"
echo

echo "[7] Ultimi commit"
git log --oneline -n 5
echo

echo "==============================="
echo " DIAGNOSTICA COMPLETATA"
echo "==============================="
