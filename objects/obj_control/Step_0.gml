#region mouse config
x = mouse_x;
y = mouse_y;

//changing the image index
if(alarm[0] > 0){
	image_index = 2;		
}else{
	image_index = 1;	
}

#endregion





#region mouse config
if(instance_exists(obj_player)){

//mouse direction
var _dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);

//max distance
var _dis = min(150, point_distance(obj_player.x, obj_player.y, mouse_x, mouse_y));

//target settings
var _tar_x = obj_player.x + lengthdir_x(_dis, _dir);
var _tar_y = obj_player.y + lengthdir_y(_dis, _dir);

//moving object
x = _tar_x;
y = _tar_y;

}

//changing the image index
if(alarm[0] > 0){
image_index = 2;		
}else{
image_index = 1;	
}

//changinging mouse button image index
if(mouse_check_button_pressed(mb_left) && alarm[0] <= 0){
alarm[0] = 20;
}
#endregion