// vars set by cam_set_following();
following_char = noone;
following_char_half_width = 0;
following_char_half_height = 0;
follow_min_sq_diff = 0;
// vars set by cam_create();
top_left_bound_x = 0;
top_left_bound_y = 0;
bot_right_bound_x = 0;
bot_right_bound_y = 0;
cam_x = 0;
cam_y = 0;
// other
follow_speed_factor = 1/7;
follow_speed_limited = true;
magnitude_limit = 70;
magnitude_sq_limit = magnitude_limit * magnitude_limit;
camera_in_range = true;
camera_on_map_edge = false;
camera_transitioning = false;

global.camera_controller = self;
event_user(0);