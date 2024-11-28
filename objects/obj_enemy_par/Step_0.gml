#region enemies slow motion
if(global.slashing){
	move_speed = lerp(move_speed, .2, .07);
	vel = .1;
	state = ENEMY_STATES.HIT;
	timer_hit = 120;
}else{
	move_speed = lerp(move_speed, 1.3, .07);
	vel = 12;
}
#endregion

#region hit alpha
//decreases the hit_alpha value
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion

if(stamina_at <= 0){
		knocked = true;
}

stamina_at = clamp(stamina_at, 0, stamina_t);

show_debug_message(stamina_at)