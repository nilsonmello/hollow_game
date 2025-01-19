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

//mouse alligned to the enemy
if (alligned){
    draw_sprite(spr_quad, frame, x, y);
}else{
    frame = 0;
}

//escala da barra
var _escx = stamina_at;

//desenho da barra de energia
draw_sprite_stretched(spr_bar, 0, x - 7, y + 20, _escx, 1.5);

draw_line(x - 8, y - 8, obj_player.x, obj_player.y);
draw_line(x - 8, y + 8, obj_player.x, obj_player.y);
draw_line(x + 8, y - 8, obj_player.x, obj_player.y);
draw_line(x + 8, y + 8, obj_player.x, obj_player.y);