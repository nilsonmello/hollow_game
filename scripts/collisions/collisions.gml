function enemy_colide(){
    var step_size = 1;
    if(vel_h != 0 or emp_veloc > 0){
        if(place_meeting(x + vel_h, y, obj_wall) ||
            place_meeting(x + vel_h, y, obj_player) ||
            place_meeting(x + vel_h, y, obj_enemy_par) ||
            place_meeting(x + vel_h, y, obj_ambient)){
            
            while(!place_meeting(x + sign(vel_h) * step_size, y, obj_wall) &&
                !place_meeting(x + sign(vel_h) * step_size, y, obj_player) &&
                !place_meeting(x + sign(vel_h) * step_size, y, obj_enemy_par) &&
                !place_meeting(x + sign(vel_h) * step_size, y, obj_ambient)){
                x += sign(vel_h) * step_size;
            }
            
            vel_h = 0;
            emp_timer = 0;
            emp_veloc = 0;
        }
    }

    if(vel_v != 0 or emp_veloc > 0){
        if(place_meeting(x, y + vel_v, obj_wall) ||
            place_meeting(x, y + vel_v, obj_player) ||
            place_meeting(x, y + vel_v, obj_enemy_par) ||
            place_meeting(x, y + vel_v, obj_ambient)){
            
            while(!place_meeting(x, y + sign(vel_v) * step_size, obj_wall) &&
                !place_meeting(x, y + sign(vel_v) * step_size, obj_player) &&
                !place_meeting(x, y + sign(vel_v) * step_size, obj_enemy_par) &&
                !place_meeting(x, y + sign(vel_v) * step_size, obj_ambient)){
                y += sign(vel_v) * step_size;
            }
            
            vel_v = 0;
            emp_timer = 0;
            emp_veloc = 0;
        }
    }
}