#!/usr/bin/env bash
# build_ghosttrack_iso.sh
# Ritual: genera una ISO live minimale con GhostTrack integrato

set -e

# =========================
# CONFIGURAZIONE
# =========================

WORKDIR="$(pwd)/bootable/work"
ROOTFS_DIR="$WORKDIR/rootfs"
ISO_DIR="$WORKDIR/iso"
ISO_NAME="ghosttrack-live.iso"
ARCH="amd64"
DEBIAN_RELEASE="stable"
MIRROR_URL="http://deb.debian.org/debian"

GHOSTTRACK_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GHOSTTRACK_TARGET_DIR="/opt/ghosttrack"

# =========================
# LOG
# =========================

log() {
  printf "[GHOSTTRACK-ISO] %s\n" "$*"
}

warn() {
  printf "[GHOSTTRACK-ISO][WARN] %s\n" "$*" >&2
}

# =========================
# CHECK PREREQUISITI
# =========================

check_prereqs() {
  for cmd in debootstrap chroot grub-mkrescue xorriso mksquashfs; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      warn "Comando richiesto non trovato: $cmd"
      warn "Installa i pacchetti necessari (Debian/Ubuntu):"
      warn "  sudo apt install debootstrap grub-pc-bin grub-efi-amd64-bin xorriso squashfs-tools"
      exit 1
    fi
  done

  if [ "$(id -u)" -ne 0 ]; then
    warn "Questo script deve essere eseguito come root (sudo)."
    exit 1
  fi
}

# =========================
# PREPARAZIONE CARTELLE
# =========================

prepare_dirs() {
  log "Pulisco e preparo cartelle di lavoro..."
  rm -rf "$WORKDIR"
  mkdir -p "$ROOTFS_DIR" "$ISO_DIR"
}

# =========================
# CREAZIONE ROOTFS DEBIAN
# =========================

create_rootfs() {
  log "Avvio debootstrap per creare rootfs Debian minimale..."
  debootstrap --arch="$ARCH" "$DEBIAN_RELEASE" "$ROOTFS_DIR" "$MIRROR_URL"
}

# =========================
# CONFIGURAZIONE BASE ROOTFS
# =========================

configure_rootfs_base() {
  log "Configuro il rootfs (hostname, fstab, ecc.)..."

  echo "ghosttrack" > "$ROOTFS_DIR/etc/hostname"

  cat > "$ROOTFS_DIR/etc/hosts" <<EOF
127.0.0.1   localhost
127.0.1.1   ghosttrack
EOF

  cat > "$ROOTFS_DIR/etc/fstab" <<EOF
proc            /proc           proc    defaults          0       0
sysfs           /sys            sysfs   defaults          0       0
devpts          /dev/pts        devpts  defaults          0       0
tmpfs           /run            tmpfs   defaults          0       0
EOF

  # network minimale
  cat > "$ROOTFS_DIR/etc/network/interfaces" <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
}

# =========================
# CHROOT + INSTALL PACCHETTI
# =========================

chroot_install_packages() {
  log "Monto pseudo-filesystem per chroot..."
  mount --bind /dev "$ROOTFS_DIR/dev"
  mount --bind /dev/pts "$ROOTFS_DIR/dev/pts"
  mount --bind /sys "$ROOTFS_DIR/sys"
  mount --bind /proc "$ROOTFS_DIR/proc"

  log "Installazione pacchetti minimi nel rootfs..."

  chroot "$ROOTFS_DIR" /bin/bash -c "
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  linux-image-$ARCH \
  systemd-sysv \
  live-boot \
  grub-pc-bin grub-efi-amd64-bin \
  bash \
  dialog \
  tmux \
  fzf \
  git \
  curl \
  ca-certificates \
  less \
  nano

apt-get clean
"

  log "Smonto pseudo-filesystem chroot..."
  umount "$ROOTFS_DIR/dev/pts"
  umount "$ROOTFS_DIR/dev"
  umount "$ROOTFS_DIR/sys"
  umount "$ROOTFS_DIR/proc"
}

# =========================
# COPIA GHOSTTRACK NEL ROOTFS
# =========================

