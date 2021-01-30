event_inherited();


state = CHAR_STATES.IDLE;
facing = FACING.RIGHT;
use_reaction = USE_REACTIONS.DIALOGUE;

_speed = 4;
can_push = false;
push_force = 1;
can_use = false;
use_trigger = noone;
init_push_ctr = 0;
usable = true;
unresolved_push = false;
_name = "Sammy";
dialogue = instance_create_layer(0, 0, "Instances", Dialogue);
dialogue.set_owner(self);

event_user(0); // defines methods