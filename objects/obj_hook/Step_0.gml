if (state == "orbiting") {
    orbit_angle += orbit_speed;
    var new_x = lengthdir_x(orbit_distance, orbit_angle);
    var new_y = lengthdir_y(orbit_distance, orbit_angle);

    x = obj_player.x + new_x;
    y = obj_player.y + new_y;

    if (keyboard_check_pressed(ord("E"))) {
        // Zera valores de órbita antes do lançamento
        orbit_distance = 0;
        orbit_angle = 0;
        orbit_speed = 0;
        
        // Ajusta a posição do gancho para o jogador
        x = obj_player.x;
        y = obj_player.y;

        // Calcula a direção diretamente para o mouse
        var mouse_dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);

        // Defina o estado para "lançado" e registre a posição de origem
        state = "launched";
        launch_origin_x = obj_player.x;
        launch_origin_y = obj_player.y;
        dir = mouse_dir;  // Define a direção para o mouse
    }
}

if (state == "launched") {
    global.hooking = true;

    // Movimenta o gancho na direção do mouse
    x += lengthdir_x(spd, dir);
    y += lengthdir_y(spd, dir);

    // Verifica se o gancho atingiu a distância máxima
    if (point_distance(launch_origin_x, launch_origin_y, x, y) >= max_dist) {
        state = "retracting";
    }

    // Verifica se o gancho atingiu um inimigo
    var _enemy = instance_place(x, y, obj_enemy_par);
    if (instance_exists(_enemy)) {
        state = "retracting";
        target_enemy = _enemy;
    }

    // Verifica se o gancho atingiu uma parede
    if (place_meeting(x, y, obj_wall)) {
        state = "retracting";
        target_wall = true;
        wall_x = x;     
        wall_y = y;
        wall_exists = true;
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

