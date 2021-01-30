add_item("Save");
add_item("Load");
add_item("Settings");
add_item("Exit");
set_layout(0);
set_halign(1);
set_valign(2);
set_text_color(135, 175, 190, false);
set_padding(15);
set_selection_token_color(100, 130, 190);
set_item_positions();
global.options_menu = self;

attach_callback(controller_deactivate, 3);