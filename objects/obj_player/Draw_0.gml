#region sprite draw
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
#endregion

#region hability draw debug
if(keyboard_check(ord("R")) && global.slashing){

    draw_circle(x, y, area, true);

    if(enemy_list != undefined && ds_list_size(enemy_list) > 0){
        var _enemy_data_1 = enemy_list[| 0];
        var _enemy_1 = _enemy_data_1[0];

        if(instance_exists(_enemy_1)){
            for(var _i = 1; _i < ds_list_size(enemy_list); _i++){
                var _enemy_data_prev = enemy_list[| _i - 1];
                var _enemy_data_curr = enemy_list[| _i];
                var _enemy_prev = _enemy_data_prev[0];
                var _enemy_curr = _enemy_data_curr[0];

                if(instance_exists(_enemy_prev) && instance_exists(_enemy_curr)){
                    if((_enemy_prev.object_index == obj_enemy || _enemy_prev.object_index == obj_enemy_2) &&
                        (_enemy_curr.object_index == obj_enemy || _enemy_curr.object_index == obj_enemy_2)){
                        
                        var _dir = point_direction(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
                        var _dist = point_distance(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
                        draw_sprite_ext(spr_line, 0, _enemy_prev.x, _enemy_prev.y, _dist / sprite_width, 1, _dir, c_white, 1);
                    }
                }
            }

            var _last_enemy_data = enemy_list[| ds_list_size(enemy_list) - 1];
            var _last_enemy = _last_enemy_data[0];
            if(instance_exists(_last_enemy)){
                draw_sprite(spr_sign, 0, _last_enemy.x, _last_enemy.y);
            }
        }
    }
}
#endregion

#region trail with dynamic extension
if(move_speed > 0){
    var _prev_x, _prev_y;
    var _alpha_step = .1 / trail_length;
    var _current_alpha = 1.0;

    if(ds_queue_size(trail_positions) < trail_length){
        ds_queue_enqueue(trail_positions, [x, y]);
	}else{
        ds_queue_dequeue(trail_positions);
        ds_queue_enqueue(trail_positions, [x, y]);
    }

    if(ds_queue_size(trail_positions) > 1){
        var _first_position = ds_queue_head(trail_positions);
        _prev_x = _first_position[0];
        _prev_y = _first_position[1];

        var _temp_queue = ds_queue_create();
        ds_queue_copy(_temp_queue, trail_positions);

        ds_queue_dequeue(_temp_queue);

        while(!ds_queue_empty(_temp_queue)){
            var _current_position = ds_queue_dequeue(_temp_queue);
            var _current_x = _current_position[0];
            var _current_y = _current_position[1];

            var _dx = _current_x - _prev_x;
            var _dy = _current_y - _prev_y;
            var _distance = point_distance(_prev_x, _prev_y, _current_x, _current_y);
            var _angle = point_direction(_prev_x, _prev_y, _current_x, _current_y);

            draw_set_alpha(_current_alpha);
							
            draw_sprite_ext(spr_trail, 0, (_prev_x + _current_x) / 2, (_prev_y + _current_y) / 2,
                            _distance / 32, 1, _angle, c_white, _current_alpha);

            _prev_x = _current_x;
            _prev_y = _current_y;

            _current_alpha -= _alpha_step;
        }
        ds_queue_destroy(_temp_queue);
        draw_set_alpha(1.0);
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
    draw_sprite_ext(spr_trail_2, 0, _position[0], _position[1], 1, 1, _angle, c_white, _alpha);
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