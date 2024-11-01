#region debugging
if(keyboard_check_pressed(ord("Y"))){
	state = STATES.IDLE;
	global.life_at = global.life;
	game_restart();
}
#endregion

#region state machine

#region comand keys
global.energy = clamp(global.energy, 0, global.energy_max);

var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _top = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));
		
var _keys = _right - _left != 0 || _down - _top != 0;

if(global.life_at <= 0){
	state = STATES.DEATH;
}

if(keyboard_check(ord("H")) && can_heal && global.life_at < global.life){
	state = STATES.HEAL;
}
#endregion

switch(state){
	#region idle
	case STATES.IDLE:
		spd = 0;
		andar = false;
		
		if(_keys){
			state = STATES.MOVING;
			andar = true;
		}
		
		dash_dir = move_dir
		
		if(keyboard_check_pressed(vk_space) && dash_num > 0){
			global.is_dashing = true;
			alarm[0] = 12;
			state = STATES.DASH;
			dash_num--; 
			dash_cooldown = dash_time;
		}
	break;
	#endregion
	
	#region walking
	case STATES.MOVING:
		if(!keyboard_check(ord("R"))){
			spd = 1.6;
		}else{
			spd = 0;
		}

		if(_keys){
			move_dir = point_direction(0, 0, _right - _left, _down - _top);
		
			spd_h = lengthdir_x(spd * _keys, move_dir);
			spd_v = lengthdir_y(spd * _keys, move_dir);
		
			player_colide();
		
			x += spd_h;
			y += spd_v;
			
		}else{
			state = STATES.IDLE;
		}
		
		dash_dir = move_dir;
		if(keyboard_check_pressed(vk_space) && dash_num > 0){
			global.is_dashing = true;
			alarm[0] = 8;
			state = STATES.DASH;
			dash_num--; 
			dash_cooldown = dash_time;
		}
	break;
	#endregion
	
	#region dash
	case STATES.DASH:
		//can_take_dmg = false;
		alarm[6] = 15;

		spd_h = lengthdir_x(dash_veloc, dash_dir);
		spd_v = lengthdir_y(dash_veloc, dash_dir);

		state_timer += 1;

		if(state_timer >= 2){
		    part_particles_create(obj_particle_setup.particle_system, x, y, obj_particle_setup.particle_shadow, 1);
		    state_timer = 0;
		}

		player_colide();	

		x += spd_h;
		y += spd_v;
	break;
	#endregion
	
	#region hit
	case STATES.HIT:
		spd_h = lengthdir_x(emp_veloc, emp_dir);
		spd_v = lengthdir_y(emp_veloc, emp_dir);
    
		emp_veloc = lerp(emp_veloc, 0, .01);
    
		player_colide();
    
		x += spd_h;
		y += spd_v;
	break;
	#endregion
	
	#region heal
	case STATES.HEAL:
		if(global.energy <= 0){
			return false;	
		}
	
		timer_heal++;
	
		if(timer_heal >= 50){
			player_heal();
			timer_heal = 0;
			alarm[2] = 80;
			can_heal = false;
			state = STATES.MOVING;
		}
	break;
	#endregion
	
	#region slash
	case STATES.ATTAKING:
	    if(advancing){
	        var _advance_speed = 0.2;

	        var __new_x = lerp(x, advance_x, _advance_speed);
	        var __new_y = lerp(y, advance_y, _advance_speed);

	        if(!place_meeting(__new_x, __new_y, obj_wall) && !place_meeting(__new_x, __new_y, obj_enemy)){
	            x = __new_x;
	            y = __new_y;
	        }else{
	            advancing = false;
	        }

	        if(point_distance(x, y, advance_x, advance_y) < 1){
	            advancing = false;
	        }
	    }

	    if(!advancing){
	        state = STATES.MOVING;
	    }
	break;
	#endregion

	#region death
	case STATES.DEATH:
		if(keyboard_check_pressed(ord("Y"))){
			state = STATES.IDLE;
			global.life_at = global.life;
			game_restart();
		}
	break;
	#endregion
}
#endregion

