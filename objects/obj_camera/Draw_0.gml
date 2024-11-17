#region shader set and reset
if(global.slashing){

if(!surface_exists(surf_dark)){
    surf_dark = surface_create(display_get_width(), display_get_height());
}

surface_set_target(surf_dark);
draw_clear_alpha(c_black, 0);
draw_self();
surface_reset_target();

shader_set(sh_shd_vignette);

var _dk_uni = shader_get_uniform(sh_shd_vignette, "darkness");
shader_set_uniform_f(_dk_uni, darkness_value);

draw_surface(surf_dark, 0, 0);

shader_reset();
}
#endregion