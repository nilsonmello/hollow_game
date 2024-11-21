#region state machine
event_inherited();

var _line_wall = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false);

if (vida <= 0){
    state = ENEMY_STATES.DEATH;
}
if (time_per_attacks > 0){
    time_per_attacks--;
}

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
		
		if(distance_to_object(obj_player) < 80 && time_per_attacks <= 0){
			if(_line_wall){
				return false;
			}
			state = ENEMY_STATES.WAITING;
			atk_wait = 60;
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
		
		if(distance_to_object(obj_player) < 80 && time_per_attacks <= 0){
			if(_line_wall){
				return false;
			}
			state = ENEMY_STATES.WAITING;
			atk_wait = 60;
		}
		
		if(state_time <= 0){
			state = ENEMY_STATES.CHOOSE;
		}
    break;
	#endregion

	#region hit
    case ENEMY_STATES.HIT:
        if(hit){
            hit = false;
        }
        part_particles_create(obj_particle_setup.particle_hit, x, y, obj_particle_setup.particle_slash, 1);

        vel_h = lengthdir_x(emp_veloc, emp_dir);
        vel_v = lengthdir_y(emp_veloc, emp_dir);

        emp_veloc = lerp(emp_veloc, 0, .01);
		
		enemy_colide();

        x += vel_h;
        y += vel_v;
		
        layer_set_visible("screenshake_damaging_enemies", 0);
	break;
	#endregion

	#region knocked
    case ENEMY_STATES.KNOCKED:
	knocked_time--;
	layer_set_visible("screenshake_damaging_enemies", 0);
        if(knocked_time > 0){
            if(hit){
                hit = false;
                alarm[1] = 15;
            }

            vel_h = lengthdir_x(emp_veloc, emp_dir);
            vel_v = lengthdir_y(emp_veloc, emp_dir);

            emp_veloc = lerp(emp_veloc, 0, .01);

			enemy_colide();

            x += vel_h;
            y += vel_v;

            alarm[0] = 15;

            repeat(1){
                var _exp = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
                _exp.direction = irandom(360);
                _exp.speed = 2;
            }
        }
    break;
	#endregion
	
	#region waiting attack
	case ENEMY_STATES.WAITING:
		attacking = true;
		if(time_per_attacks <= 0){
			warning = true;
			atk_wait--;
		
		    if(atk_wait <= 0){
		        atk_time = 15;
		        state = ENEMY_STATES.ATTACK;
				dire = point_direction(x, y, obj_player.x, obj_player.y);
		    }
		}else{
			state = ENEMY_STATES.MOVE;
		}
	break;
	#endregion

	#region attack
	case ENEMY_STATES.ATTACK:
	    atk_time--;
		warning = false;
		
	    if(atk_time > 0){
	        vel = lerp(vel, 0, 0.5);
	        vel_h = lengthdir_x(vel, dire);
	        vel_v = lengthdir_y(vel, dire);
            
	        enemy_colide();

	        x += vel_h;
	        y += vel_v;

	        if(!has_attacked){
	            var _direction = point_direction(x, y, obj_player.x, obj_player.y);
	            var _attack_range = 18;
	            var _attack_offset = 2;

	            var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range / 2;
	            var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range / 2;
	            var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range / 2;
	            var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range / 2;

	            if(collision_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, obj_player, false, true)){
	                with(obj_player){
	                    if(can_take_dmg){
	                        if(!global.parry){
	                            state = STATES.HIT;
	                            alarm[5] = 10;
	                            hit_alpha = 1;
	                            emp_dir = point_direction(other.x, other.y, x, y);
	                            emp_veloc = 6;
	                            global.life_at -= 2;

	                            can_take_dmg = false;
	                            alarm[6] = 60;
	                            obj_control.alarm[0] = 60;

	                            with(other){
									state = ENEMY_STATES.RECOVERY;
									attacking = false;
									time_per_attacks = 110;
									knocked_time = 20;
									has_attacked = false;
									recover_time = 60;
			
									var _away = point_direction(obj_player.x, obj_player.y, x, y);
			
									esc_x = x + lengthdir_x(50, _away);
									esc_y = y + lengthdir_y(50, _away);
	                            }
	                        }else{
	                            layer_set_visible("screenshake_damaging_enemies", 1);

	                            with(other){
	                                state = ENEMY_STATES.KNOCKED;
	                                emp_dir = point_direction(obj_player.x, obj_player.y, other.x, other.y);
	                                emp_veloc = 6;
	                                hit = true;
	                                attacking = false;
										
	                                alarm[0] = 5;
	                                alarm[2] = 30;
	                                time_per_attacks = 110;
									knocked_time = 30;
	                            }
	                        }
	                    }
	                }
	                has_attacked = true;
	            }
	        }
	    }else{
	        state = ENEMY_STATES.RECOVERY;
	        attacking = false;
	        has_attacked = false;
			time_per_attacks = 110;
			recover_time = 60;
			
			var _away = point_direction(obj_player.x, obj_player.y, x, y);
			
			esc_x = x + lengthdir_x(50, _away);
			esc_y = y + lengthdir_y(50, _away);
	    }
	    break;
	#endregion

	#region recovery
	case ENEMY_STATES.RECOVERY:
	recover_time--;
	if(recover_time > 0){
		var _move_speed = 2;
		var _new_x = lerp(x, esc_x, 0.05);
		var _new_y = lerp(y, esc_y, 0.05);

			if(!place_meeting(_new_x, _new_y, obj_player) && !place_meeting(_new_x, _new_y, obj_wall)){
				x = _new_x;
				y = _new_y;
			}else{
				r_speed = 0;	
				state = ENEMY_STATES.MOVE;
			}
	}else{
		state = ENEMY_STATES.CHOOSE;
	}
	break;
	#endregion

	#region death
    case ENEMY_STATES.DEATH:
        part_particles_create(obj_particle_setup.particle_system_explosion, x, y, obj_particle_setup.particle_circle, 1); 
        part_particles_create(obj_particle_setup.particle_system_explosion, x, y, obj_particle_setup.particle_explosion, 8); 
        part_particles_create(obj_particle_setup.particle_system_explosion, x, y, obj_particle_setup.particle_explosion_2, 8); 

        layer_set_visible("screenshake_damaging_enemies", 0);
        
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

