#region state machine

#region variables and timers
event_inherited();

var _line_wall = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false);

if (vida <= 0){
    state = ENEMY_STATES.DEATH;
}
if (time_per_attacks > 0){
    time_per_attacks--;
}
if (state_cooldown  > 0){
    state_cooldown--;
}
#endregion

#region state machine
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
		
		if(distance_to_object(obj_player) < 150 && time_per_attacks <= 0){
			if(_line_wall){
				return false;
			}
			if(state_cooldown > 0){
				return false;
			}
			state = ENEMY_STATES.FOLLOW
		}
		
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
		
		if(distance_to_object(obj_player) < 200 && tiro <= 0){
			if(_line_wall){
				return false;
			}
			if(state_cooldown > 0){
				return false;
			}
			state = ENEMY_STATES.FOLLOW;
		}
		
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

		if(distance_to_object(obj_player) < 100){
			state = ENEMY_STATES.ATTACK;
			state_cooldown = 100;
		}	
	break;
	#endregion

	#region hit
    case ENEMY_STATES.HIT:
		attacking = false;
		warning = false;
		
		timer_hit_at++;
		time_per_attacks = 40;
		
		if(emp_timer > 0){
			emp_timer--;
			
	        vel_h = lengthdir_x(emp_veloc, emp_dir);
	        vel_v = lengthdir_y(emp_veloc, emp_dir);

	        emp_veloc = lerp(emp_veloc, 0, .01);
		
			enemy_colide();

	        x += vel_h;
	        y += vel_v;
		}
        layer_set_visible("screenshake_damaging_enemies", 0);
		
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
	    layer_set_visible("screenshake_damaging_enemies", 0);
	    stamina_at += .5;

	    if (stamina_at < stamina_t){
	        if (hit){
	            hit = false;
	            alarm[1] = 0;
	        }

        if (emp_timer > 0){
            emp_timer--;
            vel_h = lengthdir_x(emp_veloc, emp_dir);
            vel_v = lengthdir_y(emp_veloc, emp_dir);

            emp_veloc = lerp(emp_veloc, 0, .01);

            enemy_colide();

            x += vel_h;
            y += vel_v;
        }

        if (energy_count < max_energy){
            var _exp = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
            _exp.direction = irandom(360);
            _exp.speed = 2;

            energy_count++;
        }

    }else{
        state = ENEMY_STATES.IDLE;
        hit = true;
        attack = false;
        knocked = false;
    }
break;
#endregion

	#region attack
	case ENEMY_STATES.ATTACK:
		with(my_weapon){
			alvo_x = obj_player.x;
			alvo_y = obj_player.y;
			current_weapon.shoot(weapon_x, weapon_y);
			recoil_gun = 12;
		}
		state = ENEMY_STATES.RECOVERY;
	break;
	#endregion

	#region recovery
	case ENEMY_STATES.RECOVERY:
		var _dist_r = 180;
		var _dir_r = point_direction(obj_player.x, obj_player.y, x, y);
		
		var _x = x +lengthdir_x(_dist_r, _dir_r);
		var _y = y +lengthdir_y(_dist_r, _dir_r);
		
		if(!collision_line(x, y, _x, _y, obj_wall, true, false)){
			x += lengthdir_x(2, _dir_r);
			y += lengthdir_y(2, _dir_r);
		}else{
			var _ld = _dir_r + irandom_range(-45, 45);
			
			x += lengthdir_x(2, _ld);
			y += lengthdir_y(2, _ld);
			
			if(distance_to_point(_x, _y < 10)){
				state = ENEMY_STATES.MOVE;	
			}
		}
	break;
	#endregion

	#region death
    case ENEMY_STATES.DEATH:
        part_particles_create(particle_system_explosion, x, y, particle_circle, 1); 
        part_particles_create(particle_system_explosion, x, y, particle_explosion, 8); 
        part_particles_create(particle_system_explosion, x, y, particle_explosion_2, 8); 

        layer_set_visible("screenshake_damaging_enemies", 0);
        
        var _chances = irandom(2);
        
        if(_chances == 2){
            repeat(6){
                var _exp = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
                _exp.direction = irandom(360);
                _exp.speed = 2;
            }
        }
        instance_destroy(my_weapon);
        instance_destroy();
    break;
	#endregion
}
#endregion

#endregion

#region weapon movement
with(my_weapon){
	alvo_x = obj_player.x;
	alvo_y = obj_player.y;
}
#endregion