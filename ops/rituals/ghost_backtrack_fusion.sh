#!/data/data/com.termux/files/usr/bin/bash
set -e

# 1. Nome del nuovo progetto
FUSION_NAME="BackTrack_Ghost"

# 2. Crea directory di fusione
mkdir -p "$FUSION_NAME"

# 3. Scheletro "distro-like" in stile BackTrack
cd "$FUSION_NAME"
mkdir -p \
  etc \
  usr/bin \
  usr/sbin \
  usr/share \
  var/log \
  var/tmp \
  opt \
  lib \
  boot \
  home/ghost \
  root \
  mnt \
  media \
  tmp

# 4. Rientra nella root del repo originario
cd ..

# 5. Innesta il core di Ghost_Ops_Unit dentro la fusione
cp -r core          "$FUSION_NAME/opt/ghost_core"
cp -r ghost_os      "$FUSION_NAME/opt/ghost_os"
cp -r ghost_ops_unit "$FUSION_NAME/opt/ghost_ops_unit"
cp -r modules       "$FUSION_NAME/opt/ghost_modules"
cp -r ops           "$FUSION_NAME/opt/ghost_ops"
cp -r rituals       "$FUSION_NAME/opt/ghost_rituals"
cp -r docs          "$FUSION_NAME/opt/ghost_docs"
cp -r var           "$FUSION_NAME/var/ghost"

# 6. Copia alcuni script chiave come "comandi di sistema"
cp ghost_survival_console.sh  "$FUSION_NAME/usr/bin/ghost-survival"
cp ghost_full_activation.sh   "$FUSION_NAME/usr/bin/ghost-activate"
cp ghost_text_only_mode.sh    "$FUSION_NAME/usr/bin/ghost-tty"
cp ghost_site_builder.sh      "$FUSION_NAME/usr/bin/ghost-site"
cp ghost_super_ritual.sh      "$FUSION_NAME/usr/sbin/ghost-super"
cp ghost_total_integration.sh "$FUSION_NAME/usr/sbin/ghost-integrate"

# 7. Rende eseguibili i "comandi"
chmod +x "$FUSION_NAME"/usr/bin/*
chmod +x "$FUSION_NAME"/usr/sbin/*

# 8. Crea un manifest minimale
cat > "$FUSION_NAME/etc/backtrack_ghost_manifest.txt" << 'EOM'
BackTrack_Ghost Fusion Environment
Base: Ghost_Ops_Unit + distro-like skeleton
Questo NON è un OS completo, ma un ambiente operativo ibrido.
EOM

echo "[OK] Fusione creata in: $FUSION_NAME"
echo "Aggiungi al PATH, ad esempio:"
echo "  export PATH=\$PWD/$FUSION_NAME/usr/bin:\$PWD/$FUSION_NAME/usr/sbin:\$PATH"
