//weapon custom function to colide with enemies
custom_function = function(_custom_id){}

coliding_walls = function(_custom_id){}


part_sys = part_system_create();
part_type = part_type_create();

part_type_shape(part_type, pt_shape_pixel);
part_type_size(part_type, 0.3, 0.5, 0.05, 0);
part_type_color1(part_type, c_white);
part_type_alpha3(part_type, 1, 0.5, 0);
part_type_life(part_type, 15, 30);
part_type_speed(part_type, 2, 3, 0, 0);

part_type_direction(part_type, 0, 360, 0, 0);