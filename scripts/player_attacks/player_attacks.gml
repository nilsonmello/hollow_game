#region player basic attack
function player_basic_attack(){
		if(global.slow_motion){
			return false;	
		}
	
		clicked_attack = true;
        alarm[4] = 5;
        image_index = 0;
        state = STATES.ATTAKING;

        var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
        var _advance_dir = 20;
        var _advance_distance = 28;

        var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
        var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);
        
        advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
        advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

        if(!instance_exists(obj_hitbox)){
            var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox);
            _box.image_angle = _melee_dir;
			_box.sprite_index = spr_hitbox_1;
			_box.dmg = 1;
        }
        advancing = true;
		
        alarm[3] = 20;
        alarm[8] = 300;
}
#endregion

#region line attack

#region movement
function player_line_attack(){
	if(global.slow_motion){
		return false;	
	}
	if(global.stamina < 30){
		return false;	
	}
	
    holded_attack = true;
    alarm[4] = 50;
    image_index = 0;
    state = STATES.LINE_ATK;
	
    var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
    var _advance_dir = 20;
    var _advance_distance = 150;
        
    advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
    advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

	_p_slash = part_system_create();

	_bs = part_type_create();

	part_type_sprite(_bs, spr_hitbox_4, 0, 0, 0);
	part_type_orientation(_bs, _melee_dir, _melee_dir, 0, 0, 0);
	part_type_alpha3(_bs, 1, .5, 0);
	part_type_life(_bs, 20, 20);
	part_particles_create(_p_slash, x, y, _bs, 1);

    advancing = true;
    global.combo = 0;
    alarm[3] = 40;
    alarm[8] = 40;

    timer = 0;
    h_atk = true;
    global.stamina -= 30;
}
#endregion

#region line damage
function line_dmg(){
	if(alarm[9] > 0 && !h_atk){
		if(!variable_global_exists("attacked_enemies")){
			global.attacked_enemies = ds_list_create();
		}

		var _list = ds_list_create();
		collision_rectangle_list(x - 10, y - 10, x + 10, y + 10, obj_enemy_par, false, false, _list, true);

		for(var i = 0; i < ds_list_size(_list); i++){
			var _rec = _list[| i];

			if(!ds_list_find_index(global.attacked_enemies, _rec)){
				with(_rec){

					if(!attack){
						switch(knocked){
							case 0:
								part_particles_create(particle_hit, x, y, particle_slash, 1);
			
								escx = 1.5;
								escy = 1.5;
								hit_alpha = 1;
			
								layer_set_visible("screenshake_damaging_enemies", 1);
								state = ENEMY_STATES.HIT;
								timer_hit = 5;
								emp_timer = 5;
								
								atk_timer = 0;
								atk_wait = 0;
								attacking = false;
                    
								emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
								emp_veloc = 6;
								global.combo++;
								stamina_at -= 30;
								alarm[2] = 30;
							break;
			
							case 1:
								layer_set_visible("screenshake_damaging_enemies", 1);
									
								escx = 1.5;
								escy = 1.5;
					
								hit_alpha = 1;
									
								state = ENEMY_STATES.KNOCKED;
								vida -= 2
								emp_timer = 5;
								
								atk_timer = 0;
								atk_wait = 0;
								attacking = false;
								
								emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
								emp_veloc = 8;
								combo_visible = 0;
								hit = false;
								global.combo++;
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
	}

	if(alarm[9] <= 0 && variable_global_exists("attacked_enemies")){
		ds_list_clear(global.attacked_enemies);
	}	
}
#endregion

#endregion

function player_circular_attack(){
	if(global.slow_motion){
		return false;	
	}
	if(global.stamina < 30){
		return false;	
	}
	
    alarm[4] = 50;
    image_index = 0;
    state = STATES.CIRCULLAR_ATK;
	
	if(!holded_attack){
		holded_attack = true;
		var _box = instance_create_layer(x, y, "Instances_player", obj_hitbox);
		_box.sprite_index = spr_hitbox_5;
	}
	
	timer = 0;
	h_atk = true;
	global.stamina -= 30;
	holded_attack = false;
}

#region player parry
function player_parry(){
	if(global.stamina > 20){
		if(global.slow_motion){
			return false;	
		}
		if(!parry_cooldown <= 0){
			return false;	
		}
	
		state = STATES.PARRY
		global.stamina -= 20;
		parry_cooldown = 70;
	}
}
#endregion