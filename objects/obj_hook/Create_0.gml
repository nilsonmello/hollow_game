spd = 10; 
max_dist = 200; 
origin_x = x; 
origin_y = y;
target_enemy = noone;
state = "orbiting";
dir = 0;
target_wall = false;
wall_x = x;
wall_y = y;
target_size = 0;

orbit_distance = 10
orbit_angle = 0;

launch_origin_x = obj_player.x;
launch_origin_y = obj_player.y;

orbit_speed = 1
wall_exists = true;

selected_enemy_index = -1;
enemy_list = ds_list_create();
