//#region player_colide
//function player_colide(){
//    if(spd_h != 0){
//        if (place_meeting(x + spd_h, y, obj_wall) ||
//            place_meeting(x + spd_h, y, obj_enemy_par)){

//            while(!place_meeting(x + sign(spd_h), y, obj_wall) &&
//                   !place_meeting(x + sign(spd_h), y, obj_enemy_par)){
//                x += sign(spd_h);
//            }
//            spd_h = 0;
//			advance_speed = 0;
//			advancing = false;
//        }
//    }
	
//    if(spd_v != 0){
//        if(place_meeting(x, y + spd_v, obj_wall) ||
//            place_meeting(x, y + spd_v, obj_enemy_par)){
				
//            while(!place_meeting(x, y + sign(spd_v), obj_wall) &&
//                   !place_meeting(x, y + sign(spd_v), obj_enemy_par)){
//                y += sign(spd_v);
//            }
//            spd_v = 0;
//			advance_speed = 0;
//			advancing = false;
//        }
//    }
//}
//#endregion

#region enemy_colide
function enemy_colide(){

    if(vel_h != 0){
        if(place_meeting(x + vel_h, y, obj_wall) ||
            place_meeting(x + vel_h, y, obj_enemy_par) ||
            place_meeting(x + vel_h, y, obj_player)){
				
            while(!place_meeting(x + sign(vel_h), y, obj_wall) &&
                   !place_meeting(x + sign(vel_h), y, obj_enemy_par) &&
                   !place_meeting(x + sign(vel_h), y, obj_player)){
                x += sign(vel_h);
            }
            vel_h = 0;
        }
    }

    if(vel_v != 0){
        if(place_meeting(x, y + vel_v, obj_wall) ||
            place_meeting(x, y + vel_v, obj_enemy_par) ||
            place_meeting(x, y + vel_v, obj_player)){
				
            while(!place_meeting(x, y + sign(vel_v), obj_wall) &&
                   !place_meeting(x, y + sign(vel_v), obj_enemy_par) &&
                   !place_meeting(x, y + sign(vel_v), obj_player)){
                y += sign(vel_v);
            }
            vel_v = 0;
        }
    }
}
#endregion