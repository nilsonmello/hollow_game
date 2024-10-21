#region self e hit
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);

if(hit_alpha > 0){
	
	gpu_set_fog(true, hit_color,0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, hit_alpha);
	gpu_set_fog(false, hit_color,0, 0);
}
#endregion

if(alarm[3] > 20){
	draw_sprite(spr_warning, 3, x, y - 20);	
}

if(state == ENEMY_STATES.KNOCKED){
	draw_sprite(spr_warning, 2, x - 20, y);
}

switch(combo_visible){
	case 1:
		draw_sprite(spr_warning, 0, x - 20, y);
	break;
	
	case 2:
		draw_sprite(spr_warning, 1, x - 20, y);
	break;
}

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