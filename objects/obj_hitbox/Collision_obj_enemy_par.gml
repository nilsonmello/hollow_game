if(!hitted){
	with(other){
	    if(hit == true && !attacking && alarm[1] <= 0){ 
	        combo_visible++;
			part_particles_create(particle_hit, x, y, particle_slash, 1);
			
			escx = 1.5;
			escy = 1.5;
			
			hit_alpha = 1;
	        switch(combo_visible){
	            case 1:
	            case 2:
				layer_set_visible("screenshake_damaging_enemies", 1);
	                state = ENEMY_STATES.HIT;
	                vida -= other.dmg;
	                timer_hit = 5;
					emp_timer = 5;
                    
	                emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
	                emp_veloc = 6;
	                hit = false;
                    
	                alarm[1] = 10;
	                alarm[2] = 30;
	            break;

	            case 3:
					layer_set_visible("screenshake_damaging_enemies", 1);
	                state = ENEMY_STATES.KNOCKED;
	                vida -= other.dmg;
	                knocked_time = 10;
					emp_timer = 5;
					
	                emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
	                emp_veloc = 8;
	                combo_visible = 0;
	                hit = false;
                    
	                alarm[1] = 10;
	                alarm[2] = 30;
	            break;
	        }
	    }
	}
hitted = true;
}