//setting the speed
speed *= fric;

//if the animation ends, destroy
if(image_index >= image_number - 1){
    instance_destroy();
}