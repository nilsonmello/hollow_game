#region variáveis da arma do player
my_weapon = instance_create_layer(x, y, "Instances_control", obj_weapon);
my_weapon.weapon_id = self;

with(my_weapon){
    slot = 0;
    weapon_slots[0] = vazio;
    current_weapon = weapon_slots[slot_at];
	shot_cooldown = current_weapon.shot_cooldown;
	cost_per_shot = current_weapon.cost_per_shot;
}
recoil_pause_timer = 0;
#endregion

#region variáveis de movimento
timer = 0;
state_timer = 0;
sprite_index = spr_player_idle;

move_dir = 0;
andar = false;

spd_h = 0;
spd_v = 0;

spd = 1.2;

dash_dir = 0;
dash_veloc = 12;

can_take_dmg = true;

emp_veloc = 4;
emp_dir = 0;

alarm[0] = 0;
alarm[1] = 0;
#endregion

#region hability variables
can_activate_slash = false
area = 20;

enemy_list = ds_list_create();
path_list = ds_list_create();

moving_along_path = false;
path_position_index = 0;

move_speed = 0;

stamina_timer = 20;
stamina_timer_regen = 0;

trail_length = 10;
trail_positions = ds_queue_create();
trail_thickness = 2;

candust = true;

trail_fixed_positions = ds_list_create();
trail_fixed_timer = ds_list_create();
temp = 0;
#endregion

#region combo variables
advance_x = 0;
advance_y = 0;

advancing = false;

timer = 0;
h_atk = false
#endregion

#region state machine

//variáveis de estado
enum STATES {
    IDLE,
    MOVING,
    DASH,
    HEAL,
    ATTAKING,
    HIT,
    DEATH,
}

//estado atual
state = STATES.MOVING;

function player_colide(){
	var _collidable_objects = [obj_wall, obj_enemy_par];
    
	for(var _i = 0; _i < array_length(_collidable_objects); _i++){
		var _obj = _collidable_objects[_i];
		if(place_meeting(x + spd_h, y, _obj)){
			while (!place_meeting(x + sign(spd_h), y, _obj)){
				x += sign(spd_h);
			}
			spd_h = 0;
		}
	}

	for(var _i = 0; _i < array_length(_collidable_objects); _i++){
		var _obj = _collidable_objects[_i];
		if(place_meeting(x, y + spd_v, _obj)){
			while(!place_meeting(x, y + sign(spd_v), _obj)){
				y += sign(spd_v);
			}
			spd_v = 0;
		}
	}
}
#endregion

#region player regen
can_heal = true;
timer_heal = 0;
alarm[2] = 0;

function player_heal() {
    if (global.energy >= global.cost_r) {
        global.life_at += global.life * 0.2;
        if (global.life_at > global.life) {
            global.life_at = global.life;
        }
        global.energy -= global.cost_r;
    }
}
#endregion

#region hit variables
hit_color = c_white;
hit_alpha = 0;
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