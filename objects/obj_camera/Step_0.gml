#region player hability shader control

//if player hability is on, changes the dark value
if(keyboard_check(ord("R")) && global.slashing){
    darkness_target = .1;
}else{
    darkness_target = 1;
}
darkness_value = lerp(darkness_value, darkness_target, 0.1);
#endregion