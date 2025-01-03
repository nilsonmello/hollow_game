#region player hability shader control

//if player hability is on, changes the dark value
if(global.slashing){
    darkness_target = .1;
}else{
    darkness_target = 1;
}

//changing the darkess value
darkness_value = lerp(darkness_value, darkness_target, 0.1);
#endregion

//lerp camera effect
if(instance_exists(view_target)){
    var _dist = 100;

    var target_x = lerp(view_target.x, mouse_x, 0.3);
    var target_y = lerp(view_target.y, mouse_y, 0.3);

    x = lerp(x, target_x - global.view_width / 2, view_spd);
    y = lerp(y, target_y - global.view_height / 2, view_spd);

    x = clamp(x, 0, room_width - global.view_width);
    y = clamp(y, 0, room_height - global.view_height);

    camera_set_view_pos(view_camera[0], x, y);
}



#region screenshake control
if (alarm[1] > 0){
    layer_set_visible("screenshake_damaging_enemies", 1);
}else{
    layer_set_visible("screenshake_damaging_enemies", 0);
}

#endregion