var _inst = instance_nearest(x, y, obj_enemy_par);

if(distance_to_object(obj_player) < 25){
    image_alpha = lerp(image_alpha, .2, .1);
}else{
    image_alpha =  lerp(image_alpha, 1, .1);
}
