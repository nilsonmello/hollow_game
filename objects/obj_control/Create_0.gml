randomize();

window_set_cursor(cr_none);

global.part_sist = part_system_create();
part_system_depth(global.part_sist, -100);

selected_enemy_index = -1;
enemy_list = ds_list_create();


global.enemy_list = ds_list_create();
global.selected_enemy_index = -1;