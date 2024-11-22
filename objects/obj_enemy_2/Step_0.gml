#region state machine

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
		
        part_particles_create(obj_particle_setup.particle_hit, x, y, obj_particle_setup.particle_slash, 1);

        vel_h = lengthdir_x(emp_veloc, emp_dir);
        vel_v = lengthdir_y(emp_veloc, emp_dir);

		enemy_colide();

        x += vel_h;
        y += vel_v;
		
        layer_set_visible("screenshake_damaging_enemies", 0);
	break;
	#endregion

	#region knocked
    case ENEMY_STATES.KNOCKED:
		knocked_time--;
	
        if(knocked_time > 0){
            if (hit){
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
	
    #region waiting for attack
    case ENEMY_STATES.WAITING:
		attacking = true;
		atk_wait--;
	
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

	        var _advance_dir = 10;
	        var _advance_distance = 2;

	        var _box_x = x + lengthdir_x(_advance_dir, atk_direction);
	        var _box_y = y + lengthdir_y(_advance_dir, atk_direction);

	        if(atk_time > 18 && !created_hitbox){
	            var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox_enemy);
	            _box.image_angle = atk_direction;
	            _box.sprite_index = spr_hitbox_3;
	            _box.dmg = 2;

	            created_hitbox = true;
	        }

	        var _advance_x = x + lengthdir_x(_advance_distance, atk_direction);
	        var _advance_y = y + lengthdir_y(_advance_distance, atk_direction);

	        var _advance_speed = 2;
	        var __new_x = lerp(x, _advance_x, _advance_speed);
	        var __new_y = lerp(y, _advance_y, _advance_speed);

	        if(!place_meeting(__new_x, __new_y, obj_player) && !place_meeting(__new_x, __new_y, obj_wall)){
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
	        state = ENEMY_STATES.RECOVERY;
	        count = 0;
			
	        var _away = point_direction(obj_player.x, obj_player.y, x, y);
	        esc_x = x + lengthdir_x(50, _away);
	        esc_y = y + lengthdir_y(50, _away);
	    }
    break;
	#endregion
	
	#region recovery from last attack
	case ENEMY_STATES.RECOVERY:
		if(recovery == 0){
			center_x = obj_player.x;
			center_y = obj_player.y;
			
		    radius = point_distance(x, y, center_x, center_y);
		    angle = point_direction(center_x, center_y, x, y);

		    r_speed = 0.6;
		    move_direction = choose(-1, 1);
			
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

			if(point_distance(x, y, esc_x, esc_y) < 2){
				recovery = 1;

				radius = point_distance(x, y, center_x, center_y);
				angle = point_direction(center_x, center_y, x, y);
				
				r_speed = .6;
				move_direction = choose(-1, 1)
			}
		}else if(recovery == 1){
			
		    angle += r_speed * move_direction;

		    var _new_x = center_x + lengthdir_x(radius, angle);
		    var _new_y = center_y + lengthdir_y(radius, angle);

		    if(!place_meeting(_new_x, _new_y, obj_player) && !place_meeting(_new_x, _new_y, obj_wall)){
		        x = _new_x;
		        y = _new_y;
		    }else{
		        r_speed = 0;
		    }

	        if(time_per_attacks > 0){
	            time_per_attacks--;
	        }else{
	            state = ENEMY_STATES.CHOOSE;
				center_x = 0;
				center_y = 0;
				angle = 0;

				radius = 0;
				r_speed = 0;

				recovery = 0;
				esc_x = 0;
				esc_y = 0;
				move_direction = 0;
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
        instance_destroy();
    break;
	#endregion
}
#endregion