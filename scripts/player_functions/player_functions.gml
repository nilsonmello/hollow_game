#region player parry

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


function player_line_attack() {
    // Verifica se o jogador pressionou "E" após o parry
    if (global.line_ready && mouse_check_button_pressed(mb_left) && instance_exists(global.target_enemy)) {
        // Define o inimigo como o alvo
        var _enemy = global.target_enemy;
        direc = point_direction(x, y, _enemy.x, _enemy.y);

        var extra_distance = 80;
        distan = point_distance(x, y, _enemy.x, _enemy.y) + extra_distance;

        target_x = x + lengthdir_x(distan, direc);
        target_y = y + lengthdir_y(distan, direc);

        line_attack = true;
        time_adv = 200;
        can_line = false;

        // Reseta o estado de ataque preparado
        global.line_ready = false;
        global.target_enemy = noone;
    }

    if (line_attack) {
        if (time_adv > 0) {
            var _new_x = lerp(x, target_x, vel_a);
            var _new_y = lerp(y, target_y, vel_a);

            if (collision_rectangle(_new_x - 5, _new_y - 9, _new_x + 5, _new_y + 9, obj_wall, false, false)) {
                line_attack = false;
            } else {
                x = _new_x;
                y = _new_y;
            }

            if (distance_to_point(target_x, target_y) < 10) {
                line_attack = false;
                line = false;
                can_line = true;
            }
        }

        // Colisão com inimigo
        var _hit_enemy = collision_rectangle(x - 10, y - 10, x + 10, y + 10, obj_enemy_par, false, false);

        with (_hit_enemy) {
            particles(obj_player.x, obj_player.y, x, y, c_black, 6, 4);

            var _is_critical = irandom(100) < global.critical;
            var _damage_to_apply = _is_critical ? other.damage * 2 : other.damage;
            var _stamina = _is_critical ? 60 : 30;

            escx = 1.5;
            escy = 1.5;
            hit_alpha = 1;
            timer_hit = 5;
            emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
            global.combo++;
            obj_camera.alarm[1] = 5;

            switch (knocked) {
                case 0:
                    state = ENEMY_STATES.HIT;
                    emp_timer = 5;
                    emp_veloc = 6;
                    stamina_at -= _stamina;
                    alarm[2] = 30;
                    break;

                case 1:
                    state = ENEMY_STATES.KNOCKED;
                    vida -= _damage_to_apply;
                    hit = false;
                    alarm[1] = 10;
                    alarm[2] = 30;
                    break;
            }
        }
    }
}
