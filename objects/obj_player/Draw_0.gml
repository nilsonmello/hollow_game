#region sprite draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
#endregion

#region switch dash indication
switch(dash_num){
    case 0:
        break;
    case 1:
        draw_sprite(spr_warning, 5, x, y - 20);
        break;
    case 2:
        draw_sprite(spr_warning, 6, x, y - 20);
        break;
    case 3:
        draw_sprite(spr_warning, 7, x, y - 20);
        break;
    case 4:
        draw_sprite(spr_warning, 8, x, y - 20);
        break;
}
#endregion

#region hability draw debug
//if(keyboard_check(ord("R")) && global.stamina >= global.stamina_max){
//    draw_circle(x, y, area, true);

//    if(enemy_list != undefined && ds_list_size(enemy_list) > 0){
//        var _enemy_data_1 = enemy_list[| 0];
//        var _enemy_1 = _enemy_data_1[0];

//        if (instance_exists(_enemy_1)){
//            draw_line(x, y, _enemy_1.x, _enemy_1.y);

//            for(var _i = 1; _i < ds_list_size(enemy_list); _i++){
//                var _enemy_data_prev = enemy_list[| _i - 1];
//                var _enemy_data_curr = enemy_list[| _i];
//                var _enemy_prev = _enemy_data_prev[0];
//                var _enemy_curr = _enemy_data_curr[0];

//                if (instance_exists(_enemy_prev) && instance_exists(_enemy_curr)) {
//                    draw_line(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
//                }
//            }
//        }
//    }
//}
#endregion

#region trail with dynamic extension
if(move_speed > 0){
    var _prev_x, _prev_y;
    var _alpha_step = 1 / trail_length;
    var _current_alpha = 1.0;
    
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