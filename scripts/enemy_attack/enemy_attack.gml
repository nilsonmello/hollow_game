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
                    lsm_change("hit");
                    
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
                }
            }
        }
        //verification for the next attack
        has_attacked = true;
    }
}
