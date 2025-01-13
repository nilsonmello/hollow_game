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

    if (instance_exists(target_enemy)) {
        var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, origin_x, origin_y);

        if (_dist_to_player > 25) {
            target_enemy.x = x;
            target_enemy.y = y;
        }
    }

    if (point_distance(x, y, origin_x, origin_y) < 5) {
        if (instance_exists(target_enemy)) {
            with (target_enemy) {
                state = ENEMY_STATES.HIT;
                hit_alpha = 1;
                emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                emp_veloc = 6;
            }
        }
        instance_destroy();
    }
}
