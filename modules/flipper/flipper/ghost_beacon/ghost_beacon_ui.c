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
