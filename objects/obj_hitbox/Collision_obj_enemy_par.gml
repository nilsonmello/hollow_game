if(!hitted){
	with(other){
	    if(!attacking){ 
			
			switch(knocked){
				case 0:
					part_particles_create(particle_hit, x, y, particle_slash, 1);
			
					escx = 1.5;
					escy = 1.5;
					
					hit_alpha = 1;
			
					layer_set_visible("screenshake_damaging_enemies", 1);
				    state = ENEMY_STATES.HIT;
				    timer_hit = 5;
					emp_timer = 5;
                    
				    emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
				    emp_veloc = 6;
			        global.combo++;
					stamina_at -= 30;
				    alarm[2] = 30;
				break;
			
				case 1:
					escx = 1.5;
					escy = 1.5;
					
					hit_alpha = 1;
				
					layer_set_visible("screenshake_damaging_enemies", 1);
					state = ENEMY_STATES.KNOCKED;
					vida -= other.dmg;

					emp_timer = 5;
					
					emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
					emp_veloc = 8;
					combo_visible = 0;
					hit = false;
					global.combo++;
					alarm[1] = 10;
					alarm[2] = 30;
				break;
			}
	    }
	}
hitted = true;
}