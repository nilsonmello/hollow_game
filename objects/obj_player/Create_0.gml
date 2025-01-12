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

//speed movement
advance_speed = .2;

//is advancing
advancing = false;

//time for the adnvancing
time_attack = 0;

//the target x and y
advance_x = 0;
advance_y = 0;

//cooldown for basic attack
attack_cooldown = 0;

//cooldown for parry and time for parry
parry_time = 20;
parry_cooldown = 70;

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

//timer fos tates
state_timer = 0;
#endregion


//can use healing
can_heal = true;

//timer for heal
timer_heal = 0;

//cooldown for healing
heal_cooldown = 80;

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

//basic attack range
range = 30

//if the line attack can be executed
line_attack = false;

//if it is actualy in use
line = false;
can_line = false;

//the distance for the line attack
distan = 0;

//the speed for the line attack
vel_a = .2

//the final x and y position for the line
target_x = x;
target_y = y;

//the damage for the attack
damage = 2;

#region particles
dust_time = 0;

//if can create the dust particles
candust = true;

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
                        
                        particles(obj_player.x, obj_player.y, _rec.x, _rec.y, c_black, 6, 4);
                    
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
                                //alarm[1] = 5;
                                alarm[2] = 30;
                                var _inst2 = instance_create_layer(x, y, "Instances_player", obj_hitstop);
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

sprite_index = spr_player_idle;

