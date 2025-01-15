#region player healing
function player_healing(){
    if(state != STATES.DASH){
        
        if(global.life_at >= global.life){
            return false;    
        }
    
        if(global.energy < global.cost_r){
            return false;
        }
        
        global.healing = true;
        timer_heal++;

        if(timer_heal >= 30){
            if(global.energy >= global.cost_r){
                global.life_at += global.life * 0.2;
                if(global.life_at > global.life){
                    global.life_at = global.life;
                }
                global.energy -= global.cost_r;
            }
            
            timer_heal = 0;
            heal_cooldown = 80;
            can_heal = false;
            global.healing = false;
        }
    }
}
#endregion

function particles(_x_inicial, _y_inicial, _x_final, _y_final, _color, _number_1, _number_2){
    repeat(_number_1){
        with(instance_create_layer(_x_inicial, _y_inicial, "Instances_bellow", obj_particle_effect)){
            randomize();
            sprite_index = choose(spr_particle_line, spr_particle_line_2);
            fric = .8;
            
            var relative_angle = point_direction(_x_inicial, _y_inicial, _x_final, _y_final) + irandom_range(-70, 70);
            
            speed = choose(20, 20);
            direction = relative_angle;
            image_xscale = 1.5;
            image_yscale = 1.5;
            image_angle = relative_angle;
            image_blend = _color;
        }
    }
    
    repeat(_number_2){
        with(instance_create_layer(_x_inicial, _y_inicial, "Instances_bellow", obj_particle_effect)){
            randomize();
            sprite_index = spr_pixel;
            fric = .8;
            
            var relative_angle = point_direction(_x_inicial, _y_inicial, _x_final, _y_final) + irandom_range(-70, 70);
            
            speed = choose(10, 10);
            direction = relative_angle;
            image_xscale = 1.5;
            image_yscale = 1.5;
            image_angle = relative_angle;
            image_blend = _color;
        }
    }
}

function player_line_attack() {
    if (global.line_ready && mouse_check_button_pressed(mb_left) && instance_exists(global.target_enemy)) {
        if (!instance_exists(obj_hook)) {
            
            if (distance_to_object(global.target_enemy) < 40) {
                return false;
            }
    
            global.line_ready = false;   
        }
        obj_hook.state = "launched"
    }
}
