#region variáveis de movimento

//timer fos tates
state_timer = 0;
//first index for sprite
sprite_index = spr_player_idle;

//direction for walk and sprite
move_dir = 0;

//horizontal and vertical speed
spd_h = 0;
spd_v = 0;

//actual speed
spd = 1.2;

//dash direction
dash_dir = 0;

//dash speed
dash_veloc = 12;

//dash time
dash_timer = 0;

//cooldown for dash
dash_cooldown = 0;

dash_pressed = 0;
line_pressed = 0;
#endregion

#region hability variables
//hability range
area = 20;

//enemy and path lists
enemy_list = ds_list_create();
path_list = ds_list_create();

//actual position and if its moving
moving_along_path = false;
path_position_index = 0;

//actual hability speed
move_speed = 0;

//trail length, positions and 
trail_length = 10;
trail_positions = ds_queue_create();
trail_thickness = 2;

//if can create the dust particles
candust = true;

//the second trial possibility
trail_fixed_positions = ds_list_create();
trail_fixed_timer = ds_list_create();

//speed movement
advance_speed = .2
#endregion

#region combo variables
parry_time = 20;
parry_cooldown = 70;
#endregion

#region state machine

//variáveis de estado
enum STATES{
    IDLE,
    MOVING,
    DASH,
	PARRY,
    HEAL,
    ATTAKING,
    HIT,
    DEATH,
}

//estado atual
state = STATES.MOVING;
#endregion

#region player regen

//can use healing
can_heal = true;

//timer for heal
timer_heal = 0;

//cooldown for healing
heal_cooldown = 80;
#endregion

#region hit variables
hit_color = c_white;
hit_alpha = 0;

//enemies can attack
can_take_dmg = true;

//veloc for hit
emp_veloc = 4;

//direction
emp_dir = 0;

//timer for can hit again
hit_timer = 0;

//cooldown for hits
hit_cooldown = 0;
#endregion

#region particles
dust_time = 0;

#region healing particles
ps = part_system_create();
part_system_draw_order(ps, true);
part_system_depth(ps, 100);

//globe sphere
ptype1 = part_type_create();
part_type_shape(ptype1, pt_shape_sphere);

part_type_size(ptype1, .2, .5, 0.01, 0);
part_type_scale(ptype1, 1, 1);
part_type_speed(ptype1, 0, 0, 0, 0);
part_type_direction(ptype1, 0, 0, 0, 0);
part_type_gravity(ptype1, 0, 0);
part_type_orientation(ptype1, 0, 0, 0, 0, false);
part_type_colour3(ptype1, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype1, 0, .5, 0);
part_type_blend(ptype1, false);
part_type_life(ptype1, 60, 60);

// pixel
ptype2 = part_type_create();
part_type_shape(ptype2, pt_shape_pixel);

part_type_size(ptype2, 1, 1, 0.01, 0);
part_type_scale(ptype2, 1, 1);
part_type_speed(ptype2, 1, 1, 0, 0);
part_type_direction(ptype2, 90, 90, 0, 0);
part_type_gravity(ptype2, 0, 0);
part_type_orientation(ptype2, 0, 0, 0, 0, false);
part_type_colour3(ptype2, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype2, 0, .5, 0);
part_type_blend(ptype2, false);
part_type_life(ptype2, 30, 30);

//lines
ptype3 = part_type_create();
part_type_sprite(ptype3, spr_line_effect, 0, 0, 0);

part_type_size(ptype3, .2, .5, 0.01, 0);
part_type_scale(ptype3, 1, 1);
part_type_speed(ptype3, .5, .5, 0, 0);
part_type_direction(ptype3, 90, 90, 0, 0);
part_type_gravity(ptype3, 0, 0);
part_type_orientation(ptype3, 0, 0, 0, 0, false);
part_type_colour3(ptype3, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype3, .5, 1, 0);
part_type_blend(ptype3, false);
part_type_life(ptype3, 30, 30);

emitter = part_emitter_create(ps);
emitter2 = part_emitter_create(ps);
#endregion

#region walk particle
particle_system_dust = part_system_create_layer("Instance_particle", true);
particle_dust = part_type_create();

part_type_sprite(particle_dust, spr_dust, 0, 0, 0);
part_type_subimage(particle_dust, 0);
part_type_size(particle_dust, .2, .8, .001, 0)

part_type_direction(particle_dust, 0, 180, 0, 1);
part_type_speed(particle_dust, .1, .2, -0.004, 0);

part_type_life(particle_dust, 50, 70);
part_type_orientation(particle_dust, 0, 180, .1, 1, 0);
part_type_alpha3(particle_dust, 0.6, 0.4, 0.1);
#endregion

#region player shadow
particle_system = part_system_create_layer("Instance_particle", true);

particle_shadow = part_type_create();

part_type_sprite(particle_shadow, spr_player_idle, 0, 0, 1);
part_type_subimage(particle_shadow, 0)
part_type_size(particle_shadow, 1, 1, 0, 0);
part_type_life(particle_shadow, 25, 45);
part_type_alpha1(particle_shadow, 0.5);

var _red = make_color_rgb(53, 43, 66);
var _red_2 = make_color_rgb(67, 67, 106);
var _red_3 = make_color_rgb(75, 128, 202);

part_type_color3(particle_shadow, _red, _red_2, _red_3);
#endregion

#endregion

