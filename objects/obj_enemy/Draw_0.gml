event_inherited();

switch(vida){
	case 3:
		draw_sprite(spr_warning, 9, x, y + 15);
	break;
	
	case 2:
		draw_sprite(spr_warning, 10, x, y + 15);
	break;
	
	case 1:
		draw_sprite(spr_warning, 11, x, y + 15);
	break;
}