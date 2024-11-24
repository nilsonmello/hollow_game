#region resolution and camera config
resolution_width = 1920;
resolution_height = 1080;

//screen scale
resolution_scale = 4;

//camera height and width
global.view_width = resolution_width div resolution_scale;
global.view_height = resolution_height div resolution_scale;

//target to follow and speed
view_target = obj_player;
view_spd = 0.1;

//zoom variables
zoom_scale = 1;
zoom_target = 1;

//setting size of the camera
window_set_size(global.view_width * resolution_scale, global.view_height * resolution_scale);
surface_resize(application_surface, global.view_width * resolution_scale, global.view_height * resolution_scale);

display_set_gui_size(global.view_width, global.view_height);

//center screen alarm
alarm[0] = 1;
#endregion

#region player hability shader

//shadow shader variables
darkness_value = 0;
surf_dark = -1;
darkness_target = 0;

#endregion