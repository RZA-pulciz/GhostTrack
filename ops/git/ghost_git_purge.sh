#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST_GIT_PURGE — RIMOZIONE DEFINITIVA"
echo "====================================="

echo
echo "[1] Rimuovo ghost_os.img e artefatti dalla CRONOLOGIA…"

git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch ghost_os.img; \
   git rm --cached --ignore-unmatch bootable/ghost_os.img; \
   git rm --cached --ignore-unmatch rootfs.tar.gz; \
   git rm --cached --ignore-unmatch bootable/rootfs.tar.gz; \
   git rm --cached --ignore-unmatch rootfs/ -r; \
   git rm --cached --ignore-unmatch bootable/rootfs/ -r" \
  --prune-empty --tag-name-filter cat -- --all

echo
echo "[2] Pulizia reflog…"
git reflog expire --expire=now --all

echo
echo "[3] Garbage collection profonda…"
git gc --prune=now --aggressive

echo
echo "[4] Push forzato della nuova cronologia…"
git push origin --force

echo
echo "====================================="
echo " PURGA COMPLETATA — REPO RIPULITA"
echo "====================================="
