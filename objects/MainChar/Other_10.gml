/// @description Define Methods
event_inherited();

animate_facing = function() {
	switch(facing) {
		case FACING.RIGHT:
			sprite_index = sMainCharIdleRight;
			break;
		case FACING.UP:
			sprite_index = sMainCharIdleBack;
			break;
		case FACING.LEFT:
			sprite_index = sMainCharIdleLeft;
			break;
		case FACING.DOWN:
			sprite_index = sMainCharIdleFront;
			break;
	}
}