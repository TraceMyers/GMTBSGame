if (usable) {
	if (use_range_trigger == noone) {
		spawn_use_range_trigger();
	}
	use_range_trigger.x = x - 10;
	use_range_trigger.y = y - 10;
	use_range_trigger.depth = depth - 1;
	use_range_trigger.owner = self;
}