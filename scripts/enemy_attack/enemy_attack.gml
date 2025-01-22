function enemy_attack(){
    //setting direction
    var _direction = point_direction(x, y, obj_player.x, obj_player.y);
    //range of the attack
    var _attack_range = 20;
    //offset for the attack
    var _attack_offset = 1;
    
    //setting points to the rectangle
    var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range / 2;
    var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range / 2;
    var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range / 2;
    var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range / 2;
    
    //initial x and y
    var _x_init = x;
    var _y_init = y;
    
    //rectangle for the attack
    if(collision_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, obj_player, false, true)){
        with(obj_player){
            //if the player can take damage
            if(can_take_dmg){
                //if the player isnt parring
                if(!global.parry){
                    //create particles
                    particles(_x_init, _y_init, x, y, c_white, 6, 4);
                    
                    //create hitstop object and set spd
                    var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                    _inst.spd = 10;
                    
                    //player changings
                    
                    //state changed to hit
                    state = STATES.HIT;
                    
                    //timer for hit duration
                    hit_timer = 10;
                    
                    //hit flash effect
                    hit_alpha = 1;
                    
                    //direction to be pulled
                    emp_dir = point_direction(other.x, other.y, x, y);
                    
                    //speed of the pull
                    emp_veloc = 6;
                    
                    //decreasing player's life
                    global.life_at -= 2;
                    
                    //he cant take damage
                    can_take_dmg = false;
                    
                    //cooldown to take damage again
                    hit_cooldown = 60;
                    
                    //enemy changes
                    with(other){
                        //change state
                        state = ENEMY_STATES.CHOOSE;
                        
                        //isnt attacking 
                        attacking = false;
                        
                        //cooldown for attacks
                        time_per_attacks = 110;
                        
                        //can attack again
                        has_attacked = false;
                    }
                }else{
                    //if the player is parring
                    
                    //theres no cooldown
                    parry_cooldown = 0;
                    
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
                        
                        alarm[2] = 30;
                        
                        //attack cooldown
                        time_per_attacks = 110;
                        
                        //time knocked
                        knocked_time = 30;
                        
                        //setting stamina to zero
                        stamina_at = 0;
                    }
                }
            }
        }
        //verification for the next attack
        has_attacked = true;
    }
}
