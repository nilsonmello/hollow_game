function Gancho(_vel, _max_dist, _owner) constructor {
    spd = _vel;
    max_dist = _max_dist;
    owner = _owner;
    max_dist_sqr = _max_dist * _max_dist;
    origin_x = _owner.x;
    origin_y = _owner.y;
    orbit_distance = 10;
    orbit_angle = 0;
    orbit_speed = 1;
    target_enemy = noone;
    dir = 0;
    target_wall = false;
    wall_exists = false;
    orbit_distance_y = orbit_distance * 0.5;
    disparar = false;
    retorno = false;
    launch_origin_x = 0;
    launch_origin_y = 0;
    
    colide = [obj_wall, obj_wall_2, obj_enemy_par];

    orbita = function() {
        var player_x = obj_player.x;
        var player_y = obj_player.y;
        x = player_x;
        y = player_y;

        orbit_angle += orbit_speed;
        var cos_angle = dcos(orbit_angle);
        var sin_angle = dsin(orbit_angle);
        var new_x = cos_angle * orbit_distance;
        var new_y = sin_angle * orbit_distance_y;
        var _x = player_x + new_x;
        var _y = player_y + new_y;
        draw_sprite_ext(spr_grapple, 0, _x, _y, 1, 1, 0, c_white, 1);
    }

    checagem = function() {
        var player_x = obj_player.x;
        var player_y = obj_player.y;
        x = player_x;
        y = player_y;

        if (keyboard_check_pressed(ord("E")) && !global.disparado) {
            resetOrbit();
            dir = point_direction(player_x, player_y, mouse_x, mouse_y);
            launch_origin_x = player_x;
            launch_origin_y = player_y;
            disparar = true;
            global.disparado = true;
        }
    }

    dispararGancho = function() {
        if (!retorno) {
            owner.x += lengthdir_x(spd, dir);
            owner.y += lengthdir_y(spd, dir);

            var dx = owner.x - launch_origin_x;
            var dy = owner.y - launch_origin_y;

            if (dx * dx + dy * dy >= max_dist_sqr) {
                retorno = true;
            }

            var collision_instance = checkCollision();
            if (collision_instance != noone) {
                handleCollision(collision_instance);
            }
        } else {
            handleReturn();
        }
    }

    resetOrbit = function() {
        orbit_distance = 70; 
        orbit_angle = 0;
        orbit_speed = 1;
        owner.x = obj_player.x;
        owner.y = obj_player.y;
    }

    checkCollision = function() {
        var collision_instance = collision_rectangle(owner.x - 8, owner.y - 8,  owner.x + 8, owner.y + 8,  colide, true, true);
    
        if (collision_instance != noone) {
            if (collision_instance.object_index == obj_wall || collision_instance.object_index == obj_wall_2) {
                return collision_instance;
            }
            
            if (collision_instance.object_index == obj_enemy) {
                return collision_instance;
            }
        }
        return noone;
    }
    
    handleCollision = function(collision_instance) {
        if (collision_instance.object_index == obj_wall || collision_instance.object_index == obj_wall_2) {
            target_wall = true;
            global.wall_x = owner.x;
            global.wall_y = owner.y;
            wall_exists = true;
            retorno = true;
        } else if (collision_instance.object_index == obj_enemy) {
            target_enemy = collision_instance;
            retorno = true;
        }
    }

    handleReturn = function() {
        if (target_wall && wall_exists) {
            var _dir_to_wall = point_direction(obj_player.x, obj_player.y, global.wall_x, global.wall_y);
            var _stop_dist = 80;
            var _dist_to_wall = point_distance(obj_player.x, obj_player.y, global.wall_x, global.wall_y);

            if (_dist_to_wall > _stop_dist) {
                obj_player.x += lengthdir_x(spd, _dir_to_wall);
                obj_player.y += lengthdir_y(spd, _dir_to_wall);
            } else {
                with (obj_player) {
                    lsm_change("sliding");
                }
                wall_exists = false;
                target_wall = false;
            }
        } else if (target_enemy != noone) {
            pullEnemy(); 
        } else {
            var _dir_back = point_direction(owner.x, owner.y, obj_player.x, obj_player.y);
            var _dist_to_player = point_distance(owner.x, owner.y, obj_player.x, obj_player.y);

            owner.x += lengthdir_x(spd, _dir_back);
            owner.y += lengthdir_y(spd, _dir_back);

            if (_dist_to_player <= 40) {
                resetState();
            } 
        }
    }

    pullEnemy = function() {
        var _dir_to_player = point_direction(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
        var _pull_speed = 10;

        target_enemy.x += lengthdir_x(_pull_speed, _dir_to_player);
        target_enemy.y += lengthdir_y(_pull_speed, _dir_to_player);
        owner.x = target_enemy.x;
        owner.y = target_enemy.y;

        var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
        if (_dist_to_player <= 40) {
            resetState();
        }
    }

    resetState = function() {
        target_enemy = noone;
        retorno = false;
        disparar = false;
        global.disparado = false;
        resetOrbit();
    }
}

hook = new Gancho(10, 200, self);