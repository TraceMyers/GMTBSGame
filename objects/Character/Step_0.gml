event_inherited();

if (can_push) {
	can_be_pushed = false;
}

if (can_use) {
	if (use_trigger == noone) {
		spawn_use_trigger();
	}
	set_use_trigger_pos();
}

switch(state) {
	case CHAR_STATES.IDLE:
		break;
	case CHAR_STATES.WALK:
		break;
	case CHAR_STATES.RUN:
		break;
	case CHAR_STATES.INIT_PUSH:
		--init_push_ctr;
		if (init_push_ctr <= 0) {
			state = CHAR_STATES.PUSH;
		}
		break;
	case CHAR_STATES.PUSH:
		break;
	default:
		//show_debug_message("character id [" + string(id) + "] in non-existent state");
}

react_to_use = function() {
	return use_reaction;
}