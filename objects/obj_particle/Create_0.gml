//yellow particle
part_system = part_system_create();
part_emitter = part_emitter_create(part_system);
part_type = part_type_create();

color_1 = make_color_rgb(247, 246, 49);

part_emitter_region(part_system, part_emitter, 0, display_get_width(), 0, display_get_height(), ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(part_system, part_emitter, part_type, 8);

part_type_alpha3(part_type, 0, 1, 0);
part_type_color1(part_type,  color_1);
part_type_life(part_type, 200, 250);
part_type_scale(part_type, 1, 1);
part_type_gravity(part_type, 0.001, 270);
part_system = part_system_create();

//orange particle
part_emitter_2 = part_emitter_create(part_system);
part_type_2 = part_type_create();

color_2 = make_color_rgb(255, 128, 0);

part_emitter_region(part_system, part_emitter_2, 0, display_get_width(), 0, display_get_height(), ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(part_system, part_emitter_2, part_type_2, 8);

part_type_alpha3(part_type_2, 0, 1, 0);
part_type_color1(part_type_2,  color_2);
part_type_life(part_type_2, 200, 250);
part_type_scale(part_type_2, 1, 1);
part_type_gravity(part_type_2, 0.001, 270);
part_type_direction(part_type_2, 180, 180, 1, 0);
part_type_direction(part_type_2, 180, 180, 1, 0); 