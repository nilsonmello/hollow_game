#region mouse config
x = mouse_x;
y = mouse_y;
#endregion

with (obj_enemy_par) 
    alligned = false;
}

var _line = collision_line(obj_player.x, obj_player.y, x, y, obj_enemy_par, false, false);

if (_line) {
    sprite_index = spr_dot;

    var _enemy_x = _line.x;
    var _enemy_y = _line.y;

    var _distance = point_distance(obj_player.x, obj_player.y, _enemy_x, _enemy_y);
    var _max_distance = 200;
    var _min_strength = 0.2;
    var _max_strength = 1.5;

    var _tracking_strength = _max_strength

    // Ajustar posição do mouse
    x = lerp(x, _enemy_x, _tracking_strength);
    y = lerp(y, _enemy_y, _tracking_strength);

    with (_line) {
        alligned = true;
    }
} else {
    sprite_index = spr_mouse;
}