if(global.slashing > 0 && distance_to_object(obj_player) < 150){
	move_speed = lerp(move_speed, .2, .07);
	vel = .1;
}else{
	move_speed = lerp(move_speed, 1.3, .07);
	vel = 11;
}

hit_alpha = lerp(hit_alpha, 0, 0.1);