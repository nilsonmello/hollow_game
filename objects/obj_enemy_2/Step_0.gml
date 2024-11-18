#region state machine
event_inherited();

if (vida <= 0){
    state = ENEMY_STATES.DEATH;
}

switch(state){
	
    #region movement
    case ENEMY_STATES.MOVE:
        if(distance_to_object(obj_player) < 80 && alarm[5] <= 0){
            state = ENEMY_STATES.WAITING;
            atk_wait = 60;
        }
    break;
	#endregion

	#region hit
    case ENEMY_STATES.HIT:
        if (hit){
            hit = false;
        }
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
        if (alarm[7] > 0){
            if (hit) {
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
		atk_wait--;
	
        if(atk_wait <= 0){
            state = ENEMY_STATES.ATTACK;
            atk_time = 20;
            atk_direction = point_direction(x, y, obj_player.x, obj_player.y);
        }else{
            warning = true;
        }
    break;
    #endregion
	
	#region attack
    case ENEMY_STATES.ATTACK:
        if(atk_time <= 0){
            atk_cooldown = 10;
            count++;
        }

        if(atk_cooldown >= 0){
            atk_cooldown--;
            atk_time = 20;
        }

        if (!has_attacked && atk_time > 0 && atk_cooldown <= 0) {
            atk_time--;
			warning = false;
            var _advance_dir = 30;
            var _advance_distance = 2;

            var _box_x = x + lengthdir_x(_advance_dir, atk_direction);
            var _box_y = y + lengthdir_y(_advance_dir, atk_direction);

            if (!instance_exists(obj_hitbox_enemy) && atk_time > 18) {
                var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox_enemy);
                _box.image_angle = atk_direction;
                _box.sprite_index = spr_hitbox_3;
                _box.dmg = 2;
            }

            var _advance_x = x + lengthdir_x(_advance_distance, atk_direction);
            var _advance_y = y + lengthdir_y(_advance_distance, atk_direction);

            var _advance_speed = 1.4;
            var __new_x = lerp(x, _advance_x, _advance_speed);
            var __new_y = lerp(y, _advance_y, _advance_speed);

            if (!place_meeting(__new_x, __new_y, obj_player) && !place_meeting(__new_x, __new_y, obj_wall)) {
                x = __new_x;
                y = __new_y;
            }else{
                atk_time = 0;
            }
        }

        if(has_attacked = true){
            has_attacked = false;
			
        }

        if (count > 1) {
            alarm[5] = 50;
            state = ENEMY_STATES.MOVE;
            count = 0;
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