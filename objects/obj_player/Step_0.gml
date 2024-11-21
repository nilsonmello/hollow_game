#region debugging
if(keyboard_check_pressed(ord("Y"))){
	state = STATES.IDLE;
	global.life_at = global.life;
	global.energy = global.energy_max;
	global.stamina = global.stamina_max;
	game_restart();
}
#endregion

#region state machine

#region comand keys
var _spr_dir = move_dir;

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
		switch(_spr_dir){
			case 0:	sprite_index = spr_player_idle	image_xscale = 1	break;
			case 90:	sprite_index = spr_player_idle_up	break;
			case 180:	sprite_index = spr_player_idle	image_xscale = -1	break;
			case 270:	sprite_index = spr_player_idle_down	 break;
		}
		
		spd = 0;
		andar = false;
		
		if(_keys){
			state = STATES.MOVING;
			andar = true;
		}
		
		dash_dir = move_dir
		
		if(keyboard_check_pressed(vk_space) && alarm[1] <= 0){
			global.is_dashing = true;
			alarm[0] = 8;
			alarm[1] = 23;
			state = STATES.DASH;
		}
		
	break;
	#endregion
	
	#region walking
	case STATES.MOVING:
	
		if(!keyboard_check(ord("R"))){
			spd = 1.3;
		}else{
			spd = 0;
		}
			
		switch(_spr_dir){
			case 0:	sprite_index = spr_player_walk_rl;	image_xscale = 1	break;
			case 90:	sprite_index = spr_walk_up;	break;
			case 180:	sprite_index = spr_player_walk_rl;	image_xscale = -1	break;
			case 270:	sprite_index = spr_walk_down;	break;
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
		if(keyboard_check_pressed(vk_space) && alarm[1] <= 0){
				global.is_dashing = true;
				alarm[0] = 8;
				alarm[1] = 23;
				state = STATES.DASH;
		}
	break;
	#endregion
	
	#region dash
	case STATES.DASH:
		alarm[6] = 15;

		spd_h = lengthdir_x(dash_veloc, dash_dir);
		spd_v = lengthdir_y(dash_veloc, dash_dir);

		state_timer += 1;

		if(state_timer >= 1){
		    part_particles_create(obj_particle_setup.particle_system, x, y, obj_particle_setup.particle_shadow, 4);
		    state_timer = 0;
		}

		player_colide();
		
		x += spd_h;
		y += spd_v;

		var _colide = collision_rectangle(x - 10, y + 10,x + 10, y - 10, obj_bush, 0, 0);
		
		if(_colide){
			with(_colide){
				
				#region particle leafs
				var _ps = part_system_create();
				part_system_draw_order(_ps, true);

				//Emitter
				var _ptype1 = part_type_create();
				part_type_sprite(_ptype1, spr_leaf, false, true, false);
				part_type_subimage(_ptype1, choose(0, 1, 2, 3))
				part_type_size(_ptype1, 1, 1, 0, 0);
				part_type_scale(_ptype1, 1, 1);

				var _spd = 2;
				_spd = lerp(_spd, 0, .6);

				part_type_speed(_ptype1, _spd, _spd, 0, 0);
				part_type_direction(_ptype1, 0, 359, 0, 0);
				part_type_gravity(_ptype1, .02, 270)
				part_type_orientation(_ptype1, 0, 0, 0, 0, true);
				part_type_colour3(_ptype1, $FFFFFF, $FFFFFF, $FFFFFF);
				part_type_alpha3(_ptype1, 1, 1, 1);
				part_type_blend(_ptype1, false);
				part_type_life(_ptype1, 40, 40);
				part_type_alpha2(_ptype1, 1, .1);

				var _pemit1 = part_emitter_create(_ps);
				part_emitter_burst(_ps, _pemit1, _ptype1, 8);

				part_system_position(_ps, x, y);
				#endregion
	
				#region particle dots
				var _ps2 = part_system_create();
				part_system_draw_order(_ps2, true);

				//Emitter
				var _ptype2 = part_type_create();
				part_type_shape(_ptype2, pt_shape_pixel);
				part_type_size(_ptype2, 1, 1, 0, 0);
				part_type_scale(_ptype2, 1, 1);
				part_type_speed(_ptype2, 1, 1, 0, 0);
				part_type_direction(_ptype2, 0, 359, 0, 0);
				part_type_gravity(_ptype2, 0, 270);
				part_type_orientation(_ptype2, 0, 0, 0, 0, false);
				part_type_colour3(_ptype2, $FFFFFF, $FFFFFF, $FFFFFF);
				part_type_alpha3(_ptype2, 1, 1, 1);
				part_type_blend(_ptype2, false);
				part_type_life(_ptype2, 30, 30);

				var _pemit2 = part_emitter_create(_ps2);
				part_emitter_region(_ps2, _pemit2, -16, 16, -16, 16, ps_shape_rectangle, ps_distr_linear);
				part_emitter_burst(_ps2, _pemit2, _ptype2, 11);

				part_system_position(_ps2, x, y);
				#endregion
				
				layer_set_visible("screenshake_damaging_enemies", 1);
				
				instance_destroy();	
			}
		}	
	break;
	#endregion
	
	#region parry
	case STATES.PARRY:
		parry_time--;
		global.parry = true;
		
		if(parry_time <= 0){
			parry_time = 20;
			state = STATES.ATTAKING;
			global.parry = false;
		}
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
    if (advancing) {
        var _melee_dir = point_direction(x, y, advance_x, advance_y);
        move_dir = nearest_cardinal_direction(_melee_dir);

        switch (_spr_dir) {
            case 0: sprite_index = spr_player_attack_rl; image_xscale = 1; break;
            case 90: sprite_index = spr_player_attack_rl; break;
            case 180: sprite_index = spr_player_attack_rl; image_xscale = -1; break;
            case 270: sprite_index = spr_player_attack_rl; break;
        }

        var _advance_speed = 0.2;
        var __new_x = lerp(x, advance_x, _advance_speed);
        var __new_y = lerp(y, advance_y, _advance_speed);

		if(holded_attack){
	        var _future_x = x + lengthdir_x(20, _melee_dir);
	        var _future_y = y + lengthdir_y(20, _melee_dir);

	        if (instance_position(_future_x, _future_y, obj_enemy_par)) {
	            var _extra_distance = 40;
	            advance_x += lengthdir_x(_extra_distance, _melee_dir);
	            advance_y += lengthdir_y(_extra_distance, _melee_dir);
	        }
		}
        if (!place_meeting(__new_x, __new_y, obj_wall)) {
            x = __new_x;
            y = __new_y;
        } else {
            advancing = false;
        }


        if (point_distance(x, y, advance_x, advance_y) < 1) {
            advancing = false;
        }
    }

    if (!advancing && image_index >= image_number - 1) {

        while (place_meeting(x, y, obj_enemy_par)) {
            x += lengthdir_x(-1, move_dir);
            y += lengthdir_y(-1, move_dir);
        }
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

#region sword dash
var _mb = mouse_check_button_pressed(mb_left);
var _mb2 = mouse_check_button(mb_left);
var _ma = mouse_check_button_pressed(mb_right);

show_debug_message(state)

parry_cooldown = clamp(parry_cooldown, 0, 70);

parry_cooldown--;

if(_ma && global.stamina > 20 && parry_cooldown <= 0 && !global.slow_motion){
	state = STATES.PARRY
	global.stamina -= 20;
	parry_cooldown = 70;
}

var _hold_time = 30;

if(!mouse_check_button(mb_left) && !global.slow_motion){
    if(timer >= _hold_time && !h_atk && global.stamina > 30){ // hold atk
		holded_attack = true;
        alarm[4] = 50;
        image_index = 0;
        state = STATES.ATTAKING;
        
        var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
        var _advance_dir = 15;
        var _advance_distance = 120;

        var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
        var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);
        
        advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
        advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

        if(!instance_exists(obj_hitbox)){
            var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox);
            _box.image_angle = _melee_dir;
            _box.sprite_index = spr_hitbox_4;
            _box.dmg = 3;
        }

        advancing = true;
        global.combo = 0;
        alarm[3] = 40;
        alarm[8] = 40;
		
        timer = 0;
        h_atk = true;
		global.stamina -= 30;
		
		var _colide = collision_rectangle(x - 8, y - 8, x + 8, y + 8, obj_enemy_par, false, false);
		
		if(_colide){
	        emp_dir = point_direction(other.x, other.y, x, y);
	        emp_veloc = 6;
			
			state = STATES.HIT
			alarm[5] = 5;
		}

    }else{
        timer = 0;
        h_atk = false;
    }
}else if(_mb2 && !global.slow_motion){
    timer++;
}

