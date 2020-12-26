
function test_switch_control_on_create() {
	dummy = instance_create_layer(room_width / 2, room_height / 2, "Instances", MoveDummy);
}

function test_switch_control_step() {
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