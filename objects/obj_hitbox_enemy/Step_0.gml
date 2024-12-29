//if the owner exists
if(instance_exists(owner)){
    x = owner.x + lengthdir_x(offset, owner.atk_direction);
    y = owner.y + lengthdir_y(offset, owner.atk_direction);
    image_angle = owner.atk_direction; // changes the angle
}else{
    //if the owner doesnt exists, destroy
    instance_destroy();
}
