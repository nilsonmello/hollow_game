function search_for_player(){
	var _dis = distance_to_object(obj_player);
	
	if(alarm[5] <= 0){
	
		if(_dis <= alert_dis or alert) and (_dis > attack_dis){
			alert = true;
		
			if(calc_path_timer-- <= 0){
				var _found_player = mp_grid_path(global.mp_grid, path, x, y, obj_player.x, obj_player.y, choose(0, 1));

				calc_path_timer = calc_path_delay;
	
				if(_found_player){
					path_start(path, move_speed, path_action_stop, false);
				}
			}
		}else{
			if(_dis <= attack_dis){
				path_end();	
				atk_wait = 40;
				state = ENEMY_STATES.WAITING;
			}
		}
	}
}