owner = self;
usable = true;
arena = instance_place(x, y, CombatBoard);

react_to_use = function() {
	return USE_REACTIONS.COMBAT;
}