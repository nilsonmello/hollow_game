#region sprite draw
var _dir = floor((point_direction(x, y, mouse_x, mouse_y) + 45) mod 360 / 90);
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
if(keyboard_check(ord("R")) && global.stamina >= global.stamina_max){
    draw_circle(x, y, area, true);

    if(enemy_list != undefined && ds_list_size(enemy_list) > 0){
        var _enemy_data_1 = enemy_list[| 0];
        var _enemy_1 = _enemy_data_1[0];

        if (instance_exists(_enemy_1)){
            draw_line(x, y, _enemy_1.x, _enemy_1.y);

            for(var _i = 1; _i < ds_list_size(enemy_list); _i++){
                var _enemy_data_prev = enemy_list[| _i - 1];
                var _enemy_data_curr = enemy_list[| _i];
                var _enemy_prev = _enemy_data_prev[0];
                var _enemy_curr = _enemy_data_curr[0];

                if (instance_exists(_enemy_prev) && instance_exists(_enemy_curr)) {
                    draw_line(_enemy_prev.x, _enemy_prev.y, _enemy_curr.x, _enemy_curr.y);
                }
            }
        }
    }
}
#endregion

#region trail with dynamic extension
if(move_speed > 0){
    var prev_x, prev_y;
    var alpha_step = 1 / trail_length;
    var current_alpha = 1.0;
    
    if(ds_queue_size(trail_positions) > 1){

        var first_position = ds_queue_head(trail_positions);
        prev_x = first_position[0];
        prev_y = first_position[1];
    
        var temp_queue = ds_queue_create();
        ds_queue_copy(temp_queue, trail_positions);

        ds_queue_dequeue(temp_queue);
    
        while(!ds_queue_empty(temp_queue)){
            var current_position = ds_queue_dequeue(temp_queue);
            var current_x = current_position[0];
            var current_y = current_position[1];
        
            var dx = current_x - prev_x;
            var dy = current_y - prev_y;
            var distance = point_distance(prev_x, prev_y, current_x, current_y);
            var angle = point_direction(prev_x, prev_y, current_x, current_y);
        
            draw_set_alpha(current_alpha);
        
            draw_sprite_ext(spr_trail, 0, (prev_x + current_x) / 2, (prev_y + current_y) / 2,
                            distance / 32, 1, angle, c_white, current_alpha);
        
            prev_x = current_x;
            prev_y = current_y;
        
            current_alpha -= alpha_step;
        }
        ds_queue_destroy(temp_queue);
        draw_set_alpha(1.0);
    }    
}
#endregion