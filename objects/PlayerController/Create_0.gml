controlling_char = get_main_char();
move_vec[0] = 0;
move_vec[1] = 0;
default_scroll_min = global.game_speed / 6 + 1;
default_scroll_spd = 4;
dialogue = noone;
dialogue_buddy = noone;
dialogue = noone;
menu = noone;
board = noone;
control_type = CONTROL_TYPES.CHARACTER;

global.player_controller = self;
event_user(0);