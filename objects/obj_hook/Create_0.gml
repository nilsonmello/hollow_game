//hook speed
spd = 10; 

//max distance
max_dist = 200;

//initial x and y 
origin_x = x; 
origin_y = y;

//aim enemy
target_enemy = noone;

//hook state
state = "orbiting";

//direction to launch
dir = 0;

//finded a wall
target_wall = false;

//wall position
wall_x = x;
wall_y = y;

//enemy size
target_size = 0;

//orbit variables
orbit_distance = 10
orbit_angle = 0;

//initial x and y to launch
launch_origin_x = obj_player.x;
launch_origin_y = obj_player.y;

//speed to orbitate
orbit_speed = 1

//if it finds a wall
wall_exists = true;

wall_type = 0;
is_drifting = false;

drift_time_started = false;
drift_time = 0;
drift_start_time = 0;