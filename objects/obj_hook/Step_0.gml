if (state == "launched") {
    global.hooking = true;

    // Caso haja inimigo no tracking, ajustar a direção
    var _tracked_enemy = collision_line(obj_player.x, obj_player.y, mouse_x, mouse_y, obj_enemy_par, false, false);
    if (_tracked_enemy != noone) {
        dir = point_direction(obj_player.x, obj_player.y, _tracked_enemy.x, _tracked_enemy.y);
    }

    // Movimentação do gancho
    x += lengthdir_x(spd, dir);
    y += lengthdir_y(spd, dir);

    // Verificar se alcançou a distância máxima
    if (point_distance(origin_x, origin_y, x, y) >= max_dist) {
        state = "retracting";
    }

    // Verificar colisão com inimigo
    var _enemy = instance_place(x, y, obj_enemy_par);
    if (instance_exists(_enemy)) {
        state = "retracting";
        target_enemy = _enemy;
    }

    // Verificar colisão com parede
    if (place_meeting(x, y, obj_wall)) {
        state = "retracting";
    }
}

if (state == "retracting") {
    // Retornar ao jogador
    var _dir_back = point_direction(x, y, obj_player.x, obj_player.y);
    x += lengthdir_x(spd, _dir_back);
    y += lengthdir_y(spd, _dir_back);

    // Caso tenha um alvo, puxar inimigo ou ajustar posição
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

    // Verificar se o gancho voltou ao jogador
    if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
        if (instance_exists(target_enemy)) {
            with (target_enemy) {
                state = ENEMY_STATES.HIT;
                emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                emp_veloc = 6;
            }
        }
        global.hooking = false;
        instance_destroy();
    }
}
