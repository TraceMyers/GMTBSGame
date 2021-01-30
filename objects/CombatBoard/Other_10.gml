/// @description Define Methods

// TODO: jumps?
// TODO: AI should be given a fake high speed, so they can pick a path
// that is more likely to be accurate, but with a goal out of their range.
// then, just move them as far along as their speed allows.
// TODO: more than one board per room?
// TODO: piece placement like dota picks were you take turns and can ban spots?
//      maybe place multiple at once so it doesn't take too long, but there is some
//      strategy
// TODO: occupied nodes are set to unoccupied in the search (from node)
// Finds all nodes, marks their positions, and deletes the node objects.
// All we need is to know where to draw their sprites, and where pieces can move
// Also marks where colored tokens are, which note the spaces wherein teams
// can set up their pieces before combat begins; 
// TODO: path customization (chain pathing)
// TODO: cancel move

init_board = function() {
	node_ct = instance_number(BoardNode);
    var blue_token_ct = instance_number(BlueToken);
    var red_token_ct = instance_number(RedToken);
    var red_chars = ds_list_create();
    var blue_chars = ds_list_create();
    for (var i = 0; i < node_ct; ++i) {
        path_costs[i] = noone;
        characters[i] = noone;
		var node = instance_find(BoardNode, i);
        with (node) {
            var token_set = false;
            for (var j = 0; j < blue_token_ct; ++j) {
                var blue_token = instance_find(BlueToken, j);
                if (x == blue_token.x && y == blue_token.y) {
                    var blue_char = instance_create_layer(x, y, "Characters", BluePiece);
                    blue_char.y -= blue_char.sprite_height * 0.6;
                    blue_char._name = blue_token._name;
                    blue_char._color = TEAM.BLUE;
                    ds_list_add(blue_chars, blue_char);
                    ds_list_add(blue_chars, i);
                    other.characters[i] = blue_char;
                    other.path_costs[i] = other.occupied;
                    token_set = true;
                    break;
                }
            }
            if (!token_set) {
                for (var j = 0; j < red_token_ct; ++j) {
                    var red_token = instance_find(RedToken, j);
                    if (x == red_token.x && y == red_token.y) {
                        var red_char = instance_create_layer(x, y, "Characters", RedPiece);
                        red_char.y -= red_char.sprite_height * 0.6;
                        red_char._name = red_token._name;
                        red_char._color = TEAM.RED;
                        ds_list_add(red_chars, red_char);
                        ds_list_add(red_chars, i);
                        other.characters[i] = red_char;
                        other.path_costs[i] = other.occupied;
                        token_set = true;
                        break;
                    }
                }
            }
            if (!token_set) {
                other.tokens[i] = noone;
            }
        }
		var _node_x = node.x;
		var _node_y = node.y;
		world_x[i] = _node_x;
		world_y[i] = _node_y;
		
		// for setting and accessing the sparse array	
		if (_node_x < world_leftmost_x) {
			world_leftmost_x = _node_x;
		}
		if (_node_x > world_rightmost_x) {
			world_rightmost_x = _node_x;
		}
		if (_node_y < world_topmost_y) {
			world_topmost_y = _node_y;
		}
		if (_node_y > world_bottommost_y) {
			world_bottommost_y = _node_y;
		}
	}
    leftmost_x = get_sparse_graph_x(world_leftmost_x);
    rightmost_x = get_sparse_graph_x(world_rightmost_x);
    topmost_y = get_sparse_graph_y(world_topmost_y);
    bottommost_y = get_sparse_graph_y(world_bottommost_y);
	instance_destroy(BoardNode);
    instance_destroy(RedToken);
    instance_destroy(BlueToken);
    selection_obj = instance_create_layer(x, y, "Instances", BoardNode);
    selection_obj._speed = 80; // hacky bullshit so the camera will follow our selection
    selection_obj.visible = false;

    var red_i = 0;
    var blue_i = 0;
    var red_done = false;
    var blue_done = false;
    while (!red_done || !blue_done) {
        if (!red_done) {
            turn_queue.push_back(red_chars[|red_i], red_chars[|red_i + 1]);
            red_i += 2;
            red_done = (red_i < ds_list_size(red_chars) ? false : true);
        }
        if (!blue_done) {
            turn_queue.push_back(blue_chars[|blue_i], blue_chars[|blue_i + 1]);
            blue_i += 2;
            blue_done = (blue_i < ds_list_size(blue_chars) ? false : true);
        }
    }
    ds_list_destroy(blue_chars);
    ds_list_destroy(red_chars);
}


get_sparse_graph_x = function(_x) {
	return round((_x - world_leftmost_x) * tile_half_width_factor) + global.max_char_speed * 2 + 1;
}

get_sparse_graph_y = function(_y) {
	return round((_y - world_topmost_y) * row_height_factor) + global.max_char_speed + 1;	
}

get_world_x = function(scaled_x) {
	return round(((scaled_x - 2) * tile_half_width) + world_leftmost_x);	
}

get_world_y = function(scaled_y) {
	return round(((scaled_y - 1) * row_height) + world_topmost_y);
}

init_sparse_graph = function() {
	for (var _x = 0; _x <= rightmost_x + 4 * global.max_char_speed + 2; ++_x) {
		for (var _y = 0; _y <= bottommost_y + 2 * global.max_char_speed + 2; ++_y) {
			sparse_graph[_x][_y] = noone;
		}
	}
}

set_check_dirs = function() {
	check_dir_x[BOARD.LEFT] = -tile_width;
	check_dir_x[BOARD.RIGHT] = tile_width;
	check_dir_x[BOARD.UP_LEFT] = -tile_half_width;
	check_dir_x[BOARD.UP_RIGHT] = tile_half_width;
	check_dir_x[BOARD.DOWN_LEFT] = -tile_half_width;
	check_dir_x[BOARD.DOWN_RIGHT] = tile_half_width;
	check_dir_y[BOARD.LEFT] = 0;
	check_dir_y[BOARD.RIGHT] = 0;
	check_dir_y[BOARD.UP_LEFT] = -row_height;
	check_dir_y[BOARD.UP_RIGHT] = -row_height;
	check_dir_y[BOARD.DOWN_LEFT] = row_height;
	check_dir_y[BOARD.DOWN_RIGHT] = row_height;
}

scale_check_dirs = function() {
	check_dir_x[BOARD.LEFT] = -2;
	check_dir_x[BOARD.RIGHT] = 2;
	check_dir_x[BOARD.UP_LEFT] = -1;
	check_dir_x[BOARD.UP_RIGHT] = 1;
	check_dir_x[BOARD.DOWN_LEFT] = -1;
	check_dir_x[BOARD.DOWN_RIGHT] = 1;
	check_dir_y[BOARD.LEFT] = 0;
	check_dir_y[BOARD.RIGHT] = 0;
	check_dir_y[BOARD.UP_LEFT] = -1;
	check_dir_y[BOARD.UP_RIGHT] = -1;
	check_dir_y[BOARD.DOWN_LEFT] = 1;
	check_dir_y[BOARD.DOWN_RIGHT] = 1;
}

set_check_rings = function() {
	for (var i = 0; i < global.max_char_speed; ++i) {
		var ctr = 0;
		var dir_steps = i + 1;
		var step_x = check_dir_x[BOARD.RIGHT] * dir_steps;
		var step_y = 0;
		for (var step_dir = BOARD.DOWN_LEFT; step_dir <= BOARD.DOWN_RIGHT; ++step_dir) {
			for (var j = 0; j < dir_steps; ++j) {
				step_x += check_dir_x[step_dir];
				step_y += check_dir_y[step_dir];
				check_rings_x[i][ctr] = step_x;
				check_rings_y[i][ctr] = step_y;
				++ctr;
			}	
		}
	}
}

get_ring_node_ct = function(ring) {
	return (ring + 1) * 6;
}

build_graph = function() {
	for (var i = 0; i < node_ct; ++i) {
		var _x = world_x[i];
		var _y = world_y[i];
		
		var scaled_x = get_sparse_graph_x(_x);
		var scaled_y = get_sparse_graph_y(_y);
		sparse_graph[scaled_x][scaled_y] = i;
		
		var edge_ct = 0;
		for (var j = 0; j < check_dir_ct; ++j) {
			var check_x = _x + check_dir_x[j];
			var check_y = _y + check_dir_y[j];
			var found_edge = false;
			for (var k = 0; k < node_ct; ++k) {
				if (world_x[k] == check_x && world_y[k] == check_y) {
					edges[i][j] = k;
					found_edge = true;
					++edge_ct;
					break;
				}
			}
			if (!found_edge) {
				edges[i][j] = noone;
			}
		}
	}
}

scale_graph = function() {
	for (var i = 0; i < node_ct; ++i) {
		node_x[i] = get_sparse_graph_x(world_x[i]);
		node_y[i] = get_sparse_graph_y(world_y[i]);
	}
}

