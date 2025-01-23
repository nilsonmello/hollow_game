#region movement variables
//direction for walk and sprite
move_dir = 0;

//horizontal and vertical speed
spd_h = 0;
spd_v = 0;

//actual speed
spd = .9;
#endregion

#region dash variables
//dash direction
dash_dir = 0;

//dash speed
dash_veloc = 12;

//dash time
dash_timer = 0;

//cooldown for dash
dash_cooldown = 0;
#endregion

#region attack variables
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

//basic attack range
range = 30

//charge timer for the charged attack
actual_timer = 0;
timer_charge = 50;

//NUMBER OF THE HIT AND THE TIMER FOR IT
combo = 0;
combo_time = 0;

//cooldown for parry and time for parry
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

//timer fos tates
state_timer = 0;
#endregion

#region healing variables
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

//target for the circular attack
target = noone;

//charging attack variable
combo_charge = 0;

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
    
    //distance or range for the attacks
    distance = _dist;
    
    //direction for the attacks
    dir_atk = _direction;
    
    //the attack damage
    dmg = _damage;
    
    //if it creates a hitbox
    create_hitbox = _hitbox;
    
    //the owner of the attack, the player
    owner = _owner;
    
    //the cost of the attack
    cost = _cost;
    
    //base colide function
    collision = function(){
        show_debug_message("bateu");
    };
}

//basic attack
function basic_attack(_dist, _direction, _damage, _hitbox, _owner, _cost, _combo) : slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor{
    //parameters
    
    //distance or range for the attacks
    distance = _dist;
    
    //direction for the attacks
    dir_atk = _direction;
    
    //the attack damage
    dmg = _damage;
    
    //if it creates a hitbox
    create_hitbox = _hitbox;
    
    //the owner of the attack, the player
    owner = _owner;
    
    //the cost of the attack
    cost = _cost;
    
    //if the attack is active
    active = false;
    
    //the number of the combo attack
    combo = _combo;

    //attack function
    activate = function(){
        active = true;

        //list of enemies
        if(!variable_global_exists("attacked_enemies")){
            global.attacked_enemies = ds_list_create();
        }
        
        //direction for the attack
        var _dir = point_direction(owner.x, owner.y, mouse_x, mouse_y);
        
        //variables for the attack x and y position
        var _attack_x = owner.x + lengthdir_x(distance, _dir);
        var _attack_y = owner.y + lengthdir_y(distance, _dir);
        
        //enemies list
        var _list = ds_list_create();
        
        //recive enemy information
        collision_circle_list(_attack_x, _attack_y, distance, obj_enemy_par, false, false, _list, true); 
        
        //bush information
        var _colide = collision_circle(_attack_x, _attack_y, distance, obj_bush, false, false);
        
        //box information
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
        
        //with boxes
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
        
        //finding the enemy index on the list
        for(var _i = 0; _i < ds_list_size(_list); _i++){
            var _rec = _list[| _i];
            if(!ds_list_find_index(global.attacked_enemies, _rec)){
                //apply attacks for the enemies
                with (_rec){
                    //with the enemy, if he inst attacking
                    if(!attacking){
                        //create particles
                        particles(obj_player.x, obj_player.y, _rec.x, _rec.y, c_black, 6, 4);
                        
                        //critical attack chance
                        var _is_critical = irandom(100) < global.critical;
                        
                        //total damage to apply
                        var _damage_to_apply = _is_critical ? other.dmg * 2 : other.dmg;
                        
                        //the stamina to decrease with the attack
    					var _stamina = 0;
                        
                        //if the enemy is bigger, take less stamina, if he's tynier, take more stamina
                        switch (size) {
                            case 1:
                                _stamina = 50;
                            break;
                            
                            case 2:
                                _stamina = 25
                            break;
                        }
                        
                        //changing the scale of the enemy for effect
                        escx = 1.5;
                        escy = 1.5;
                        
                        //hit flash effect
                        hit_alpha = 1;
                        
                        //direction for de pull
                        emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                        
                        //increase combo
                        global.combo++;
                        
                        //alarm for the screenshake layer visible
                        obj_camera.alarm[1] = 5;
                        
                        //in case of the enemy is in combo one or zero, he will be pulled a bit, if its two, he will be pulled a lot
                        switch (other.combo) {
                            case 1:
                                emp_timer = 5;
                                emp_veloc = 6;
                                timer_hit = 5;
                            break;
                            
                            case 2:
                                emp_timer = 20;
                                emp_veloc = 6; 
                                timer_hit = 20;
                            break;
                        }
                        
                        //switch the enemy state
                        switch(knocked){
                            //if isnt knocked, state is hit
                            case 0:
                                state = ENEMY_STATES.HIT;
                            
                                //decrease stamina
                                stamina_at -= _stamina;
                            
                                //create hitstop object
                                var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                                break;
                            
                            //if its knocked, state is knocked
                            case 1:
                                state = ENEMY_STATES.KNOCKED;
                                //decrease health
                                vida -= _damage_to_apply;
                                
                                //set hit to true
                                hit = false;
                            
                                //create hitstop object
                                var _inst2 = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                            break;
                        }
                    }
                }
                //add the enemy to the list
                ds_list_add(global.attacked_enemies, _rec);
            }
        }
        
        //reset the list and reset the attack
        ds_list_destroy(_list);
        
        //if the variable exists, clear it
        if(variable_global_exists("attacked_enemies")){
            ds_list_clear(global.attacked_enemies);
        }
        //decrease the cost and turn off the attack
        global.energy -= cost;
        active = false;
    };
    
    //function for reflect bullets
	bullet = function(){
        
        //initial direction
        var _dir = point_direction(owner.x, owner.y, mouse_x, mouse_y);
        
        //armazenating x and y
        var _attack_x = owner.x + lengthdir_x(distance, _dir);
        var _attack_y = owner.y + lengthdir_y(distance, _dir);
        
        //creating collision circle
        var _colide = collision_circle(_attack_x, _attack_y, distance, obj_bullet, false, false);
		
        //with the bullet
		with(_colide){
            //chenge direction
			direction = direction + 180;
            
            //speed of the bullet
			speed = 3.5;
            
            //camera for effect screenshake
            obj_camera.alarm[1] = 5;
		}
	}
}

