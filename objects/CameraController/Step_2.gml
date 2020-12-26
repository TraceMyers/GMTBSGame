var distance_to_character = point_distance(cam_x, cam_y, x, y);
if (distance_to_character > global.view_height / 3.0 && !camera_on_map_edge) {
	camera_in_range = false;
}
else {
	camera_in_range = true;
	camera_transitioning = false;
}
cam_follow();