draw_edges = function() {
	var x_offset = 24;
	var y_offset = 16;
	var count = 0;
	for (var i = 0; i < node_ct; ++i) {
		var from_x = world_x[i] + x_offset;
		var from_y = world_y[i] + y_offset;
		var to_x = noone;
		var to_y = noone;
		for (var j = 0; j < check_dir_ct; ++j) {
			var edge = edges[i][j];
			if (edge != noone) {
				count++;
				to_x = world_x[edge] + x_offset;
				to_y = world_y[edge] + y_offset;
				switch(j) {
					case BOARD.LEFT:
					case BOARD.UP_LEFT:
					case BOARD.DOWN_LEFT:
						from_y += 1;
						to_y += 1;
						draw_set_color(c_yellow);
						break;
					case BOARD.RIGHT:
					case BOARD.UP_RIGHT:
					case BOARD.DOWN_RIGHT:
						from_y -= 1;
						to_y -= 1;
						draw_set_color(c_red);
						break;
				}
				draw_line(from_x, from_y, to_x, to_y);
			}
		}
	}
	draw_set_color(c_white);
}

start_combat = function() {
	show_debug_message("hey! listen!");
}

bfs_populate_moves = function(from_node, _speed) {
	var read = 0;
	var write = 1;
	var considering;
	considering[read] = ds_list_create();
	considering[write] = ds_list_create();
	ds_list_add(considering[read], from_node);
	path_costs[from_node] = 0;
	for (var i = 1; i <= _speed; ++i) {
		var read_list = considering[read];
		var write_list = considering[write];
		for (var j = 0; j < ds_list_size(read_list); ++j) {
			var search_node = read_list[|j];	
			for (var k = 0; k < check_dir_ct; ++k) {
				var edge = edges[search_node][k];
				if (edge != noone && path_costs[edge] == noone) {
					path_costs[edge] = i;	
					point_backs[edge] = search_node;
					ds_list_add(write_list, edge);
				}
			}
		}	
		ds_list_clear(read_list);
		if (read == 0) {
			read = 1;
			write = 0
		}
		else {
			read = 0;
			write = 1;
		}
	}
	ds_list_destroy(considering[read]);
	ds_list_destroy(considering[write]);
}

clear_paths = function() {
	for (var i = 0; i < node_ct; ++i) {
        if (path_costs[i] != occupied) {
            path_costs[i] = noone;
        }
		point_backs[i] = noone;
	}
}

// TODO: learn how to use surfaces in order to make the board into
// a single sprite, and maybe draw other effects on top there, too?
draw_node_graphics = function() {
	var r = 160;
	var g = 10;
	var b = 15;
	var a = 0.7;
	var colors;
	for (var i = 0; i <= global.max_char_speed; ++i) {
		colors[i] = make_color_rgb(
			r + 15 * i,
			g + 8 * i,
			b + 25 * i
		);
	}
    var selected_node_w_x = -1;
    var selected_node_w_y = -1;
    if (selected_node != noone) {
        selected_node_w_x = world_x[selected_node];
        selected_node_w_y = world_y[selected_node];
    }
	for (var i = 0; i < node_ct; ++i) {
        var w_x = world_x[i];
        var w_y = world_y[i];
        var is_path_node = false;
        for (var j = 0; j < _path_len; ++j) {
            var path_node = moving_char_path[j]
            if (i == path_node) {
                shader_flashing_set(global.frame_count / 18, 0.08);
                var swx = world_x[path_node];
                var swy = world_y[path_node];
                draw_sprite_ext(sBoardNodeOutline, 0, swx, swy, 1, 1, 0, c_white, 0.8);
                shader_reset();
                is_path_node = true;
                break;
            }
        }
        if (!is_path_node) {
            if (path_costs[i] >= 0) {
                // if (w_y == selected_node_w_y) {
                //     shader_flashing_set(global.frame_count / 18, 0.15);
                //     draw_sprite_ext(sBoardNode, 0, w_x, w_y, 1, 1, 0, colors[path_costs[i]], a - path_costs[i] / 16);
                //     shader_reset();
                // }
                // else {
                    draw_sprite_ext(sBoardNode, 0, w_x, w_y, 1, 1, 0, colors[path_costs[i]], a - path_costs[i] / 16);	
                // }
            }
            else {
                draw_sprite(sBoardNodeLowAlpha, 0, w_x, w_y);
            }
        }
		
        /*
        if (tokens[i] == TEAM.RED){
			draw_sprite_ext(sBoardNode, 0, w_x, w_y, 1, 1, 0, c_red, 0.4);	
        }
        else if (tokens[i] == TEAM.BLUE) {
			draw_sprite_ext(sBoardNode, 0, w_x, w_y, 1, 1, 0, c_blue, 0.4);	
        }
        */
	}
}