#region dash config
if(dash_num < 3){
	
	dash_cooldown--;
	
	if(dash_cooldown <= 0){
		dash_num++;	
		dash_cooldown = dash_time
	}
}
#endregion

#region weapon

with(my_weapon){
    #region target
    alvo_x = mouse_x;
    alvo_y = mouse_y;
    #endregion
    
    #region comand keys
    var _ma = mouse_check_button(mb_right);
    var _mb = noone;
    weapon_drop = instance_nearest(x, y, obj_weapon_drop);
    
    if(current_weapon.automatic){
        _mb = mouse_check_button(mb_left);
    } else {
        _mb = mouse_check_button_pressed(mb_left);
    }
    #endregion

	#region shoot
	if(_ma){
	    aiming = true;    
	}else{
	    aiming = false;    
	}

	if(_ma && _mb && current_weapon.can_shoot && global.energy >= current_weapon.cost_per_shot){

	    if(current_weapon == vazio){
	        return false;    
	    }

	    current_weapon.shoot(weapon_x, weapon_y);
		recoil = current_weapon.recoil_player;
	    recoil_gun = 8;
	}

	current_weapon.update_cooldown();

	if(current_weapon.shot_cooldown > 0){
	    recoil_gun = lerp(recoil_gun, 0, 0.1);
	}
	#endregion

    #region slots
    slot_at = clamp(slot_at, 0, 2);
        
    if(keyboard_check_pressed(ord("F"))){
        slot_at++;
        if(slot_at > 2){
            slot_at = 0;    
        }
    }
        
    current_weapon = weapon_slots[slot_at];
    #endregion
    
    #region functions
    if(keyboard_check_pressed(ord("E"))){
        weapon_pickup();
    }
    if(keyboard_check_pressed(ord("Q"))){
        drop_weapon();
    }
    #endregion
}

#endregion

#region player recoil
if(my_weapon.recoil > 0){
	var _target_playerx = x - lengthdir_x(my_weapon.recoil, my_weapon.weapon_dir);
	var _target_playery = y - lengthdir_y(my_weapon.recoil, my_weapon.weapon_dir);

	if(!place_meeting(_target_playerx, _target_playery, obj_wall)){
	    x = _target_playerx;
	    y = _target_playery;

	    my_weapon.recoil = max(0, my_weapon.recoil - 0.5);
	}else{
	    my_weapon.recoil = 0;
	}
}
#endregion

#region sword dash
var _mb = mouse_check_button_pressed(mb_left);
var _ma = mouse_check_button(mb_right);

if(_mb && state != STATES.ATTAKING && alarm[4] <= 0){
	alarm[4] = 15;

    if(_ma){
        return false;
    }
    image_index = 0;
    state = STATES.ATTAKING;

    var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
    var _advance_dir = 20;
    var _advance_distance = 28;

    var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
    var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);
	
	player_colide();
	
    advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
    advance_y = y + lengthdir_y(_advance_distance, _melee_dir);
	
	if(!instance_exists(obj_hitbox)){
		var _box = instance_create_layer(_box_x, _box_y, "Instances", obj_hitbox);
		_box.image_angle = _melee_dir;
	}
    advancing = true;
    alarm[3] = 20;
}
#endregion

#region power activation

#region hability activation
if(global.energy >= global.energy_max){
    global.can_attack = true;    
}

