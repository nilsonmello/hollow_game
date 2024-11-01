#region mouse config
if(instance_exists(obj_player)){

    var _dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);
    
    var _dis = min(150, point_distance(obj_player.x, obj_player.y, mouse_x, mouse_y));
    
    var _tar_x = obj_player.x + lengthdir_x(_dis, _dir);
    var _tar_y = obj_player.y + lengthdir_y(_dis, _dir);
    
    x = _tar_x;
    y = _tar_y;
}
#endregion