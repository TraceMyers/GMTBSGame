
layout = LAYOUTS.VERTICAL;
h_align = HALIGN.LEFT;
v_align = VALIGN.TOP;
font = fntBerlinSans;
font_size = font_get_size(font);
height = sprite_height;
width = sprite_width;
item_ct = 0;
items[item_ct] = noone;
item_pos_x[item_ct] = noone;
item_pos_y[item_ct] = noone;
item_spacing = noone;
submenus[item_ct] = noone;
callbacks[item_ct] = noone;
highlight_selection = true;
background = BACKGROUNDS.SIMPLE_BOX;
background_image = noone;
index = 0;
padding = 10;
bg_lr_x = 0;
bg_lr_y = 0;
text_color[0] = 0;
text_color[1] = 0;
text_color[2] = 0;
text_color_gmvar = noone;
selection_highlight_lift = 30;
selection_highlight_color_gmvar = noone;
selection_token = TOKENS.TRIANGLE;
selection_token_color[0] = 220;
selection_token_color[1] = 220;
selection_token_color[2] = 220;
selection_token_color_gmvar = make_color_rgb(
	selection_token_color[0],
	selection_token_color[1],
	selection_token_color[2]
);
selection_token_image = noone;
selection_token_spacing = padding / 3;
selection_token_scale = 1/2;
selection_token_box_side_height = font_get_size(font) * selection_token_scale;
text_flash_half_width = 0;
flash_speed_factor = 15;
active = false;
text_drop_shadow = true;
drop_shadow_color[0] = 50;
drop_shadow_color[1] = 50;
drop_shadow_color[2] = 80;
drop_shadow_color_gmvar = make_color_rgb(
	drop_shadow_color[0],
	drop_shadow_color[1],
	drop_shadow_color[2]
);
paused = false;
parent_menu = noone;
set_invisible_when_navigating_to_submenu = true;

event_user(0);
set_text_color(200, 200, 200, true);