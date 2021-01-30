#define pc_init
global.kb_params[pc.up][0] = vk_up;
global.kb_params[pc.up][1] = ord("W");
global.kb_params[pc.right][0] = vk_right;
global.kb_params[pc.right][1] = ord("D");
global.kb_params[pc.down][0] = vk_down;
global.kb_params[pc.down][1] = ord("S");
global.kb_params[pc.left][0] = vk_left;
global.kb_params[pc.left][1] = ord("A");
global.kb_params[pc.select][0] = ord("E");
global.kb_params[pc.select][1] = ord("E");
global.kb_params[pc.pause][0] = vk_escape;
global.kb_params[pc.pause][1] = vk_escape;
global.kb_params[pc.cancel][0] = vk_escape;
global.kb_params[pc.cancel][1] = ord("Q");
global.kb_params[pc.dbg_1][0] = vk_f9;
global.kb_params[pc.dbg_1][1] = vk_f9;
global.kb_params[pc.dbg_2][0] = vk_f10;
global.kb_params[pc.dbg_2][1] = vk_f10;
global.mouse_params[pc.up] = noone;
global.mouse_params[pc.right] = noone;
global.mouse_params[pc.down] = noone;
global.mouse_params[pc.left] = noone;
global.mouse_params[pc.select] = mb_left;
global.controller_params[pc.up][0] = gp_padu;
global.controller_params[pc.up][1] = gp_axislv;
global.controller_params[pc.down][0] = gp_padd;
global.controller_params[pc.down][1] = gp_axislv;
global.controller_params[pc.right][0] = gp_padr;
global.controller_params[pc.right][1] = gp_axislh;
global.controller_params[pc.left][0] = gp_padl;
global.controller_params[pc.left][1] = gp_axislh;
global.controller_params[pc.select][0] = gp_face1;
global.controller_params[pc.pause][0] = gp_start;
global.controller_params[pc.cancel][0] = gp_face2;
global.controller_params[pc.dbg_1][0] = gp_shoulderlb;
global.controller_params[pc.dbg_2][0] = gp_shoulderrb;
global.device_type = DEVICE.MOUSE_KB;
global.just_activated_axis = pc.none;
global.just_released_axis = pc.none;
global.last_axis = pc.none;
global.scroll_counter = 0;
global.scroll_registered = false;
return 0;


// TODO: allow noone
#define pc_check
var kb_in0 = max(global.kb_params[argument0][0], 0);
var kb_in1 = max(global.kb_params[argument0][1], 0);
// var ms_in = max(global.mouse_params[argument0], 0);
var kb_ms_check = 
    keyboard_check(kb_in0) 
    || keyboard_check(kb_in1) 
    // || keyboard_check(ms_in);
if (kb_ms_check) {
    global.device_type = DEVICE.MOUSE_KB;
    return true;
}
if (
    argument0 == pc.up 
    || argument0 == pc.down 
    || argument0 == pc.left 
    || argument0 == pc.right
) {
    var dpad_in = global.controller_params[argument0][0];
    var stick_in = global.controller_params[argument0][1];
    var stick_used = gamepad_axis_value(global.controller_index, stick_in);
    if ((argument0 == pc.down) || (argument0 == pc.right)) {
        if (stick_used > 0) {
            stick_used = true;
        }
        else {
            stick_used = false;
        }
    }
    else if (stick_used < 0) {
        stick_used = true;
    }
    else {
        stick_used = false;
    }
    var cnt_move_check = 
        gamepad_button_check(global.controller_index, dpad_in)
        || stick_used
    if (cnt_move_check) {
        global.device_type = DEVICE.CONTROLLER;
        return true;
    }
    else {
        return false;
    }
}
var cnt_in = global.controller_params[argument0][0];
if (gamepad_button_check(global.controller_index, cnt_in)) {
    global.device_type = DEVICE.CONTROLLER;
    return true;
}
return false;


#define pc_begin_step_update
global.scroll_registered = false;
var _direction = pc.up;
var stick_in = global.controller_params[_direction][1];
var stick_used = gamepad_axis_value(global.controller_index, stick_in);
if (stick_used < 0) {
    stick_used = true;
    _direction = pc.down;
}
else if (stick_used > 0) {
    stick_used = true;
    _direction = pc.up;
}
else {
    _direction = pc.left;
    stick_in = global.controller_params[_direction][1];
    stick_used = gamepad_axis_value(global.controller_index, stick_in);
    if (stick_used < 0) {
        stick_used = true;
        _direction = pc.left;
    }
    else if (stick_used > 0) {
        stick_used = true;
        _direction = pc.right;
    }
    else {
        stick_used = false;
        _direction = pc.none;
    }
}
if (stick_used) {
    if (global.last_axis != _direction) {
        global.just_activated_axis = _direction;
        global.just_released_axis = global.last_axis;
    }
    else {
        global.just_activated_axis = pc.none;
        global.just_released_axis = pc.none;
    }
    global.last_axis = _direction;
}
else if (global.last_axis != pc.none) {
    global.just_activated_axis = pc.none;
    global.just_released_axis = global.last_axis;
    global.last_axis = pc.none;
}
else {
    global.just_released_axis = pc.none;
    global.last_axis = pc.none;
}


