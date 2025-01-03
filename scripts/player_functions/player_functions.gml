#region player parry
function player_parry(){
		if(global.slow_motion){
			return false;	
		}
		if(!parry_cooldown <= 0){
			return false;	
		}
		state = STATES.PARRY
		parry_cooldown = 70;
}
#endregion

#region player healing
function player_healing(){
    if(state != STATES.DASH){
        
        if(global.life_at >= global.life){
            return false;    
        }
    
        if(global.energy < global.cost_r){
            return false;
        }
        
        global.healing = true;
        timer_heal++;
    
        if(timer_heal >= 30){
            if(global.energy >= global.cost_r){
                global.life_at += global.life * 0.2;
                if(global.life_at > global.life){
                    global.life_at = global.life;
                }
                global.energy -= global.cost_r;
            }
            
            timer_heal = 0;
            heal_cooldown = 80;
            can_heal = false;
            global.healing = false;
        }
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