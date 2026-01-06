#!/usr/bin/env bash
set -e

echo "[GHOST_SUPER_RITUAL] Avvio rito completo Ghost_OS..."

mkdir -p docs

############################################
# 1. THEME + EFFECTS (FULL OVERRIDE)
############################################
echo "[1] Generazione tema Ghost 90s Tech Fusion + effetti..."

cat > docs/style.css << "EOF"
/* ================================
   GHOST_OS — 90s TECH FUSION THEME
   Fluido • Tecnico • Retro-Futurista
   ================================ */

body {
  font-family: "IBM Plex Mono", "Courier New", monospace;
  background: #020302;
  color: #c8f7d4;
  margin: 0;
  padding: 0;
  line-height: 1.6;
  text-shadow: 0 0 2px rgba(0,255,140,0.25);
  background-image:
    linear-gradient(rgba(0,255,140,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,255,140,0.03) 1px, transparent 1px);
  background-size: 4px 4px;
  image-rendering: pixelated;
}

/* CRT scanlines */
body::after {
  content: "";
  position: fixed;
  inset: 0;
  pointer-events: none;
  background: repeating-linear-gradient(
    to bottom,
    rgba(0,255,140,0.03) 0px,
    rgba(0,255,140,0.03) 1px,
    transparent 2px,
    transparent 3px
  );
  opacity: 0.25;
  mix-blend-mode: overlay;
}

/* Screen noise */
#noise {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2P4//8/AwAI/AL+X2VINwAAAABJRU5ErkJggg==");
  opacity: 0.05;
  z-index: 9999;
}

/* Glitch effect */
.glitch {
  position: relative;
  color: #0aff9d;
}
.glitch::before,
.glitch::after {
  content: attr(data-text);
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0.6;
}
.glitch::before {
  left: 2px;
  text-shadow: -2px 0 magenta;
  animation: glitch 0.3s infinite;
}
.glitch::after {
  left: -2px;
  text-shadow: -2px 0 cyan;
  animation: glitch 0.4s infinite;
}
@keyframes glitch {
  0% { clip-path: inset(0 0 80% 0); }
  20% { clip-path: inset(10% 0 60% 0); }
  40% { clip-path: inset(40% 0 30% 0); }
  60% { clip-path: inset(20% 0 50% 0); }
  80% { clip-path: inset(60% 0 10% 0); }
  100% { clip-path: inset(0 0 80% 0); }
}

/* Cursor blinking */
.cursor {
  display: inline-block;
  width: 10px;
  height: 18px;
  background: #0aff9d;
  margin-left: 4px;
  animation: blink 0.8s infinite;
}
@keyframes blink {
  0% { opacity: 1; }
  50% { opacity: 0; }
  100% { opacity: 1; }
}

/* Typing effect */
.typewriter {
  overflow: hidden;
  border-right: 2px solid #0aff9d;
  white-space: nowrap;
  animation: typing 3s steps(40, end), blink-caret 0.75s step-end infinite;
}
@keyframes typing {
  from { width: 0 }
  to { width: 100% }
}
@keyframes blink-caret {
  50% { border-color: transparent; }
}

/* Terminal reveal */
.terminal-line {
  opacity: 0;
  animation: reveal 0.6s forwards;
}
@keyframes reveal {
  to { opacity: 1; }
}

/* Code blocks */
pre {
  background: #031a10;
  padding: 16px;
  border-radius: 4px;
  overflow-x: auto;
  border: 1px solid #0aff9d;
  box-shadow: 0 0 12px rgba(0,255,140,0.15);
}
EOF

echo "[OK] Tema completo generato."

############################################
# 2. NAVBAR
############################################
NAV='<nav>
  <a href="index.html">Home</a>
  <a href="about.html">About</a>
  <a href="modules.html">Modules</a>
  <a href="flipper.html">Flipper</a>
  <a href="logs.html">Logs</a>
  <a href="install.html">Install</a>
  <a href="contact.html">Contact</a>