install_ghosttrack_into_rootfs() {
  log "Installo GhostTrack in $GHOSTTRACK_TARGET_DIR nel rootfs..."

  mkdir -p "$ROOTFS_DIR$GHOSTTRACK_TARGET_DIR"
  rsync -a --delete \
    "$GHOSTTRACK_SOURCE_DIR"/ \
    "$ROOTFS_DIR$GHOSTTRACK_TARGET_DIR"/

  chroot "$ROOTFS_DIR" /bin/bash -c "
chmod +x $GHOSTTRACK_TARGET_DIR/ghost_*.sh 2>/dev/null || true
chmod +x $GHOSTTRACK_TARGET_DIR/flipper/*.sh 2>/dev/null || true
"
}

# =========================
# AUTOSTART GHOSTTRACK A LOGIN
# =========================

configure_autostart_ghosttrack() {
  log "Configuro autostart GhostTrack all'accesso terminale..."

  cat > "$ROOTFS_DIR/etc/profile.d/ghosttrack.sh" <<'EOF'
#!/bin/bash
# Avvio rituale GhostTrack all'apertura di una shell login

if [ -x /opt/ghosttrack/ghost_bootstrap.sh ]; then
  echo "[GHOSTTRACK] Avvio ghost_bootstrap.sh..."
  /opt/ghosttrack/ghost_bootstrap.sh || echo "[GHOSTTRACK] ghost_bootstrap.sh terminato."
elif [ -x /opt/ghosttrack/ghost_ops_unit.sh ]; then
  echo "[GHOSTTRACK] Avvio ghost_ops_unit.sh..."
  /opt/ghosttrack/ghost_ops_unit.sh || echo "[GHOSTTRACK] ghost_ops_unit.sh terminato."
else
  echo "[GHOSTTRACK] Nessuno script principale trovato in /opt/ghosttrack."
fi
EOF

  chmod +x "$ROOTFS_DIR/etc/profile.d/ghosttrack.sh"
}

# =========================
# CONFIGURAZIONE GRUB E LIVE
# =========================

configure_live_boot_and_grub() {
  log "Preparo struttura ISO e configurazione live..."

  mkdir -p "$ISO_DIR/boot/grub" "$ISO_DIR/live"

  # Crea squashfs del rootfs
  log "Creo filesystem squashfs del rootfs..."
  mksquashfs "$ROOTFS_DIR" "$ISO_DIR/live/filesystem.squashfs" -e boot

  # Copia kernel e initrd
  KERNEL_PATH="$(find "$ROOTFS_DIR/boot" -name 'vmlinuz-*' | head -n1)"
  INITRD_PATH="$(find "$ROOTFS_DIR/boot" -name 'initrd.img-*' | head -n1)"

  if [ -z "$KERNEL_PATH" ] || [ -z "$INITRD_PATH" ]; then
    warn "Kernel o initrd non trovati nel rootfs. Controlla l'installazione del kernel."
    exit 1
  fi

  cp "$KERNEL_PATH" "$ISO_DIR/boot/vmlinuz"
  cp "$INITRD_PATH" "$ISO_DIR/boot/initrd"

  # Configurazione GRUB minima
  cat > "$ISO_DIR/boot/grub/grub.cfg" <<'EOF'
set timeout=5
set default=0

menuentry "GhostTrack Live (terminal only)" {
    linux /boot/vmlinuz boot=live toram quiet nomodeset
    initrd /boot/initrd
}
EOF
}

# =========================
# CREAZIONE ISO
# =========================

create_iso() {
  log "Genero ISO con grub-mkrescue: $ISO_NAME"

  grub-mkrescue -o "$WORKDIR/$ISO_NAME" "$ISO_DIR" || {
    warn "grub-mkrescue fallito."
    exit 1
  }

  log "ISO generata: $WORKDIR/$ISO_NAME"
}

# =========================
# ENTRYPOINT
# =========================

main() {
  log "=== RITUALE BUILD GHOSTTRACK LIVE ISO AVVIATO ==="

  check_prereqs
  prepare_dirs
  create_rootfs
  configure_rootfs_base
  chroot_install_packages
  install_ghosttrack_into_rootfs
  configure_autostart_ghosttrack
  configure_live_boot_and_grub
  create_iso

  log "=== BUILD COMPLETATA ==="
  log "ISO pronta in: $WORKDIR/$ISO_NAME"
  log "Puoi testarla con, ad esempio:"
  log "  qemu-system-x86_64 -cdrom $WORKDIR/$ISO_NAME -m 2G"
}

main "$@"
