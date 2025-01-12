#region player parry
function player_parry(){
    if(!parry_cooldown <= 0){
        return false;	
    }
    
    state = STATES.PARRY
    parry_cooldown = 70;
    
    combo_time = 200;
    
    var _spr_dir = floor((point_direction(x, y, mouse_x, mouse_y) + 90) / 180) % 2;

    var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);
    _inst.direction = point_direction(x, y, mouse_x, mouse_y);
    _inst.sprite_index = spr_hitbox_parry;
    _inst.speed = 0;
    _inst.fric = 0.1
    _inst.image_blend = c_white;
    
    switch(_spr_dir){
        case 0:
            _inst.image_xscale = 1;
        break;
    
        case 1:
            _inst.image_xscale = -1;
        break;
    }
}
#endregion

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
