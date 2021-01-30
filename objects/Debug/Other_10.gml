/// @description Define Methods

change_game_speed = function() {
	if (keyboard_check_pressed(vk_f1)) {
		global.game_speed /= 2;
		game_set_speed(global.game_speed, gamespeed_fps);
	}
	else if (keyboard_check_pressed(vk_f2)) {
		global.game_speed *= 2;
		game_set_speed(global.game_speed, gamespeed_fps);
	}
}

set_fullscreen = function() {
	if (keyboard_check_pressed(vk_f4)) {
		if window_get_fullscreen() {
			window_set_fullscreen(false);
	    }
		else {
			window_set_fullscreen(true);
		}
	}
}

draw_collision_boxes = function(){
	if (keyboard_check_pressed(vk_f3)) {
		if (drawing_collision_boxes) {
			drawing_collision_boxes = false;
		}
		else {
			drawing_collision_boxes = true;
		}
	}
	if (drawing_collision_boxes) {
		draw_set_color(c_yellow);
		draw_set_alpha(0.5);
		for (var i = 0; i < instance_number(CollisObj); ++i) {
			var collis_obj = instance_find(CollisObj, i);
			draw_rectangle(
				collis_obj.bbox_left,
				collis_obj.bbox_top,
				collis_obj.bbox_right,
				collis_obj.bbox_bottom,
				false
			);
		}
		draw_set_color(c_white);
		draw_set_alpha(1.0);
	}
}

draw_triggers = function() {
	if (keyboard_check_pressed(vk_f5)) {
		if (drawing_use_range_triggers) {
			drawing_use_range_triggers = false;
			for (var i = 0; i < instance_number(Trigger); ++i) {
				show_debug_message("turning off box");
				var trigger = instance_find(Trigger, i);
				trigger.visible = false;
			}
		}
		else {
			drawing_use_range_triggers = true;
			for (var i = 0; i < instance_number(Trigger); ++i) {
				var trigger = instance_find(Trigger, i);
				show_debug_message("turning on box");
				trigger.visible = true;
			}
		}
	}
}

draw_fps = function() {
	draw_text(0, 0, string(global.game_speed));
}

restart_room = function() {
	if (keyboard_check_pressed(ord("R"))) {
		room_restart();
	}
}

restart_game = function() {
	if (keyboard_check_pressed(ord("G"))) {
		game_restart();
	}
}

draw_highlighted_pixels = function() {
	for (var i = 0; i < highlighted_pixels_ct; ++i) {
		draw_sprite(sPixelHighlight, 0, highlighted_pixels_x[i], highlighted_pixels_y[i]);
	}
}

highlight_pixel = function(_x, _y) {
	highlighted_pixels_x[highlighted_pixels_ct] = _x;
	highlighted_pixels_y[highlighted_pixels_ct] = _y;
	highlighted_pixels_ct++;
}

turbo_move_speed = function() {
	if (keyboard_check_pressed(vk_f6)) {
		if (player_controller_character_speed_turbo) {
			global.player_controller.controlling_char._speed /= 2.5;
			player_controller_character_speed_turbo = false;
		}
		else {
			global.player_controller.controlling_char._speed *= 2.5;
			player_controller_character_speed_turbo = true;
		}
	}
}

test_switch_control_create = function() {
	dummy = instance_create_layer(room_width / 2, room_height / 2, "Instances", MoveDummy);
}

test_switch_control_step = function() {
	if (keyboard_check_pressed(ord("1"))) {
		var switch_to_char = dummy;
		with (global.camera_controller) {
			if (following_char == other.dummy) {
				switch_to_char = get_main_char();
				cam_set_following(switch_to_char);
			}
			else {
				switch_to_char = other.dummy;
				cam_set_following(switch_to_char);
			}
		}
		global.player_controller.controlling_char = switch_to_char;
	}
}

test_menu_create = function() {
	menu = instance_create_layer(0, 0, "UI", Menu);
	menu.add_item("Fish");
	menu.add_item("Puke");
	menu.add_item("Banana Pile");
	menu.x = window_get_width() / 2;
	menu.y = window_get_height() / 2;
	menu.set_layout(0);
	menu.set_halign(0);
	menu.set_valign(1);
	menu.set_length_by_spacing(10);
	menu.set_text_color(180, 180, 100, false);
	menu.set_item_positions();
}

test_menu_draw_gui = function() {
	draw_sprite(sPixelHighlight, 0, menu.x, menu.y);	
}

turn_queue_test_load = function() {
    turn_queue = instance_create_layer(x, y, "Instances", TurnQueue);
    with (turn_queue) {
        for (var i = 0; i < 5; ++i) {
            chars[i] = instance_create_layer(x, y, "Characters", Character);
        }
        chars[0]._name = "Jerry";
        chars[1]._name = "Wishbone";
        chars[2]._name = "Fishy Joe";
        chars[3]._name = "Dippy";
        chars[4]._name = "Scoops";
        for (var i = 0; i < 4; ++i) {
            push_back(chars[i]);
        }
    }
}

turn_queue_dbg_draw = function() {
	draw_set_font(turn_queue.font);
    var _x = global.view_width - 50;
    var y_diff = font_get_size(turn_queue.font) + 3;
    var _y = global.view_height - y_diff;
    var i = turn_queue.turn_index;
    do {
        draw_text(_x, _y, turn_queue.queue[i]._name);
        _y -= y_diff;
        ++i;
        if (i == turn_queue._size) {
            i = 0;
        }
    }
    until (i == turn_queue.turn_index)
    draw_set_font(global.default_font);
}

turn_queue_test_advance = function() {
    turn_queue_advance_ctr++;
    if (turn_queue_advance_ctr == global.game_speed * 3) {
        turn_queue_advance_ctr = 0;
        turn_queue.advance();
    }
}

turn_queue_test_remove_and_push = function() {
    turn_queue_remove_and_push_ctr++;
    if (turn_queue_remove_and_push_ctr == global.game_speed) {
        turn_queue.push_back(turn_queue.chars[4]);
    }
    else if (turn_queue_remove_and_push_ctr == global.game_speed * 2) {
        turn_queue.remove(turn_queue.chars[4]);
        turn_queue_remove_and_push_ctr = 0;
    }
}