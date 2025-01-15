#region alarms
//cooldown per player attacks
alarm[1] = 0;

//time between attacks to mantain the players combo 
alarm[2] = 0;
#endregion

#region enemies state machine base
state = ENEMY_STATES.IDLE;

enum ENEMY_STATES{
	CHOOSE,
	IDLE,
	MOVE,
	FOLLOW,
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

//has been attacked
slashed = false;

//control the number of the hitbox created
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

//variable to identify if the enemy can be attacked with the players line attack
attack = false;

//total timer of the hit
timer_hit = 0;

//crescent value that tefines the timer_hit
timer_hit_at = 0;

//the period of time that he will be pushed
emp_timer = 0;
#endregion

#region movement
//x and y point are used to the normal walk of the enemies
x_point = 0;
y_point = 0;

//the time that the enemie will stay in the same state
state_time = 0;
#endregion

#region circular movement (recovery state)
//the central point of the circle
center_x = 0;
center_y = 0;

//the angle increase for the movement
angle = 0;

//the radius of the circle
radius = 0;

//speed of the movement
r_speed = 0;

//control the phases of the recovery state
recovery = 0;

//the variables that create the movement with the x and y position
esc_x = 0;
esc_y = 0;

//the time in this state
recover_time = 0;

//the direction of the movement
move_direction = 0;
#endregion

#region particles

#region death particle
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
part_type_color1(particle_explosion, c_black);

part_type_direction(particle_explosion, 0, 359, 0, 1);
part_type_speed(particle_explosion, .5, 1, -.01, 0);

part_type_life(particle_explosion, 30, 50);
part_type_orientation(particle_explosion, 0, 359, .1, 1, 0);
part_type_alpha3(particle_explosion, 0.8, 1, 0.1);

//second
part_type_sprite(particle_explosion_2, spr_explosion, 0, 0, 0);
part_type_size(particle_explosion_2, .1, .2, .001, 0);

var _color2 = make_color_rgb(58, 56, 88);
part_type_color1(particle_explosion_2, c_black);

part_type_direction(particle_explosion_2, 0, 359, 0, 1);
part_type_speed(particle_explosion_2, 1.2, 1.5, -0.004, 0);

part_type_life(particle_explosion_2, 20, 30);
part_type_orientation(particle_explosion_2, 0, 359, .1, 1, 0);
part_type_alpha2(particle_explosion_2, 1, 0.1);

//third
part_type_sprite(particle_circle, spr_circle_outline, 1, 1, 1);
part_type_size(particle_circle, 1, 1, .01, 0);

var _color3 = make_color_rgb(100, 99, 101);
part_type_color1(particle_circle, c_black);

part_type_life(particle_circle, 20, 20);
part_type_alpha3(particle_circle, .2, .8, .1);
#endregion
#endregion

#region stamina and energy

//total and actual stamina
stamina_t = 100;
stamina_at = stamina_t;

//knocked variable
knocked = false;

//total and actual aenergy
max_energy = 1;
energy_count = 0;
#endregion

//cooldown for the attack states
state_cooldown = 0;

//check for player timer
check_timer = 0;

function check_for_player(_distance){
    if(check_timer > 0){
        check_timer--;
        return;
    }
    
    check_timer = 20;

    var _line_wall = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false);
    var _linha = collision_line(x, y, obj_player.x, obj_player.y, obj_enemy_par, false, self);
    
    if(_line_wall or _linha){
        return false;
    }
    
    if(time_per_attacks <= 0){
        if (distance_to_object(obj_player) <= _distance){
            state = ENEMY_STATES.FOLLOW;
        }else{
            state = ENEMY_STATES.CHOOSE;
        }
    }
}

//variable for the draw arround the enemies using the mouse
alligned = false;

//actual frame
frame = 0;

//the actual size of the enemy
size = 2;