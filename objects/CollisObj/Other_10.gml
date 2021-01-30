/// @description Define Methods

spawn_use_range_trigger = function() {
	use_range_trigger = instance_create_layer(x - 10, y - 10, "Triggers", UseRangeTrigger);
	var x_scale = sprite_width / use_range_trigger.sprite_width + 15 / sprite_width;
	var y_scale = sprite_height / use_range_trigger.sprite_height + 15 / sprite_height;
	use_range_trigger.image_xscale *= x_scale;
	use_range_trigger.image_yscale *= y_scale;
}

react_to_use = function() {
	// start dialogue
	show_debug_message("Help me I'm " + string(self.id) + " and I'm being used!");
}