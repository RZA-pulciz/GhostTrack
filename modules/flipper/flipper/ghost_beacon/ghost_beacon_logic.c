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
