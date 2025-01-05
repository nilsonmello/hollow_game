function enemy_attack(){
    var _direction = point_direction(x, y, obj_player.x, obj_player.y);
    var _attack_range = 20;
    var _attack_offset = 1;
    
    var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range / 2;
    var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range / 2;
    var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range / 2;
    var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range / 2;
    
    if(collision_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, obj_player, false, true)){
        with(obj_player){
            if(can_take_dmg){
                if(!global.parry){
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
                    obj_control.alarm[0] = 60;
    
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
    
                    with(other){
                        state = ENEMY_STATES.KNOCKED;
                        emp_dir = point_direction(obj_player.x, obj_player.y, other.x, other.y);
                        emp_veloc = 6;
                        hit = true;
                        attacking = false;
                        timer_hit = 20;
                        emp_timer = 10;
                        
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
