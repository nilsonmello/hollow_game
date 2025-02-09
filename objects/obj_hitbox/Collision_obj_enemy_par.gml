switch (global.parry) {
    case 0:
        
    break;
    
    case 1:
        //parry time
        global.parry_timer = 30;
        
        //rectangle for the parry check
        var _enemy = collision_rectangle(x - 15, y - 15, x + 15, y + 15, obj_enemy_par, false, false);
        
        //if the parry got the enemy
        if (instance_exists(_enemy)) {
            //turn the enemy in target
            global.target_enemy = _enemy;
            
            //can use line attack
            global.line_ready = true;
            
            //if the index is correspondent to an enemy in the list
            if (global.index >= 0 && global.index < ds_list_size(global.enemy_list)) {
                //removing the mark from the enemy
                var previous_enemy = global.enemy_list[| global.index];
                if (instance_exists(previous_enemy)) {
                    with (previous_enemy) {
                        alligned = false;
                    }
                }
            }
            
            //find the index of the target enemy in the enemy list
            for (var i = 0; i < ds_list_size(global.enemy_list); i++) {
                if (global.enemy_list[| i] == _enemy) {
                    global.index = i;
                    break;
                }
            }
            
            //align the target enemy
            if (instance_exists(global.target_enemy)) {
                with (global.target_enemy) {
                    alligned = true;
                }
            }
        }
    
        //apply knockback effect to the enemy
        with(other){
            //knocked out state
            state = ENEMY_STATES.KNOCKED;
            
            //direction and speed to pe pulled
            emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
            emp_veloc = 6;
            
            //check if it was hitted
            hit = true;
            
            //stop the attack
            attacking = false;
            
            //timer to get hitted again
            timer_hit = 20;
            
            //the time he will be pulled
            emp_timer = 20;
            
            //hit flash effect
            hit_alpha = 1;
            
            //decrease speed
            spd = 0;
            
            //dreate particles
            particles(other.x, other.y, x, y, c_black, 4, 2);
            
            //create hitstop
            var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
            _inst.time = 2;
            
            //turn on layer effect
            layer_set_visible("screenshake_damaging_enemies", 1);
            
            //attack cooldown
            time_per_attacks = 110;
            
            //time knocked
            knocked_time = 30;
            
            //setting stamina to zero
            stamina_at = 0;
        }
    
        global.parry = false;
    break;
}