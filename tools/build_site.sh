#!/usr/bin/env bash

mkdir -p docs

NAV='<nav>
  <a href="index.html">Home</a>
  <a href="about.html">About</a>
  <a href="modules.html">Modules</a>
  <a href="flipper.html">Flipper</a>
  <a href="logs.html">Logs</a>
  <a href="install.html">Install</a>
  <a href="contact.html">Contact</a>
</nav>'

make_page() {
  FILE="docs/$1.html"
  TITLE="$2"
  CONTENT="$3"

  printf "%s" "<!DOCTYPE html>
<html lang=\"it\">
<head>
<meta charset=\"UTF-8\">
<title>$TITLE – Ghost_OS</title>
<link rel=\"stylesheet\" href=\"style.css\">
</head>
<body>

<header>
  <h1>Ghost_OS</h1>
  <p>Rituale • Effimero • Difensivo</p>
</header>

$NAV

<section>
$CONTENT
</section>

<footer>
<p>© Ghost_OS – HighKali</p>
</footer>

</body>
</html>" > "$FILE"
}

make_page "index" "Home" "<h2>Benvenuto in Ghost_OS</h2><p>Sistema operativo rituale per cyber difesa etica.</p>"
make_page "about" "About" "<h2>About</h2><p>Ghost_OS è un sistema effimero, modulare e rituale.</p>"
make_page "modules" "Modules" "<h2>Modules</h2><p>Core, Ops, Missions, Rituals, Var.</p>"
make_page "flipper" "Flipper" "<h2>Flipper Integration</h2><p>Moduli dedicati a Flipper Zero.</p>"
make_page "logs" "Logs" "<h2>Logs</h2><p>Logging JSON effimero e rituale.</p>"
make_page "install" "Install" "<h2>Installazione</h2><p>Termux e Linux supportati.</p>"
make_page "contact" "Contact" "<h2>Contatti</h2><p>GitHub: https://github.com/HighKali</p>"

echo "Sito multipagina generato."