// TODO: bug where when going across gap, pause frames aren't happening on right
// node. sometimes late, sometimes early
cursor_move = function(dir) {
    var cursor_x = node_x[selected_node];
    var cursor_y = node_y[selected_node];
    var vert_set = false;
    // just for up & down
    var y_diffmod = noone;;
    var _checkdir = noone;
    var changed_selection = false;
    switch(dir) {
        case HEX_CURSOR.UP:
            // alternate diag direction every other row
            y_diffmod = abs(cursor_y - node_y[cur_character_node]) mod 2
            _checkdir = (y_diffmod == 0 ? BOARD.UP_LEFT : BOARD.UP_RIGHT);
            vert_set = true;
        case HEX_CURSOR.DOWN:
            // alternate diag direction every other row
            if (!vert_set) {
                y_diffmod = abs(cursor_y - node_y[cur_character_node]) mod 2
                _checkdir = (y_diffmod == 0 ? BOARD.DOWN_LEFT : BOARD.DOWN_RIGHT);
            }

            // HEX_CURSOR.UP and HEX_CURSOR.DOWN:
            var checkdir_x = check_dir_x[_checkdir];
            cursor_x += checkdir_x;
            cursor_y += check_dir_y[_checkdir];
            if (
                cursor_x >= leftmost_x 
                && cursor_x <= rightmost_x
                && cursor_y >= topmost_y
                && cursor_y <= bottommost_y
            ) {
                var new_selection = sparse_graph[cursor_x][cursor_y];
                if (new_selection != noone && path_costs[new_selection] >= 0) {
                    selected_node = new_selection;
                    changed_selection = true;
                }
                else {
                    var check_x;
                    var search_x;
                    search_x[0] = cursor_x;
                    search_x[1] = cursor_x;
                    if (checkdir_x < 0) {
                        check_x[0] = check_dir_x[BOARD.RIGHT];
                        check_x[1] = check_dir_x[BOARD.LEFT];
                    }
                    else {
                        check_x[0] = check_dir_x[BOARD.LEFT];
                        check_x[1] = check_dir_x[BOARD.RIGHT];
                    }
                    var row_finished_search = false;
                    for (var i = 0; i < cur_character_speed && !row_finished_search; ++i) {
                        for (var j = 0; j < 2; ++j) {
                            search_x[j] += check_x[j];
                            var cur_x = search_x[j];
                            if (cur_x >= leftmost_x && cur_x <= rightmost_x) {
                                var new_selection = sparse_graph[cur_x][cursor_y];
                                if (new_selection != noone && path_costs[new_selection] >= 0) {
                                    selected_node = new_selection;
                                    changed_selection = true;
                                    row_finished_search = true;
                                    break;
                                }
                            }
                        }
                    }
                    // alternate checking left and right on this row
                    // TODO: jump? move up/down again if row empty
                }
            }
            break;
        case HEX_CURSOR.UP_RIGHT:
        case HEX_CURSOR.UP_LEFT:
        case HEX_CURSOR.DOWN_RIGHT:
        case HEX_CURSOR.DOWN_LEFT:
        case HEX_CURSOR.LEFT:
        case HEX_CURSOR.RIGHT:
            var new_selection = noone;
            do {
                cursor_x += check_dir_x[dir];
                cursor_y += check_dir_y[dir];
                show_debug_message("checking " + string(cursor_x));
                new_selection = sparse_graph[cursor_x][cursor_y];
            }
            until (
                (new_selection != noone && path_costs[new_selection] >= 0)
                || cursor_x < leftmost_x
                || cursor_x > rightmost_x
                || cursor_y < topmost_y
                || cursor_y > bottommost_y
            )
            if (new_selection != noone) {
                selected_node = new_selection;
                changed_selection = true;
            }
            break;
    }
    selection_obj.x = world_x[selected_node];
    selection_obj.y = world_y[selected_node];

    if (changed_selection) {
        get_move_path();
    }
}

