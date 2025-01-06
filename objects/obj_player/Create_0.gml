#region variáveis de movimento

//timer fos tates
state_timer = 0;

//direction for walk and sprite
move_dir = 0;

//horizontal and vertical speed
spd_h = 0;
spd_v = 0;

//actual speed
spd = 1;

//dash direction
dash_dir = 0;

//dash speed
dash_veloc = 12;

//dash time
dash_timer = 0;

//cooldown for dash
dash_cooldown = 0;
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
advance_speed = .2;

//basic attack variables

//is advancing
advancing = false;

//time for the adnvancing
time_attack = 0;

//the target x and y
advance_x = 0;
advance_y = 0;

attack_cooldown = 0;
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

#endregion

#region constructor attacks

//constructor base
function slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    //parameter
    distance = _dist;
    dir_atk = _direction;
    dmg = _damage;
    create_hitbox = _hitbox;
    owner = _owner;
    cost = _cost;
    
    //base colide function
    collision = function(){
        show_debug_message("bateu");
    };
}

//basic attack
function basic_attack(_dist, _direction, _damage, _hitbox, _owner, _cost) : slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    //parameters
    distance = _dist;
    dir_atk = _direction;
    dmg = _damage;
    create_hitbox = _hitbox;
    owner = _owner;
    cost = _cost;
    active = false;

    //attack
    activate = function(){
        active = true;

        //list of enemies
        if(!variable_global_exists("attacked_enemies")){
            global.attacked_enemies = ds_list_create();
        }
        
        //direction
        var _dir = point_direction(owner.x, owner.y, mouse_x, mouse_y);

        var _attack_x = owner.x + lengthdir_x(distance, _dir);
        var _attack_y = owner.y + lengthdir_y(distance, _dir);
        
        //enemies list
        var _list = ds_list_create();
        
        //recive enemy information
        collision_circle_list(_attack_x, _attack_y, distance, obj_enemy_par, false, false, _list, true); 
        
        //bush information
        var _colide = collision_circle(_attack_x, _attack_y, distance, obj_bush, false, false);
        var _colide_2 = collision_circle(_attack_x, _attack_y, distance, obj_box, false, false);
        
        //apply the attack to bushes
        if(_colide){
            if(_colide.image_index == 0){
                var _part_num = irandom_range(7, 12);
                
                repeat(_part_num){
                    var _inst = instance_create_layer(_colide.x + irandom_range(-2, 2), _colide.y - 8, "Instances_player", obj_b_part);
                    _inst.direction = point_direction(owner.x, owner.y, _colide.x, _colide.y) + irandom_range(90, -90);
                    _inst.image_index = irandom(4);
                    obj_camera.alarm[1] = 5;
                }
            }
            
            with(_colide){
                image_index = 1;
            }
        }
            
        if(_colide_2){
            var _part_num = irandom_range(7, 12);
            
            repeat(_part_num){
                var _inst = instance_create_layer(_colide_2.x + irandom_range(-2, 2), _colide_2.y - 8, "Instances_player", obj_b_part);
                _inst.direction = point_direction(owner.x, owner.y, _colide_2.x, _colide_2.y) + irandom_range(90, -90);
                _inst.image_index = irandom_range(5, 8);
                obj_camera.alarm[1] = 5;
            }
           with(_colide_2){
               instance_destroy(_colide_2);
           }
        }
        
        
        //apply attacks for the enemies
        for(var _i = 0; _i < ds_list_size(_list); _i++){
            var _rec = _list[| _i];
            if(!ds_list_find_index(global.attacked_enemies, _rec)){
                
                with (_rec){
                    if(!attacking){
                        
                        repeat(6){
                            with (instance_create_layer(x, y, "Instances_bellow", obj_particle_effect)){
                                randomize();
                                sprite_index = choose(spr_particle_line, spr_particle_line_2);
                                fric = .8;
                                
                                var relative_angle = point_direction(obj_player.x, obj_player.y, x, y) + irandom_range(-70, 70);
                                var angle = point_direction(obj_player.x, obj_player.y, x, y);
                                
                                speed = choose(20, 20);
                                direction = relative_angle;
                                speed = lerp(speed, 0, .1);
                                image_xscale = 1.5;
                                image_yscale = 1.5;
                                image_angle = relative_angle;
                            }
                        }
                        
                        repeat(4){
                            with (instance_create_layer(x, y, "Instances_bellow", obj_particle_effect)){
                                randomize();
                                sprite_index = spr_pixel;
                                fric = .8;
                                
                                var relative_angle = point_direction(obj_player.x, obj_player.y, x, y) + irandom_range(-70, 70);
                                var angle = point_direction(obj_player.x, obj_player.y, x, y);
                                
                                speed = choose(10, 10);
                                direction = relative_angle;
                                speed = lerp(speed, 0, .1);
                                image_xscale = 1.5;
                                image_yscale = 1.5;
                                image_angle = relative_angle;
                            }
                        }
                    
                        
                        var _is_critical = irandom(100) < global.critical;
                        var _damage_to_apply = _is_critical ? other.dmg * 2 : other.dmg;
    					var _stamina = _is_critical ? 60 : 30;
    
                        escx = 1.5;
                        escy = 1.5;
                        hit_alpha = 1;
                        timer_hit = 10;
                        emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                        global.combo++;
                        obj_camera.alarm[1] = 5;
                        
                        switch(knocked){
                            case 0:
                                state = ENEMY_STATES.HIT;
                                emp_timer = 5;
                                emp_veloc = 6;
                                stamina_at -= _stamina;
                                alarm[2] = 30;
                                var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                                break;
    
                            case 1:
                                state = ENEMY_STATES.KNOCKED;
                                vida -= _damage_to_apply;
                                hit = false;
                                alarm[1] = 10;
                                alarm[2] = 30;
                                var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                                break;
                        }
                    }
                }
                ds_list_add(global.attacked_enemies, _rec);
            }
        }
        
        //reset the list and reset the attack
        ds_list_destroy(_list);

        if(variable_global_exists("attacked_enemies")){
            ds_list_clear(global.attacked_enemies);
        }
        global.energy -= cost;
        active = false;
    };
    
    //function for reflect bullets
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
#endregion


#region teste

//distance to advance
distan = 100;
//direction to advance
direc = 0;
//speed
vel_a = .1;

//if he can activate
line_attack = false;

//final point
target_x = 0;
target_y = 0;

//line draw indication
line = false;

//timer for advance
time_adv = 0;

//attack damage
damage = 1;

//control for hability
can_line = true;

sprite_index = spr_player_idle;

created = false;