#region sprite draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
#endregion

if(global.parry_timer > 0){
    draw_sprite(spr_dust, 0, x, y + 10);
}