// Ajuste da escala de zoom ao pressionar "R"
if (keyboard_check(ord("R"))) {
    zoom_target = 0.8; // Zoom in (80% da visão original)
} else {
    zoom_target = 1; // Volta ao zoom padrão (100%)
}

// Suaviza a transição para o zoom desejado
zoom_scale = lerp(zoom_scale, zoom_target, 0.1);

// Aplica o tamanho da visão com base na escala de zoom
var current_view_width = global.view_width * zoom_scale;
var current_view_height = global.view_height * zoom_scale;

camera_set_view_size(view_camera[0], current_view_width, current_view_height);

// Configuração da posição da câmera
if (instance_exists(view_target)) {
    var _x1 = view_target.x - current_view_width div 2;    
    var _y1 = view_target.y - current_view_height div 2;    
    
    _x1 = clamp(_x1, 0, room_width - current_view_width);
    _y1 = clamp(_y1, 0, room_height - current_view_height);
    
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    
    camera_set_view_pos(view_camera[0], lerp(_cx, _x1, view_spd), lerp(_cy, _y1, view_spd));
}

