if(alarm[0] > 1){
    raio = lerp(raio, .6, .1);
}else{
    raio = lerp(raio, 1, .1);
}

if(!obj_player.can_take_dmg && !global.slashing){
    shader_set(sh_shd_take_dmg);
    shader_set_uniform_f(shader_get_uniform(sh_shd_take_dmg, "radius"), raio);
    shader_set_uniform_f(shader_get_uniform(sh_shd_take_dmg, "smooth"), leveza);

    draw_sprite(spr_take_dmg, 0, 0, 0);

    shader_reset();
}