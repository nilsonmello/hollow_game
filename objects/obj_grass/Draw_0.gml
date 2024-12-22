if (surface_exists(surface_grass)){
    shader_set(shd_grass);
    var uni = shader_get_uniform(shd_grass, "u_time")
    shader_set_uniform_f(uni, get_timer() / 1000000); 

    var tile = shader_get_uniform(shd_grass, "tile")
    shader_set_uniform_f(tile, room_height / grid_t); 

    draw_surface(surface_grass, 0, 0);
    shader_reset();
}else{
    surface_grass = surface_create(room_width, room_height);
}