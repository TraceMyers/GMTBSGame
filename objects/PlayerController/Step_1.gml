if (!instance_exists(controlling_char)) {
	controlling_char = noone;
}
switch(control_type) {
    case CONTROL_TYPES.CHARACTER:
        if (controlling_char != noone && global.camera_controller.camera_in_range) {
            player_character_move();
            player_character_use();
            player_character_open_and_close_options_menu();
        }
        break;
    case CONTROL_TYPES.BOARD:
        if (board != noone) {
            board_move();
            board_use();
        } 
        break;
}