</nav>'

############################################
# 3. PAGE GENERATOR
############################################
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
<body class=\"crt\">

<header>
  <h1 class=\"glitch\" data-text=\"Ghost_OS\">Ghost_OS</h1>
  <p>Rituale • Effimero • Difensivo</p>
</header>

$NAV

<section>
$CONTENT
</section>

<footer>
<p>© Ghost_OS – HighKali</p>
</footer>

<div id=\"noise\"></div>

</body>
</html>" > "$FILE"

  echo "  → Generata pagina: $FILE"
}

############################################
# 4. PAGES
############################################
echo "[2] Generazione pagine..."

make_page "index" "Home" "<h2>Benvenuto in Ghost_OS <span class='cursor'></span></h2>
<p class='typewriter'>$ loading Ghost_OS modules...</p>
<pre>
<span class='terminal-line'>$ welcome</span>
<span class='terminal-line'>Ghost_OS — Sistema operativo rituale per cyber difesa etica.</span>
<span class='terminal-line'>Ogni esecuzione è un rito. Ogni log è un battito.</span>
</pre>
"

make_page "about" "About" "<h2>About Ghost_OS <span class='cursor'></span></h2>
<pre>
<span class='terminal-line'>$ whoami</span>
<span class='terminal-line'>Ghost_OS — Sistema Operativo Rituale</span>

<span class='terminal-line'>$ philosophy</span>
<span class='terminal-line'>- Nessuno stato permanente</span>
<span class='terminal-line'>- Nessuna traccia inutile</span>
<span class='terminal-line'>- Ogni azione è un rito</span>
<span class='terminal-line'>- Ogni log è un battito</span>

<span class='terminal-line'>$ architecture</span>
<span class='terminal-line'>core/ ops/ missions/ rituals/ var/</span>
</pre>
"

make_page "modules" "Modules" "<h2>Modules <span class='cursor'></span></h2>
<pre>
<span class='terminal-line'>$ ls modules/</span>
<span class='terminal-line'>core/ ops/ missions/ rituals/ var/</span>

<span class='terminal-line'>$ core/</span>
<span class='terminal-line'>integrità, heartbeat, logging</span>

<span class='terminal-line'>$ ops/</span>
<span class='terminal-line'>ghost_doctor, ghost_selfheal, ghost_push</span>
</pre>
"

make_page "flipper" "Flipper Integration" "<h2>Flipper Integration <span class='cursor'></span></h2>
<pre>
<span class='terminal-line'>$ flipper status</span>
<span class='terminal-line'>Device: Flipper Zero</span>
<span class='terminal-line'>Mode: Passive Analysis</span>
</pre>
"

make_page "logs" "Logs" "<h2>Logs <span class='cursor'></span></h2>
<pre>
<span class='terminal-line'>$ tail -f ghost.log.json</span>
<span class='terminal-line'>{ \"event\": \"heartbeat\", \"status\": \"ok\" }</span>
</pre>
"

make_page "install" "Installazione" "<h2>Installazione <span class='cursor'></span></h2>
<pre>
$ termux
pkg update
pkg install git python bash coreutils
</pre>
"

make_page "contact" "Contact" "<h2>Contatti <span class='cursor'></span></h2>
<pre>
$ github
https://github.com/HighKali/Ghost_Ops_Unit
</pre>
"

############################################
# 5. GIT PUSH
############################################
echo "[3] Aggiornamento GitHub..."

git add docs || true

if git diff --cached --quiet; then
  echo "    Nessuna modifica da committare."
else
  git commit -m "Ghost_OS: full site + theme + effects ritual update"
fi

git push || echo "[!] git push fallito."

echo "[GHOST_SUPER_RITUAL] Completato."
echo "Apri: https://highkali.github.io/Ghost_Ops_Unit/"
EOF
