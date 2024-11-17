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

#region mp grid and enemy state enum create
#macro TS 16

var _w = ceil(room_width / TS);
var _h = ceil(room_height / TS);

global.mp_grid = mp_grid_create(0, 0, _w, _h, TS, TS);

mp_grid_add_instances(global.mp_grid, obj_wall, false);

enum ENEMY_STATES{
	IDLE,
	MOVE,
	HIT,
	KNOCKED,
	ATTACK,
	DEATH
}
#endregion

#region scale variables
escx = 0;
escy = 0;
#endregion

#region colide
function enemy_colide(){
	if(place_meeting(x + vel_h, y, obj_wall)){
		while(!place_meeting(x + sign(vel_h), y, obj_wall)){
			x  = x + sign(vel_h);
		}
		vel_h = 0;	
	}
	if(place_meeting(x, y + vel_v, obj_wall)){
		while(!place_meeting(x, y + sign(vel_v), obj_wall)){
			y  = y + sign(vel_v);
		}
		vel_v = 0;	
	}	
}
#endregion

#region enemy 2
count = 0;
atk_time = 0;
atk_cooldown = 0;
#endregion