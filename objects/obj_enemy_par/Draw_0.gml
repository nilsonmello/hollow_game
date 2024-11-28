#region self and sprites
//enemie sprite
draw_sprite_ext(sprite_index, image_index, x, y, escx, escy, 0, c_white, 1);

//hit effect
if(hit_alpha > 0){
	gpu_set_fog(true, hit_color,0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y, escx, escy, 0, c_white, hit_alpha);
	gpu_set_fog(false, hit_color,0, 0);
}

//enemy x and y scale
escx = lerp(escx, image_xscale, 0.2);
escy = lerp(escy, image_yscale, 0.2);

////warning advice
if(warning){
	draw_sprite(spr_warning, 0, x, y - 30);
}
#endregion

var _wid = stamina_at div 5

draw_sprite_stretched(spr_bar_stamina, 0, x - 10, y + 20, _wid, 3);