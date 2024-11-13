event_inherited();

if (vida <= 0){
    state = ENEMY_STATES.DEATH;
}

switch(state){
    case ENEMY_STATES.MOVE:
        script_execute(search_for_player);
        break;

    case ENEMY_STATES.HIT:
        if (hit){
            hit = false;
            alarm[1] = 80;
        }
        part_particles_create(obj_particle_setup.particle_hit, x, y, obj_particle_setup.particle_slash, 1);

        vel_h = lengthdir_x(emp_veloc, emp_dir);
        vel_v = lengthdir_y(emp_veloc, emp_dir);

        emp_veloc = lerp(emp_veloc, 0, .01);
		
		if(place_meeting(x + vel_h, y, obj_wall)){
			while(!place_meeting(x + sign(vel_h), y, obj_wall)){
				x  = x + sign(vel_h);
			}
			vel_h = 0;	
		}
		if(place_meeting(x, y + vel_v, obj_wall)){
			while(!place_meeting(x, y + sign(vel_v), obj_wall)){
				y  = y + sign(vel_v);
			}
			vel_v = 0;	
		}

        x += vel_h;
        y += vel_v;
		
        layer_set_visible("screenshake_damaging_enemies", 0);
        break;

    case ENEMY_STATES.KNOCKED:
        if (alarm[7] > 0){
            if (hit) {
                hit = false;
                alarm[1] = 15;
            }

            vel_h = lengthdir_x(emp_veloc, emp_dir);
            vel_v = lengthdir_y(emp_veloc, emp_dir);

            emp_veloc = lerp(emp_veloc, 0, .01);

			if(place_meeting(x + vel_h, y, obj_wall)){
				while(!place_meeting(x + sign(vel_h), y, obj_wall)){
					x  = x + sign(vel_h);
				}
				vel_h = 0;	
			}
			if(place_meeting(x, y + vel_v, obj_wall)){
				while(!place_meeting(x, y + sign(vel_v), obj_wall)){
					y  = y + sign(vel_v);
				}
				vel_v = 0;	
			}

            x += vel_h;
            y += vel_v;

            alarm[0] = 15;

            repeat(1){
                var _exp = instance_create_layer(x, y, "Instances", obj_energy_dust);
                _exp.direction = irandom(360);
                _exp.speed = 2;
            }
        }
        break;

    case ENEMY_STATES.ATTACK:
        attacking = true;
        if(alarm[3] <= 0){
            if(alarm[4] > 0){
                vel = lerp(vel, 0, 0.2);

                vel_h = lengthdir_x(vel, dire);
                vel_v = lengthdir_y(vel, dire);
				
				if(place_meeting(x + vel_h, y, obj_wall)){
					while(!place_meeting(x + sign(vel_h), y, obj_wall)){
						x  = x + sign(vel_h);
					}
					vel_h = 0;	
				}
				if(place_meeting(x, y + vel_v, obj_wall)){
					while(!place_meeting(x, y + sign(vel_v), obj_wall)){
						y  = y + sign(vel_v);
					}
					vel_v = 0;	
				}
				
                x += vel_h;
                y += vel_v;

                if(!has_attacked){
                    var _direction = point_direction(x, y, obj_player.x, obj_player.y);
                    
                    var _attack_range_x = 20;
                    var _attack_range_y = 14;
                    var _attack_offset = 2;

                    var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range_x / 2;
                    var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range_y / 2;
                    var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range_x / 2;
                    var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range_y / 2;

                    if(collision_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, obj_player, false, true)) {
                        with(obj_player){
                            if(can_take_dmg){
                                state = STATES.HIT;
                                alarm[5] = 10;
                                hit_alpha = 1;
                                emp_dir = point_direction(other.x, other.y, x, y);
                                emp_veloc = 6;
                                global.life_at -= 2;
                                can_take_dmg = false;
                                alarm[6] = 60;
                                obj_control.alarm[0] = 60;
                            }
                        }
                        has_attacked = true;
                    }
                }
            }else{
                state = ENEMY_STATES.MOVE;
                attacking = false;
                has_attacked = false;
                alarm[5] = 80;
            }
        }
        break;

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
}