#!/usr/bin/env bash
set -e

# Directory dello script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# Directory root della repo
ROOT_DIR=$(dirname "$SCRIPT_DIR")

cd "$SCRIPT_DIR"

echo "[GHOST_BOOTABLE] Creo immagine Ghost_OS RAW compatibile..."

# 1. Preparo rootfs
rm -rf rootfs
mkdir -p rootfs

# 2. Copio tutto Ghost_OS dentro rootfs
cp -r "$ROOT_DIR/ghost_os" \
      "$ROOT_DIR/core" \
      "$ROOT_DIR/ops" \
      "$ROOT_DIR/rituals" \
      "$ROOT_DIR/missions" \
      "$ROOT_DIR/var" \
      rootfs/

cp -r "$ROOT_DIR/docs" rootfs/
cp "$ROOT_DIR/README.md" rootfs/

# 3. Creo archivio rootfs
tar -czf rootfs.tar.gz rootfs/

# 4. Creo immagine RAW da 512MB
dd if=/dev/zero of=ghost_os.img bs=1M count=512

# 5. Inserisco rootfs.tar.gz nell'immagine
dd if=rootfs.tar.gz of=ghost_os.img conv=notrunc

echo "[GHOST_BOOTABLE] Immagine RAW creata con successo!"
ls -lh ghost_os.img
