//inherted event
event_inherited();

//switch for the enemy life
switch(vida){
	case 6:
		draw_sprite(spr_life_enemy_2, 0, x, y + 15);
	break;
    
    case 5:
        draw_sprite(spr_life_enemy_2, 1, x, y + 15);
    break;

    case 4:
        draw_sprite(spr_life_enemy_2, 2, x, y + 15);
    break;
    
    case 3:
        draw_sprite(spr_life_enemy_2, 3, x, y + 15);
    break;
    
    case 2:
        draw_sprite(spr_life_enemy_2, 4, x, y + 15);
    break;
    
    case 1:
        draw_sprite(spr_life_enemy_2, 5, x, y + 15);
    break;
}