get_move_path = function() {
    var char_node = turn_queue.cur_ancillary();
    var path_node = selected_node;
    _path_len = path_costs[selected_node];
    _path_i = 0;
    for (var i = _path_len - 1; i >= 0; --i) {
        moving_char_path[i] = path_node;
        moving_char_path_x[i] = world_x[path_node] + tile_half_width;
        moving_char_path_y[i] = world_y[path_node] + tile_half_height_plus_two;
        path_node = point_backs[path_node];
    }
}

test_bfs = function() {
	static cur_character_node = 0;
	if (pc_check(pc.dbg_1)) {
		pathing_requested = true;
	}
	if (pathing_requested && pathing_ready) {
		pathing_requested = false;
        do {
            ++cur_character_node;
            if (cur_character_node >= node_ct) {
                cur_character_node = 0;
            }
        }
        until (path_costs[cur_character_node] != occupied)
		clear_paths();
		bfs_populate_moves(cur_character_node, cur_character_speed);
        
	}
}

test_selection = function() {
    static dbg_switch = false;
    if (pc_check_pressed(pc.dbg_2)) {
        if (dbg_switch) {
            global.camera_controller.following_char = global.player_controller.controlling_char;
            global.player_controller.control_type = CONTROL_TYPES.CHARACTER;
            global.camera_controller.follow_speed_factor *= 4;
            dbg_switch = false;
        }
        else {
            global.camera_controller.following_char = selection_obj;
            global.camera_controller.follow_speed_factor *= 1/4;
            global.player_controller.board = self;
            global.player_controller.control_type = CONTROL_TYPES.BOARD;
            dbg_switch = true;
        }
    }
	if (pc_check_scroll(pc.dbg_1, global.game_speed / 6, 4)) {
		pathing_requested = true;
	}
	if (pathing_requested && pathing_ready) {
		pathing_requested = false;
        do {
            ++cur_character_node;
            if (cur_character_node >= node_ct) {
                cur_character_node = 0;
            }
        }
        until (path_costs[cur_character_node] != occupied)
		clear_paths();
		bfs_populate_moves(cur_character_node, cur_character_speed);
        selected_node = cur_character_node;
        selection_obj.x = world_x[selected_node];
        selection_obj.y = world_y[selected_node];
	}
}

test_turns = function() {
    static dbg_switch = false;
    if (pc_check_pressed(pc.dbg_1)) {
        if (dbg_switch) {
            global.camera_controller.following_char = global.player_controller.controlling_char;
            global.player_controller.control_type = CONTROL_TYPES.CHARACTER;
            global.camera_controller.follow_speed_factor *= 4;
            dbg_switch = false;
        }
        else {
            global.camera_controller.following_char = selection_obj;
            global.camera_controller.follow_speed_factor *= 1/4;
            global.player_controller.board = self;
            global.player_controller.control_type = CONTROL_TYPES.BOARD;
            dbg_switch = true;
        }
    }
    if (pc_check_pressed(pc.dbg_2)) {
        var char_node_index = turn_queue.cur_ancillary();
        var char = turn_queue.cur();
        clear_paths();
        bfs_populate_moves(char_node_index, char._speed);
        selected_node = char_node_index;
        selection_obj.x = world_x[selected_node];
        selection_obj.y = world_y[selected_node];
        get_move_path();
    }
}

test_turns_draw_gui = function() {
    turn_queue.dbg_draw();
}

move_character = function() {
    moving_char = true;
    state = BOARD_STATES.MOVING_CHAR;
    
}

move_character_step = function() {
    if (_path_i < _path_len) {
        var char = turn_queue.cur();
        var char_x = char.x + char.sprite_width / 2;
        var char_y = char.y + char.sprite_height;
        var dist_x = moving_char_path_x[_path_i] - char_x;
        var dist_y = moving_char_path_y[_path_i] - char_y;
        var dist = sqrt(dist_x * dist_x + dist_y * dist_y);
        if (dist <= char._speed) {
            char.x += dist_x;
            char.y += dist_y;
            ++_path_i;
        }
        else {
            var speed_factor = char._speed / dist;
            char.x += dist_x * speed_factor;
            char.y += dist_y * speed_factor; 
        }
    }
    else {
        turn_queue.set_cur_ancillary(selected_node);
        moving_char = false;
        path_costs[selected_node] = occupied;
        // TODO: obv this goes somewhere else, but whether the piece moves or not, 
        // must reset its space to occupied ^^^
        state = BOARD_STATES.CURSOR;
        turn_queue.advance();
        char_node_index = turn_queue.cur_ancillary();
        char = turn_queue.cur();
        clear_paths();
        bfs_populate_moves(char_node_index, char._speed);
        selected_node = char_node_index;
        selection_obj.x = world_x[selected_node];
        selection_obj.y = world_y[selected_node];
    }
}

