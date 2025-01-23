#region movement keys
//energy limit clamp
global.energy = clamp(global.energy, 0, global.energy_max);

//keyboard keys
var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _top = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));

//result of the key pressed
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
        //time to dash
        dash_timer = 4;
        
        //cooldown for dash
        dash_cooldown = global.dash_cooldown;
        
        //change state to dash
        state = STATES.DASH;
        
        //if the dash can interrupt enemy attacks
        if(global.shield){
            //he cant be attacked
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
        //set speed to zero
		spd = 0;
        spd_h = 0;
        spd_v = 0;
		
        //if press the movement buttons, change state to move
		if(_keys){
			state = STATES.MOVING;
		}
	break;
	
	//MOVING
	case STATES.MOVING:
        //if he can attack
        if(attack_cooldown <= 0){
            //change speed
			spd = .9;
            
            //if the key pressed
    		if(_keys){
                //calculate the direction
    			move_dir = point_direction(0, 0, _right - _left, _down - _top);
    		      
                //move the player
    			spd_h = lengthdir_x(spd * _keys, move_dir);
    			spd_v = lengthdir_y(spd * _keys, move_dir);
    			
                //collisions
    			if(!place_meeting(x + spd_h, y, collision_list)){
    				x += spd_h;
    			}else{
    				spd_h = 0;
    			}
    			if(!place_meeting(x, y + spd_v, collision_list)){
    				y += spd_v;
    			}else{
    				spd_v = 0;
    			}
    		}else{
                //if he inst moving, return to idle
    			state = STATES.IDLE;
    		}
        }
	break;
	
	//DASH
    case STATES.DASH:
        //dash timer
        if(dash_timer > 0){
            dash_timer--;
        }else{
            state = STATES.MOVING;
        }          
            
        state_timer++;
        
        //creating dash particles
        repeat(5){
            var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);
            _inst.speed = 1;
            _inst.direction = dash_dir + 180;
            _inst.image_angle = _inst.direction;
            _inst.sprite_index = spr_dash;
            _inst.fric = .8;   
        }
        
        //creating the movement
        spd_h = lengthdir_x(dash_veloc, dash_dir);
        spd_v = lengthdir_y(dash_veloc, dash_dir);
        
        //collisions
        if(!place_meeting(x + spd_h, y, obj_enemy_par) && !place_meeting(x + spd_h, y, obj_wall) && !place_meeting(x + spd_h, y, obj_ambient)){
            x += spd_h;
        } else {
            spd_h = 0;
            state = STATES.MOVING;
            dash_timer = 0;
        }
        if(!place_meeting(x, y + spd_v, obj_enemy_par) && !place_meeting(x, y + spd_v, obj_wall) && !place_meeting(x, y + spd_v, obj_ambient)){
            y += spd_v;
        } else {
            spd_v = 0;
            state = STATES.MOVING;
            dash_timer = 0;
        }
    break;
	
	//PARRY
    case STATES.PARRY:
        //dont activate if player is dashing
        if(state != STATES.DASH){
            //decrease parry time
            parry_time--;
    
            //parry_check for the enemies
            global.parry = true;
            
            //cooldown for the parry use
            parry_cooldown = 70;
            
            //if the parry can be executed
            if (parry_time <= 0) {
                //parry duration
                parry_time = 15;
                //change player state
                state = STATES.MOVING;
                
                //reset variable for the enemies
                global.parry = false;
            }
    
            //particles for the parry
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
        //if the player isnt dashing
		if(state != STATES.DASH){
            
            //moving the player for the pull direction
			spd_h = lengthdir_x(emp_veloc, emp_dir);
			spd_v = lengthdir_y(emp_veloc, emp_dir);
    
            //lerping the speed of the pull
			emp_veloc = lerp(emp_veloc, 0, .05);
			
            //collisions
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
			
            //reseting the player state
			if(hit_timer <= 0){
				state = STATES.MOVING;
			}
		}
	break;
	
	//DEATH
	case STATES.DEATH:
        //reseting state
		state = STATES.IDLE;
        
        //reseting life
		global.life_at = global.life;
    
        //reseting target_enemy
        global.target_enemy = noone;
    
        //reseting game speed
        game_set_speed(60, gamespeed_fps);
    
        //restarting game
		game_restart();
	break;

}
#endregion

