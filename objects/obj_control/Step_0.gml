#region camera setting target
if(instance_exists(target)){
    var _dist = 100;

    if(keyboard_check(ord("R"))){
        cam_largura = lerp(cam_largura, 600, 0.1);
        cam_altura = lerp(cam_altura, 300, 0.1);
    }else{
        cam_largura = lerp(cam_largura, 640, 0.1);
        cam_altura = lerp(cam_altura, 320, 0.1);
    }

    var _target_x = lerp(target.x, mouse_x, 0.3);
    var _target_y = lerp(target.y, mouse_y, 0.3);

    x = lerp(x, _target_x - cam_largura / 2, cam_veloc);
    y = lerp(y, _target_y - cam_altura / 2, cam_veloc);

    x = clamp(x, 0, room_width - cam_largura);
    y = clamp(y, 0, room_height - cam_altura);

    camera_set_view_size(view_camera[0], cam_largura, cam_altura);

    camera_set_view_pos(view_camera[0], x, y);
}else{
    target = -1;
}
#endregion