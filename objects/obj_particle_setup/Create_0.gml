randomize();

#region player shadow
particle_system = part_system_create_layer("Instance_particle", true);

particle_shadow = part_type_create();

part_type_sprite(particle_shadow, spr_player, 1, 0, 1);
part_type_size(particle_shadow, 1, 1, 0, 0);
part_type_life(particle_shadow, 25, 45);
part_type_alpha1(particle_shadow, 0.5);

var _red = make_color_rgb(53, 43, 66);
var _red_2 = make_color_rgb(67, 67, 106);
var _red_3 = make_color_rgb(75, 128, 202);

part_type_color3(particle_shadow, _red, _red_2, _red_3);
#endregion

#region walk particle

particle_system_dust = part_system_create_layer("Instance_particle", true);
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
particle_system_explosion  = part_system_create_layer("Instance_particle", true);
//first particle
particle_explosion = part_type_create();
//second particle
particle_explosion_2 = part_type_create();

//third particle
particle_circle = part_type_create();

//first
part_type_sprite(particle_explosion, spr_explosion, 0, 0, 0);
part_type_subimage(particle_explosion, 0);
part_type_size(particle_explosion, .4, .8, .001, 0)

var _color1 = make_color_rgb(33, 33, 35);
part_type_color1(particle_explosion, _color1);

part_type_direction(particle_explosion, 0, 359, 0, 1);
part_type_speed(particle_explosion, .5, 1, -.01, 0);

part_type_life(particle_explosion, 30, 50);
part_type_orientation(particle_explosion, 0, 359, .1, 1, 0);
part_type_alpha3(particle_explosion, 0.8, 1, 0.1);

//second
part_type_sprite(particle_explosion_2, spr_explosion, 0, 0, 0);
part_type_size(particle_explosion_2, .1, .2, .001, 0);

var _color2 = make_color_rgb(58, 56, 88);
part_type_color1(particle_explosion_2, _color2);

part_type_direction(particle_explosion_2, 0, 359, 0, 1);
part_type_speed(particle_explosion_2, 1.2, 1.5, -0.004, 0);

part_type_life(particle_explosion_2, 20, 30);
part_type_orientation(particle_explosion_2, 0, 359, .1, 1, 0);
part_type_alpha2(particle_explosion_2, 1, 0.1);

//third
part_type_sprite(particle_circle, spr_circle_outline, 1, 1, 1);
part_type_size(particle_circle, 1, 1, .01, 0);

var _color3 = make_color_rgb(100, 99, 101);
part_type_color1(particle_circle, _color1);

part_type_life(particle_circle, 20, 20);
part_type_alpha3(particle_circle, .2, .8, .1);
#endregion

#region hit particles
particle_hit  = part_system_create_layer("Instance_particle", true);
particle_slash = part_type_create();

part_type_sprite(particle_slash, spr_explosion, 0, 0, 0);
part_type_size(particle_slash, .3, .4, .001, 0);

part_type_color1(particle_slash, _color1);

part_type_direction(particle_slash, 0, 180, 1, 1);
part_type_speed(particle_slash, .8, 1, -0.004, 0);

part_type_life(particle_slash, 20, 30);
part_type_orientation(particle_slash, 0, 359, .1, 1, 0);
part_type_alpha2(particle_slash, 1, 0.1);
#endregion
