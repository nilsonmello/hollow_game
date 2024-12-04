#region player basic attack
function player_basic_attack(){
		if(global.slow_motion){
			return false;	
		}
	
		clicked_attack = true;
        alarm[4] = 9;
        image_index = 0;
        state = STATES.ATTAKING;

        var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
        var _advance_dir = 20;
        var _advance_distance = 25;

        var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
        var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);
        
        advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
        advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

        if(!instance_exists(obj_hitbox)){
            var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox);
            _box.image_angle = _melee_dir;
			_box.sprite_index = spr_hitbox_1;
			_box.dmg = 1;
        }
        advancing = true;
		timer = 0;

        alarm[3] = 10;
        alarm[8] = 300;
}
#endregion

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


function hold_atk_1(){
	var _dir = point_direction(x, y, obj_control.x, obj_control.y);
	
	var _x = lengthdir_x(100, _dir);
	var _y = lengthdir_y(100, _dir);
	
	x += _x;
	y += _y;
	
	global.stamina -= 30;
}

function hold_atk_2(){
	show_debug_message("ABLABLUBLÉ");
}

function hold_atk_3(){
	show_debug_message("LABULABULA")
}