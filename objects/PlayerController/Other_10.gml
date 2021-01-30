/// @description Define Methods

// TODO: load from save file for saved customization, rather than here

player_character_move = function() {
	switch(controlling_char.state) {
		case CHAR_STATES.IDLE:
		case CHAR_STATES.WALK:
		case CHAR_STATES.RUN:
		    var move_x = pc_check(pc.right) - pc_check(pc.left);
		    var move_y = pc_check(pc.down) - pc_check(pc.up);
			with (controlling_char) {
				if (pc_check(pc.right))		{ facing = FACING.RIGHT; }
				else if (pc_check(pc.up))	{ facing = FACING.UP; }
				else if (pc_check(pc.left))	{ facing = FACING.LEFT; }
				else if (pc_check(pc.down))	{ facing = FACING.DOWN; }
				// else if (
				// 	pc_check_released(pc.right)
				// 	|| pc_check_released(pc.up)
				// 	|| pc_check_released(pc.left)
				// 	|| pc_check_released(pc.down)
				// ) {
				// 	if		(move_y > 0)	{ facing = FACING.DOWN; }
				// 	else if (move_y < 0)	{ facing = FACING.UP; }
				// 	else if (move_x > 0)	{ facing = FACING.RIGHT; }
				// 	else if (move_x < 0)	{ facing = FACING.LEFT; }
				// }
			}
		    global.move_queue.queue_move(controlling_char, move_x, move_y);
		    break;
		case CHAR_STATES.MENU:
            var move_x = pc_check_scroll(pc.right, default_scroll_min, default_scroll_spd) 
                - pc_check_scroll(pc.left, default_scroll_min, default_scroll_spd);
		    var move_y = pc_check_scroll(pc.down, default_scroll_min, default_scroll_spd) 
                - pc_check_scroll(pc.up, default_scroll_min, default_scroll_spd);
			if (move_x > 0) {
				menu.change_selection(FACING.RIGHT);
			}
			else if (move_x < 0) {
				menu.change_selection(FACING.LEFT);
			}
			if (move_y > 0) {
				menu.change_selection(FACING.DOWN);
			}
			else if (move_y < 0) {
				menu.change_selection(FACING.UP);
			}
			break;
    }
}

board_move = function() {
    switch(board.state) {
        case BOARD_STATES.CURSOR:
            var move_x = pc_check_scroll(pc.right, default_scroll_min, default_scroll_spd) 
                - pc_check_scroll(pc.left, default_scroll_min, default_scroll_spd);
		    var move_y = pc_check_scroll(pc.down, default_scroll_min, default_scroll_spd) 
                - pc_check_scroll(pc.up, default_scroll_min, default_scroll_spd);
            // var move_x = pc_check_pressed(pc.right) - pc_check_pressed(pc.left);
            // var move_y = pc_check_pressed(pc.down) - pc_check_pressed(pc.up);
			if (move_x > 0) {
                if (move_y > 0) {
                    board.cursor_move(HEX_CURSOR.DOWN_RIGHT);
                }
                else if (move_y < 0) {
                    board.cursor_move(HEX_CURSOR.UP_RIGHT);
                }
                else {
                    board.cursor_move(HEX_CURSOR.RIGHT);
                }
			}
			else if (move_x < 0) {
                if (move_y > 0) {
                    board.cursor_move(HEX_CURSOR.DOWN_LEFT);
                }
                else if (move_y < 0) {
                    board.cursor_move(HEX_CURSOR.UP_LEFT);
                }
                else {
                    board.cursor_move(HEX_CURSOR.LEFT);
                }
			}
            else {
                if (move_y > 0) {
                    board.cursor_move(HEX_CURSOR.DOWN);
                }
                else if (move_y < 0) {
                    board.cursor_move(HEX_CURSOR.UP);
                }
            }
			break;

    }
}

