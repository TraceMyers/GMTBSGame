// If you check in Begin Step, you're guaranteed to get
//		last frame's move data from each Kinetic
// If you check in End Step, you're guaranteed to get
//		this frame's move data from each Kinetic
// TODO: aggregrate queues so we don't just have one weirdly only calling the other's
scrub_old_character_move_data();
attempt_moves();
global.push_queue.scrub_old_pushee_move_data();
global.push_queue.attempt_pushes();