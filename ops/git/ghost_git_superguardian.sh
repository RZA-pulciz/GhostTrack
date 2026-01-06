#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST_GIT_SUPERGUARDIAN — AVVIO"
echo "====================================="

###############################################
# 1. DIAGNOSTICA SILENTE
###############################################

echo "[1] Diagnostica silente…"

HEAVY_FILES=$(find . -type f -size +100M || true)
TRACKED_HEAVY=$(git ls-files | grep -E "ghost_os.img|rootfs|tar.gz" || true)
IGNORED_STAGED=$(git ls-files -i -o --exclude-from=.gitignore || true)
IN_HISTORY=$(git rev-list --objects --all | grep -q "ghost_os.img" && echo "YES" || echo "NO")

###############################################
# 2. AUTO-RIPARAZIONE
###############################################

echo "[2] Auto-riparazione…"

# A) Rimuove file pesanti dallo staging
if [ -n "$TRACKED_HEAVY" ]; then
    echo "[FIX] Rimuovo file pesanti dallo staging…"
    git rm --cached -r ghost_os.img 2>/dev/null || true
    git rm --cached -r bootable/ghost_os.img 2>/dev/null || true
    git rm --cached -r rootfs.tar.gz 2>/dev/null || true
    git rm --cached -r bootable/rootfs.tar.gz 2>/dev/null || true
fi

# B) Rimuove file ignorati dallo staging
if [ -n "$IGNORED_STAGED" ]; then
    echo "[FIX] Pulizia file ignorati dallo staging…"
    git rm --cached -r $IGNORED_STAGED 2>/dev/null || true
fi

# C) Purga cronologia se necessario
if [ "$IN_HISTORY" = "YES" ]; then
    echo "[FIX] ghost_os.img trovato nella cronologia — avvio purga…"

    git filter-branch --force --index-filter \
      "git rm --cached --ignore-unmatch ghost_os.img; \
       git rm --cached --ignore-unmatch bootable/ghost_os.img; \
       git rm --cached --ignore-unmatch rootfs.tar.gz; \
       git rm --cached --ignore-unmatch bootable/rootfs.tar.gz; \
       git rm --cached --ignore-unmatch rootfs/ -r; \
       git rm --cached --ignore-unmatch bootable/rootfs/ -r" \
      --prune-empty --tag-name-filter cat -- --all

    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
fi

###############################################
# 3. COMMIT AUTOMATICO
###############################################

if git status --porcelain | grep -q .; then
    echo "[3] Creo commit di riparazione…"
    git add .
    git commit -m "GHOST_SUPERGUARDIAN: auto-riparazione completa"
else
    echo "[3] Nessuna modifica da committare."
fi

###############################################
# 4. PUSH AUTOMATICO
###############################################

if [ "$IN_HISTORY" = "YES" ]; then
    echo "[4] Push forzato…"
    git push origin --force
else
    echo "[4] Push normale…"
    git push
fi

###############################################
# 5. INSTALLAZIONE GIT GUARDIAN (pre-commit)
###############################################

echo "[5] Installazione Git Guardian…"

HOOK=".git/hooks/pre-commit"

cat > "$HOOK" << 'EOF'
#!/usr/bin/env bash

echo "[GIT GUARDIAN] Controllo rituale del commit…"

# Blocca file > 50MB
LARGE=$(git diff --cached --name-only | xargs -I{} bash -c 'if [ -f "{}" ] && [ $(stat -c%s "{}") -gt 50000000 ]; then echo "{}"; fi')

if [ -n "$LARGE" ]; then
    echo "[GUARDIAN] ❌ File troppo grande:"
    echo "$LARGE"
    exit 1
fi

# Blocca artefatti bootable
if git diff --cached --name-only | grep -E "ghost_os.img|rootfs|tar.gz|build_image" >/dev/null; then
    echo "[GUARDIAN] ❌ Artefatti bootable rilevati."
    exit 1
fi

# Blocca file ignorati
IGNORED=$(git ls-files -i --exclude-from=.gitignore)
if [ -n "$IGNORED" ]; then
    echo "[GUARDIAN] ❌ File ignorati ma tracciati:"
    echo "$IGNORED"
    exit 1
fi

echo "[GIT GUARDIAN] ✔ Tutto pulito."
EOF

chmod +x "$HOOK"

echo
echo "====================================="
echo " GHOST_GIT_SUPERGUARDIAN — COMPLETATO"
echo "====================================="