player_character_use = function() {
	if (pc_check_pressed(pc.select) && controlling_char.can_use) {
		switch(controlling_char.state) {
			case CHAR_STATES.IDLE:
			case CHAR_STATES.WALK:
			case CHAR_STATES.RUN:
				var use_obj = get_use_obj();
				if (use_obj != noone) {
					var reaction = use_obj.react_to_use();
					if (reaction == USE_REACTIONS.DIALOGUE) {
						init_dialogue(use_obj);
					}
					else if (reaction == USE_REACTIONS.CHANGE_ROOM) {
						// TODO: customizable room change transitions
						room_goto(use_obj._room);
					}
					else if (reaction == USE_REACTIONS.COMBAT) {
						use_obj.arena.start_combat();
						controlling_char.state = CHAR_STATES.COMBAT_WAIT;
					}
				}
				break;
			case CHAR_STATES.DIALOGUE_LISTEN:
				var line = dialogue.get_next_line();
				if (line == noone) {
					end_dialogue();
				}
				else {
					global.main_text.display(line);
				}
				break;
			case CHAR_STATES.MENU:
				var callback_func = menu.get_selected_callback();
				if (callback_func != noone) {
					callback_func();
				}
				break;
		}
	}
}

board_use = function() {
    if (pc_check_pressed(pc.select)) {
        switch(board.state) {
            case BOARD_STATES.CURSOR:
                board.move_character();
                break;
        }
    }
}

// TODO: work with embedded / multiple menus
// TODO: work even if not idle/walk/run
player_character_open_and_close_options_menu = function() {
	switch(controlling_char.state) {
		case CHAR_STATES.IDLE:
		case CHAR_STATES.WALK:
		case CHAR_STATES.RUN:
		case CHAR_STATES.MENU:
			if (pc_check_pressed(pc.pause)) {
				if (menu != noone && menu.active) {
					if (menu.parent_menu != noone) {
						menu.to_parent_menu();
					}
					else {
						menu.deactivate();
						menu = noone;
						controlling_char.state = CHAR_STATES.IDLE;
					}
				}
				else {
					activate_menu(global.options_menu);
				}
			}
            else if (pc_check_pressed(pc.cancel)) {
                if (menu.parent_menu != noone) {
                    menu.to_parent_menu();
                }
                else {
                    menu.deactivate();
                    menu = noone;
                    controlling_char.state = CHAR_STATES.IDLE;
                }      
            }
			break;
	}
}

get_use_obj = function() {
	var use_trigger = controlling_char.use_trigger;
	var use_obj = noone;
	var overlapping_use_range_triggers = ds_list_create();
	with (use_trigger) {
		instance_place_list(x, y, UseRangeTrigger, overlapping_use_range_triggers, false);
	}
	for (var i = 0; i < ds_list_size(overlapping_use_range_triggers); i++) {
		var range_trigger = overlapping_use_range_triggers[|i];
		var rt_owner = range_trigger.owner;
		if (rt_owner.id != controlling_char && rt_owner.usable) {
			use_obj = rt_owner;
			break;
		}
	}
	ds_list_destroy(overlapping_use_range_triggers);
	return use_obj;
}

init_dialogue = function(use_obj) {
	controlling_char.state = CHAR_STATES.DIALOGUE_LISTEN;
	use_obj.state = CHAR_STATES.DIALOGUE_TALK;
	dialogue_buddy = use_obj;
	dialogue = use_obj.dialogue;
	global.main_text.activate();
	global.main_text.display(dialogue.get_next_line());
}

end_dialogue = function() {
	controlling_char.state = CHAR_STATES.IDLE;
	dialogue_buddy.state = CHAR_STATES.IDLE;
	dialogue_buddy = noone;
	dialogue = noone;
	global.main_text.deactivate();
}

activate_menu = function(_menu) {
	menu = _menu;
	menu.activate(true);
	controlling_char.state = CHAR_STATES.MENU;
}