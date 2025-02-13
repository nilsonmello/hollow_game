#region movement keys
//energy limit clamp
global.energy = clamp(global.energy, 0, global.energy_max);

//keyboard keys
var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _top = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));

//result od the key pressed
var _keys = _right - _left != 0 || _down - _top != 0;
#endregion

#region dash control

//dash direction
dash_dir = move_dir;

//dash cooldown control
if(dash_cooldown > 0){
	dash_cooldown--;	
}

//activate the dash
if(keyboard_check_pressed(vk_space) && dash_cooldown <= 0){
    if(_keys){
        global.is_dashing = true;
        dash_timer = 4;
        dash_cooldown = global.dash_cooldown;
        state = STATES.DASH;
        
        if(global.shield){
            hit_cooldown = 8;
        }  
    }
}
#endregion

#region state machine
//STATE MACHINE
switch(state){
	//IDLE
	case STATES.IDLE:
		spd = 0;
        spd_h = 0;
        spd_v = 0;
		
		if(_keys){
			state = STATES.MOVING;
		}
	break;
	
	//MOVING
	case STATES.MOVING:
        if(attack_cooldown <= 0){
			spd = .9;

    		if(_keys){
    			move_dir = point_direction(0, 0, _right - _left, _down - _top);
    		
    			spd_h = lengthdir_x(spd * _keys, move_dir);
    			spd_v = lengthdir_y(spd * _keys, move_dir);
    			
    			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
    				x += spd_h;
    			}else{
    				spd_h = 0;
    			}
    			if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
    				y += spd_v;
    			}else{
    				spd_v = 0;
    			}
    		}else{
    			state = STATES.IDLE;
    		}
        }
	break;
	
	//DASH
    case STATES.DASH:
        if(global.is_dashing){
            if(dash_timer > 0){
                dash_timer--;
            }else{
                state = STATES.MOVING;
                global.is_dashing = false;
            }
            
            state_timer++;
            
            repeat(5){
                var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);
                _inst.speed = 1;
                _inst.direction = dash_dir + 180;
                _inst.image_angle = _inst.direction;
                _inst.sprite_index = spr_dash;
                _inst.fric = .8;   
            }

            spd_h = lengthdir_x(dash_veloc, dash_dir);
            spd_v = lengthdir_y(dash_veloc, dash_dir);

            if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
                x += spd_h;
            } else {
                spd_h = 0;
                state = STATES.MOVING;
                dash_timer = 0;
                global.is_dashing = false;
            }
            if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
                y += spd_v;
            } else {
                spd_v = 0;
                state = STATES.MOVING;
                dash_timer = 0;
                global.is_dashing = false;
            }
        }
    break;
	
	//PARRY
    case STATES.PARRY:
        if(state != STATES.DASH){
            parry_time--;
    
            global.parry = true;
            parry_cooldown = 70;
    
            if (parry_time <= 0) {
                parry_time = 15;
                state = STATES.MOVING;
                global.parry = false;
            }
    
            if (!instance_exists(obj_particle_effect)) {
                var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);
                _inst.direction = point_direction(x, y, mouse_x, mouse_y);
                _inst.sprite_index = spr_hitbox_parry;
                _inst.speed = 0;
                _inst.fric = 0.1;
                _inst.image_blend = c_white;
    
                var _spr_d = floor((point_direction(x, y, mouse_x, mouse_y) + 90) / 180) % 2;
                _inst.image_xscale = (_spr_d == 0) ? 1 : -1;
            }
        }
        break;
	
	//HIT
	case STATES.HIT:
		if(state != STATES.DASH){
			spd_h = lengthdir_x(emp_veloc, emp_dir);
			spd_v = lengthdir_y(emp_veloc, emp_dir);
    
			emp_veloc = lerp(emp_veloc, 0, .05);
			
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
				x += spd_h;
			}else{
				spd_h = 0;
			}
			if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
				y += spd_v;
			}else{
				spd_v = 0;
			}
			
			if(hit_timer <= 0){
				state = STATES.MOVING;
			}
		}
	break;
	
	//DEATH
	case STATES.DEATH:
		state = STATES.IDLE;
		global.life_at = global.life;
        global.target_enemy = noone;
        game_set_speed(60, gamespeed_fps);
		game_restart();
	break;

}
#endregion

#region dust walk
if(dust_time <= 0){
    dust_time = choose(10, 12);
	candust = true;
}else{
    dust_time--;
}

if(xprevious != x and candust == true){
	candust = false;
	part_particles_create(particle_system_dust, x, y + 10, particle_dust, 10);
}
if(yprevious != y and candust == true){
	candust = false;
	part_particles_create(particle_system_dust, x, y, particle_dust, 10);
}
#endregion

#region sword dash
var _mb = mouse_check_button_pressed(mb_left);
var _mb2 = mouse_check_button(mb_left);
var _mb3 = mouse_check_button_released(mb_left);

var _ma = mouse_check_button_pressed(mb_right);

