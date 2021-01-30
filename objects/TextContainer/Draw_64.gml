// TODO: (better than) for now just put a transparent black background behind text to make it readable

if (visible) {
    draw_set_alpha(0.4);
    draw_set_color(c_black);
    draw_rectangle(x, y, x + width, y + height, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_font(font);
    // TODO: scrolling
    if (!scrolling) {
        for (var i = 0; i < line_ct; ++i) {
            draw_text(line_positions_x[i], line_positions_y[i], lines[i]);
        }
    }
}
