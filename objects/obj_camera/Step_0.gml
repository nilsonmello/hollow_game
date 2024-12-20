#region player hability shader control

//if player hability is on, changes the dark value
if(keyboard_check(ord("R")) && global.slashing){
    darkness_target = .1;
}else{
    darkness_target = 1;
}

//changing the darkess value
darkness_value = lerp(darkness_value, darkness_target, 0.1);
#endregion

#region screenshake control
if (alarm[1] > 0){
    layer_set_visible("screenshake_damaging_enemies", 1);
}else{
    layer_set_visible("screenshake_damaging_enemies", 0);
}

#endregion