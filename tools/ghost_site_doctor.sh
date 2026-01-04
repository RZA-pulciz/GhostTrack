#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS="$ROOT/docs"

echo "[GHOST_SITE_DOCTOR] Analisi e correzione sito Ghost_OS..."

###############################################
# 1. Verifica / crea cartella docs
###############################################
if [[ ! -d "$DOCS" ]]; then
  echo "[+] Cartella docs non trovata, la creo..."
  mkdir -p "$DOCS"
else
  echo "[OK] Cartella docs esistente."
fi

###############################################
# 2. Verifica file chiave del sito
###############################################
NEED_REBUILD=0

check_file() {
  local f="$1"
  if [[ ! -f "$DOCS/$f" ]]; then
    echo "[!] Manca docs/$f"
    NEED_REBUILD=1
  else
    echo "[OK] docs/$f presente."
  fi
}

check_file "index.html"
check_file "style.css"

###############################################
# 3. Se mancano file chiave, ricreo sito minimo
###############################################
if [[ "$NEED_REBUILD" -eq 1 ]]; then
  echo "[GHOST_SITE_DOCTOR] Ricostruisco sito minimo in docs/..."

  cat > "$DOCS/style.css" << 'EOM'
body { font-family: system-ui, sans-serif; background:#050608; color:#e4e4e4; margin:0; }
header { text-align:center; padding:40px 20px; background:#111; border-bottom:1px solid #333; }
nav { text-align:center; padding:10px; background:#151515; border-bottom:1px solid #222; }
nav a { color:#66ccff; margin:0 12px; text-decoration:none; }
section { max-width:900px; margin:30px auto; padding:0 20px 40px; }
pre { background:#111; padding:12px; border-radius:4px; overflow-x:auto; }
footer { text-align:center; padding:20px; background:#08080a; border-top:1px solid #222; font-size:0.85rem; color:#777; }
EOM

  cat > "$DOCS/index.html" << 'EOM'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Ghost Ops Unit – Ghost_OS</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>Ghost Ops Unit</h1>
    <p>Ghost_OS – Ghost Cyber Defence OS</p>
  </header>
  <nav>
    <a href="index.html">Home</a>
  </nav>
  <section>
    <h2>Benvenuto in Ghost_OS</h2>
    <p>Sistema operativo effimero, modulare e rituale per cyber difesa legale.</p>
  </section>
  <footer>
    <p>© 2025 Ghost Ops Unit – HighKali</p>
  </footer>
</body>
</html>
EOM

  echo "[GHOST_SITE_DOCTOR] Sito minimo ricreato."
fi

###############################################
# 4. Verifica / crea ghost_build_site.sh base
###############################################
if [[ ! -f "$ROOT/ghost_build_site.sh" ]]; then
  echo "[!] ghost_build_site.sh mancante, creo versione base..."

  cat > "$ROOT/ghost_build_site.sh" << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS="$ROOT/docs"
mkdir -p "$DOCS"
# qui puoi in futuro espandere con pagine aggiuntive
echo "[GHOST_BUILD_SITE] Rigenero index.html + style.css..."
cat > "$DOCS/style.css" << 'EOF2'
body { font-family: system-ui, sans-serif; background:#050608; color:#e4e4e4; margin:0; }
header { text-align:center; padding:40px 20px; background:#111; border-bottom:1px solid #333; }
nav { text-align:center; padding:10px; background:#151515; border-bottom:1px solid #222; }
nav a { color:#66ccff; margin:0 12px; text-decoration:none; }
section { max-width:900px; margin:30px auto; padding:0 20px 40px; }
pre { background:#111; padding:12px; border-radius:4px; overflow-x:auto; }
footer { text-align:center; padding:20px; background:#08080a; border-top:1px solid #222; font-size:0.85rem; color:#777; }
EOF2
cat > "$DOCS/index.html" << 'EOF2'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Ghost Ops Unit – Ghost_OS</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>Ghost Ops Unit</h1>
    <p>Ghost_OS – Ghost Cyber Defence OS</p>
  </header>
  <nav>
    <a href="index.html">Home</a>
  </nav>
  <section>
    <h2>Benvenuto in Ghost_OS</h2>
    <p>Sistema operativo effimero, modulare e rituale per cyber difesa legale.</p>
  </section>
  <footer>
    <p>© 2025 Ghost Ops Unit – HighKali</p>
  </footer>
</body>
</html>
EOF2
echo "[GHOST_BUILD_SITE] Sito base rigenerato in docs/."
EOM

  chmod +x "$ROOT/ghost_build_site.sh"
else
  echo "[OK] ghost_build_site.sh esistente."
fi

###############################################
# 5. Mostra stato Git e suggerisce commit
###############################################
cd "$ROOT"
echo
echo "[GHOST_SITE_DOCTOR] Stato Git dopo correzioni:"
git status

echo
echo "[GHOST_SITE_DOCTOR] Se ti va bene, esegui:"
echo "  git add docs ghost_build_site.sh"
echo "  git commit -m \"Fix sito Ghost_OS\""
echo "  git push"
echo
echo "[GHOST_SITE_DOCTOR] Completato."
