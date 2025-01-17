var front_layer_id = layer_get_id("Instances_bellow");
var back_layer_id = layer_get_id("Instances_above");

if (state == "orbiting") {
    orbit_angle += orbit_speed;
    var orbit_distance_x = orbit_distance;
    var orbit_distance_y = orbit_distance * 0.5;

    var new_x = lengthdir_x(orbit_distance_x, orbit_angle);
    var new_y = lengthdir_y(orbit_distance_y, orbit_angle);

    x = obj_player.x + new_x;
    y = obj_player.y + new_y;

    if (y > obj_player.y) {
        layer = back_layer_id;
    } else {
        layer = front_layer_id;
    }

    if (keyboard_check_pressed(ord("E"))) {
        orbit_distance = 0;
        orbit_angle = 0;
        orbit_speed = 0;
        
        x = obj_player.x;
        y = obj_player.y;

        var mouse_dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);

        state = "launched";
        launch_origin_x = obj_player.x;
        launch_origin_y = obj_player.y;
        dir = mouse_dir;
    }
}

if (state == "launched") {
    if (global.selected_enemy_index >= 0 && global.selected_enemy_index < ds_list_size(global.enemy_list)) {
        var selected_enemy = global.enemy_list[| global.selected_enemy_index];
        if (instance_exists(selected_enemy)) {
            var enemy_x = selected_enemy.x;
            var enemy_y = selected_enemy.y;

            dir = point_direction(x, y, enemy_x, enemy_y);

            x += lengthdir_x(spd, dir);
            y += lengthdir_y(spd, dir);

            if (point_distance(x, y, enemy_x, enemy_y) < 10) {
                state = "retracting";
                target_enemy = selected_enemy;
            }
        } else {
            state = "retracting";
        }
    } else {
        x += lengthdir_x(spd, dir);
        y += lengthdir_y(spd, dir);
    
        if (point_distance(launch_origin_x, launch_origin_y, x, y) >= max_dist) {
            state = "retracting";
        }
    
        var _enemy = instance_place(x, y, obj_enemy_par);
        if (instance_exists(_enemy)) {
            state = "retracting";
            target_enemy = _enemy;
        }
    
        if (place_meeting(x, y, obj_wall)) {
            state = "retracting";
            target_wall = true;
            wall_x = x;     
            wall_y = y;
            wall_exists = true;
        }
    }
}

