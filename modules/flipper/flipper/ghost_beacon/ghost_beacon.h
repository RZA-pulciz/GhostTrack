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
