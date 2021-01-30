/// @description Define Methods

set_owner = function(_owner) {
	owner = _owner;
	owner_name = _owner._name;
}

add_line = function(_line, _menu) {
	lines[size] = _line;
	menus[size] = _menu;
	++size;
}

get_next_line = function() {
	if (iter >= size) {
		iter = 0;
		return noone;
	}
	var menu = menus[iter];
	if (menu != noone) {
		global.player_controller.activate_menu(menu);
		global.main_text.set_text_to_ratio(0.85);
		position_menu_in_main_text(menu);
	}
	var line = lines[iter++];
	return line;
}

get_last_line = function() {
	return lines[size - 1];
}

get_size = function() {
	return size;
}

cur_line_last = function() {
	return iter == size;
}

reset = function() {
	iter = 0;
}

debug_print_line = function() {
	var line = get_next_line();
	if (line != noone) {
		show_debug_message(line);
	}
	return line;
}

position_menu_in_main_text = function(_menu) {
	var main_text = global.main_text;
	var menu_width = main_text.width * 0.15;
	_menu.x = main_text.x + main_text.width * 0.85;
	_menu.y = main_text.y;
	_menu.width = menu_width;
	_menu.height = main_text.height;
	_menu.set_background_type(noone);
	_menu.set_item_spacing(main_text.line_spacing);
	_menu.set_padding(main_text.padding);
	_menu.set_valign(0);
	// _menu.set_halign(2);
	_menu.set_item_positions();
}
