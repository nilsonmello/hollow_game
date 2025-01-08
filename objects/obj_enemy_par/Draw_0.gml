#region self and sprites
//enemie sprite
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);

//hit effect
if(hit_alpha > 0){
	gpu_set_fog(true, hit_color,0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, hit_alpha);
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

//bar width
var _wid = stamina_at div 5

//drawing bar stretched
draw_sprite_stretched(spr_bar_stamina, 0, x - 10, y + 20, _wid, 3);

if(line_mark){
    draw_sprite_ext(spr_sign, 2, x, y, 1, 1, rotation, c_white, 1);
}