if(keyboard_check(ord("R")) && global.stamina >= global.stamina_max && global.can_attack){
    layer_set_visible("screenshake_charging", 1);
    if(global.energy > 0){
        global.energy -= .3;
        global.slashing = true;
        global.slow_motion = true;
        area += 3;
    }
	
    ds_list_clear(enemy_list);
    ds_list_clear(path_list);

    var _circ = collision_circle_list(x, y, area, obj_enemy_par, false, false, enemy_list, true);

    for(var _i = ds_list_size(enemy_list) - 1; _i >= 0; _i--){
        var _enemy = enemy_list[| _i];
        if(!instance_exists(_enemy)){
            ds_list_delete(enemy_list, _i);
        }
    }

    if(ds_list_size(enemy_list) > 0){
        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            var _enemy = enemy_list[| _i];
            var _dist = point_distance(x, y, _enemy.x, _enemy.y);
            ds_list_set(enemy_list, _i, [_enemy, _dist]);
        }

        ds_list_sort(enemy_list, true);

        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            var _enemy_data = enemy_list[| _i];
            var _enemy = _enemy_data[0];

            if(instance_exists(_enemy)){
                ds_list_add(path_list, [_enemy.x, _enemy.y]);
            }
        }
    }
    move_speed = 20;
    moving_along_path = false;
    path_position_index = 0;

}else{ 
    area = 0;
    global.slow_motion = false;
    layer_set_visible("screenshake_charging", 0);
    global.slashing = false;

    if(!moving_along_path && ds_list_size(path_list) > 0){
        moving_along_path = true;
        path_position_index = 0;
    }
}
#endregion

#region Movimento ao Longo do Caminho
if(moving_along_path && ds_list_size(path_list) > 0){
    if(path_position_index < ds_list_size(path_list)){

        var _target_pos = path_list[| path_position_index];
        var _target_x = _target_pos[0];
        var _target_y = _target_pos[1];

        var _dir = point_direction(x, y, _target_x, _target_y);
        var _dist = point_distance(x, y, _target_x, _target_y);

        if(move_speed > 0){
            timer++;
            if(timer >= 2){
                timer = 0;
            }
        }

        if(_dist > move_speed){
            x += lengthdir_x(move_speed, _dir);
            y += lengthdir_y(move_speed, _dir);

            ds_queue_enqueue(trail_positions, [x, y]);

            if(ds_queue_size(trail_positions) > trail_length){
                ds_queue_dequeue(trail_positions);
            }

            if(move_speed > 0){
                can_take_dmg = false;    
                alarm[6] = 20;
                global.stamina = 0;
                global.can_attack = false;
            }

        }else{
            path_position_index++;

            if(path_position_index >= ds_list_size(path_list)){
                moving_along_path = false;
                path_position_index = ds_list_size(path_list) - 1;
                move_speed = 0;
                global.slashing = false;
            }

            var _enemy_index = instance_position(_target_x, _target_y, obj_enemy_par);
            if(_enemy_index != noone){
                _enemy_index.vida -= 3;
                _enemy_index.emp_dir = point_direction(obj_player.x, obj_player.y, _enemy_index.x, _enemy_index.y);
                _enemy_index.state = ENEMY_STATES.HIT;
                _enemy_index.alarm[0] = 3;
                _enemy_index.alarm[1] = 10;
                _enemy_index.alarm[5] = 80;
                _enemy_index.emp_veloc = 20;
                _enemy_index.hit_alpha = 1;

                ds_list_add(trail_fixed_positions, [x, y, direction]);
                ds_list_add(trail_fixed_timer, 30);

                layer_set_visible("screenshake_damaging_enemies", 1);
            }
            layer_set_visible("screenshake_damaging_enemies", 0);
        }
    }else{
        moving_along_path = false;
    }
}
#endregion

#region Regeneração de Stamina
if(stamina_timer_regen > 0){
    stamina_timer_regen--;
}else{
    if(global.stamina < global.stamina_max){
        global.stamina += 1;
        stamina_timer_regen = stamina_timer;
    }
}
global.stamina = clamp(global.stamina, 0, global.stamina_max);
#endregion

#endregion

#region dust walk
if(xprevious != x and candust == true){
	candust = false;
	alarm[7] = 10;
	var _random_time = irandom_range(-1, 2);
	alarm_set(3, 8 + _random_time);
	part_particles_create(obj_particle_setup.particle_system_dust, x, y + 12, obj_particle_setup.particle_dust, 10);
}
if(yprevious != y and candust == true){
	candust = false;
	alarm[7] = 10;
	var _random_time = irandom_range(-1, 2);
	alarm_set(3, 8 + _random_time);
	part_particles_create(obj_particle_setup.particle_system_dust, x, y + 12, obj_particle_setup.particle_dust, 10);
}
#endregion

#region hit indication
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion