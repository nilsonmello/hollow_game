resolution_width = 2560;
resolution_height = 1080;

resolution_scale = 3;

global.view_width = resolution_width div resolution_scale;
global.view_height = resolution_height div resolution_scale;

view_target = obj_player;
view_spd = 0.1;

zoom_scale = 1;
zoom_target = 1;

window_set_size(global.view_width * resolution_scale, global.view_height * resolution_scale);
surface_resize(application_surface, global.view_width * resolution_scale, global.view_height * resolution_scale);


display_set_gui_size(global.view_width, global.view_height);

alarm[0] = 1;