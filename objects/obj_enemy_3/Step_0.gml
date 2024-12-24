#region state machine

#region variables and timers
event_inherited();

with(my_weapon){
    current_weapon = pistol
}

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
			state = ENEMY_STATES.ATTACK
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
        state_time = 50;
	break;
	#endregion

	#region recovery
	case ENEMY_STATES.RECOVERY:
        state_time--;
    
        var _total = 100;
        var _dir = point_direction(obj_player.x, obj_player.y, x, y);
        
        var _target_x = x + lengthdir_x(_total, _dir);
        var _target_y = y + lengthdir_y(_total, _dir);
        
        var _dist = 1;
        var _move_dir = point_direction(x, y, _target_x, _target_y);
        
        x += lengthdir_x(_dist, _move_dir);
        y += lengthdir_y(_dist, _move_dir);
    
        if(state_time <= 0){
            state = ENEMY_STATES.IDLE;    
        
        }
	break;
	#endregion

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