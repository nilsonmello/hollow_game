#region alarms
alarm[0] = 0;
alarm[1] = 0;
alarm[2] = 0;
#endregion

#region attack and state
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
	WAITING,
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

#region atack variables

//enemy has attacked?
has_attacked = false;

//enemy is going to attack
warning = false;

//number of ettacks
count = 0;

//attack duration
atk_time = 0;

//cooldown between attacks
atk_cooldown = 0;

//direction of the attack
atk_direction = 0;

//timer for the waiting state 
atk_wait = 0;

//timer for the stated knocked out
knocked_time = 0;

//cooldown for attacks
time_per_attacks = 0;
#endregion