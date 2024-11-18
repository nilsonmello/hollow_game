#region self e hit
draw_sprite_ext(sprite_index, image_index, x, y, escx, escy, 0, c_white, 1);

if(hit_alpha > 0){
	
	gpu_set_fog(true, hit_color,0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y, escx, escy, 0, c_white, hit_alpha);
	gpu_set_fog(false, hit_color,0, 0);
}
#endregion

escx = lerp(escx, image_xscale, 0.2);
escy = lerp(escy, image_yscale, 0.2);

if(warning){
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


