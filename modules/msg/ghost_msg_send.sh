#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"
mkdir -p "$SURV_DIR"
read -rp "ID mittente: " FROM
read -rp "ID destinatario: " TO
read -rp "Messaggio: " MSG
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LINE="FROM=$FROM|TO=$TO|TS=$TS|MSG=$MSG"
echo "$LINE" >> "$SURV_DIR/comms.log"
echo "Messaggio formattato:"
echo "$LINE"
