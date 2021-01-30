/// @description Define Methods

queue_move = function(moving_char, move_x, move_y) {
	moving_chars[size] = moving_char;
	moving_x[size] = move_x;
	moving_y[size] = move_y;
	++size;
}

attempt_moves = function() {
	for (var i = 0; i < size; ++i) {
		var char = moving_chars[i];
		var move_x = moving_x[i];
		var move_y = moving_y[i];
		char.attempt_move(move_x, move_y);
		prev_moving_chars[i] = char;
	}
	prev_size = size;
	size = 0;
}

scrub_old_character_move_data = function() {
	for (var i = 0; i < prev_size; ++i) {
		prev_moving_chars[i].moved_x = 0;
		prev_moving_chars[i].moved_y = 0;
		prev_moving_chars[i].moved_dist = 0;
	}
}