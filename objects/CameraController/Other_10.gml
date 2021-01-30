/// @description Define Methods

cam_set_following = function(character) {
	following_char = character;
	var char_speed = following_char._speed;
	follow_min_sq_diff = char_speed * char_speed //- char_speed / 1.5;
	following_char_half_width = following_char.sprite_width / 2.0;
	following_char_half_height = following_char.sprite_height / 2.0;
	x = following_char.x + following_char_half_width;
	y = following_char.y + following_char_half_height;
	camera_transitioning = true;
}

cam_create = function() {
	top_left_bound_x = global.view_width / 2;
	top_left_bound_y = global.view_height / 2;
	bot_right_bound_x = room_width - top_left_bound_x;
	bot_right_bound_y = room_height - top_left_bound_y;
	cam_x = x;
	cam_y = y;
	view_camera[0] = camera_create();
	var viewmat = matrix_build_lookat(x, y, -1, x, y, 1, 0, 1, 0);
	var projmat = matrix_build_projection_ortho(global.view_width, global.view_height, -room_height, room_height + 1);
	camera_set_view_mat(view_camera[0], viewmat);
	camera_set_proj_mat(view_camera[0], projmat);
}

cam_follow = function(){
	x = following_char.x + following_char_half_width;
	y = following_char.y + following_char_half_height;
	var x_diff = x - cam_x;
	var y_diff = y - cam_y;
	var magnitude_square = x_diff * x_diff + y_diff * y_diff;
	if (magnitude_square >= follow_min_sq_diff) {
		if (follow_speed_limited && magnitude_square > magnitude_sq_limit) {
			var magnitude_factor = 1 / sqrt(magnitude_square);
			x_diff *= magnitude_factor * magnitude_limit;
			y_diff *= magnitude_factor * magnitude_limit;
		}
		var add_x = x_diff * follow_speed_factor;
		var add_y = y_diff * follow_speed_factor;

		cam_x += round(add_x);
		cam_y += round(add_y);

		camera_on_map_edge = false;
		if (cam_x <= top_left_bound_x) { 
			cam_x = top_left_bound_x;
			camera_on_map_edge = true;
		}
		else if (cam_x >= bot_right_bound_x) { 
			cam_x = bot_right_bound_x;
			camera_on_map_edge = true;
		}
		if (cam_y <= top_left_bound_y) { 
			cam_y = top_left_bound_y;
			camera_on_map_edge = true;
		}
		else if (cam_y >= bot_right_bound_y) { 
			cam_y = bot_right_bound_y;
			camera_on_map_edge = true;
		}

		var viewmat = matrix_build_lookat(cam_x,cam_y, -10, cam_x,cam_y, 0, 0, 1, 0);
		camera_set_view_mat(view_camera[0], viewmat);
	}
}