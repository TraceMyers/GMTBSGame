/// @description Define Methods
// TODO: background windows should use tiny tileset that is put together
// here algorithmically for the correct size. Or, if the sides are identical
// when stretched, just stretch edges in two pieces and draw corners on

add_item = function(item) {
	items[item_ct] = item;
	submenus[item_ct] = noone;
	++item_ct;
}

attach_submenu = function(submenu, _index, attach_submenu_callback) {
	submenus[_index] = submenu;
	if (attach_submenu_callback) {
		callbacks[_index] = to_submenu;
	}
}

attach_callback = function(callback, _index) {
	callbacks[_index] = callback;
}

set_font = function(_font) {
	font = _font;
	font_size = font_get_size(_font);
	selection_token_box_side_height = font_get_size(font) * selection_token_scale;
}

set_selection_token_scale = function(val) {
	selection_token_scale = val;
}

set_background_type = function(val) {
	background = val;
}

set_background_image = function(val) {
	background_image = val;
}

set_selection_token_spacing = function(val) {
	selection_token_spacing = val;
}

set_layout = function(val) {
	layout = val;
}

set_halign = function(val) {
	h_align = val;
}

set_valign = function(val) {
	v_align = val;
}

set_height = function(val) {
	height = val;
}

get_height = function() {
	return height;
}

set_width = function(val) {
	width = val;
}

get_width = function() {
	return width;
}

set_padding = function(val) {
	padding = val;
}

set_flash_speed = function(val) {
	flash_speed_factor = val;
}

set_drop_shadow = function(val) {
	text_drop_shadow = val;
}

set_drop_shadow_color = function(r, g, b) {
	drop_shadow_color[0] = r;
	drop_shadow_color[1] = g;
	drop_shadow_color[2] = b;
	drop_shadow_color_gmvar = make_color_rgb(r, g, b);
}

// if item_spacing == noone, evenly spaced
set_item_spacing = function(val) {
	item_spacing = val;
}

set_parent_menu = function(val) {
	parent_menu = val;
}

get_parent_menu = function() {
	return parent_menu;
}

// simply gets the height of all text without padding/spacing
get_text_height = function() {
	switch(layout) {
		case LAYOUTS.HORIZONTAL:
			return font_size;
			break;
		case LAYOUTS.VERTICAL:
			return font_size * item_ct;
			break;
	}
}

// only made to be used as callback
// other is PlayerController
to_parent_menu = function() {
	deactivate();
	parent_menu.set_pause(false, true);
	other.menu = parent_menu;
}

// only made to be used as callback
// other is PlayerController
to_submenu = function() {
	set_pause(true, set_invisible_when_navigating_to_submenu);
	var selected_submenu = submenus[index];
	selected_submenu.activate(true);
	other.menu = selected_submenu;
}

// TODO: bg positions for horizontal layout
set_item_positions = function() {
	draw_set_font(font);
	bg_lr_y = y + height;
	bg_lr_x = x + width;
	switch(layout) {
		case LAYOUTS.VERTICAL:
			var cursor = y;
			var text_height_sum = item_ct * font_size;	
			var item_vertical_diff = 0;
			var total_text_height = 0;
			if (item_spacing == noone) { // automatic even spacing
				var gap_size_sum = height - padding * 2 - text_height_sum;
				var gap_size = gap_size_sum / (item_ct - 1);
				item_vertical_diff = font_size + gap_size;
				total_text_height = height - padding * 2;
				cursor += padding;
			}
			else {
				item_vertical_diff = font_size + item_spacing;
				total_text_height = text_height_sum + item_spacing * (item_ct - 1);
				if (v_align == VALIGN.TOP) {
					cursor += padding;
				}
				else if (v_align == VALIGN.CENTER) {
					cursor += (height - (padding * 2) - total_text_height) / 2  + item_vertical_diff / 2;
				}
				else if (v_align == VALIGN.BOTTOM) {
					cursor += height - (padding * 2) - total_text_height + item_vertical_diff / 2;
				}
			}
			
			var center_x = x + width / 2;
			var right_x = x + width;
			for (var i = 0; i < item_ct; ++i) {
				var str_width = string_width(items[i]);
				switch(h_align) {
					case HALIGN.LEFT:
						item_pos_x[i] = x + padding;
						break;
					case HALIGN.CENTER:
						item_pos_x[i] = center_x - str_width / 2;
						break;
					case HALIGN.RIGHT:
						item_pos_x[i] = right_x - padding - str_width;
						break;
				}
				item_pos_y[i] = cursor + item_vertical_diff * i;
			}
			break;
		/*
		case LAYOUTS.HORIZONTAL:
			var cursor = x + padding;
			var item_vertical_diff = height / item_ct;
			if (h_align == HALIGN.CENTER) {
				cursor -= height / 2;
			}
			else if (h_align == HALIGN.RIGHT) {
				cursor -= height;
			}
			for (var i = 0; i < item_ct; ++i) {
				item_pos_x[i] = cursor;
				cursor += item_vertical_diff;
				switch(v_align) {
					case VALIGN.TOP:
						item_pos_y[i] = y + padding;
						break;
					case VALIGN.CENTER:
						item_pos_y[i] = y - font_size / 2;
						break;
					case VALIGN.BOTTOM:
						item_pos_y[i] = y - font_size - padding;
						break;
				}
			}
			break;
		*/
	}
}

