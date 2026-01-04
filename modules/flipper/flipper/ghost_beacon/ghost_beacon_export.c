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
