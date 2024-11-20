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
	CHOOSE,
	IDLE,
	MOVE,
	HIT,
	KNOCKED,
	WAITING,
	ATTACK,
	RECOVERY,
	DEATH
}
#endregion

#region scale variables
escx = 0;
escy = 0;
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

#region movement
x_point = 0;
y_point = 0;
state_time = 0;
#endregion

#region circular movement (recovery state)
center_x = 0;
center_y = 0;
angle = 0;

radius = 0;
r_speed = 0;

recovery = 0;
esc_x = 0;
esc_y = 0;
recover_time = 0;
move_direction = 0;
#endregion