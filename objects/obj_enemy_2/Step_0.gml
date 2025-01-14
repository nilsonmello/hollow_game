#region state machine
size = 2;
#region life and cooldown
event_inherited();
var _line_wall = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false);

if (vida <= 0){
    state = ENEMY_STATES.DEATH;
}

if(time_per_attacks > 0){
    time_per_attacks--;
}
#endregion

switch(state){
	
    #region choose
    case ENEMY_STATES.CHOOSE:
		state_time = irandom_range(70, 120);
		state = choose(ENEMY_STATES.MOVE, ENEMY_STATES.IDLE);
		
		x_point = irandom_range(0, room_width);
		y_point = irandom_range(0, room_height);
    break;
	#endregion	
	
	#region idle
    case ENEMY_STATES.IDLE:
		state_time--;
		
        check_for_player(150);
		
		if(state_time <= 0){
			state = ENEMY_STATES.CHOOSE;
		}
    break;
	#endregion	
	
    #region movement
    case ENEMY_STATES.MOVE:
		state_time--;
			
		var _dir = point_direction(x, y, x_point, y_point);
			
		vel_h = lengthdir_x(1, _dir);
		vel_v = lengthdir_y(1, _dir);

		enemy_colide();
		
		if(distance_to_point(x_point, y_point) > vel_h and distance_to_point(x_point, y_point) > vel_v){
			x += vel_h;
			y += vel_v;
		}else{
			state = ENEMY_STATES.CHOOSE;	
		}
		
		check_for_player(150);
		
		if(state_time <= 0){
			state = ENEMY_STATES.CHOOSE;
		}
    break;
	#endregion

	#region follow player
	case ENEMY_STATES.FOLLOW:
		var _dir_m = point_direction(x, y, obj_player.x, obj_player.y);
			
		vel_h = lengthdir_x(1, _dir_m);
		vel_v = lengthdir_y(1, _dir_m);

		enemy_colide();
		
		x += vel_h;
		y += vel_v;

		if(distance_to_object(obj_player) < 80){
			state = ENEMY_STATES.WAITING;
			atk_wait = 60;
		}
	break;
	#endregion
	
	#region hit
    case ENEMY_STATES.HIT:
		attacking = false;
		warning = false;
	
		timer_hit_at++;
		time_per_attacks = 40;

        if (hit){
            hit = false;
        }
		
		center_x = 0;
		center_y = 0;
		angle = 0;

		radius = 0;
		r_speed = 0;

		recovery = 0;
		esc_x = 0;
		esc_y = 0;
		move_direction = 0;
		
		if(emp_timer > 0){
			emp_timer--;
	        vel_h = lengthdir_x(emp_veloc, emp_dir);
	        vel_v = lengthdir_y(emp_veloc, emp_dir);

	        emp_veloc = lerp(emp_veloc, 0, .01);
		
			enemy_colide();

	        x += vel_h;
	        y += vel_v;
		}
		
		if(timer_hit_at >= timer_hit){
			state = ENEMY_STATES.IDLE
			hit = true;
			attack = false;
			timer_hit_at = 0;
		}
	break;
	#endregion

	#region knocked
    case ENEMY_STATES.KNOCKED:

		stamina_at++;
		
        if(stamina_at < stamina_t){
            if (hit){
                hit = false;
                alarm[1] = 15;
            }

		if(emp_timer > 0){
			emp_timer--;
	        vel_h = lengthdir_x(emp_veloc, emp_dir);
	        vel_v = lengthdir_y(emp_veloc, emp_dir);

	        emp_veloc = lerp(emp_veloc, 0, .01);
		
			enemy_colide();

	        x += vel_h;
	        y += vel_v;
		}
	
		if(energy_count < max_energy){
			var _exp = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
			_exp.direction = irandom(360);
			_exp.speed = 2;
			
			energy_count++;
		}
		
        }else{
			state = ENEMY_STATES.IDLE
			hit = true;
			attack = false;
			knocked = false;
		}
    break;
	#endregion
	
    #region waiting for attack
    case ENEMY_STATES.WAITING:
		attacking = true;
		atk_wait--;
		
		enemy_colide();
		
        if(atk_wait <= 0){
            state = ENEMY_STATES.ATTACK;
            atk_time = 30;
            atk_direction = point_direction(x, y, obj_player.x, obj_player.y);
        }else{
            warning = true;
        }
    break;
    #endregion
	
	#region attack
	case ENEMY_STATES.ATTACK:
		if(!variable_instance_exists(id, "created_hitbox")){
	        created_hitbox = false;
	    }

	    if(atk_time <= 0){
	        atk_cooldown = 10;
	        count++;
	        created_hitbox = false;
	    }

	    if(atk_cooldown >= 0){
	        atk_cooldown--;
	        atk_time = 20;
	    }

	    if(!has_attacked && atk_time > 0 && atk_cooldown <= 0){
	        atk_time--;
	        warning = false;
            enemy_attack();
	        var _advance_distance = 2;

	        var _advance_x = x + lengthdir_x(_advance_distance, atk_direction);
	        var _advance_y = y + lengthdir_y(_advance_distance, atk_direction);

	        var _advance_speed = 2;
	        var __new_x = lerp(x, _advance_x, _advance_speed);
	        var __new_y = lerp(y, _advance_y, _advance_speed);

	        if(!place_meeting(__new_x, __new_y, obj_player) && !place_meeting(__new_x, __new_y, obj_wall) && !place_meeting(__new_x, __new_y, obj_enemy_par) && !place_meeting(__new_x, __new_y, obj_ambient)){
	            x = __new_x;
	            y = __new_y;
	        }else{
	            atk_time = 0;
	        }
	    }

	    if(has_attacked == true){
	        has_attacked = false;
	    }

	    if(count > 1){
	        attacking = false;
	        time_per_attacks = 250;
	        state = ENEMY_STATES.MOVE;
	        count = 0;
			
			var _dist = distance_to_object(obj_player);
			
	        var _away = point_direction(obj_player.x, obj_player.y, x, y);
	        esc_x = x + lengthdir_x(_dist, _away);
	        esc_y = y + lengthdir_y(_dist, _away);
	    }
    break;
	#endregion
	
	//#region recovery from last attack
	//case ENEMY_STATES.RECOVERY:

	//break;
	//#endregion

	#region death
    case ENEMY_STATES.DEATH:
        part_particles_create(particle_system_explosion, x, y, particle_circle, 1); 
        part_particles_create(particle_system_explosion, x, y, particle_explosion, 8); 
        part_particles_create(particle_system_explosion, x, y, particle_explosion_2, 8); 
        
        var _chances = irandom(2);
        
        if(_chances == 2){
            repeat(6){
                var _exp = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
                _exp.direction = irandom(360);
                _exp.speed = 2;
            }
        }
        instance_destroy();
    break;
	#endregion
}
#endregion