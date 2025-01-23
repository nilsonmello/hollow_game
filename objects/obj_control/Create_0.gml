randomize();

//hiding the mouse
window_set_cursor(cr_none);

//particle sistem
global.part_sist = part_system_create();
part_system_depth(global.part_sist, -100);

//enemy list and the index of the list
global.enemy_list = ds_list_create();
global.index = -1;

can_target = false;