// called by PlayerController in step
function char_move() {
	if (controlling_char == noone) { return; }
    var move_x = keyboard_check(vk_right) - keyboard_check(vk_left);
    var move_y = keyboard_check(vk_down) - keyboard_check(vk_up);
    if (move_x != 0 && move_y != 0) {
        move_x *= bidirectional_magnitude_factor * controlling_char._speed;
        move_y *= bidirectional_magnitude_factor * controlling_char._speed;
    }
	else {
		move_x *= controlling_char._speed;
		move_y *= controlling_char._speed;
	}
    controlling_char.x += move_x;
    controlling_char.y += move_y;
	with (controlling_char) {
		if (x < top_left_bound_x) { 
			x = top_left_bound_x;
		}
		else if (x > bot_right_bound_x) { 
			x = bot_right_bound_x;
		}
		if (y < top_left_bound_y) { 
			y = top_left_bound_y;
		}
		else if (y > bot_right_bound_y) { 
			y = bot_right_bound_y;
		}
	}
}

