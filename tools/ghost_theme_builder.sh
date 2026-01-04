#!/usr/bin/env bash
set -e

echo "[GHOST_THEME_BUILDER] Generazione docs/style.css (Ghost 90s Tech Fusion)..."

mkdir -p docs

cat > docs/style.css << 'EOF'
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

/* Header */
header {
  text-align: center;
  padding: 60px 20px;
  background: linear-gradient(180deg, #041f0f 0%, #020302 80%);
  border-bottom: 2px solid #0aff9d;
  box-shadow: 0 0 20px rgba(0,255,140,0.2);
}

header h1 {
  margin: 0;
  font-size: 3rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: #0aff9d;
  text-shadow: 0 0 12px rgba(0,255,140,0.6);
}

header p {
  margin-top: 12px;
  color: #7fffc8;
  font-size: 1.1rem;
}

/* Navbar */
nav {
  text-align: center;
  padding: 12px;
  background: #031a10;
  border-bottom: 1px solid #0aff9d;
  position: sticky;
  top: 0;
  z-index: 10;
  box-shadow: 0 0 10px rgba(0,255,140,0.15);
}

nav a {
  color: #0aff9d;
  margin: 0 14px;
  text-decoration: none;
  font-size: 0.95rem;
  transition: 0.2s ease;
}

nav a:hover {
  color: #b3ffdf;
  text-shadow: 0 0 8px rgba(0,255,140,0.6);
}

/* Content */
section {
  max-width: 900px;
  margin: 40px auto;
  padding: 0 20px 60px;
}

section h2 {
  border-bottom: 1px solid #0aff9d;
  padding-bottom: 6px;
  color: #0aff9d;
  text-shadow: 0 0 6px rgba(0,255,140,0.4);
}

section h3 {
  margin-top: 30px;
  color: #7fffc8;
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

code {
  background: #041f0f;
  padding: 3px 6px;
  border-radius: 4px;
  color: #9bffd9;
}

/* Footer */
footer {
  text-align: center;
  padding: 25px;
  background: #020302;
  border-top: 1px solid #0aff9d;
  font-size: 0.85rem;
  color: #7fffc8;
  text-shadow: 0 0 4px rgba(0,255,140,0.3);
}
EOF

echo "[GHOST_THEME_BUILDER] Tema scritto in docs/style.css"
