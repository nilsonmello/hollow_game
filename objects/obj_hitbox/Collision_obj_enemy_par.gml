switch (global.parry && !hitted) {
    case 0:
        with (other){
            //with the enemy, if he inst attacking
            if(!attacking){
                //critical attack chance
                var _is_critical = irandom(100) < global.critical;
                
                //total damage to apply
                var _damage_to_apply = _is_critical ? 2 * 2 : 2;
                
                //the stamina to decrease with the attack
                var _stamina = 0;
                
                //if the enemy is bigger, take less stamina, if he's tynier, take more stamina
                switch (size) {
                    case 1:
                        _stamina = 50;
                    break;
                    
                    case 2:
                        _stamina = 25
                    break;
                }
                
                //changing the scale of the enemy for effect
                escx = 1.5;
                escy = 1.5;
                
                //hit flash effect
                hit_alpha = 1;
                
                //direction for de pull
                emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                
                //increase combo
                global.combo++;
                
                //alarm for the screenshake layer visible
                obj_camera.alarm[1] = 5;
                
                //in case of the enemy is in combo one or zero, he will be pulled a bit, if its two, he will be pulled a lot
                switch (global.combo) {
                    case 1:
                        emp_timer = 5;
                        emp_veloc = 6;
                        timer_hit = 5;
                    break;
                    
                    case 2:
                        emp_timer = 20;
                        emp_veloc = 6; 
                        timer_hit = 20;
                    break;
                }
                
                //switch the enemy state
                switch(knocked){
                    //if isnt knocked, state is hit
                    case 0:
                        state = ENEMY_STATES.HIT;
                    
                        //decrease stamina
                        stamina_at -= _stamina;
                    
                        //create hitstop object
                        var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                        break;
                    
                    //if its knocked, state is knocked
                    case 1:
                        state = ENEMY_STATES.KNOCKED;
                        //decrease health
                        vida -= _damage_to_apply;
                        
                        //set hit to true
                        hit = false;
                    
                        //create hitstop object
                        var _inst2 = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                    break;
                }
            }
        }
    hitted = true;

    break;
    
    case 1:
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