//if time is above zero
if (time > 0) {
    //change the speed of the game
    game_set_speed(spd, gamespeed_fps);
}else {
    //return to the normal
    game_set_speed(60, gamespeed_fps);
    
    //destroy the object
    instance_destroy();
}

//decrease time
time--;