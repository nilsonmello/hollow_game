//inherted event
event_inherited();

//switch for the enemy life
switch(vida){
	case 3:
		draw_sprite(spr_life_enemy_1, 0, x, y + 15);
	break;
	
	case 2:
		draw_sprite(spr_life_enemy_1, 1, x, y + 15);
	break;
	
	case 1:
		draw_sprite(spr_life_enemy_1, 2, x, y + 15);
	break;
}