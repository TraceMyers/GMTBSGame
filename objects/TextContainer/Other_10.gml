/// @description Define Methods

activate = function() {
    // TODO: animation
    visible = true;
}

deactivate = function() {
    // TODO: animation
    visible = false;
}

set_font = function(_font) {
    font = _font;
    font_size = font_get_size(font);
}

set_scroll_speed = function(val) { // 0 = immediate
    scroll_speed = val;
}

set_padding = function(val) {
    padding = val;
}

set_line_spacing = function(val) {
    line_spacing = val;
}

set_halign = function(val) {
	h_align = val;
}

set_valign = function(val) {
	v_align = val;
}

set_width = function(val) {
	text_width = val * (text_width / width);
	width = val;
}

set_text_to_ratio = function(val) {
	text_width = width * val;
}

set_text_to_full_width = function() {
	text_width = width;
}

display = function(text) {
    draw_set_font(font);
    set_lines(text);
    set_line_positions();
    if (scroll_speed > 0) {
        scrolling = true;
    }
}

set_lines = function(text) {
    line_ct = 0;
    var remaining_slice = text;
    var text_box_width = text_width - padding * 2;
    var text_len = string_length(text);
    var slice_end = text_len;
    var remaining_slice_len = slice_end;
    while (true) {
        var last_line = true;
		var test_slice = remaining_slice;
		while (true) {
	        var slice_width = string_width(test_slice);
	        var scale = text_box_width / slice_width;
	        if (scale < 1) {
	            last_line = false;
				var test_slice_len = string_length(test_slice);
				var old_slice_end = slice_end;
	            slice_end = ceil(scale * test_slice_len);
				if (slice_end >= old_slice_end) {
					--slice_end;
				}
				test_slice = string_copy(remaining_slice, 1, slice_end);
	        }
			else {
				break;
			}
		}
        if (!last_line) {
            var search_counter = 0;
            for (
                ; // TODO: wtf is this 6?
                search_counter < 6 && search_counter < slice_end; 
                ++search_counter
            ) {
                var char = string_char_at(remaining_slice, slice_end - search_counter);
                if (char == " ") {
                    break;
                }
            }
            if (search_counter == 6) {
                slice_end -= 2;
                remaining_slice_len -= slice_end;
                lines[line_ct] = string_copy(remaining_slice, 1, slice_end);
                lines[line_ct] += "-";
            }
            else {
                slice_end -= search_counter;
                remaining_slice_len -= slice_end;
                lines[line_ct] = string_copy(remaining_slice, 1, slice_end);
            }
        }
        else {
            lines[line_ct] = string_copy(remaining_slice, 1, remaining_slice_len);
            ++line_ct;
            break;
        }
        ++line_ct;
        remaining_slice = string_copy(remaining_slice, slice_end + 1, remaining_slice_len);
        slice_end = remaining_slice_len;
    }
}

set_line_positions = function() {
    var left = x + padding;
    var center_x = x + width / 2;
    var right = x + width - padding;
    var top = y + padding;
    var center_y = y + height / 2;
    var bottom = y + height - padding;
    
    var valign_cursor = top;
    var valign_diff = font_get_size(font) + line_spacing;
    switch(v_align) {
        case VALIGN.CENTER:
            var lines_height = line_ct * font_get_size(font);
            var spacing_height = (line_ct - 1) * line_spacing;
            var text_height = lines_height + spacing_height;
            valign_cursor = center_y - text_height / 2;
            break;
        case VALIGN.BOTTOM:
            var lines_height = line_ct * font_get_size(font);
            var spacing_height = (line_ct - 1) * line_spacing;
            var text_height = lines_height + spacing_height;
            valign_cursor = bottom - text_height
            break;
    }
    for (var i = 0; i < line_ct; ++i) {
        switch(h_align) {
            case HALIGN.LEFT:
                line_positions_x[i] = left;
                break;
            case HALIGN.CENTER:
                line_positions_x[i] = center_x - string_width(lines[i]) / 2;
                break;
            case HALIGN.RIGHT:
                line_positions_x[i] = right - string_width(lines[i]);
                break;
        }
        line_positions_y[i] = valign_cursor;
        valign_cursor += valign_diff;
    }
}

get_text_height = function() {
	return font_size * line_ct;
}