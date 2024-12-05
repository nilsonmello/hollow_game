#region player parry
function player_parry(){
	if(global.stamina > 20){
		if(global.slow_motion){
			return false;	
		}
		if(!parry_cooldown <= 0){
			return false;	
		}
	
		state = STATES.PARRY
		global.stamina -= 20;
		parry_cooldown = 70;
	}
}
#endregion

#region healing function
function player_heal(){
	
    if(global.energy >= global.cost_r){
        global.life_at += global.life * 0.2;
        if(global.life_at > global.life){
            global.life_at = global.life;
        }
        global.energy -= global.cost_r;
    }
}
#endregion

#region preserving directional sprites
function nearest_cardinal_direction(_direction){
    var _directions = [0, 90, 180, 270];
    
    _direction = _direction mod 360;
    if (_direction < 0) _direction += 360;

    var _min_diff = 360;
    var _nearest_direction = _directions[0];
    
    for(var _i = 0; _i < array_length(_directions); _i++){
        var _diff = abs(_direction - _directions[_i]);
        
        if(_diff < _min_diff){
            _min_diff = _diff;
            _nearest_direction = _directions[_i];
        }
    }
    
    return _nearest_direction;
}
#endregion