if (state == "retracting") {
    if (target_wall && wall_exists) {
        var _dir_to_wall = point_direction(obj_player.x, obj_player.y, wall_x, wall_y);
        var _stop_dist = 30;
        var _dist_to_wall = point_distance(obj_player.x, obj_player.y, wall_x, wall_y);

        if (_dist_to_wall > _stop_dist) {
            obj_player.x += lengthdir_x(spd, _dir_to_wall);
            obj_player.y += lengthdir_y(spd, _dir_to_wall);
        } else {
            global.hooking = false;
            state = "orbiting";
            
            launch_origin_x = obj_player.x;
            launch_origin_y = obj_player.y;
            
            if (target_wall) {
                wall_exists = false;
            }
    
            orbit_distance = 10;
            orbit_angle = 0;
            orbit_speed = 1;
        }
    } else {
        var _dir_back = point_direction(x, y, obj_player.x, obj_player.y);
        x += lengthdir_x(spd, _dir_back);
        y += lengthdir_y(spd, _dir_back);

        if (instance_exists(target_enemy)) {
            switch (target_enemy.size) {
                case 1:
                    if (instance_exists(target_enemy)) {
                        var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
            
                        if (_dist_to_player > 40) {
                            target_enemy.x = x;
                            target_enemy.y = y;
                        } else {
                            var _front_dir = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                            var _stop_dist = 20;
                            target_enemy.x = obj_player.x + lengthdir_x(_stop_dist, _front_dir);
                            target_enemy.y = obj_player.y + lengthdir_y(_stop_dist, _front_dir);
                        }
                    }
            
                    if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                        if (instance_exists(target_enemy)) {
                            with (target_enemy) {
                                state = ENEMY_STATES.HIT;
                                emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                                emp_veloc = 6;
                            }
                        }
                        global.hooking = false;
                        state = "orbiting";
                        
                        launch_origin_x = obj_player.x;
                        launch_origin_y = obj_player.y;
                        
                        orbit_distance = 10;
                        orbit_angle = 0;
                        orbit_speed = 1;
                    }
                    break;
                
                case 2:
                    if (target_enemy.state != ENEMY_STATES.KNOCKED){
                        if (target_wall && wall_exists) {
                            var _dir_to_wall = point_direction(obj_player.x, obj_player.y, wall_x, wall_y);
                            var _stop_dist = 30;
                            var _dist_to_wall = point_distance(obj_player.x, obj_player.y, wall_x, wall_y);
                    
                            if (_dist_to_wall > _stop_dist) {
                                obj_player.x += lengthdir_x(spd, _dir_to_wall);
                                obj_player.y += lengthdir_y(spd, _dir_to_wall);
                            } else {
                                global.hooking = false;
                                state = "orbiting";
                                
                                launch_origin_x = obj_player.x;
                                launch_origin_y = obj_player.y;
                                
                                if (target_wall) {
                                    wall_exists = false;
                                }
                        
                                orbit_distance = 10;
                                orbit_angle = 0;
                                orbit_speed = 1;
                            }
                        } else {
                            if (instance_exists(target_enemy)) {
                                var _dir_to_enemy = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                                var _stop_dist = 40;
                                var _dist_to_enemy = point_distance(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                    
                                if (_dist_to_enemy > _stop_dist) {
                                    obj_player.x += lengthdir_x(spd, _dir_to_enemy);
                                    obj_player.y += lengthdir_y(spd, _dir_to_enemy);
                                } else {
                                    global.hooking = false;
                                    state = "orbiting";
                                    
                                    launch_origin_x = obj_player.x;
                                    launch_origin_y = obj_player.y;
                                    
                                    orbit_distance = 10;
                                    orbit_angle = 0;
                                    orbit_speed = 1;
                                }
                            } else {
                                var _dir_back = point_direction(x, y, obj_player.x, obj_player.y);
                                x += lengthdir_x(spd, _dir_back);
                                y += lengthdir_y(spd, _dir_back);
                    
                                if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                                    global.hooking = false;
                                    state = "orbiting";
                                    
                                    launch_origin_x = obj_player.x;
                                    launch_origin_y = obj_player.y;
                                    
                                    orbit_distance = 10;
                                    orbit_angle = 0;
                                    orbit_speed = 1;
                                }
                            }
                        }
                    } else {
                        if (instance_exists(target_enemy)) {
                            var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
                
                            if (_dist_to_player > 40) {
                                target_enemy.x = x;
                                target_enemy.y = y;
                            } else {
                                var _front_dir = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                                var _stop_dist = 20;
                                target_enemy.x = obj_player.x + lengthdir_x(_stop_dist, _front_dir);
                                target_enemy.y = obj_player.y + lengthdir_y(_stop_dist, _front_dir);
                            }
                        }
                
                        if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                            if (instance_exists(target_enemy)) {
                                with (target_enemy) {
                                    state = ENEMY_STATES.HIT;
                                    emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                                    emp_veloc = 6;
                                }
                            }
                            global.hooking = false;
                            state = "orbiting";
                            
                            launch_origin_x = obj_player.x;
                            launch_origin_y = obj_player.y;
                            
                            orbit_distance = 10;
                            orbit_angle = 0;
                            orbit_speed = 1;
                        }
                    }
                    break;
            }
        } else {
            if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                global.hooking = false;
                state = "orbiting";
                
                launch_origin_x = obj_player.x;
                launch_origin_y = obj_player.y;
                
                orbit_distance = 10;
                orbit_angle = 0;
                orbit_speed = 1;
            }
        }
    }
}