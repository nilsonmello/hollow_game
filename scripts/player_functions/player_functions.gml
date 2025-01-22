#region player healing
function player_healing(){
    //if isnt dashing
    if(state != STATES.DASH){
        
        //if its full life, return false
        if(global.life_at >= global.life){
            return false;    
        }
        
        //if the energy is less than the cost, return false
        if(global.energy < global.cost_r){
            return false;
        }
        
        //is healing
        global.healing = true;
        //timer for the heal
        timer_heal++;
        
        //if the timer reach the limit
        if(timer_heal >= 30){
            //if the energy is bigger than cost
            if(global.energy >= global.cost_r){
                //increase player's life
                global.life_at += global.life * 0.2;
                if(global.life_at > global.life){
                    global.life_at = global.life;
                }
                //decrease the energy
                global.energy -= global.cost_r;
            }
            //reset the timer
            timer_heal = 0;
            
            //cooldown for the cure
            heal_cooldown = 80;
            
            //check if the player can use the healing
            can_heal = false;
            
            //reset to false
            global.healing = false;
        }
    }
}
#endregion

function particles(_x_inicial, _y_inicial, _x_final, _y_final, _color, _number_1, _number_2){
    //first type of particles
    repeat(_number_1){
        //create the object
        with(instance_create_layer(_x_inicial, _y_inicial, "Instances_bellow", obj_particle_effect)){
            //choose the sprite
            randomize();
            sprite_index = choose(spr_particle_line, spr_particle_line_2);
            fric = .8;
            
            //relative angle for the movement
            var relative_angle = point_direction(_x_inicial, _y_inicial, _x_final, _y_final) + irandom_range(-70, 70);
            
            //setting speed
            speed = choose(20, 20);
            
            //setting direction
            direction = relative_angle;
            
            //changing xscale
            image_xscale = 1.5;
            
            //changing yscale
            image_yscale = 1.5;
            
            //changing the image angle
            image_angle = relative_angle;
            
            //changing color
            image_blend = _color;
        }
    }
    
    repeat(_number_2){
        with(instance_create_layer(_x_inicial, _y_inicial, "Instances_bellow", obj_particle_effect)){
            //choose the sprite
            randomize();
            sprite_index = choose(spr_particle_line, spr_particle_line_2);
            fric = .8;
            
            //relative angle for the movement
            var relative_angle = point_direction(_x_inicial, _y_inicial, _x_final, _y_final) + irandom_range(-70, 70);
            
            //setting speed
            speed = choose(20, 20);
            
            //setting direction
            direction = relative_angle;
            
            //changing xscale
            image_xscale = 1.5;
            
            //changing yscale
            image_yscale = 1.5;
            
            //changing the image angle
            image_angle = relative_angle;
            
            //changing color
            image_blend = _color;
        }
    }
}

function player_line_attack() {
    //if the enemy exists and its the hook target enemy
    if (global.line_ready && mouse_check_button_pressed(mb_left) && instance_exists(global.target_enemy)) {
        
        //if the hook dont exists, create one
        if (!instance_exists(obj_hook)) {
            var hook_instance = instance_create_layer(obj_player.x, obj_player.y, "Instances", obj_hook);
            
            //direction to the enemy
            var launch_dir = point_direction(obj_player.x, obj_player.y, global.target_enemy.x, global.target_enemy.y);
            
            //keep the direction
            hook_instance.dir = launch_dir;
            
            //change the state
            hook_instance.state = "launched";
            
            //turn the global.target_enemy in the hooks target enemy
            hook_instance.target_enemy = global.target_enemy;
        } else {
            //shoot normal
            obj_hook.state = "launched";
            obj_hook.target_enemy = global.target_enemy;
            
            obj_hook.dir = point_direction(obj_player.x, obj_player.y, global.target_enemy.x, global.target_enemy.y);
        }
        //reset the line variable
        global.line_ready = false;
    }
}
