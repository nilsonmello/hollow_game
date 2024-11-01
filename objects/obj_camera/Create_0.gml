resolution_width = 1280;
resolution_height = 720;

resolution_scale = 2;

// Definindo a largura e altura padrão da câmera
global.view_width = resolution_width div resolution_scale;
global.view_height = resolution_height div resolution_scale;

view_target = obj_player;
view_spd = 0.1;

// Variáveis de zoom
zoom_scale = 1;  // Escala de zoom inicial (1 = 100%)
zoom_target = 1; // Valor de zoom desejado

window_set_size(global.view_width * resolution_scale, global.view_height * resolution_scale);
surface_resize(application_surface, global.view_width * resolution_scale, global.view_height * resolution_scale);

display_set_gui_size(global.view_width * resolution_scale, global.view_height * resolution_scale);
