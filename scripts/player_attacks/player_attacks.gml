#region player basic attack
function player_basic_attack(){
		if(global.combo > 3){
			return false;	
		}
		if(global.slow_motion){
			return false;	
		}
	
		clicked_attack = true;
        alarm[4] = 15;
        image_index = 0;
        state = STATES.ATTAKING;

        var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
        var _advance_dir = 20;
        var _advance_distance = 28;

        var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
        var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);
        
        advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
        advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

        if(!instance_exists(obj_hitbox)){
            var _box = instance_create_layer(_box_x, _box_y, "Instances_player", obj_hitbox);
            _box.image_angle = _melee_dir;
			_box.dmg = 1;

            switch(global.combo){
                case 0:
                    _box.sprite_index = spr_hitbox_1;
                    break;
                case 1:
                    _box.sprite_index = spr_hitbox_2;
                    break;
                case 2:
                    _box.sprite_index = spr_hitbox_3;
                    break;
            }
        }
        advancing = true;
        global.combo++;
        alarm[3] = 20;
        alarm[8] = 30;
        timer = 0;
}
#endregion

#region line attack
function player_line_attack(){
	if(global.slow_motion){
		return false;	
	}
	if(global.stamina < 30){
		return false;	
	}
	
    holded_attack = true;
    alarm[4] = 50;
    image_index = 0;
    state = STATES.HOLD_ATK;
	
	
        var _melee_dir = point_direction(x, y, obj_control.x, obj_control.y);
        var _advance_dir = 20;
        var _advance_distance = 150;
        
        advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
        advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

		_p_slash = part_system_create();

		_bs = part_type_create();

		part_type_sprite(_bs, spr_hitbox_4, 0, 0, 0);
		part_type_orientation(_bs, _melee_dir, _melee_dir, 0, 0, 0);
		part_type_alpha3(_bs, 1, .5, 0);
		part_type_life(_bs, 20, 20);
		part_particles_create(_p_slash, x, y, _bs, 1);


    advancing = true;
    global.combo = 0;
    alarm[3] = 40;
    alarm[8] = 40;

    timer = 0;
    h_atk = true;
    global.stamina -= 30;
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



