#region alarms
alarm[0] = 0;
alarm[1] = 0;
alarm[2] = 0;
#endregion

#region attack and state
path = path_add();

marked = false;

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
created_hitbox = false;

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

#region particles

#region explosion particle
particle_system_explosion  = part_system_create_layer("Instance_particle", true);
//first particle
particle_explosion = part_type_create();
//second particle
particle_explosion_2 = part_type_create();

//third particle
particle_circle = part_type_create();

//extended explosion
exp_part = part_type_create();

//first
part_type_sprite(particle_explosion, spr_explosion, 0, 0, 0);
part_type_subimage(particle_explosion, 0);
part_type_size(particle_explosion, .4, .8, .001, 0)

var _color1 = make_color_rgb(33, 33, 35);
part_type_color1(particle_explosion, _color1);

part_type_direction(particle_explosion, 0, 359, 0, 1);
part_type_speed(particle_explosion, .5, 1, -.01, 0);

part_type_life(particle_explosion, 30, 50);
part_type_orientation(particle_explosion, 0, 359, .1, 1, 0);
part_type_alpha3(particle_explosion, 0.8, 1, 0.1);

//second
part_type_sprite(particle_explosion_2, spr_explosion, 0, 0, 0);
part_type_size(particle_explosion_2, .1, .2, .001, 0);

var _color2 = make_color_rgb(58, 56, 88);
part_type_color1(particle_explosion_2, _color2);

part_type_direction(particle_explosion_2, 0, 359, 0, 1);
part_type_speed(particle_explosion_2, 1.2, 1.5, -0.004, 0);

part_type_life(particle_explosion_2, 20, 30);
part_type_orientation(particle_explosion_2, 0, 359, .1, 1, 0);
part_type_alpha2(particle_explosion_2, 1, 0.1);

//third
part_type_sprite(particle_circle, spr_circle_outline, 1, 1, 1);
part_type_size(particle_circle, 1, 1, .01, 0);

var _color3 = make_color_rgb(100, 99, 101);
part_type_color1(particle_circle, _color1);

part_type_life(particle_circle, 20, 20);
part_type_alpha3(particle_circle, .2, .8, .1);
#endregion

#region hit particles
particle_hit  = part_system_create_layer("Instance_particle", true);
particle_slash = part_type_create();

part_type_sprite(particle_slash, spr_explosion, 0, 0, 0);
part_type_size(particle_slash, .3, .4, .001, 0);

part_type_color1(particle_slash, _color1);

part_type_direction(particle_slash, 0, 180, 1, 1);
part_type_speed(particle_slash, .8, 1, -0.004, 0);

part_type_life(particle_slash, 20, 30);
part_type_orientation(particle_slash, 0, 359, .1, 1, 0);
part_type_alpha2(particle_slash, 1, 0.1);
#endregion

#endregion

attack = false;