if(state != STATES.ATTAKING && alarm[4] <= 0){
    if(_mb && global.combo < 3 && !_ma && !global.slow_motion){ // click atk
		clicked_attack = true;
        alarm[4] = 15;
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
			_box.dmg = 1;

            switch(global.combo){
                case 0:
                    _box.sprite_index = spr_hitbox_1;
                    break;
                case 1:
                    _box.sprite_index = spr_hitbox_2;
                    break;
                case 2:
                    _box.sprite_index = spr_hitbox_3;
                    break;
            }
        }
        advancing = true;
        global.combo++;
        alarm[3] = 20;
        alarm[8] = 30;
        timer = 0;
    }
}
#endregion

#region power activation

#region hability activation
area = clamp(area, 0, global.hab_range);

if(global.energy >= global.energy_max){
    global.can_attack = true;    
}

if(keyboard_check(ord("R")) && global.can_attack){
    layer_set_visible("screenshake_charging", 1);
    if(global.energy > 0){
        global.energy -= .3;
        global.slashing = true;
        global.slow_motion = true;
    }

    ds_list_clear(enemy_list);
    ds_list_clear(path_list);

    var _circ = collision_circle_list(x, y, global.hab_range, obj_enemy_par, false, false, enemy_list, true);

    for(var _i = ds_list_size(enemy_list) - 1; _i >= 0; _i--){
        var _enemy = enemy_list[| _i];

        if(!instance_exists(_enemy) || collision_line(x, y, _enemy.x, _enemy.y, obj_wall, false, true)){
            ds_list_delete(enemy_list, _i);
        }

        if(ds_list_size(enemy_list) >= global.marked){
            break;
        }
    }

    if(ds_list_size(enemy_list) > 0){
        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            var _enemy = enemy_list[| _i];
            if(instance_exists(_enemy)){
                var _dist = point_distance(x, y, _enemy.x, _enemy.y);
                ds_list_set(enemy_list, _i, [_enemy, _dist]);
            } else {
                ds_list_delete(enemy_list, _i);
            }
        }

        ds_list_sort(enemy_list, true);

        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            if(_i >= global.marked) break;
            var _enemy_data = enemy_list[| _i];
            if(is_array(_enemy_data)){
                var _enemy = _enemy_data[0];
                if(instance_exists(_enemy)){
                    ds_list_add(path_list, [_enemy.x, _enemy.y]);
                }
            } else {
                show_debug_message("Elemento inválido em enemy_list: " + string(_enemy_data));
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
	part_particles_create(obj_particle_setup.particle_system_dust, x, y + 5, obj_particle_setup.particle_dust, 10);
}
if(yprevious != y and candust == true){
	candust = false;
	alarm[7] = 10;
	var _random_time = irandom_range(-1, 2);
	alarm_set(3, 8 + _random_time);
	part_particles_create(obj_particle_setup.particle_system_dust, x, y, obj_particle_setup.particle_dust, 10);
}
#endregion

#region hit indication
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion