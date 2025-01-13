if (state == "launched") {
    x += lengthdir_x(spd, dir);
    y += lengthdir_y(spd, dir);

    if (point_distance(origin_x, origin_y, x, y) >= max_dist) {
        state = "retracting";
    }

    var _enemy = instance_place(x, y, obj_enemy_par);
    if (instance_exists(_enemy)) {
        state = "retracting";
        target_enemy = _enemy;
    }

    if (place_meeting(x, y, obj_wall)) {
        state = "retracting";
    }
}

if (state == "retracting") {
    var _dir_back = point_direction(x, y, origin_x, origin_y);
    x += lengthdir_x(spd, _dir_back);
    y += lengthdir_y(spd, _dir_back);

    // Se tiver um inimigo capturado, mova-o
    if (instance_exists(target_enemy)) {
        var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, origin_x, origin_y);

        // Verifica se o inimigo está muito perto do jogador
        if (_dist_to_player > 40) { // Ajuste 40 para a distância desejada
            target_enemy.x = x;
            target_enemy.y = y;
        } else {
            // Calcula a posição "à frente" do jogador
            var _front_dir = point_direction(origin_x, origin_y, target_enemy.x, target_enemy.y);
            var _stop_dist = 40; // Distância à frente do jogador
            target_enemy.x = origin_x + lengthdir_x(_stop_dist, _front_dir);
            target_enemy.y = origin_y + lengthdir_y(_stop_dist, _front_dir);
        }
    }

    // Finaliza quando o gancho retorna ao jogador
    if (point_distance(x, y, origin_x, origin_y) < 5) {
        if (instance_exists(target_enemy)) {
            // Aplica dano ou estado no inimigo capturado
            with (target_enemy) {
                state = ENEMY_STATES.HIT;
                emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                emp_veloc = 6;
            }
        }
        instance_destroy();
    }
}
