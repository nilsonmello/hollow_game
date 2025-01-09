#region sprite draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
#endregion

#region hability draw debug
if (keyboard_check(ord("R")) && global.hability == 2) {
    draw_sprite(spr_area, 0, x, y);

    if (enemy_list != undefined && ds_list_size(enemy_list) > 0) {
        var _max_enemies = min(global.marked, ds_list_size(enemy_list));

        var _first_enemy_data = enemy_list[| 0];
        var _first_enemy = _first_enemy_data[0];
        if (instance_exists(_first_enemy)) {
            draw_sprite(spr_quad, frame, _first_enemy.x, _first_enemy.y);

            var _dir = point_direction(x, y, _first_enemy.x, _first_enemy.y);
            var _dist = point_distance(x, y, _first_enemy.x, _first_enemy.y);

            draw_sprite_ext(spr_line, 0, x, y, _dist / sprite_width, 1, _dir, c_white, 1);
        }

        for (var _i = 0; _i < _max_enemies; _i++) {
            var _enemy_data = enemy_list[| _i];
            var _enemy = _enemy_data[0];

            if (instance_exists(_enemy)) {
                draw_sprite(spr_quad, frame, _enemy.x, _enemy.y);
            }

            if (_i < _max_enemies - 1) {
                var _enemy_data_next = enemy_list[| _i + 1];
                var _enemy_next = _enemy_data_next[0];

                if (instance_exists(_enemy) && instance_exists(_enemy_next)) {
                    if ((_enemy.object_index == obj_enemy || _enemy.object_index == obj_enemy_2) &&
                        (_enemy_next.object_index == obj_enemy || _enemy_next.object_index == obj_enemy_2)) {

                        var _dir = point_direction(_enemy.x, _enemy.y, _enemy_next.x, _enemy_next.y);
                        var _dist = point_distance(_enemy.x, _enemy.y, _enemy_next.x, _enemy_next.y);

                        draw_sprite_ext(spr_line, 0, _enemy.x, _enemy.y, _dist / sprite_width, 1, _dir, c_white, 1);
                    }
                }
            }
        }
    }
}
#endregion

#region static trail
for(var _i = 0; _i < ds_list_size(trail_fixed_positions); _i++){
    var _position = trail_fixed_positions[| _i];
   
    trail_fixed_timer[| _i] -= 1;
    if (trail_fixed_timer[| _i] <= 0) {
        ds_list_delete(trail_fixed_positions, _i);
        ds_list_delete(trail_fixed_timer, _i);
        continue;
    }

    var _angle = 0;
    if(_i > 0){
        var _prev_position = trail_fixed_positions[| _i - 1];
        _angle = point_direction(_prev_position[0], _prev_position[1], _position[0], _position[1]);
    }else{
        _angle = _position[2];
    }

    var _alpha = trail_fixed_timer[| _i] / 30;
    draw_set_alpha(_alpha);
    draw_sprite_ext(spr_trail_2, image_index, _position[0], _position[1], 1, 1, _angle, c_white, _alpha);
}
draw_set_alpha(1);
#endregion

#region hit effect
if(hit_alpha > 0){
	gpu_set_fog(true, hit_color,0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, hit_alpha);
	gpu_set_fog(false, hit_color,0, 0);
}
#endregion

if(line){
    draw_sprite(spr_area, 0, x, y);
    draw_sprite(spr_quad_2, 0, target_x, target_y);    
}