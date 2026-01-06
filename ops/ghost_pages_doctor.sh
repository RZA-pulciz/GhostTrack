#!/usr/bin/env bash
set -euo pipefail

echo "[GHOST_PAGES_DOCTOR] Analisi GitHub Pages per Ghost_Ops_Unit..."

ROOT="$(pwd)"

echo
echo "[1] Controllo branch corrente..."
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'UNKNOWN')"
echo "    Branch: $BRANCH"

if [[ "$BRANCH" != "main" && "$BRANCH" != "master" ]]; then
  echo "    [!] Non sei su main/master. GitHub Pages di solito usa main."
fi

echo
echo "[2] Controllo cartella docs/..."
if [[ ! -d "$ROOT/docs" ]]; then
  echo "    [!] docs/ NON esiste. GitHub Pages non troverà il sito."
  echo "    → Creo docs/ con index.html minimale."
  mkdir -p docs
  cat > docs/index.html << 'EOM'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Ghost_OS – GitHub Pages</title>
</head>
<body>
  <h1>Ghost_OS – Ghost_Ops_Unit</h1>
  <p>Pagina generata da ghost_pages_doctor.sh</p>
</body>
</html>
EOM
else
  echo "    [OK] docs/ esiste."
fi

echo
echo "[3] Controllo file chiave in docs/..."
if [[ -f docs/index.html ]]; then
  echo "    [OK] docs/index.html presente."
else
  echo "    [!] docs/index.html mancante. Creo versione minima."
  cat > docs/index.html << 'EOM'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Ghost_OS – GitHub Pages</title>
</head>
<body>
  <h1>Ghost_OS – Ghost_Ops_Unit</h1>
  <p>Pagina generata da ghost_pages_doctor.sh</p>
</body>
</html>
EOM
fi

echo
echo "[4] Controllo remote Git..."
REMOTE_URL="$(git remote get-url origin 2>/dev/null || echo 'NONE')"
echo "    Remote origin: $REMOTE_URL"
if [[ "$REMOTE_URL" == "NONE" ]]; then
  echo "    [!] Nessun remote origin configurato. Non posso pushare."
fi

echo
echo "[5] Stato Git locale..."
git status

echo
echo "[6] Preparazione push (docs/)..."
git add docs || true

if git diff --cached --quiet; then
  echo "    [OK] Nessuna modifica nuova in docs/ da committare."
else
  echo "    [*] Trovate modifiche in docs/. Creo commit."
  git commit -m "Ghost Pages Doctor: ensure docs/ for GitHub Pages" || true
fi

if [[ "$REMOTE_URL" != "NONE" ]]; then
  echo
  echo "[7] Eseguo git push..."
  git push || echo "[!] git push fallito. Controlla credenziali o connessione."
fi

echo
echo "[8] Passi da fare su GitHub (manuali ma guidati):"
echo "    1) Vai su: https://github.com/HighKali/Ghost_Ops_Unit/settings/pages"
echo "    2) In 'Build and deployment' verifica che:"
echo "       - Source: 'Deploy from a branch'"
echo "       - Branch: 'main' e cartella '/docs'"
echo "    3) Se il sito non si aggiorna ancora:"
echo "       - Premi 'Delete cache' (se presente) per forzare rebuild."
echo "       - Controlla i log build nella stessa pagina."
echo
echo "[GHOST_PAGES_DOCTOR] Completato. Attendi 1–2 minuti e ricarica la Page in incognito."
