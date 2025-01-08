#region sprite draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
#endregion

#region hability draw debug
if(keyboard_check(ord("R")) && global.hability == 2){

    draw_circle(x, y, global.hab_range, true);


	var _colors = [
	    make_color_rgb(139, 0, 255),   // Roxo escuro
	    make_color_rgb(157, 0, 255),   // Roxo médio
	    make_color_rgb(175, 0, 255),   // Roxo com mais vermelho
	    make_color_rgb(193, 0, 255),   // Lilás intenso
	    make_color_rgb(211, 0, 255),   // Lilás
	    make_color_rgb(229, 0, 255),   // Rosa claro
	    make_color_rgb(247, 0, 255),   // Rosa mais vibrante
	    make_color_rgb(255, 0, 247),   // Rosa com leve azul
	    make_color_rgb(255, 0, 231),   // Rosa intenso
	    make_color_rgb(255, 0, 255)    // Rosa puro
	];

    if(enemy_list != undefined && ds_list_size(enemy_list) > 0){
        var _max_enemies = min(global.marked, ds_list_size(enemy_list));
        
        for(var _i = 0; _i < _max_enemies - 1; _i++){
            var _enemy_data_prev = enemy_list[| _i];
            var _enemy_data_curr = enemy_list[| _i + 1];
            var _enemy_prev = _enemy_data_prev[0];
            var _enemy_curr = _enemy_data_curr[0];
			
            var _first_enemy_data = enemy_list[| 0];
            var _first_enemy = _first_enemy_data[0];
            
            if(instance_exists(_first_enemy)){
                draw_sprite(spr_sign, 0, _first_enemy.x, _first_enemy.y);
            }
            
            var _dir = point_direction(x, y, _first_enemy.x, _first_enemy.y);
            var _dist = point_distance(x, y, _first_enemy.x, _first_enemy.y);
            
            var _color_index = 0;
            draw_sprite_ext(spr_line, 0, x, y, _dist / sprite_width, 1, _dir, _colors[_color_index], 1);

            if(instance_exists(_enemy_prev) && instance_exists(_enemy_curr)){
                if((_enemy_prev.object_index == obj_enemy || _enemy_prev.object_index == obj_enemy_2) &&
                   (_enemy_curr.object_index == obj_enemy || _enemy_curr.object_index == obj_enemy_2)){

                    _dir = point_direction(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
                    _dist = point_distance(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
                   
                    image_xscale = 1;

                    _color_index = (_i + 1) mod array_length(_colors);
                    draw_sprite_ext(spr_line, 0, _enemy_prev.x, _enemy_prev.y, _dist / sprite_width, 1, _dir, _colors[_color_index], 1);
                }
            }
        }

        var _last_enemy_data = enemy_list[| _max_enemies - 1];
        var _last_enemy = _last_enemy_data[0];
        
        if(instance_exists(_last_enemy)){
            draw_sprite(spr_sign, 1, _last_enemy.x, _last_enemy.y);
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