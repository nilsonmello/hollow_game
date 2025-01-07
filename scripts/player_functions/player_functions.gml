#region player parry
function player_parry(){
		if(global.slow_motion){
			return false;	
		}
		if(!parry_cooldown <= 0){
			return false;	
		}
		state = STATES.PARRY
		parry_cooldown = 70;
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

function player_line_attack(){
    if(keyboard_check(ord("E")) && global.energy >= global.cost_hab && can_line){
        if(global.hability == 2){
            return false;
        }
    
        global.hability = 1;
        global.can_attack = true;
        global.slow_motion = true;
        global.slashing = true;
        line = true;
    
        with(obj_enemy_par){
            line_mark = false;
        }
    
        direc = point_direction(x, y, obj_control.x, obj_control.y);
    
        var full_target_x = x + lengthdir_x(distan, direc);
        var full_target_y = y + lengthdir_y(distan, direc);
    
        var _line = collision_line(x, y, full_target_x, full_target_y, obj_wall, true, false);
        var _line_2 = collision_line(x, y, full_target_x, full_target_y, obj_enemy_par, true, false);
    
        if(_line_2){
            with(_line_2){
                line_mark = true;
            }
    
            var extra_distance = 100;
            distan = point_distance(x, y, _line_2.x, _line_2.y) + extra_distance;
    
            target_x = x + lengthdir_x(distan, direc);
            target_y = y + lengthdir_y(distan, direc);
        }
    
        if(_line){
            distan = point_distance(x, y, _line.x, _line.y);
            target_x = _line.x;
            target_y = _line.y;
        }else if(_line_2){
        }else{
            distan = 150;
            target_x = full_target_x;
            target_y = full_target_y;
        }
    }
    
    if(keyboard_check_released(ord("E")) && global.energy >= global.cost_hab){
        if(global.hability == 2){
            return false;
        }
        
        global.energy -= global.cost_hab
        global.slow_motion = false;
        global.slashing = false;
        line_attack = true;
        global.hability = 0;
        time_adv = 200;
    }
    
    if(line_attack){
        if(time_adv > 0){
            can_line = false;
            var _new_x = lerp(x, target_x, vel_a);
            var _new_y = lerp(y, target_y, vel_a);
    
            if(collision_rectangle(_new_x - 5, _new_y - 9, _new_x + 5, _new_y + 9, obj_wall, false, false)){
                line_attack = false;
            }else{
                x = _new_x;
                y = _new_y;
            }
        
            if(distance_to_point(target_x, target_y) < 10){
                line_attack = false;
                line = false;
                can_line = true;
            }
        }
        
        //enemy colide
        var _enemy = collision_rectangle(x - 10, y - 10, x + 10, y + 10, obj_enemy_par, false, false);
    
        //bush colide
        var _colide = collision_circle(x, y, 20, obj_bush, false, false);
        
        //box colide
        var _colide_2 = collision_circle(x, y, 20, obj_box, false, false);
        
        with(_enemy){
            
            particles(obj_player.x, obj_player.y, _enemy.x, _enemy.y, c_black, 6, 4);
            
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
    
            switch(knocked){
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
        
        if(_colide){
            if(_colide.image_index == 0){
                var _part_num = irandom_range(7, 12);
                
                repeat(_part_num){
                    var _inst = instance_create_layer(_colide.x + irandom_range(-2, 2), _colide.y - 8, "Instances_player", obj_b_part);
                    _inst.direction = point_direction(x, y, _colide.x, _colide.y) + irandom_range(90, -90);
                    _inst.image_index = irandom(4);
                    obj_camera.alarm[1] = 5;
                }
            }
            
            with(_colide){
                image_index = 1;
            }
        }
            
        if(_colide_2){
            var _part_num = irandom_range(7, 12);
            
            repeat(_part_num){
                var _inst = instance_create_layer(_colide_2.x + irandom_range(-2, 2), _colide_2.y - 8, "Instances_player", obj_b_part);
                _inst.direction = point_direction(x, y, _colide_2.x, _colide_2.y) + irandom_range(90, -90);
                _inst.image_index = irandom_range(5, 8);
                obj_camera.alarm[1] = 5;
            }
            with(_colide_2){
                instance_destroy(_colide_2);
            }
        }
    }
}

function player_area_attack(){
    area = clamp(area, 0, global.hab_range);
    
    if(global.energy >= global.cost_hab){
        global.can_attack = true;    
    }
    
    if(keyboard_check(ord("R")) && global.can_attack){
        if(global.hability == 1){
            return false;
        }
            global.hability = 2;
            global.slashing = true;
            global.slow_motion = true;
        
    
        ds_list_clear(enemy_list);
        ds_list_clear(path_list);
    
        var _circ = collision_circle_list(x, y, global.hab_range, obj_enemy_par, false, false, enemy_list, true);
    
        for(var _i = ds_list_size(enemy_list) - 1; _i >= 0; _i--){
            var _enemy = enemy_list[| _i];
    
            if(!instance_exists(_enemy) || collision_line(x, y, _enemy.x, _enemy.y, obj_wall, false, true)){
                ds_list_delete(enemy_list, _i);
            }
    
            if(ds_list_size(enemy_list) >= global.marked){
                break;
            }
        }
    
        if(ds_list_size(enemy_list) > 0){
            for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
                var _enemy = enemy_list[| _i];
                if(instance_exists(_enemy)){
                    var _dist = point_distance(x, y, _enemy.x, _enemy.y);
                    ds_list_set(enemy_list, _i, [_enemy, _dist]);
                }else{
                    ds_list_delete(enemy_list, _i);
                }
            }
    
            ds_list_sort(enemy_list, true);
    
            for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
                if(_i >= global.marked) break;
                var _enemy_data = enemy_list[| _i];
                if(is_array(_enemy_data)){
                    var _enemy = _enemy_data[0];
                    if(instance_exists(_enemy)){
                        ds_list_add(path_list, [_enemy.x, _enemy.y]);
                    }
                }
            }
        }
    
        move_speed = 20;
        moving_along_path = false;
        path_position_index = 0;
    }else{ 
        area = 0;
    
        if(keyboard_check_released(ord("R"))){
            if(global.hability == 1){
                return false;
            }
            
            global.energy -= global.cost_hab;  
            global.slow_motion = false;
            global.slashing = false;
            global.hability = 0;
        }
        
        
        if(!moving_along_path && ds_list_size(path_list) > 0){
            moving_along_path = true;
            path_position_index = 0;
        }
    }
    #endregion
    
    #region Movimento ao Longo do Caminho
    if(moving_along_path && ds_list_size(path_list) > 0){
        if(path_position_index < ds_list_size(path_list)){
    
            var _target_pos = path_list[| path_position_index];
            var _target_x = _target_pos[0];
            var _target_y = _target_pos[1];
    
            var _dir = point_direction(x, y, _target_x, _target_y);
            var _dist = point_distance(x, y, _target_x, _target_y);
    
            if(_dist > move_speed){
                x += lengthdir_x(move_speed, _dir);
                y += lengthdir_y(move_speed, _dir);
    
                ds_queue_enqueue(trail_positions, [x, y]);
    
                if(ds_queue_size(trail_positions) > trail_length){
                    ds_queue_dequeue(trail_positions);
                }
    
                if(move_speed > 0){
                    can_take_dmg = false;    
                    alarm[6] = 20;
                    global.can_attack = false;
                }	
            }else{
                path_position_index++;
    
                if(path_position_index >= ds_list_size(path_list)){
                    moving_along_path = false;
                    path_position_index = ds_list_size(path_list) - 1;
                    move_speed = 0;
                    global.slashing = false;
                }
    
                var _enemy_index = instance_position(_target_x, _target_y, obj_enemy_par);
                if(_enemy_index != noone){
                    
                    particles(obj_player.x, obj_player.y, _enemy_index.x, _enemy_index.y, c_black, 6, 4);

                    _enemy_index.vida -= global.hab_dmg;
                    _enemy_index.stamina_at -= 100;
                    _enemy_index.emp_dir = point_direction(obj_player.x, obj_player.y, _enemy_index.x, _enemy_index.y);
                    _enemy_index.emp_veloc = 20;
                    _enemy_index.timer_hit = 15;
                    _enemy_index.emp_timer = 2;
                    _enemy_index.state = ENEMY_STATES.KNOCKED;
                    _enemy_index.alarm[1] = 10;
                    _enemy_index.alarm[5] = 80;
                    _enemy_index.hit_alpha = 1;
                    _enemy_index.slashed = true;
                    
                    ds_list_add(trail_fixed_positions, [x, y, direction]);
                    ds_list_add(trail_fixed_timer, 30);
                }
            }
        }else{
            moving_along_path = false;
        }
    }
    #endregion
}

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
