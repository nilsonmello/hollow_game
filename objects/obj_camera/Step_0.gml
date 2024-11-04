#region player hability shader control
if(keyboard_check(ord("R"))){
    darkness_target = .3;
}else{
    darkness_target = 1;
}

darkness_value = lerp(darkness_value, darkness_target, 0.1);
#endregion