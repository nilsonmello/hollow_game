randomize();

#region player shadow
particle_system = part_system_create_layer("Instance_particle", true);

particle_shadow = part_type_create();

part_type_sprite(particle_shadow, spr_player, 1, 0, 1);
part_type_size(particle_shadow, 1, 1, 0, 0);
part_type_life(particle_shadow, 25, 45);
part_type_alpha1(particle_shadow, 0.1);

var _red = make_color_rgb(51, 0, 25);
var _red_2 = make_color_rgb(255, 0, 127);
var _red_3 = make_color_rgb(255, 204, 229);

part_type_color3(particle_shadow, _red, _red_2, _red_3);
#endregion

#region walk particle
particle_system_dust = part_system_create();
particle_dust = part_type_create();

part_type_sprite(particle_dust, spr_dust, 0, 0, 0);
part_type_subimage(particle_dust, 0);
part_type_size(particle_dust, .2, .8, .001, 0)

part_type_direction(particle_dust, 0, 359, 0, 1);
part_type_speed(particle_dust, .1, .2, -0.004, 0);

part_type_life(particle_dust, 50, 70);
part_type_orientation(particle_dust, 0, 359, .1, 1, 0);
part_type_alpha3(particle_dust, 0.6, 0.4, 0.1);
#endregion

#region explosion particle
particle_system_explosion =  part_system_create();
particle_explosion = part_type_create();
particle_explosion_2 = part_type_create();

part_type_sprite(particle_explosion, spr_explosion, 0, 0, 0);
part_type_subimage(particle_explosion, 0);
part_type_size(particle_explosion, .2, .8, .001, 0)
part_type_color1(particle_explosion, c_gray)

part_type_direction(particle_explosion, 0, 359, 0, 1);
part_type_speed(particle_explosion, .1, .2, -0.004, 0);

part_type_life(particle_explosion, 50, 70);
part_type_orientation(particle_explosion, 0, 359, .1, 1, 0);
part_type_alpha3(particle_explosion, 0.6, 0.4, 0.1);

//second color
part_type_sprite(particle_explosion_2, spr_explosion, 0, 0, 0);
part_type_subimage(particle_explosion_2, 0);
part_type_size(particle_explosion_2, .2, .8, .001, 0)
part_type_color1(particle_explosion_2, c_dkgray)

part_type_direction(particle_explosion_2, 0, 359, 0, 1);
part_type_speed(particle_explosion_2, .1, .2, -0.004, 0);

part_type_life(particle_explosion_2, 50, 70);
part_type_orientation(particle_explosion_2, 0, 359, .1, 1, 0);
part_type_alpha3(particle_explosion_2, 0.6, 0.4, 0.1);
#endregion