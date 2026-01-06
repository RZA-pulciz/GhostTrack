#!/usr/bin/env bash
set -e

echo "[GHOST_AUTODOCTOR] Avvio diagnostica silente…"

###############################################
# 1. DIAGNOSTICA SILENTE — ANALISI
###############################################

# File pesanti nella working tree
HEAVY_FILES=$(find . -type f -size +100M || true)

# File pesanti tracciati
TRACKED_HEAVY=$(git ls-files | grep -E "ghost_os.img|rootfs|tar.gz" || true)

# File ignorati ma ancora nello staging
IGNORED_STAGED=$(git ls-files -i -o --exclude-from=.gitignore || true)

# ghost_os.img nella cronologia
IN_HISTORY=$(git rev-list --objects --all | grep -q "ghost_os.img" && echo "YES" || echo "NO")


###############################################
# 2. AUTOCORREZIONE — SOLO SE NECESSARIO
###############################################

echo "[GHOST_AUTODOCTOR] Correzioni automatiche…"

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
    echo "[FIX] Pulizia staging da file ignorati…"
    git rm --cached -r $IGNORED_STAGED 2>/dev/null || true
fi

# C) Purga della cronologia se ghost_os.img è ancora dentro
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
# 3. COMMIT AUTOMATICO (solo se necessario)
###############################################

if git status --porcelain | grep -q .; then
    echo "[GHOST_AUTODOCTOR] Creo commit di riparazione…"
    git add .
    git commit -m "GHOST_AUTODOCTOR: auto-riparazione repo (diagnosi+purga)"
else
    echo "[GHOST_AUTODOCTOR] Nessuna modifica da committare."
fi


###############################################
# 4. PUSH AUTOMATICO (se la cronologia è pulita)
###############################################

if [ "$IN_HISTORY" = "YES" ]; then
    echo "[GHOST_AUTODOCTOR] Push forzato necessario…"
    git push origin --force
else
    echo "[GHOST_AUTODOCTOR] Push normale…"
    git push
fi

echo "[GHOST_AUTODOCTOR] Completato. Repo sana."
