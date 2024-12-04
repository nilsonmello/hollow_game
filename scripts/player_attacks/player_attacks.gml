#region player basic attack
function player_basic_attack(){
		if(global.slow_motion){
			return false;	
		}
	
		clicked_attack = true;
        alarm[4] = 11;
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



		
        alarm[3] = 20;
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