add_item("Video");
add_item("Audio");
add_item("Controls");
add_item("Gameplay");
add_item("Back");

set_layout(0);
set_halign(1);
set_valign(0);
set_text_color(135, 175, 190, false);
set_padding(15);
set_selection_token_color(100, 130, 190);
set_item_positions();

parent_menu = global.options_menu;
global.options_menu.attach_submenu(self, 2, true);
attach_callback(to_parent_menu, 4);