draw_items = function() {
	draw_set_font(font);
	
	for (var i = 0; i < item_ct; ++i) {
		if (text_drop_shadow) {
			draw_set_color(drop_shadow_color_gmvar);
			draw_text(item_pos_x[i] + 1, item_pos_y[i] + 1, items[i]);			
		}
		if (i == index) {
			if (!paused) {
                shader_flashing_set(
                    global.frame_count / flash_speed_factor, 
                    text_flash_half_width
                );
				draw_set_color(selection_highlight_color_gmvar);
				draw_text(item_pos_x[i], item_pos_y[i], items[i]);
				shader_reset();
			}
			else {
				draw_set_color(selection_highlight_color_gmvar);
				draw_text(item_pos_x[i], item_pos_y[i], items[i]);
			}
		}
		else {
			draw_set_color(text_color_gmvar);
			draw_text(item_pos_x[i], item_pos_y[i], items[i]);
		}
	}
	draw_set_color(c_white);
	shader_reset();
}

draw_background = function() {
	switch(background) {
		case BACKGROUNDS.SIMPLE_BOX:
			draw_set_alpha(0.5);
			draw_set_color(c_black);
			draw_rectangle(x, y, bg_lr_x, bg_lr_y, false);
			draw_set_color(c_white);
			draw_set_alpha(1.0);
			break;
		case BACKGROUNDS.IMAGE:
			break;
	}
}

// if text is set to flashing, and flash_to_white is true,
// text will flash all the way to white; otherwise, if the
// text has a color, like yellow, it will flash to a light
// yellow
set_text_color = function(r, g, b, flash_to_white) {
	text_color[0] = r;
	text_color[1] = g;
	text_color[2] = b;
	text_color_gmvar = make_color_rgb(
		text_color[0],
		text_color[1],
		text_color[2]
	);
	var selection_r = r + selection_highlight_lift;
	var selection_g = g + selection_highlight_lift;
	var selection_b = b + selection_highlight_lift;
	selection_highlight_color_gmvar = make_color_rgb(
		r + selection_highlight_lift,
		g + selection_highlight_lift,
		b + selection_highlight_lift
	);
	if (flash_to_white) {
		if (r < g) {
			if (r < b) {
				text_flash_half_width = ((255 - selection_r) / 255) / 2;
			}
			else {
				text_flash_half_width = ((255 - selection_b) / 255) / 2;
			}
		}
		else {
			if (g < b) {
				text_flash_half_width = ((255 - selection_g) / 255) / 2;	
			}
			else {
				text_flash_half_width = ((255 - selection_b) / 255) / 2;
			}
		}
	}
	else {
		if (r > g) {
			if (r > b) {
				text_flash_half_width = ((255 - selection_r) / 255) / 2;
			}
			else {
				text_flash_half_width = ((255 - selection_b) / 255) / 2;
			}
		}
		else {
			if (g > b) {
				text_flash_half_width = ((255 - selection_g) / 255) / 2;	
			}
			else {
				text_flash_half_width = ((255 - selection_b) / 255) / 2;
			}
		}
	}
}

set_selection_token_color = function(r, g, b) {
	selection_token_color[0] = r;
	selection_token_color[1] = g;
	selection_token_color[2] = b;
	selection_token_color_gmvar = make_color_rgb(
		selection_token_color[0],
		selection_token_color[1],
		selection_token_color[2]
	);
}

set_selection_token_spacing = function(val) {
	selection_token_spacing = val;
}

// TODO: finish
set_selection_token = function(val) {
	selection_token = val;
	if (val == noone) {
		selection_token_spacing = 0;
	}
}

// TODO other functionality with these three
activate = function(reset) {
	if (reset) {
		index = 0;
	}
	active = true;
}

set_pause = function(val, set_visibility) {
	if (set_visibility) {
		visible = !val;
	}
	paused = val;
}

deactivate = function() {
	active = false;
}

controller_deactivate = function() {
	deactivate();
	other.menu = noone;
	other.controlling_char.state = CHAR_STATES.IDLE;
}

change_selection = function(dir) {
	switch(layout) {
		case LAYOUTS.VERTICAL:
			if (dir == FACING.UP && index > 0) {
				--index;
			}
			else if (dir == FACING.DOWN && index < item_ct - 1) {
				++ index;	
			}
			break;
		case LAYOUTS.HORIZONTAL:
			if (dir == FACING.LEFT && index > 0) {
				--index;	
			}
			else if (dir == FACING.RIGHT && index < item_ct - 1) {
				++index;	
			}
			break;
	}
}

get_selected_callback = function() {
	return callbacks[index];
}

draw_selection_token = function() {
	draw_set_color(selection_token_color_gmvar);
	var selection_ul_x = item_pos_x[index];
	var selection_ul_y = item_pos_y[index];
	
	switch(selection_token) {
		case TOKENS.TRIANGLE:
			var center_y = selection_ul_y + selection_token_box_side_height;
			var token_left = selection_ul_x - selection_token_box_side_height - selection_token_spacing;
			var x1 = token_left;
			var y1 = center_y - selection_token_box_side_height / 2;
			var x2 = token_left;
			var y2 = center_y + selection_token_box_side_height / 2;
			var x3 = token_left + selection_token_box_side_height;
			var y3 = center_y
			if (text_drop_shadow) {
				draw_set_color(drop_shadow_color_gmvar);
				draw_triangle(x1 + 1, y1 + 1, x2 + 1, y2 + 1, x3 + 1, y3 + 1, false);
				draw_set_color(selection_token_color_gmvar);
			}
			draw_triangle(x1, y1, x2, y2, x3, y3, false);
			break;
		case TOKENS.IMAGE:
			break;
	}	
	draw_set_color(c_white);
}