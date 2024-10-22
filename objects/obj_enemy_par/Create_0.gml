#region alarms
alarm[0] = 0;
alarm[1] = 0;
alarm[2] = 0;
alarm[3] = 0;
alarm[4] = 0;
alarm[5] = 0;
alarm[6] = 0;
alarm[7] = 0;
#endregion

#region attack and state
has_attacked = false;

path = path_add();

calc_path_timer = irandom(60);

state = ENEMY_STATES.MOVE;
#endregion

#region colisions
function scr_colide(){
	switch(global.is_dashing){
		case 0:
			var _collidable_objects = [obj_wall, obj_player];
    
			    for(var _i = 0; _i < array_length(_collidable_objects); _i++){
			        var _obj = _collidable_objects[_i];
			        if(place_meeting(x + vel_h, y, _obj)){
			            while (!place_meeting(x + sign(vel_h), y, _obj)){
			                x += sign(vel_h);
			            }
			            vel_h = 0;
			        }
			    }

			    for(var _i = 0; _i < array_length(_collidable_objects); _i++){
			        var _obj = _collidable_objects[_i];
			        if(place_meeting(x, y + vel_v, _obj)){
			            while(!place_meeting(x, y + sign(vel_v), _obj)){
			                y += sign(vel_v);
			            }
			            vel_v = 0;
			        }
			    }
		break;
		
		case 1:
			var _collidable_object = [obj_wall];
    
			    for(var _i = 0; _i < array_length(_collidable_object); _i++){
			        var _obj = _collidable_object[_i];
			        if(place_meeting(x + vel_h, y, _obj)){
			            while (!place_meeting(x + sign(vel_h), y, _obj)){
			                x += sign(vel_h);
			            }
			            vel_h = 0;
			        }
			    }

			    for(var _i = 0; _i < array_length(_collidable_object); _i++){
			        var _obj = _collidable_object[_i];
			        if(place_meeting(x, y + vel_v, _obj)){
			            while(!place_meeting(x, y + sign(vel_v), _obj)){
			                y += sign(vel_v);
			            }
			            vel_v = 0;
			        }
			    }
		break;
	}
}
#endregion