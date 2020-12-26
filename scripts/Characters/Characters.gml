
function get_main_char() {
	if (instance_number(MainChar) > 0) {
		show_debug_message("returning main char");
		return instance_find(MainChar, 0);
	}
	show_debug_message("returning noone");
	return noone;
}