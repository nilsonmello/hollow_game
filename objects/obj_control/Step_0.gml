#region mouse config
x = mouse_x;
y = mouse_y;

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