#region camera settings
cam_largura = camera_get_view_width(view_camera[0]);
cam_altura = camera_get_view_height(view_camera[0]);
cam_veloc = 0.05; 

target = obj_player;

darkness = 0.0;

raio = 1;
leveza = 0.3;
#endregion
focus_strength = 0;
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