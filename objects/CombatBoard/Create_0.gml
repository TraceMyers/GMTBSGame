// stored, point_backs, steps, steps + fly distance

enum SEARCH {
	STORED,
	POINT_BACK,
	STEPS,
	EST_DISTANCE,
	SEARCHED
};

selected_node = noone;
selection_obj = noone;

node_x[0] = 0;
world_x[0] = 0;
node_y[0] = 0;
world_y[0] = 0;
node_ct = 0;
depth = 2;
edges[0][0] = 0; // [node][edge]
check_dir_x[0] = 0;
check_dir_y[0] = 0;
check_dir_ct = 6;
tile_width = 48;
tile_half_width = tile_width / 2;
tile_half_width_factor = 1 / tile_half_width;
row_height = 20;
row_height_factor = 1 / row_height;
tile_half_height_plus_two = 32 / 2 + 2;
world_leftmost_x = room_width;
world_topmost_y = room_height;
world_rightmost_x = -1;
world_bottommost_y = -1;
leftmost_x = room_width;
topmost_y = room_height;
rightmost_x = -1;
bottommost_y = -1;
sparse_graph[0][0] = noone;
sparse_max_x = 0;
sparse_max_y = 0;
occupied = -1000; // assigned to path_costs[node]

characters[0] = noone;
path_costs[0] = noone;
pathing_ready = true;
pathing_requested = false;
cur_character_node = 0;
cur_character_speed = 5;

state = BOARD_STATES.CURSOR;

moving_char_path[0] = noone;
moving_char_path_x[0] = noone;
moving_char_path_y[0] = noone;
_path_len = 0;
_path_i = 0;

point_backs[0] = noone;

test_timer = 60;

turn_queue = instance_create_layer(x, y, "Instances", TurnQueue);

event_user(0);
init_board();
init_sparse_graph();
set_check_dirs();
build_graph();
scale_graph();
clear_paths();
scale_check_dirs();
