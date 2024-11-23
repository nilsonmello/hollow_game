if(global.slashing and distance_to_object(obj_player) < global.hab_range - 20){
	move_speed = lerp(move_speed, .2, .07);
	vel = .1;
	state = ENEMY_STATES.IDLE;
}else{
	move_speed = lerp(move_speed, 1.3, .07);
	vel = 12;
}

hit_alpha = lerp(hit_alpha, 0, 0.1);