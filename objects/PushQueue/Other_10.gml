/// @description Define Methods

queue_push = function(pusher, pushee, move_x, move_y) {
	var dir = get_collis_ortho(pusher, pushee);
	if (dir != global.NO_DIR) {
		pusher.unresolved_push = true;
		dirs[size] = dir;
		pushers[size] = pusher;
		pushees[size] = pushee;
		size++;
	}
}

attempt_pushes = function() {
	for (var i = 0; i < size; ++i) {
		var pusher = pushers[i];
		var pushee = pushees[i];
		var dir = dirs[i];
		var push_speed = min(pusher.push_force / pushee.weight, pusher._speed * 0.5);
		var nudge_x = 0;
		var nudge_y = 0;
		if		(dir == global.LEFT)	{ nudge_x = -1; }
		else if (dir == global.RIGHT)	{ nudge_x =  1; }
		else if (dir == global.UP)		{ nudge_y = -1; }
		else							{ nudge_y =  1; }
		
		pushee.pre_move_x = pushee.x;
		pushee.pre_move_y = pushee.y;
		var move_x = 0;
		var move_y = 0;
		with (pushee) {
			var push_collision = place_meeting(x, y, CollisObj);
			if (nudge_x == 0) {
				var push_y = nudge_y * push_speed;
				nudge_y *= 0.5;
				if (push_y > 0) {
					while (!push_collision && move_y < push_y) {
						move_y += nudge_y;
						y += nudge_y;
						push_collision = place_meeting(x, y, CollisObj);
					}
				}
				else {
					while (!push_collision && move_y > push_y) {
						move_y += nudge_y;
						y += nudge_y;
						push_collision = place_meeting(x, y, CollisObj);
					}
				}
				if (push_collision && move_y != 0) {
					y -= nudge_y;
					move_y -= nudge_y;
				}
			}
			else {
				var push_x = nudge_x * push_speed;
				if (push_x > 0) {
					while (!push_collision && move_x < push_x) {
						move_x += nudge_x;
						x += nudge_x;
						push_collision = place_meeting(x, y, CollisObj);
					}
				}
				else {
					while (!push_collision && move_x > push_x) {
						move_x += nudge_x;
						x += nudge_x;
						push_collision = place_meeting(x, y, CollisObj);
					}
				}
				if (push_collision && move_x != 0) {
					x -= nudge_x;
					move_x -= nudge_x;
				}
			}
		}
		pushee.moved_x = pushee.pre_move_x - pushee.x;
		pushee.moved_y = pushee.pre_move_y - pushee.y;
		pushee.moved_dist = vec_magnitude(pushee.moved_x, pushee.moved_y);
		
		if (move_y * move_y > 0) {
			pusher.y += move_y;
			// lock x movement and gravitate toward centering pusher on pushee
			/*
			pusher.x = pusher.pre_move_x;
			var diff = bbox_center_x(pushee) - bbox_center_x(pusher);
			var eighth_diff = diff * 0.125;
			pusher.x += eighth_diff;
			move_x += eighth_diff;
			*/
		}
		else {
			pusher.x += move_x;
			// lock y movement and gravitate toward centering pusher on pushee
			/*
			pusher.y = pusher.pre_move_y;
			var diff = bbox_center_y(pushee) - bbox_center_y(pusher);
			var eighth_diff = diff * 0.125;
			pusher.y += eighth_diff;
			move_y += eighth_diff;
			*/
		}
		pusher.resolve_collisions(move_x, move_y, false);
		pusher.moved_x = pusher.pre_move_x - pusher.x;
		pusher.moved_y = pusher.pre_move_y - pusher.y;
		pusher.moved_dist = vec_magnitude(pusher.moved_x, pusher.moved_y);
		pusher.unresolved_push = false;
		
		prev_pushees[i] = pushee;
	}
	prev_size = size;
	size = 0;
}

scrub_old_pushee_move_data = function() {
	for (var i = 0; i < prev_size; ++i) {
		prev_pushees[i].moved_x = 0;
		prev_pushees[i].moved_y = 0;
		prev_pushees[i].moved_dist = 0;
	}
}