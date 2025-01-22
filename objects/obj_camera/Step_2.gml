//check if the player is healing
if(global.healing){
    //set the zoom target to a smaller value when healing
    zoom_target = 0.9;
}else{
    //set the zoom target to the default value
    zoom_target = 1;
}

//smoothly interpolate the zoom scale towards the target zoom
zoom_scale = lerp(zoom_scale, zoom_target, 0.1);

//calculate the current view dimensions based on the zoom scale
var _current_view_width = global.view_width * zoom_scale;
var _current_view_height = global.view_height * zoom_scale;

//set the camera view size to match the calculated dimensions
camera_set_view_size(view_camera[0], _current_view_width, _current_view_height);

//focus the camera on the current target
if(instance_exists(view_target)){
    //calculate the top-left corner of the view based on the target's position
    var _x1 = view_target.x - _current_view_width div 2;    
    var _y1 = view_target.y - _current_view_height div 2;    
    
    //clamp the view position to ensure it stays within the room boundaries
    _x1 = clamp(_x1, 0, room_width - _current_view_width);
    _y1 = clamp(_y1, 0, room_height - _current_view_height);
    
    //get the current camera position
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    
    //smoothly move the camera towards the target position
    camera_set_view_pos(view_camera[0], lerp(_cx, _x1, view_spd), lerp(_cy, _y1, view_spd));
}