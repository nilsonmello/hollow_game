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

#region mouse
orb_rad = 100;
orb_angle = 0;

image_speed = 0;
alarm[0] = 0;


window_set_cursor(cr_none);
#endregion