function enemy_attack(){
    var _direction = point_direction(x, y, obj_player.x, obj_player.y);
    var _attack_range = 20;
    var _attack_offset = 1;
    
    var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range / 2;
    var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range / 2;
    var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range / 2;
    var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range / 2;
    
    var _x_init = x;
    var _y_init = y;
    
    if(collision_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, obj_player, false, true)){
        with(obj_player){
            if(can_take_dmg){
                if(!global.parry){
                    particles(_x_init, _y_init, x, y, c_white, 6, 4);
                    var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                    _inst.spd = 10;
                    
                    state = STATES.HIT;
                    hit_timer = 10;
                    hit_alpha = 1;
                    emp_dir = point_direction(other.x, other.y, x, y);
                    emp_veloc = 6;
                    global.life_at -= 2;
    
                    can_take_dmg = false;
                    hit_cooldown = 60;
    
                    with(other){
                        state = ENEMY_STATES.CHOOSE;
                        attacking = false;
                        time_per_attacks = 110;
                        knocked_time = 20;
                        has_attacked = false;
                        recover_time = 60;
    
                        var _away = point_direction(obj_player.x, obj_player.y, x, y);
    
                        esc_x = x + lengthdir_x(50, _away);
                        esc_y = y + lengthdir_y(50, _away);
                    }
                }else{
                    parry_cooldown = 0;
                    global.parry_timer = 30;
                    
                    var _enemy = collision_rectangle(x - 15, y - 15, x + 15, y + 15, obj_enemy_par, false, false);
                    if (instance_exists(_enemy)) {
                        global.target_enemy = _enemy;
                        global.line_ready = true;
                    }
                    
                    with(other){
                        state = ENEMY_STATES.KNOCKED;
                        emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
                        emp_veloc = 6;
                        hit = true;
                        attacking = false;
                        timer_hit = 20;
                        emp_timer = 20;
                        hit_alpha = 1;
                        spd = 0;
                        
                        correct_parry = true;
                        
                        particles(other.x, other.y, x, y, c_black, 4, 2);
                        var _inst = instance_create_layer(x, y, "Instances_player", obj_hitstop);
                        _inst.time = 2;
                        
                        layer_set_visible("screenshake_damaging_enemies", 1);
                        
                        alarm[2] = 30;
                        time_per_attacks = 110;
                        knocked_time = 30;
                        stamina_at = 0;
                    }
                }
            }
        }
        has_attacked = true;
    }
}