#region dust walk
//if the timer ended
if(dust_time <= 0){
    //reset timer
    dust_time = choose(10, 12);
    //can create dust particles
	candust = true;
}else{
    //decrease timer
    dust_time--;
}

//if he moves and can_dust, create particles
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
//mouse buttom for the basic attack
var _mb = mouse_check_button_pressed(mb_left);

//charge attack button
var _mb2 = mouse_check_button(mb_left);

//mouse button for the parry
var _ma = mouse_check_button_pressed(mb_right);

//timer for the basic attack
var _timer = 10;

//basic attack constructor
var _basico = new basic_attack(23, point_direction(x, y, mouse_x, mouse_y), 1, true, self, 0, combo);

//directional player sprites
var _spr_dir = floor((point_direction(x, y, mouse_x, mouse_y) + 90) / 180) % 2;

//if he can attack
if(attack_cooldown <= 0){
    //if hes moving
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
        //if hes stopped
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
    //if hes attacking
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

//if hes using the parry
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

//limiting the parry cooldown
parry_cooldown = clamp(parry_cooldown, 0, 70);
parry_cooldown--;

//if mouse pressed, active parry
if(mouse_check_button_pressed(mb_right)){
    //if he cant active, return false
    if(!parry_cooldown <= 0){
        return false;	
    }
    //change the state to parry
    state = STATES.PARRY;
}

//if the timer for the combo if above zero
if (combo_time > 0) {
    //decrease
    combo_time--;
    
    //if the timer ends
    if (combo_time <= 0) {
        //reset combo
        combo = 0;
    }
}

// Basic attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

//if hold button for the change attack
if (_mb2) {
    //increase timer if its bellow timer_charge
    if (actual_timer <= timer_charge) {
        actual_timer++;
    }
} else {
    //if mouse released and the timer reached the limit
    if (mouse_check_button_released(_mb2)) && actual_timer >= timer_charge{
        //execute the circular attack
        golpe_circular.activate();
        
        //reset timer
        actual_timer = 0;
        combo_charge = 100;
    }
    //if didnt reach timer limit, reset
    if (actual_timer < timer_charge) {
        actual_timer = 0
    }
}

//timer for decrease combo charge
if (combo_charge > 0) {
    combo_charge--;
    
    //turning target to global.target for the hook
    global.target_enemy = target;
    player_line_attack();
}

// Check attack input
if (_mb && attack_cooldown <= 0) { 

    // execute basic attack
    _basico.activate();
    //reset timer
    actual_timer = 0;
    
    //if he can, deflect bullets
    if (global.deflect_bullets) {
        _basico.bullet();
    }
    
    //combo control, if time is above zero, and combo less than 3, increase
    if (combo_time > 0 && combo < 3) {
        combo++;
    } else {
        //reset
        combo = 1;
    }
    
    //setting combo timer
    combo_time = 40;
    
    //create particle effect
    var _inst = instance_create_layer(x, y, "Instances_player", obj_particle_effect);
    
    //changing the particle sprite
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
    
    //changing direction, speed, angle, color
    _inst.direction = point_direction(x, y, mouse_x, mouse_y);
    _inst.image_angle = _inst.direction;
    _inst.speed = 8;
    _inst.fric = 0.8;
    _inst.image_blend = c_white;
    
    //set the cooldown
    attack_cooldown = 10;
    
    //during attack time
    time_attack = 15;
    
    //advance time when attack
    advancing = true;

    // Calculate the final point of the advancing
    var _direction = point_direction(x, y, mouse_x, mouse_y);
    advance_x = x + lengthdir_x(range, _direction);
    advance_y = y + lengthdir_y(range, _direction);
}

//can use the line attack
player_line_attack();

//limiting the timer
time_attack = clamp(time_attack, 0, 5);

//if can advance and is attacking
if(advancing && time_attack > 0){
    //decrease attack time
    time_attack--;
    
    //speed for advance
    var _advance_speed = 0.2;
    
    //calculating the point to move
    var __nx = lerp(x, advance_x, _advance_speed);
    var __ny = lerp(y, advance_y, _advance_speed);
    
    //checking collisions
    var _collision_wall = place_meeting(__nx, __ny, obj_wall);
    var _collision_enemy = place_meeting(__nx, __ny, obj_enemy_par);
    
    //if didnt colide, move
    if(!_collision_wall && !_collision_enemy){
        x = __nx;
        y = __ny;
    }else{
        //stop advancing
        advancing = false;
    }

    // if reach the point, stop
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