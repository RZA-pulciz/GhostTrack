#!/usr/bin/env bash
set -e

echo "[GHOST_BEACON] Creazione struttura app + integrazione Ghost_OS..."

# Cartelle
mkdir -p flipper/ghost_beacon
mkdir -p ghost_os

############################################
# application.fam
############################################
cat > flipper/ghost_beacon/application.fam << 'EOF'
App(
    appid="ghost_beacon",
    name="Ghost Beacon",
    apptype=FlipperAppType.EXTERNAL,
    entry="ghost_beacon.c",
    requires=["gui", "storage"],
    icon="icon.png",
)
EOF

############################################
# ghost_beacon.h
############################################
cat > flipper/ghost_beacon/ghost_beacon.h << 'EOF'
#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef struct {
    uint32_t timestamp;
    char type[16];
    char data[64];
    int rssi;
} BeaconSignal;

void ghost_beacon_start();
void ghost_beacon_stop();
void ghost_beacon_export();
EOF

############################################
# ghost_beacon.c
############################################
cat > flipper/ghost_beacon/ghost_beacon.c << 'EOF'
#include "ghost_beacon.h"
#include "ghost_beacon_ui.c"
#include "ghost_beacon_logic.c"
#include "ghost_beacon_export.c"

int32_t ghost_beacon_app(void* p) {
    ghost_beacon_ui_init();
    ghost_beacon_start();
    return 0;
}
EOF

############################################
# ghost_beacon_ui.c
############################################
cat > flipper/ghost_beacon/ghost_beacon_ui.c << 'EOF'
#include <gui/gui.h>
#include <gui/elements.h>

static void ghost_beacon_ui_draw(Canvas* canvas, void* ctx) {
    canvas_clear(canvas);
    canvas_set_color(canvas, ColorWhite);

    canvas_draw_str(canvas, 10, 10, "GHOST BEACON");
    canvas_draw_str(canvas, 10, 25, "Listening...");
    canvas_draw_str(canvas, 10, 40, "Press OK to export");
}

void ghost_beacon_ui_init() {
    ViewPort* vp = view_port_alloc();
    view_port_draw_callback_set(vp, ghost_beacon_ui_draw, NULL);
    gui_add_view_port(gui_get_gui(), vp, GuiLayerFullscreen);
}
EOF

############################################
# ghost_beacon_logic.c
############################################
cat > flipper/ghost_beacon/ghost_beacon_logic.c << 'EOF'
#include "ghost_beacon.h"
#include <stdlib.h>
#include <string.h>

static BeaconSignal signals[128];
static int signal_count = 0;

void ghost_beacon_start() {
    // TODO: integrare IR/NFC/RFID/SubGHz reali
    BeaconSignal s = {
        .timestamp = 123456,
        .rssi = -42
    };
    strcpy(s.type, "IR");
    strcpy(s.data, "NEC:0x1FE48B7");

    signals[signal_count++] = s;
}

void ghost_beacon_stop() {
    // Placeholder per eventuale stop
}
EOF

############################################
# ghost_beacon_export.c
############################################
cat > flipper/ghost_beacon/ghost_beacon_export.c << 'EOF'
#include "ghost_beacon.h"
#include <storage/storage.h>
#include <string.h>
#include <stdio.h>

extern BeaconSignal signals[];
extern int signal_count;

void ghost_beacon_export() {
    File* f = storage_file_open("/ext/ghost_beacon.json", FSAM_WRITE, FSOM_CREATE_ALWAYS);
    if(!f) return;

    storage_file_write(f, "{\n  \"signals\": [\n", 20);

    for(int i = 0; i < signal_count; i++) {
        char buf[256];
        snprintf(
            buf,
            sizeof(buf),
            "    {\"timestamp\": %lu, \"type\": \"%s\", \"data\": \"%s\", \"rssi\": %d}%s\n",
            (unsigned long)signals[i].timestamp,
            signals[i].type,
            signals[i].data,
            signals[i].rssi,
            (i == signal_count - 1) ? "" : ","
        );
        storage_file_write(f, buf, strlen(buf));
    }

    storage_file_write(f, "  ]\n}\n", 7);
    storage_file_close(f);
}
EOF

############################################
# README Ghost Beacon
############################################
cat > flipper/ghost_beacon/README.md << 'EOF'
# Ghost Beacon — Flipper Zero App

Ghost Beacon è un monitor di anomalie ambientali per Flipper Zero.

- Ascolta segnali (IR, NFC, RFID, SubGHz - in futuro)
- Registra fingerprint dei segnali
- Esporta un file JSON:

Percorso su Flipper:

/ext/ghost_beacon.json

Compatibile con Ghost_OS per analisi, dashboard e rituali.
EOF

############################################
# Script Ghost_OS receiver
############################################
cat > ghost_os/ghost_beacon_receiver.py << 'EOF'
import json
import sys

def load_report(path="ghost_beacon.json"):
    with open(path) as f:
        data = json.load(f)
    print("[GHOST_OS] Report Ghost Beacon:")
    print(json.dumps(data, indent=4))

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "ghost_beacon.json"
    load_report(path)
EOF

echo "[GHOST_BEACON] File creati."

echo
echo "[GHOST_BEACON] Pronto per Git:"
echo "  git add flipper/ghost_beacon ghost_os/ghost_beacon_receiver.py"
echo "  git commit -m \"Add Ghost Beacon (Flipper app + Ghost_OS receiver)\""
echo "  git push"