#region constructor attacks
function slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    distance = _dist;
    dir_atk = _direction;
    dmg = _damage;
    create_hitbox = _hitbox;
    owner = _owner;
    cost = _cost;

    collision = function(){
        show_debug_message("bateu");
    };
}

function basic_attack(_dist, _direction, _damage, _hitbox, _owner, _cost) : slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    distance = _dist;
    dir_atk = _direction;
    dmg = _damage;
    create_hitbox = _hitbox;
    owner = _owner;
    cost = _cost;
    active = false;

    activate = function (){
        active = true;

        if(!variable_global_exists("attacked_enemies")){
            global.attacked_enemies = ds_list_create();
        }

        var _dir = point_direction(owner.x, owner.y, mouse_x, mouse_y);

        var _attack_x = owner.x + lengthdir_x(distance, _dir);
        var _attack_y = owner.y + lengthdir_y(distance, _dir);

        var _list = ds_list_create();
        collision_circle_list(_attack_x, _attack_y, distance, obj_enemy_par, false, false, _list, true);

        for(var _i = 0; _i < ds_list_size(_list); _i++){
            var _rec = _list[| _i];
            if(!ds_list_find_index(global.attacked_enemies, _rec)){
                with (_rec){
                    if(!attacking){
                        var _is_critical = irandom(100) < global.critical;
                        var _damage_to_apply = _is_critical ? other.dmg * 2 : other.dmg;
    					var _stamina = _is_critical ? 60 : 30;
    
                        escx = 1.5;
                        escy = 1.5;
                        hit_alpha = 1;
                        timer_hit = 5;
                        emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                        global.combo++;
                        obj_camera.alarm[1] = 5;
    
                        switch(knocked){
                            case 0:
                                part_particles_create(particle_hit, x, y, particle_slash, 1);
                                state = ENEMY_STATES.HIT;
                                emp_timer = 5;
                                emp_veloc = 6;
                                stamina_at -= _stamina;
                                alarm[2] = 30;
                                break;
    
                            case 1:
                                state = ENEMY_STATES.KNOCKED;
                                vida -= _damage_to_apply;
                                hit = false;
                                alarm[1] = 10;
                                alarm[2] = 30;
                                break;
                        }
                    }
                }
                ds_list_add(global.attacked_enemies, _rec);
            }
        }

        ds_list_destroy(_list);

        if(variable_global_exists("attacked_enemies")){
            ds_list_clear(global.attacked_enemies);
        }
        global.energy -= cost;
        active = false;
    };
		
	bullet = function(){
        var _dir = point_direction(owner.x, owner.y, mouse_x, mouse_y);

        var _attack_x = owner.x + lengthdir_x(distance, _dir);
        var _attack_y = owner.y + lengthdir_y(distance, _dir);

        var _colide = collision_circle(_attack_x, _attack_y, distance, obj_bullet, false, false);
		
		with(_colide){
			direction = direction + 180;
			speed = 3.5;
            obj_camera.alarm[1] = 5;
		}
	}
}

function line(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    cost = _cost;
    moving = false;
    lerp_spd = 0.2;
    damage = _damage;

    adv_x = 0;
    adv_y = 0;
    dir_atk = _direction;
    dist = _dist;

    if(!is_undefined(_owner)){
        owner = _owner;
    }
    
    set_target = function(){
        adv_x = owner.x + lengthdir_x(dist, dir_atk);
        adv_y = owner.y + lengthdir_y(dist, dir_atk);
    };

    move = function(){
        if(moving){
            var _new_x = lerp(owner.x, adv_x, lerp_spd);
            var _new_y = lerp(owner.y, adv_y, lerp_spd);

            owner.x = _new_x;
            owner.y = _new_y;
        }
    };
}

function circle(_dist, _direction, _damage, _hitbox, _owner, _cost) : slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    active = false;
    cost = _cost
    
    activate = function(){
        active = true;

        if(!variable_global_exists("attacked_enemies")){
            global.attacked_enemies = ds_list_create();
        }

        var _list = ds_list_create();
        collision_circle_list(owner.x, owner.y, distance, obj_enemy_par, false, false, _list, true);

        for (var _i = 0; _i < ds_list_size(_list); _i++){
            var _rec = _list[| _i];

            if(!ds_list_find_index(global.attacked_enemies, _rec)){
                with(_rec){
                    if (!attack){
                        escx = 1.5;
                        escy = 1.5;
                        hit_alpha = 1;			
                        timer_hit = 5;	
                        emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                        global.combo++;
                        obj_camera.alarm[1] = 5;

                        switch(knocked){
                            case 0:
                                part_particles_create(particle_hit, x, y, particle_slash, 1);
                                state = ENEMY_STATES.HIT;
                                emp_timer = 5;
                                emp_veloc = 6;
                                break;

                            case 1:
                                state = ENEMY_STATES.KNOCKED;
                                emp_veloc = 8;
                                break;
                        }
                        attack = true;
                        
        
                    }
                }
                ds_list_add(global.attacked_enemies, _rec);
            }
        }

        ds_list_destroy(_list);

        if(variable_global_exists("attacked_enemies")){
            ds_list_clear(global.attacked_enemies);
        }
        active = false;
    };
}


golpe_circular = new circle(100, 0, 10, true, self, 0);
linha = undefined;

#endregion

#region charged attack variables
timer_charge = 0;
charged_attack = false;
#endregion

sprite_index = spr_player_idle