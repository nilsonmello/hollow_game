if(alarm[0] <= 0){
	layer_set_visible("screenshake_damaging_enemies", 0)
	instance_destroy();	
}

switch(global.combo){
	case 1:
		image_index = 0;
	break;
	
	case 2:
		image_index = 1;
	break;
	
	case 3:
		image_index = 2;
	break;
}