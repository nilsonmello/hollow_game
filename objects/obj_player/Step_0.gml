if(keyboard_check(ord("E")) && global.energy >= global.cost_hab){
    global.can_attack = true;
    global.slow_motion = true;
    global.slashing = true;
    line = true;    

    direc = point_direction(x, y, obj_control.x, obj_control.y);
    
    var full_target_x = x + lengthdir_x(distan, direc);
    var full_target_y = y + lengthdir_y(distan, direc);
    
    var _line = collision_line(x, y, full_target_x, full_target_y, obj_wall, true, false);

    if(_line){
        distan = point_distance(x, y, _line.x, _line.y);
        target_x = _line.x;
        target_y = _line.y;
    }else{
        distan = 150;
        target_x = full_target_x;
        target_y = full_target_y;
    }
}

if(keyboard_check_released(ord("E")) && global.energy >= global.cost_hab){
    global.energy -= global.cost_hab
    global.slow_motion = false;
    global.slashing = false;
    line_attack = true;
    
    time_adv = 200;
}

if(line_attack){
    if(time_adv > 0){
        var _new_x = lerp(x, target_x, vel_a);
        var _new_y = lerp(y, target_y, vel_a);

        if(collision_rectangle(_new_x - 5, _new_y - 9, _new_x + 5, _new_y + 9, obj_wall, false, false)){
            line_attack = false;
        }else{
            x = _new_x;
            y = _new_y;
        }
    
        if(distance_to_point(target_x, target_y) < 10){
            line_attack = false;
            line = false;
        }
    }
    
    //enemy colide
    var _enemy = collision_rectangle(x - 10, y - 10, x + 10, y + 10, obj_enemy_par, false, false);

    //bush colide
    var _colide = collision_circle(x, y, 20, obj_bush, false, false);
    
    //box colide
    var _colide_2 = collision_circle(x, y, 20, obj_box, false, false);
    
    with(_enemy){
        var _is_critical = irandom(100) < global.critical;
        var _damage_to_apply = _is_critical ? other.damage * 2 : other.damage;
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
    
    if(_colide){
        if(_colide.image_index == 0){
            var _part_num = irandom_range(7, 12);
            
            repeat(_part_num){
                var _inst = instance_create_layer(_colide.x + irandom_range(-2, 2), _colide.y - 8, "Instances_player", obj_b_part);
                _inst.direction = point_direction(x, y, _colide.x, _colide.y) + irandom_range(90, -90);
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
            _inst.direction = point_direction(x, y, _colide_2.x, _colide_2.y) + irandom_range(90, -90);
            _inst.image_index = irandom_range(5, 8);
            obj_camera.alarm[1] = 5;
        }
        with(_colide_2){
            instance_destroy(_colide_2);
        }
    }
}

#region hit timers 
if(hit_timer > 0){
	hit_timer--;
}

//player hit timer
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

//activate the regeneration
if(keyboard_check(ord("F")) && can_heal){
	player_healing();
}
#endregion

#region dash control

//dash direction
dash_dir = move_dir;

//dash cooldown control
if(dash_cooldown > 0){
	dash_cooldown--;	
}

//activate the dash
if(keyboard_check_pressed(vk_space) && dash_cooldown <= 0){
    global.is_dashing = true;
    dash_timer = 8;
    dash_cooldown = global.dash_cooldown;
    state = STATES.DASH;
    
    if(global.shield){
        hit_cooldown = 8;
    }
}
#endregion

#region sprite control
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
			
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
				x += spd_h;
			}else{
				spd_h = 0;
			}
			if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
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
        if(global.is_dashing){
            if(dash_timer > 0){
                dash_timer--;
            }else{
                state = STATES.MOVING;
                global.is_dashing = false;
            }
            
        spd_h = lengthdir_x(dash_veloc, dash_dir);
        spd_v = lengthdir_y(dash_veloc, dash_dir);

        state_timer++;
        if(state_timer >= 1){
            part_particles_create(particle_system, x, y, particle_shadow, 4);
            state_timer = 0;
        }

        if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
            x += spd_h;
        } else {
            spd_h = 0;
            state = STATES.MOVING;
            dash_timer = 0;
            global.is_dashing = false;
        }
        if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
            y += spd_v;
        } else {
            spd_v = 0;
            state = STATES.MOVING;
            dash_timer = 0;
            global.is_dashing = false;
        }
        }
    break;
	#endregion
	
	#region parry
	case STATES.PARRY:
		if(state != STATES.DASH){
			parry_time--;
			global.parry = true;

			if(parry_time <= 0){
				parry_time = 20;
				state = STATES.MOVING;
				global.parry = false;
			}
		}
	break;
	#endregion
	
	#region hit
	case STATES.HIT:
		if(state != STATES.DASH){
			spd_h = lengthdir_x(emp_veloc, emp_dir);
			spd_v = lengthdir_y(emp_veloc, emp_dir);
    
			emp_veloc = lerp(emp_veloc, 0, .05);
			
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
				x += spd_h;
			}else{
				spd_h = 0;
			}
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
				y += spd_v;
			}else{
				spd_v = 0;
			}
			
			if(hit_timer <= 0){
				state = STATES.MOVING;
			}
		}
	break;
	#endregion

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
var _mb2 = mouse_check_button(mb_left);
var _mb3 = mouse_check_button_released(mb_left);

var _ma = mouse_check_button_pressed(mb_right);

var _timer = 30;
var _basico = new basic_attack(20, point_direction(x, y, mouse_x, mouse_y), 1, true, self, 0);

parry_cooldown = clamp(parry_cooldown, 0, 70);
parry_cooldown--;

//parry
if(_ma){
	player_parry();
}

//basic attack
if(attack_cooldown > 0){
    attack_cooldown--;
}


//advancing config
if(_mb && attack_cooldown <= 0){ 
    _basico.activate();
    if(global.deflect_bullets){
        _basico.bullet();
    }
    attack_cooldown = 15;
    time_attack = 5;
    advancing = true;

    //first and last point
    var _direction = point_direction(x, y, mouse_x, mouse_y);
    advance_x = x + lengthdir_x(30, _direction);
    advance_y = y + lengthdir_y(30, _direction);
}

//limiting the timer
time_attack = clamp(time_attack, 0, 5);

if(advancing && time_attack > 0){
    time_attack--;

    var _advance_speed = 0.2;
    var __nx = lerp(x, advance_x, _advance_speed);
    var __ny = lerp(y, advance_y, _advance_speed);

    var _collision_wall = place_meeting(__nx, __ny, obj_wall);
    var _collision_enemy = place_meeting(__nx, __ny, obj_enemy_par);

    if(!_collision_wall && !_collision_enemy){
        x = __nx;
        y = __ny;
    }else{
        advancing = false;
    }

    // Finalizar movimento ao atingir o ponto final
    if(point_distance(x, y, advance_x, advance_y) < 1){
        advancing = false;
    }
}
#endregion

#region power activation

#region hability activation
area = clamp(area, 0, global.hab_range);

if(global.energy >= global.cost_hab){
    global.can_attack = true;    
}

if(keyboard_check(ord("R")) && global.can_attack){

        global.slashing = true;
        global.slow_motion = true;
    

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


    if(keyboard_check_released(ord("R"))){
        global.energy -= global.cost_hab;  
        global.slow_motion = false;
        global.slashing = false;
    }
    
    
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
            }
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