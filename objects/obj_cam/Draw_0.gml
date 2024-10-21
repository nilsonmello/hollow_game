if(global.slow_motion){
    darkness = lerp(darkness, .6, .1);
}else{
    darkness = lerp(darkness, 1, .1);
}

shader_set(shd_vignette);
shader_set_uniform_f(shader_get_uniform(shd_vignette, "darkness"), darkness);

draw_sprite(spr_vignette, 0, 0, 0);

shader_reset();