test_switch_control_step();
change_game_speed();
set_fullscreen();
draw_triggers();
restart_room();
restart_game();
turbo_move_speed();
if (turn_queue_dbg_test) {
    turn_queue_test_advance();
    turn_queue_test_remove_and_push();
}
