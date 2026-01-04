#!/usr/bin/env bash
set -e
BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"
mkdir -p "$SURV_DIR"
echo "Incolla messaggio ricevuto (CTRL+D per finire):"
RECV="$(cat)"
echo "$RECV" >> "$SURV_DIR/comms.log"
echo "Registrato."
