// TODO: window dependent

font = fntBerlinSans;
font_size = font_get_size(font);
h_align = HALIGN.LEFT;
v_align = VALIGN.TOP;
x = 0;
y = 200;
width = 480;
height = 70;
padding = 12;
line_spacing = 4;
scroll_speed = 0;
scrolling = false;

lines[0] = noone;
line_positions_x[0] = 0;
line_positions_y[0] = 0;
scroll_ctr[0][0] = 0; // [line][character]
line_ct = 0;

text_width = width;

event_user(0);