// Disabled A* implementation.
// requires function that fields potential moves, and
// records absolute step distances (if no holes/blocking) along the way
// Maybe useful later

// get_path = function(from_node, to_node, _speed) {
// 	var data_grid = ds_grid_create(5, node_ct);
// 	var speed_plus_epsilon = _speed + 0.01;
// 	for (var _y = 0; _y < node_ct; ++_y) {
// 		data_grid[# SEARCH.STORED, _y] = false;
// 		data_grid[# SEARCH.SEARCHED, _y] = false;
// 	}
// 	data_grid[# SEARCH.STORED, to_node] = true;
// 	data_grid[# SEARCH.POINT_BACK, to_node] = noone;
// 	data_grid[# SEARCH.STEPS, to_node] = 0;
// 	data_grid[# SEARCH.SEARCHED, to_node] = true;
	
// 	var search_node = to_node;
// 	while (search_node != noone) {
// 		data_grid[# SEARCH.SEARCHED, search_node] = true;
// 		for (var i = 0; i < check_dir_ct; ++i) {
// 			var neighbor = edges[search_node][i];
// 			if (neighbor != noone) {
// 				var neighbor_steps = data_grid[# SEARCH.STEPS, search_node] + 1;
// 				if (!data_grid[# SEARCH.STORED, neighbor]) {
// 					var neighbor_step_dist = step_distances[neighbor];
// 					if (neighbor == from_node) {
// 						data_grid[# SEARCH.STORED, from_node] = true;
// 						data_grid[# SEARCH.POINT_BACK, from_node] = search_node;
// 						data_grid[# SEARCH.STEPS, from_node] = neighbor_steps;
// 						data_grid[# SEARCH.EST_DISTANCE, from_node] = neighbor_steps;
// 						data_grid[# SEARCH.SEARCHED, from_node] = true;
// 						// if (neighbor_step_dist == neighbor_steps) {
// 						// 	break;
// 						// }
// 						break;
// 					}
// 					else {
// 						var est_distance = neighbor_steps + neighbor_step_dist;
// 						if (est_distance <= speed_plus_epsilon) {
// 							data_grid[# SEARCH.STEPS, neighbor] = neighbor_steps;
// 							data_grid[# SEARCH.EST_DISTANCE, neighbor] = est_distance;
// 							data_grid[# SEARCH.SEARCHED, neighbor] = false;
// 							data_grid[# SEARCH.STORED, neighbor] = true;
// 							data_grid[# SEARCH.POINT_BACK, neighbor] = search_node;
// 						}
// 					}
// 				}
// 				else if (neighbor_steps < data_grid[# SEARCH.STEPS, neighbor]) {
// 					var neighbor_step_dist = step_distances[neighbor];
// 					var est_distance = neighbor_steps + neighbor_step_dist;
// 					data_grid[# SEARCH.POINT_BACK, neighbor] = search_node;
// 					data_grid[# SEARCH.STEPS, neighbor] = neighbor_steps;
// 					data_grid[# SEARCH.EST_DISTANCE, neighbor] = est_distance;
// 					// if (neighbor != from_node) {
// 						data_grid[# SEARCH.SEARCHED, neighbor] = false;
// 					// }
// 					// else if (neighbor_step_dist == neighbor_steps) {
// 					// 	break;
// 					// }
// 				}
// 			}
// 		}	
// 		var lowest_est_dist = 1000000;
// 		search_node = noone;
// 		for (var i = 0; i < node_ct; ++i) {
// 			if (data_grid[# SEARCH.STORED, i] && !data_grid[# SEARCH.SEARCHED, i]) {
// 				var est_dist = data_grid[# SEARCH.EST_DISTANCE, i];
// 				if (est_dist < lowest_est_dist) {
// 					lowest_est_dist = est_dist;	
// 					search_node = i;
// 				}
// 			}
// 		}
// 	}
// 	if (data_grid[# SEARCH.SEARCHED, from_node] != false) {
// 		search_node = from_node;
// 		for (var i = 0; search_node != to_node; ++i) {
// 			search_node = data_grid[# SEARCH.POINT_BACK, search_node];
// 			paths[# i, to_node] = search_node;
// 		}
// 		path_costs[to_node] = data_grid[# SEARCH.STEPS, from_node];
// 	}
// 	ds_grid_destroy(data_grid);
// }