function circle(_dist, _direction, _damage, _hitbox, _owner, _cost) : slashes(_dist, _direction, _damage, _hitbox, _owner, _cost) constructor {
    //if the attack is active
    active = false;
    
    //the attack cost
    cost = _cost;
    
    //the damage of the attack
    damage = _damage;

    //attack function
    activate = function() {
        //if he didnt has energy, dont execute
        if (global.energy < cost) {
            return false;
        }
        
        //attack activated
        active = true;

        //creating particles
        var _inst = instance_create_layer(owner.x, owner.y, "Instances_player", obj_particle_effect);
        
        //setting particles parameters
        _inst.sprite_index = spr_hitbox_area;
        _inst.image_angle = _inst.direction;
        _inst.fric = 0.8;
        _inst.image_blend = c_white;

        //if the variable global.attacked_enemies didnt exist
        if (!variable_global_exists("attacked_enemies")) {
            global.attacked_enemies = ds_list_create();
        }
    
        //turn on the effect layer
        layer_set_visible("screenshake_damaging_enemies", 1);

        //temporary list to keep the enemy information
        var _list = ds_list_create();
        
        //checking the enemies and keeping on the list
        collision_circle_list(owner.x, owner.y, distance, obj_enemy_par, false, false, _list, true);

        //passing trough the list
        for (var _i = 0; _i < ds_list_size(_list); _i++) {
            //checking for the enemy
            var _rec = _list[| _i];

            //findeng the index of the enemy
            if (!ds_list_find_index(global.attacked_enemies, _rec)) {
                
                //creating particles
                particles(_rec.x, _rec.y, _rec.x, _rec.y, c_black, 6, 4);
                
                //if the enemy exists
                if (instance_exists(_rec)) {
                    //setting the enemy to target for the attack
                    owner.target = _rec;
                    
                    //player can use line attack
                    global.line_ready = true;

                    //if the enemy exists in the list
                    if (global.index >= 0 && global.index < ds_list_size(global.enemy_list)) {
                        var previous_enemy = global.enemy_list[| global.index];
                        //clear the allign of the previous enemy
                        if (instance_exists(previous_enemy)) {
                            with (previous_enemy) {
                                alligned = false;
                            }
                        }
                    }

                    //setting the index of the enemy
                    for (var i = 0; i < ds_list_size(global.enemy_list); i++) {
                        if (global.enemy_list[| i] == _rec) {
                            global.index = i;
                            break;
                        }
                    }
                    
                    //if the enemy exists, set allign to true
                    if (instance_exists(global.target_enemy)) {
                        with (global.target_enemy) {
                            alligned = true;
                        }
                    }
                }
                
                //with the enemy
                with (_rec) {
                    
                    //timer to to pull enemy
                    emp_timer = 13;
                    
                    //timer for the hit
                    timer_hit = 13;
                    
                    //changing the scale
                    escx = 1.5;
                    escy = 1.5;
                    
                    //hit flash effect
                    hit_alpha = 1;
                    
                    //direction to pull
                    emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                    
                    //increase combo
                    global.combo++;
                    
                    //knock out enemy
                    knocked = 1;
                    
                    //decrease stamina
                    stamina_at = 0;
                    
                    //turn screenshake visible
                    layer_set_visible("screenshake_damaging_enemies", 1);
                    
                    //change state
                    state = ENEMY_STATES.KNOCKED;
                    
                    //set warning to false
                    warning = false;
                    
                    //setting attacking to false
                    attacking = false;
                    
                    //speed of the pull
                    emp_veloc = 8;
                    
                    //decreasing life
                    vida -= other.damage;
                    
                    //its been hitted
                    hit = false;
                    
                    alarm[1] = 10;
                }
                //add the enemy to the list
                ds_list_add(global.attacked_enemies, _rec);
            }
        }
        //destroy the list
        ds_list_destroy(_list);
        
        //clear global.attacked_enemies
        if (variable_global_exists("attacked_enemies")) {
            ds_list_clear(global.attacked_enemies);
        }
        //reseting the active
        active = false;
        //decreasing energy
        global.energy -= cost;
    };
}

//creating circular attack
golpe_circular = new circle(50, 0, 1, true, self, 5);
#endregion

//creating the hook
if (!instance_exists(obj_hook)) {
    var _hook = instance_create_layer(x, y, "Instances_player", obj_hook);
}