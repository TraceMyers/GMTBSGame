enum CONTROL_TYPES {
    CHARACTER,
    DIALOGUE,
    MENU,
    BOARD
}
enum CHAR_STATES {
	IDLE,
	WALK,
	RUN,
	INIT_PUSH,
	PUSH,
	DIALOGUE_LISTEN,
	DIALOGUE_TALK,
	COMBAT_WAIT,
	MENU,
};
enum BOARD_STATES {
    CURSOR,
    CONFIRM_MOVE,
    MOVING_CHAR
}
enum FACING {
	UP,
	LEFT,
	RIGHT,
	DOWN
};
enum USE_REACTIONS {
	DIALOGUE,
	CHANGE_ROOM,
	COMBAT
};
enum VALIGN {
	TOP = 0,
	CENTER = 1,
	BOTTOM = 2
};
enum HALIGN {
	LEFT = 0,
	CENTER = 1,
	RIGHT = 2
};
enum LAYOUTS {
	VERTICAL = 0,
	HORIZONTAL = 1
};
enum TOKENS {
	TRIANGLE,
	IMAGE
};
enum BACKGROUNDS {
	SIMPLE_BOX,
	IMAGE
};
enum BOARD {
	DOWN_LEFT = 0,
	LEFT = 1,
	UP_LEFT = 2,
	UP_RIGHT = 3,
	RIGHT = 4,
	DOWN_RIGHT = 5
};
enum HEX_CURSOR {
	DOWN_LEFT = 0,
	LEFT = 1,
	UP_LEFT = 2,
	UP_RIGHT = 3,
	RIGHT = 4,
	DOWN_RIGHT = 5,
    UP,
    DOWN
};
enum pc {
    none,
	up,
	left,
	right,
	down,
	select,
	cancel,
	option,
	menu,
	pause,
    dbg_1,
    dbg_2
};
enum DEVICE {
	MOUSE_KB,
	CONTROLLER
};
enum TEAM {
    BLUE,
    RED
};
global.default_font = fntBerlinSans;
global.default_view_width = 960;
global.default_view_height = 540;
global.view_width = global.default_view_width;
global.view_height = global.default_view_height;
global.player_controller = noone;
global.game_controller = noone;
global.camera_controller = noone;
global.debug = noone;
global.push_queue = noone;
global.move_queue = noone;
global.game_speed = 60;
global.RIGHT = 0;
global.UP = -pi / 2;
global.LEFT = pi;
global.DOWN = pi / 2;
global.NO_DIR = -100;
global.main_text = noone;
global.options_menu = noone;
global.frame_count = 0;
global.max_char_speed = 10;
global.controller_index = 0;