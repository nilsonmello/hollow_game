if(global.healing){
    zoom_target = 0.9;
}else if(keyboard_check(ord("R")) && global.energy >= global.energy_max && global.slashing){
    zoom_target = 0.8;
}else{
    zoom_target = 1;
}

//changing the zoom target when healing
zoom_scale = lerp(zoom_scale, zoom_target, 0.1);

//actual camera view
var _current_view_width = global.view_width * zoom_scale;
var _current_view_height = global.view_height * zoom_scale;

//setting camera
camera_set_view_size(view_camera[0], _current_view_width, _current_view_height);

//focus on the actual target
if(instance_exists(view_target)){
    var _x1 = view_target.x - _current_view_width div 2;    
    var _y1 = view_target.y - _current_view_height div 2;    
    
    _x1 = clamp(_x1, 0, room_width - _current_view_width);
    _y1 = clamp(_y1, 0, room_height - _current_view_height);
    
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    
    camera_set_view_pos(view_camera[0], lerp(_cx, _x1, view_spd), lerp(_cy, _y1, view_spd));
}