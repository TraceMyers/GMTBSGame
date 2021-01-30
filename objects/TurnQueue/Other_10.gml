/// @description Define Methods

push_back = function(item, ancillary_data) {
    // for dbg_draw()
    // draw_set_font(font);
    // var name_width = string_width(item._name);
    // longest_game_width = (name_width > longest_name_width ? name_width : longest_game_width);
    // draw_set_font(global.default_font);
    if (turn_index == 0) {
        queue[_size] = item;
        ancillary[_size] = ancillary_data;
        _size++;
    }
    else  {
        var i = _size;
        for ( ; i > turn_index; --i) {
            queue[i] = queue[i - 1];
            ancillary[i] = ancillary[i - 1];
        }
        queue[i] = item;
        ancillary[i] = ancillary_data;
        ++turn_index;
        ++_size;
    }
}

remove = function(item) {
    var found_remove_index = false;
    for (var i = 0; i < _size; ++i) {
        if (found_remove_index) {
            queue[i - 1] = queue[i];
            ancillary[i - 1] = ancillary[i];
        }
        else if (item == queue[i]) {
            found_remove_index = true;
            if (i < turn_index) {
                turn_index--;
            }
        }
    }
    if (found_remove_index) {
        _size--;
        if (turn_index == _size) {
            turn_index = 0;
        }
    }
}

cur = function() {
    return queue[turn_index];
}

cur_ancillary = function() {
    return ancillary[turn_index];
}

set_cur_ancillary = function(val) {
    ancillary[turn_index] = val;
}

get = function(index) {
    var get_index = turn_index + index;
    if (get_index >= _size) {
        get_index -= _size;
        return queue[get_index];
    }
    return 
}

get_ancillary = function(index) {
    var get_index = turn_index + index;
    if (get_index >= _size) {
        get_index -= _size;
        return ancillary[get_index];
    }
    return 
}

advance = function() {
    ++turn_index;
    if (turn_index == _size) {
        turn_index = 0;
    }
}

size = function() {
    return _size;
}

dbg_draw = function() {
	draw_set_font(font);
    var _x = global.view_width - 80;
    var y_diff = font_get_size(font) + 3;
    var _y = global.view_height - y_diff * 3;
    var i = turn_index;
    do {
        draw_text(_x, _y, queue[i]._name);
        _y -= y_diff;
        ++i;
        if (i == _size) {
            i = 0;
        }
    }
    until (i == turn_index)
    draw_set_font(global.default_font);
}