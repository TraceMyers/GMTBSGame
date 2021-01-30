/// @description set monologue

dialogue = instance_create_layer(0, 0, "Instances", Dialogue);
test_menu = instance_create_layer(0, 0, "UI", Menu);
test_menu.add_item("yes");
test_menu.add_item("no");
test_menu.set_background_type(noone);
dialogue.add_line("Hello", noone);
dialogue.add_line("Do you like fish? I sure do this is testing half width and so on blah blah", test_menu);