var _timer = 10;
var _basico = new basic_attack(23, point_direction(x, y, mouse_x, mouse_y), 1, true, self, 0, combo);

var _spr_dir = floor((point_direction(x, y, mouse_x, mouse_y) + 90) / 180) % 2;

if(attack_cooldown <= 0){
    if(spd_h == 0 && spd_v == 0){
        switch(_spr_dir){
            case 0:
                sprite_index = spr_player_idle;
                image_xscale = 1;
            break;
            case 1:
                sprite_index = spr_player_idle;
                image_xscale = -1;
            break;
        }
    }else{
        switch(_spr_dir){ 
            case 0:
                sprite_index = spr_player_walk_rl;
                image_xscale = 1;
            break;
            
            case 1:
                sprite_index = spr_player_walk_rl;
                image_xscale = -1;
            break;
        }
    }
}else{
    switch(_spr_dir){
        case 0:
            sprite_index = spr_player_attack_rl;
            image_xscale = 1;
            break;
        case 1:
            sprite_index = spr_player_attack_rl;
            image_xscale = -1;
        break;
    }
}
if(state == STATES.PARRY){
    switch(_spr_dir){
        case 0:
            sprite_index = spr_player_attack_rl;
            image_xscale = 1;
            break;
        case 1:
            sprite_index = spr_player_attack_rl;
            image_xscale = -1;
        break;
    }
}
parry_cooldown = clamp(parry_cooldown, 0, 70);
parry_cooldown--;

//parry
if(mouse_check_button_pressed(mb_right)){
    if(!parry_cooldown <= 0){
        return false;	
    }
    state = STATES.PARRY;
}

if (combo_time > 0) {
    combo_time--;
    if (combo_time <= 0) {
        combo = 0;
    }
}

// Basic attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

if (_mb2) {
    if (actual_timer <= timer_charge) {
        actual_timer++;
    }
} else {
    if (mouse_check_button_released(_mb2)) && actual_timer >= timer_charge{
        golpe_circular.activate();
        actual_timer = 0;
        combo_charge = 100;
    }
    if (actual_timer < timer_charge) {
        actual_timer = 0
    }
}

if (combo_charge > 0) {
    combo_charge--;
    
    global.target_enemy = target;
    player_line_attack();
}




// Check attack input
if (_mb && attack_cooldown <= 0) { 

    // Ativa ataque
    _basico.activate();
    actual_timer = 0;
    if (global.deflect_bullets) {
        _basico.bullet();
    }

    if (combo_time > 0 && combo < 3) {
        combo++;
    } else {
        combo = 1;
    }

    combo_time = 40;

    var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);

    switch (combo) {
        case 1:
            _inst.sprite_index = spr_hitbox;
            break;
        case 2:
            _inst.sprite_index = spr_hitbox_2;
            break;
        case 3:
            _inst.sprite_index = spr_hitbox_3;
            break;
    }
    
    _inst.direction = point_direction(x, y, mouse_x, mouse_y);
    _inst.image_angle = _inst.direction;
    _inst.speed = 8;
    _inst.fric = 0.8;
    _inst.image_blend = c_white;

    attack_cooldown = 10;
    time_attack = 15;
    advancing = true;

    // Calcula posição final para avanço
    var _direction = point_direction(x, y, mouse_x, mouse_y);
    advance_x = x + lengthdir_x(range, _direction);
    advance_y = y + lengthdir_y(range, _direction);
}

player_line_attack();

//limiting the timer
time_attack = clamp(time_attack, 0, 5);

if(advancing && time_attack > 0){
    time_attack--;

    var _advance_speed = 0.2;
    var __nx = lerp(x, advance_x, _advance_speed);
    var __ny = lerp(y, advance_y, _advance_speed);

    var _collision_wall = place_meeting(__nx, __ny, obj_wall);
    var _collision_enemy = place_meeting(__nx, __ny, obj_enemy_par);

    if(!_collision_wall && !_collision_enemy){
        x = __nx;
        y = __ny;
    }else{
        advancing = false;
    }

    // Finalizar movimento ao atingir o ponto final
    if(point_distance(x, y, advance_x, advance_y) < 1){
        advancing = false;
    }
}
#endregion

#region hit indication
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion

#region healing button
if(heal_cooldown > 0){
	heal_cooldown--;	
}else{
	can_heal = true;	
}

//activate the regeneration
if(keyboard_check(ord("Q")) && can_heal){
	player_healing();
}
#endregion

#region death verification
if(global.life_at <= 0){
	state = STATES.DEATH;
}
#endregion

#region parry and hit timers
//decreasing parry timer
if (global.parry_timer > 0) {
    global.parry_timer--;
}

//reseting variables based on timer
if (global.parry_timer <= 0) {
    global.target_enemy = noone;
}
 
//decreasing hit timer
if(hit_timer > 0){
	hit_timer--;
}

//reseting variavles based on timer
if(hit_cooldown > 0){
	hit_cooldown--;
	can_take_dmg = false;
}else{
	can_take_dmg = true;
}
#endregion