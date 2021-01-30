/// @description Define Methods
event_inherited();

attempt_move = function(move_x, move_y) {
	pre_move_x = x;
	pre_move_y = y;
	if (move_x != 0 && move_y != 0) {
	    move_x *= bidirectional_magnitude_factor * _speed;
	    move_y *= bidirectional_magnitude_factor * _speed;
	}
	else {
		move_x *= _speed;
		move_y *= _speed;
	}
	x += move_x;
	y += move_y;
		
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
	resolve_collisions(move_x, move_y, true);
	moved_x = x - pre_move_x;
	moved_y = y - pre_move_y;
	moved_dist = vec_magnitude(moved_x, moved_y);
}

resolve_collisions = function(move_x, move_y, do_push) {
	if (place_meeting(x, y, CollisObj)) {
		if (do_push) {
			var push_list = ds_list_create();
			instance_place_list(x, y, Kinetic, push_list, false);
			if (ds_list_size(push_list) == 1) {
				var kinetic = push_list[|0];
				if (can_push && kinetic.can_be_pushed && (push_force >= kinetic.weight)) {
					global.push_queue.queue_push(self, kinetic, move_x, move_y);
				}
			}
			ds_list_destroy(push_list);
		}

		var back_x = -sign(move_x);
		var back_y = -sign(move_y);
		if (move_x * move_x > 0 && move_y * move_y > 0) {
			var step = 0;
			var move_component_x = -back_x;
			var move_component_y = -back_y;
			var resolved = false;
			while (step <= _speed && !resolved) {
				x += back_x;
				y += back_y;
				++step;
				var save_x = x;
				var save_y = y;
				for (var i = step; i >= 0; --i) {
					var test_x = x + move_component_x * i;
					if (!place_meeting(test_x, y, CollisObj)) {
						x = test_x;
						resolved = true;
						break;
					}
					x = save_x;
					if (i == 0) { break; } // already checked this spot
					var test_y = y + move_component_y * i;
					if (!place_meeting(x, test_y, CollisObj)) {
						y = test_y;
						resolved = true;
						break;
					}
					y = save_y;
				}
			}
		}
		else {
			while (place_meeting(x, y, CollisObj)) {
				x += back_x;
				y += back_y;
			}
		}
	}
}

spawn_use_trigger = function() {
	use_trigger = instance_create_layer(x, y, "Triggers", UseTrigger);
	var x_scale = sprite_width / use_trigger.sprite_width / 2;
	var y_scale = sprite_height / use_trigger.sprite_height / 2;
	use_trigger.image_xscale *= x_scale;
	use_trigger.image_yscale *= y_scale;
}

set_use_trigger_pos = function() {
	use_trigger.depth = depth - 1;
	var use_trigger_half_width = use_trigger.sprite_width * 0.5;
	var use_trigger_half_height = use_trigger.sprite_height * 0.5;
	
	switch(facing) {
		case FACING.RIGHT:
			use_trigger.x = bbox_right + 1;
			use_trigger.y = bbox_top - use_trigger_half_height;
			break;
		case FACING.UP:
			use_trigger.x = bbox_center_x(self) - use_trigger_half_width;
			use_trigger.y = bbox_top - use_trigger.sprite_height;
			break;
		case FACING.LEFT:
			use_trigger.x = bbox_left - use_trigger.sprite_width;
			use_trigger.y = bbox_top - use_trigger_half_height;;
			break;
		case FACING.DOWN:
			use_trigger.x = bbox_center_x(self) - use_trigger_half_width;;
			use_trigger.y = bbox_bottom + 1;
			break;
		default:
			show_debug_message("Character.set_use_trigger_pos() bad facing value");
	}
}

change_room_on_trigger = function() {
	var change_room_trigger = instance_place(x, y, RoomChangeTrigger);
	if (change_room_trigger != noone) {
		room_goto(change_room_trigger._room);
	}
}