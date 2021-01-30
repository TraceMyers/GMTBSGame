function get_main_char() {
	if (instance_number(MainChar) > 0) {
		show_debug_message("returning main char");
		return instance_find(MainChar, 0);
	}
	show_debug_message("returning noone");
	return noone;
}

function vec_magnitude(_x, _y) {
	return sqrt(_x * _x + _y * _y);
}

function closest_ortho(vec_x, vec_y, diagonal_disallowed) {
	var magnitude = vec_magnitude(vec_x, vec_y);
	var abs_norm_x = abs(vec_x) / magnitude;
	var abs_norm_y = abs(vec_y) / magnitude;
	var epsilon = 0.12;
	if (diagonal_disallowed && abs(abs_norm_x - abs_norm_y) < epsilon) { 
		return global.NO_DIR; 
	}
	var dir = arctan2(vec_y, vec_x);
	var pi_over_4 = pi / 4;
	var abs_dir = abs(dir);
	if (abs_dir < pi_over_4) { 
		return global.RIGHT; 
	}
	else if (abs_dir < 3 * pi_over_4) {
		if (dir < 0)	{ 
			return global.UP; 
		}
		else { 
			return global.DOWN; 
		}
	}
	else { 
		return global.LEFT; 
	}
}

function bbox_center_x(obj) {
	var left = obj.bbox_left;
	return left + (obj.bbox_right - left) / 2.0;
}

function bbox_center_y(obj) {
	var top = obj.bbox_top;
	return top + (obj.bbox_bottom - top) / 2.0;
}

function sprite_center_x(obj) {
	return obj.x + obj.sprite_width / 2;
}

function sprite_center_y(obj) {
	return obj.y + obj.sprite_height / 2;
}

// get vector from center of from_obj bbox to center of to_obj bbox
// morph to square vector space and get closest ortho direction, disallowing a result when close to diagonal
// TODO: simpler and probably more accurate: use point checking on perimeter
function get_collis_ortho(from_obj, to_obj) {
	var from_center_x = bbox_center_x(from_obj);
	var from_center_y = bbox_center_y(from_obj);
	var to_center_x = bbox_center_x(to_obj);
	var to_center_y = bbox_center_y(to_obj);
	var bbox_x_to_y_ratio = (from_obj.bbox_right - from_obj.bbox_left) / (from_obj.bbox_bottom - from_obj.bbox_top);
	var vec_x = to_center_x - from_center_x;
	var vec_y = to_center_y - from_center_y;
	vec_y *= bbox_x_to_y_ratio;
	return closest_ortho(vec_x, vec_y, true);
}