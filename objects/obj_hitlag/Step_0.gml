tempo--;

if(tempo > 0){
	game_set_speed(spd_atual, gamespeed_fps)
}else{
	game_set_speed(60, gamespeed_fps)	
	instance_destroy();
}