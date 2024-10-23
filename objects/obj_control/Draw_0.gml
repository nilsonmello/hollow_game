//if(surface_exists(surf_dist)){
	
//    surface_set_target(surf_dist);
//    draw_clear_alpha(c_black, 0);

//    surface_reset_target();
	
//	if(global.slow_motion){
//	    darkness = lerp(darkness, 0, .1);
//	}else{
//	    darkness = lerp(darkness, 1, .1);
//	}

//	shader_set(sh_shd_vignette);
//	shader_set_uniform_f(shader_get_uniform(sh_shd_vignette, "darkness"), darkness);

//	draw_sprite(spr_vignette, 0, 0, 0);

//    draw_surface(surf_dist, 0, 0);
	
//    shader_reset();
//}


//if(surface_exists(surf_dist)){
	
//    surface_set_target(surf_dist);
//    draw_clear_alpha(c_black, 0);

//    surface_reset_target();
	
//	if(alarm[0] > 1){
//	    raio = lerp(raio, .6, .1);
//	}else{
//	    raio = lerp(raio, 1, .1);
//	}

//	if(!obj_player.can_take_dmg && !global.slashing){
//		shader_set(sh_shd_take_dmg);
		
//		shader_set_uniform_f(shader_get_uniform(sh_shd_take_dmg, "radius"), raio);
//		shader_set_uniform_f(shader_get_uniform(sh_shd_take_dmg, "smooth"), leveza);

//		draw_sprite(spr_take_dmg, 0, 0, 0);
//	}

//	draw_surface(surf_dist, 0, 0);
//	shader_reset();
//}


if (surface_exists(surf_dist)){
    surface_set_target(surf_dist);
    draw_clear_alpha(c_black, 0);


    if(global.slow_motion){
        darkness = lerp(darkness, 0, .1);
    }else{
        darkness = lerp(darkness, 1, .1);
    }

    shader_set(sh_shd_vignette);
    shader_set_uniform_f(shader_get_uniform(sh_shd_vignette, "darkness"), darkness);
    draw_sprite(spr_vignette, 0, 0, 0);

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
    }

    shader_reset();

    surface_reset_target();

    draw_surface(surf_dist, 0, 0);
}
