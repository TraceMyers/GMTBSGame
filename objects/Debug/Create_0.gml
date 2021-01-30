drawing_collision_boxes = false;
drawing_use_range_triggers = false;

highlighted_pixels_x[0] = 0;
highlighted_pixels_y[0] = 0;
highlighted_pixels_ct = 0;
player_controller_character_speed_turbo = false;

// turn queue
turn_queue_advance_ctr = 0;
turn_queue_remove_and_push_ctr = 0;
turn_queue_dbg_test = false;
turn_queue = noone;

event_user(0);

// TEST: menu
menu = noone;
// test_menu_create();

// TEST: switch playercontrol
test_switch_control_create();

if (turn_queue_dbg_test) {
    turn_queue_test_load();
}

global.debug = self;
