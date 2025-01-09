#region mouse config
x = mouse_x;
y = mouse_y;
#endregion

with(obj_enemy_par){
    alligned = false;

}

var _line = collision_line(obj_player.x, obj_player.y, x, y, obj_enemy_par, false, false);

if(_line){
    sprite_index = spr_dot;
    with(_line){
        alligned = true;
    }
}else{
    sprite_index = spr_mouse;
}

#region mouse config
if(instance_exists(obj_player)){

    var _dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);
    
    var _dis = min(orb_rad, point_distance(obj_player.x, obj_player.y, mouse_x, mouse_y));
    
    var _tar_x = obj_player.x + lengthdir_x(_dis, _dir);
    var _tar_y = obj_player.y + lengthdir_y(_dis, _dir);
    
    x = _tar_x;
    y = _tar_y;
}
#endregion