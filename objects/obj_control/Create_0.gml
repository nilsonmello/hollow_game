randomize();

window_set_cursor(cr_none);

global.part_sist = part_system_create();
part_system_depth(global.part_sist, -100);

global.enemy_list = ds_list_create();
global.index = -1;