if (active) {
	if (background != noone) {
		draw_background();
	}
	if (selection_token != noone) {
		draw_selection_token();
	}
	draw_items();
}