#define pc_end_step_update
if (!global.scroll_registered) {
    global.scroll_counter = 0;
}


#define pc_check_pressed
var kb_in0 = max(global.kb_params[argument0][0], 0);
var kb_in1 = max(global.kb_params[argument0][1], 0);
// var ms_in = max(global.mouse_params[argument0], 0);
var kb_ms_check = 
    keyboard_check_pressed(kb_in0) 
    || keyboard_check_pressed(kb_in1)
    // || keyboard_check_pressed(ms_in);
if (kb_ms_check) {
    global.device_type = DEVICE.MOUSE_KB;
    return true;
}
if (
    argument0 == pc.up 
    || argument0 == pc.down 
    || argument0 == pc.left 
    || argument0 == pc.right
) {
    var dpad_in = global.controller_params[argument0][0];
    var stick_in = global.controller_params[argument0][1];
    var cnt_move_check = 
        gamepad_button_check_pressed(global.controller_index, dpad_in)
        || (global.just_activated_axis == argument0)
    if (cnt_move_check) {
        global.device_type = DEVICE.CONTROLLER;
        return true;
    }
    else {
        return false;
    }
}
var cnt_in = global.controller_params[argument0][0];
if (gamepad_button_check_pressed(global.controller_index, cnt_in)) {
    global.device_type = DEVICE.CONTROLLER;
    return true;
}
return false;


#define pc_check_released
var kb_in0 = max(global.kb_params[argument0][0], 0);
var kb_in1 = max(global.kb_params[argument0][1], 0);

// var ms_in = max(global.mouse_params[argument0], 0);
var kb_ms_check = 
    keyboard_check_released(kb_in0) 
    || keyboard_check_released(kb_in1)
    // || keyboard_check_released(ms_in);
if (kb_ms_check) {
    global.device_type = DEVICE.MOUSE_KB;
    return true;
}
if (
    argument0 == pc.up 
    || argument0 == pc.down 
    || argument0 == pc.left 
    || argument0 == pc.right
) {
    var dpad_in = global.controller_params[argument0][0];
    var stick_in = global.controller_params[argument0][1];
    var cnt_move_check = 
        gamepad_button_check_released(global.controller_index, dpad_in)
        || (global.just_released_axis == argument0)
    if (cnt_move_check) {
        global.device_type = DEVICE.CONTROLLER;
        return true;
    }
    else {
        return false;
    }
}
var cnt_in = global.controller_params[argument0][0];
if (gamepad_button_check_released(global.controller_index, cnt_in)) {
    global.device_type = DEVICE.CONTROLLER;
    return true;
}
return false;

// TODO: bugs where the pause is happening early, late, recurring, etc
#define pc_check_scroll
var scroll_min = argument1;
var scroll_spd = argument2;
var input_registered = false;
var kb_in0 = max(global.kb_params[argument0][0], 0);
var kb_in1 = max(global.kb_params[argument0][1], 0);
// var ms_in = max(global.mouse_params[argument0], 0);
var kb_ms_check = 
    keyboard_check(kb_in0) 
    || keyboard_check(kb_in1) 
    // || keyboard_check(ms_in);
if (kb_ms_check) {
    global.device_type = DEVICE.MOUSE_KB;
    input_registered = true;
}
if (
    !input_registered
    && (
        argument0 == pc.up 
        || argument0 == pc.down 
        || argument0 == pc.left 
        || argument0 == pc.right
    )
) {
    var dpad_in = global.controller_params[argument0][0];
    var stick_in = global.controller_params[argument0][1];
    var stick_used = gamepad_axis_value(global.controller_index, stick_in);
    if ((argument0 == pc.down) || (argument0 == pc.right)) {
        if (stick_used > 0) {
            stick_used = true;
        }
        else {
            stick_used = false;
        }
    }
    else if (stick_used < 0) {
        stick_used = true;
    }
    else {
        stick_used = false;
    }
    var cnt_move_check = 
        gamepad_button_check(global.controller_index, dpad_in)
        || stick_used
    if (cnt_move_check) {
        global.device_type = DEVICE.CONTROLLER;
        input_registered = true;
    }
}
if (!input_registered) {
    var cnt_in = global.controller_params[argument0][0];
    if (gamepad_button_check(global.controller_index, cnt_in)) {
        global.device_type = DEVICE.CONTROLLER;
        input_registered = true;
    }
}
if (input_registered) {
    if (!global.scroll_registered) {
        ++global.scroll_counter;
        global.scroll_registered = true;
    }
    var scr_ctr = global.scroll_counter - 2;
    if (scr_ctr == 0 || (scr_ctr >= scroll_min && scr_ctr mod scroll_spd == 0)) {
        return true;
    }
    return false;
}
return false;

#define keyboard_remap
var index_of_2 = argument0;
var pc_enum_index = argument1;
var mapping = argument2;
global.kb_params[pc_enum_index][index_of_2] = mapping;

#define mouse_remap
var pc_enum_index = argument0;
var mapping = argument1;
global.mouse_params[pc_enum_index] = mapping;

// not meant to change directional mappings
#define controller_remap
var pc_enum_index = argument0;
var mapping = argument1;
global.controller_params[pc_enum_index][0] = mapping;