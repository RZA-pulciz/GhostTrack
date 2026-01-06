#include "ghost_beacon.h"
#include "ghost_beacon_ui.c"
#include "ghost_beacon_logic.c"
#include "ghost_beacon_export.c"

int32_t ghost_beacon_app(void* p) {
    ghost_beacon_ui_init();
    ghost_beacon_start();
    return 0;
}
