#region hit timers
if(hit_timer > 0){
	hit_timer--;
}
if(hit_cooldown > 0){
	hit_cooldown--;
	can_take_dmg = false;
}else{
	can_take_dmg = true;
}
#endregion

#region state machine

#region comand keys

#region movement keys
var _spr_dir = move_dir;

global.energy = clamp(global.energy, 0, global.energy_max);

var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _top = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));
		
var _keys = _right - _left != 0 || _down - _top != 0;
#endregion

#region death verification
if(global.life_at <= 0){
	state = STATES.DEATH;
}
#endregion

#region healing button
if(heal_cooldown > 0){
	heal_cooldown--;	
}else{
	can_heal = true;	
}

if(keyboard_check(ord("H")) && can_heal && global.life_at < global.life){
	state = STATES.HEAL;
}
#endregion

#region dash control
dash_dir = move_dir

if(dash_cooldown > 0){
	dash_cooldown--;	
}

if(keyboard_check_pressed(vk_space) && dash_cooldown <= 0){
	global.is_dashing = true;
	dash_timer = 8;
	dash_cooldown = 23
	state = STATES.DASH;
}
#endregion

#region sprites
switch(state){
	case STATES.IDLE:
		if(!global.slow_motion){
			switch(_spr_dir){
				case 0:	sprite_index = spr_player_idle;	image_xscale = 1	break;
				case 90:	sprite_index = spr_player_idle_up;	break;
				case 180:	sprite_index = spr_player_idle;	image_xscale = -1	break;
				case 270:	sprite_index = spr_player_idle_down;	break;
			}
		}else{
			sprite_index = spr_player_power;
		}
	break;
	
	case STATES.MOVING:
		if(!global.slow_motion){
			switch(_spr_dir){
				case 0:	sprite_index = spr_player_walk_rl;	image_xscale = 1	break;
				case 90:	sprite_index = spr_walk_up;	break;
				case 180:	sprite_index = spr_player_walk_rl;	image_xscale = -1	break;
				case 270:	sprite_index = spr_walk_down;	break;
			}
		}else{
			sprite_index = spr_player_power	
		}
	break;
	
	case STATES.ATTAKING:
	    switch(_spr_dir){
	        case 0: sprite_index = spr_player_attack_rl; image_xscale = 1; break;
	        case 90: sprite_index = spr_player_attack_rl; break;
	        case 180: sprite_index = spr_player_attack_rl; image_xscale = -1; break;
	        case 270: sprite_index = spr_player_attack_rl; break;
	    }
	break;
}
#endregion

#endregion

switch(state){
	
	#region idle
	case STATES.IDLE:
		spd = 0;
		
		if(_keys){
			state = STATES.MOVING;
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

		if(_keys){
			move_dir = point_direction(0, 0, _right - _left, _down - _top);
		
			spd_h = lengthdir_x(spd * _keys, move_dir);
			spd_v = lengthdir_y(spd * _keys, move_dir);
			
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall)){
				x += spd_h;
			}else{
				spd_h = 0;
			}
			if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall)){
				y += spd_v;
			}else{
				spd_v = 0;
			}
		}else{
			state = STATES.IDLE;
		}
	break;
	#endregion
	
	#region dash
	case STATES.DASH:
		if(dash_timer > 0){
			dash_timer--;
		}else{
			state = STATES.MOVING;
			layer_set_visible("screenshake_damaging_enemies", 0);
			global.is_dashing = false;	
		}

		spd_h = lengthdir_x(dash_veloc, dash_dir);
		spd_v = lengthdir_y(dash_veloc, dash_dir);

		state_timer += 1;

		if(state_timer >= 1){
		    part_particles_create(particle_system, x, y, particle_shadow, 4);
		    state_timer = 0;
		}

		if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall)){
			x += spd_h;
		}else{
			spd_h = 0;
		}
		if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall)){
			y += spd_v;
		}else{
			spd_v = 0;
		}

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
			state = STATES.MOVING;
			global.parry = false;
		}
	break;
	#endregion
	
	#region hit
	case STATES.HIT:
		spd_h = lengthdir_x(emp_veloc, emp_dir);
		spd_v = lengthdir_y(emp_veloc, emp_dir);
    
		emp_veloc = lerp(emp_veloc, 0, .05);
		
		if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall)){
			x += spd_h;
		}else{
			spd_h = 0;
		}
		if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall)){
			y += spd_v;
		}else{
			spd_v = 0;
		}
		
		if(hit_timer <= 0){
			state = STATES.MOVING;
		}
	break;
	#endregion
	
	#region heal
	case STATES.HEAL:
		if(global.energy <= 0){
			return false;	
		}
		
		global.healing = true;
		timer_heal++;
	
		if(timer_heal < 80){
			part_emitter_region(ps, emitter, x - 10, x + 10, y - 10, y + 10, ps_shape_rectangle, ps_distr_linear);
			part_emitter_stream(ps, emitter, ptype2, 1);
			
			part_emitter_region(ps, emitter2, x - 10, x + 10, y - 10, y + 10, ps_shape_rectangle, ps_distr_linear);
			part_emitter_stream(ps, emitter2, ptype3, 1);
		}else{
			part_emitter_destroy(ps, emitter);
			part_emitter_destroy(ps, emitter2);
			part_particles_create(ps, x, y + 5, ptype1, 1);
		}

		if(timer_heal >= 80){
			player_heal();
			
			timer_heal = 0;
			heal_cooldown = 80;
			can_heal = false;
			state = STATES.MOVING;
			
			emitter = part_emitter_create(ps);
			emitter2 = part_emitter_create(ps);
			
			global.healing = false;
		}
	break;
	#endregion
	
	#region death
	case STATES.DEATH:
		state = STATES.IDLE;
		global.life_at = global.life;
		game_restart();
	break;
	#endregion
}

#endregion

#region sword dash
var _mb = mouse_check_button_pressed(mb_left);
var _ma = mouse_check_button_pressed(mb_right);

parry_cooldown = clamp(parry_cooldown, 0, 70);
parry_cooldown--;

//parry
if(_ma){
	player_parry();
}

//basic attack
if(_mb){ 
	var _basico = new basic_attack(20, point_direction(x, y, mouse_x, mouse_y), 1, true, self, 0);
	_basico.activate();
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
            }else{
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
                _enemy_index.vida -= global.hab_dmg;
				_enemy_index.stamina_at -= 100;
                _enemy_index.emp_dir = point_direction(obj_player.x, obj_player.y, _enemy_index.x, _enemy_index.y);
				_enemy_index.emp_veloc = 20;
				_enemy_index.timer_hit = 15;
				_enemy_index.emp_timer = 2;
                _enemy_index.state = ENEMY_STATES.KNOCKED;
                _enemy_index.alarm[1] = 10;
                _enemy_index.alarm[5] = 80;
                _enemy_index.hit_alpha = 1;
				_enemy_index.slashed = true;
				
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

#endregion

#region dust walk
if(dust_time <= 0){
    dust_time = choose(10, 12);
	candust = true;
}else{
    dust_time--;
}

if(xprevious != x and candust == true){
	candust = false;
	part_particles_create(particle_system_dust, x, y + 5, particle_dust, 10);
}
if(yprevious != y and candust == true){
	candust = false;
	part_particles_create(particle_system_dust, x, y, particle_dust, 10);
}
#endregion

#region hit indication
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion