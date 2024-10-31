#region cooldown e direção
//weapon cooldown
current_weapon.update_cooldown();

//weapon direction
weapon_dir = point_direction(x, y, alvo_x, alvo_y);

//inicial point
x = weapon_id.x;
y = weapon_id.y;

//final point
weapon_x = x + lengthdir_x(20, weapon_dir);
weapon_y = y + lengthdir_y(20, weapon_dir);
#endregion

#region functions
//pickup weapon
function weapon_pickup(){
    var _slot_found = false;
    
    for(var _i = 0; _i < array_length(weapon_slots); _i++){
        if(weapon_slots[_i] == vazio){
            weapon_slots[_i] = weapon_drop.current_weapon;
            current_weapon = weapon_slots[_i];
            _slot_found = true;
            instance_destroy(weapon_drop);
            break;
        }
    }
}

//function drop weapon
function drop_weapon(){
    if(weapon_slots[slot_at] != vazio){
        var _inst = instance_create_layer(weapon_x, weapon_y, "Instances", obj_weapon_drop);
        _inst.speed = 3;
        _inst.direction = point_direction(weapon_x, weapon_y, alvo_x, alvo_y);
		_inst.sprite_index = current_weapon.weapon_sprite;
        _inst.current_weapon = weapon_slots[slot_at];
        weapon_slots[slot_at] = vazio;
        current_weapon = vazio;
    }
}
#endregion

show_debug_message(recoil)