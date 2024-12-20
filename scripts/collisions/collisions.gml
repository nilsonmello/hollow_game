#region enemy_colide
function enemy_colide(){
    if(vel_h != 0){
        if (place_meeting(x + vel_h, y, obj_wall) ||
            place_meeting(x + vel_h, y, obj_player)){

            // Evitar travar o recuo
            if(state != ENEMY_STATES.KNOCKED){
                while(!place_meeting(x + sign(vel_h), y, obj_wall) &&
                    !place_meeting(x + sign(vel_h), y, obj_player)){
                    x += sign(vel_h);
                }
                vel_h = 0;
            }
        }
    }

    if(vel_v != 0){
        if(place_meeting(x, y + vel_v, obj_wall) ||
            place_meeting(x, y + vel_v, obj_player)){

            // Evitar travar o recuo
            if(state != ENEMY_STATES.KNOCKED){
                while(!place_meeting(x, y + sign(vel_v), obj_wall) &&
                    !place_meeting(x, y + sign(vel_v), obj_player)){
                    y += sign(vel_v);
                }
                vel_v = 0;
            }
        }
    }
}
#endregion

