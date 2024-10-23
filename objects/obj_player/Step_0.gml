#region sprite direction
var _dir_sprite = floor((point_direction(x, y, mouse_x, mouse_y) + 90) mod 360 / 180);

switch(_dir_sprite){
    case 0:
        image_xscale = 1;
        break;
        
    case 1:
        image_xscale = -1;
	break;
}
#endregion

#region state machine

#region comand keys
global.energy = clamp(global.energy, 0, global.energy_max);

var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _top = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));
		
var _keys = _right - _left != 0 || _down - _top != 0;

if(global.life_at <= 0){
	state = STATES.DEATH;
}

if(keyboard_check(ord("H")) && can_heal && global.life_at < global.life){
	state = STATES.HEAL;
}
#endregion

switch(state){
	#region idle
	case STATES.IDLE:
		spd = 0;
		andar = false;
		
		if(_keys){
			state = STATES.MOVING;
			andar = true;
		}
		
		dash_dir = move_dir
		
		if(keyboard_check_pressed(vk_space) && dash_num > 0){
			global.is_dashing = true;
			alarm[0] = 12;
			state = STATES.DASH;
			dash_num--; 
			dash_cooldown = dash_time;
		}
	break;
	#endregion
	
	#region walking
	case STATES.MOVING:
		if(!keyboard_check(ord("R"))){
			spd = 1.6;
		}else{
			spd = 0;
		}

		if(_keys){
			move_dir = point_direction(0, 0, _right - _left, _down - _top);
		
			spd_h = lengthdir_x(spd * _keys, move_dir);
			spd_v = lengthdir_y(spd * _keys, move_dir);
		
			player_colide();
		
			x += spd_h;
			y += spd_v;
			
		}else{
			state = STATES.IDLE;
		}
		
		dash_dir = move_dir;
		if(keyboard_check_pressed(vk_space) && dash_num > 0){
			global.is_dashing = true;
			alarm[0] = 8;
			state = STATES.DASH;
			dash_num--; 
			dash_cooldown = dash_time;
		}
	break;
	#endregion
	
	#region dash
	case STATES.DASH:
		can_take_dmg = false;
		alarm[6] = 15;

		spd_h = lengthdir_x(dash_veloc, dash_dir);
		spd_v = lengthdir_y(dash_veloc, dash_dir);

		state_timer += 1;

		if(state_timer >= 2){
		    part_particles_create(obj_particle_setup.particle_system, x, y, obj_particle_setup.particle_shadow, 1);
		    state_timer = 0;
		}

		player_colide();	

		x += spd_h;
		y += spd_v;
	break;
	#endregion
	
	#region hit
	case STATES.HIT:
		spd_h = lengthdir_x(emp_veloc, emp_dir);
		spd_v = lengthdir_y(emp_veloc, emp_dir);
    
		emp_veloc = lerp(emp_veloc, 0, .01);
    
		player_colide();
    
		x += spd_h;
		y += spd_v;
	break;
	#endregion
	
	#region heal
	case STATES.HEAL:
		if(global.energy <= 0){
			return false;	
		}
	
		timer_heal++;
	
		if(timer_heal >= 50){
			player_heal();
			timer_heal = 0;
			alarm[2] = 80;
			can_heal = false;
			state = STATES.MOVING;
		}
	break;
	#endregion
	
	#region slash
	case STATES.ATTAKING:
	    if(advancing){
	        var _advance_speed = 0.2;

	        var __new_x = lerp(x, advance_x, _advance_speed);
	        var __new_y = lerp(y, advance_y, _advance_speed);

	        if(!place_meeting(__new_x, __new_y, obj_wall) && !place_meeting(__new_x, __new_y, obj_enemy)){
	            x = __new_x;
	            y = __new_y;
	        }else{
	            advancing = false;
	        }

	        if(point_distance(x, y, advance_x, advance_y) < 1){
	            advancing = false;
	        }
	    }

	    if(!advancing){
	        state = STATES.MOVING;
	    }
	break;
	#endregion

	#region death
	case STATES.DEATH:

	break;
	#endregion
}
#endregion

#region dash config
if(dash_num < 3){
	
	dash_cooldown--;
	
	if(dash_cooldown <= 0){
		dash_num++;	
		dash_cooldown = dash_time
	}
}
#endregion

#region weapon
with(my_weapon){
    #region target
    alvo_x = mouse_x;
    alvo_y = mouse_y;
    #endregion
    
    #region comand keys
    var _ma = mouse_check_button(mb_right);
    var _mb = noone;
    weapon_drop = instance_nearest(x, y, obj_weapon_drop);
    
    if(current_weapon.automatic){
        _mb = mouse_check_button(mb_left);
    } else {
        _mb = mouse_check_button_pressed(mb_left);
    }
    #endregion

    #region shoot
    if(_ma){
        aiming = true;    
    } else {
        aiming = false;    
    }
    
    if(_ma && _mb && current_weapon != vazio && global.energy > 0){
        current_weapon.shoot(weapon_x, weapon_y);
        recoil = 3;
		recoil_gun = 12;
    }
    recoil = lerp(recoil, 0, 0.5);
	recoil_gun= lerp(recoil_gun, 0, 0.5);

    #endregion
    
    #region slots
    slot_at = clamp(slot_at, 0, 2);
        
    if(keyboard_check_pressed(ord("F"))){
        slot_at++;
        if(slot_at > 2){
            slot_at = 0;    
        }
    }
        
    current_weapon = weapon_slots[slot_at];
    #endregion
    
    #region functions
    if(keyboard_check_pressed(ord("E"))){
        weapon_pickup();
    }
    if(keyboard_check_pressed(ord("Q"))){
        drop_weapon();
    }
    #endregion
    
    #region player recoil
    var _target_x = obj_player.x - lengthdir_x(recoil, weapon_dir);
    var _target_y = obj_player.y - lengthdir_y(recoil, weapon_dir);

    if (!place_meeting(_target_x, _target_y, obj_wall)) {
        obj_player.x = _target_x;
        obj_player.y = _target_y;
    } else {
        while (recoil > 0 && !place_meeting(obj_player.x, obj_player.y, obj_wall)) {
            obj_player.x -= lengthdir_x(1, weapon_dir);
            obj_player.y -= lengthdir_y(1, weapon_dir);
        }
    }
    #endregion
}
#endregion

if(global.energy >= global.energy_max){
	global.can_attack = true;	
}

show_debug_message(global.can_attack)

#region power activation

#region sword dash
var _mb = mouse_check_button_pressed(mb_left);
var _ma = mouse_check_button(mb_right);

if(_mb && state != STATES.ATTAKING && alarm[4] <= 0){
	alarm[4] = 15;

    if(_ma){
        return false;
    }
	
    image_index = 0;
    state = STATES.ATTAKING;

    var _melee_dir = point_direction(x, y, obj_mouse.x, obj_mouse.y);
    var _advance_dir = 25;
    var _advance_distance = 28;

    var _box_x = x + lengthdir_x(_advance_dir, _melee_dir);
    var _box_y = y + lengthdir_y(_advance_dir, _melee_dir);

    advance_x = x + lengthdir_x(_advance_distance, _melee_dir);
    advance_y = y + lengthdir_y(_advance_distance, _melee_dir);

	if(!instance_exists(obj_hitbox)){
    var _box = instance_create_layer(_box_x, _box_y, "Instances", obj_hitbox);
	_box.image_angle = _melee_dir;
	}
    advancing = true;
    alarm[3] = 20;
}
#endregion

#region hability activation
// Define o valor da área de alcance, limitando entre 0 e 170
area = clamp(area, 0, 170);

// Verifica se o jogador está pressionando a tecla "R" e se a stamina está no valor máximo
if(keyboard_check(ord("R")) && global.stamina >= global.stamina_max && global.can_attack){
    
    // Torna visível a camada de tela tremendo enquanto carrega a habilidade
    layer_set_visible("screenshake_charging", 1);

    // Se ainda houver energia, diminui a energia e ativa a habilidade de corte e o efeito de slow motion
    if(global.energy > 0){
        global.energy--;  // Consome energia
        global.slashing = true;  // Indica que o jogador está em modo de ataque
        global.slow_motion = true;  // Ativa o efeito de slow motion
        area += 10;  // Aumenta a área de alcance conforme o botão é pressionado
    }

    // Limpa as listas de inimigos e caminhos antes de começar a nova verificação
    ds_list_clear(enemy_list);
    ds_list_clear(path_list);

    // Detecta inimigos dentro da área de alcance (circular) e armazena na lista de inimigos
    var _circ = collision_circle_list(x, y, area, obj_enemy_par, false, false, enemy_list, true);

    // Se houver inimigos dentro da área de alcance
    if(ds_list_size(enemy_list) > 0){
        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            var _enemy = enemy_list[| _i];
            var _dist = point_distance(x, y, _enemy.x, _enemy.y);
            // Armazena a posição e a distância de cada inimigo
            ds_list_set(enemy_list, _i, [_enemy, _dist]);
        }

        // Ordena os inimigos pela distância, para atacar os mais próximos primeiro
        ds_list_sort(enemy_list, true);

        // Adiciona as posições dos inimigos na lista de caminhos a serem seguidos
        for(var _i = 0; _i < ds_list_size(enemy_list); _i++){
            var _enemy_data = enemy_list[| _i];
            var _enemy = _enemy_data[0];

            if(instance_exists(_enemy)){
                ds_list_add(path_list, [_enemy.x, _enemy.y]);
            }
        }
    }

    // Define a velocidade de movimento e inicializa a movimentação ao longo do caminho
    move_speed = 20;
    moving_along_path = false;
    path_position_index = 0;

} else { 
    // Se a habilidade não puder ser ativada (por falta de energia ou stamina), reseta os valores
    area = 0;
    global.slow_motion = false;
    layer_set_visible("screenshake_charging", 0);

    // Se já houver um caminho estabelecido, começa a mover ao longo do caminho
    if(!moving_along_path && ds_list_size(path_list) > 0){
        moving_along_path = true;
        path_position_index = 0;
    }
}
#endregion

#region Movimento ao Longo do Caminho
// Verifica se o jogador está se movendo ao longo de um caminho e se há um caminho definido
if(moving_along_path && ds_list_size(path_list) > 0){
    if(path_position_index < ds_list_size(path_list)){

        // Obtém a posição alvo no caminho
        var _target_pos = path_list[| path_position_index];
        var _target_x = _target_pos[0];
        var _target_y = _target_pos[1];

        // Calcula a direção e a distância até o próximo ponto no caminho
        var _dir = point_direction(x, y, _target_x, _target_y);
        var _dist = point_distance(x, y, _target_x, _target_y);

        // Se o jogador está se movendo (velocidade maior que 0)
        if(move_speed > 0){
            // Cria partículas de sombra e poeira enquanto o jogador se move
            timer++;
            if(timer >= 2){
                part_particles_create(obj_particle_setup.particle_system, x, y, obj_particle_setup.particle_shadow, 1);
                timer = 0;
            }

            part_particles_create(obj_particle_setup.particle_system_dust, x, y + 8, obj_particle_setup.particle_dust, 10);
        }

        // Se a distância até o alvo é maior que a velocidade de movimento, continua se movendo
        if(_dist > move_speed){
            // Move o jogador na direção do alvo
            x += lengthdir_x(move_speed, _dir);
            y += lengthdir_y(move_speed, _dir);

            // Adiciona a posição atual à fila de posições do rastro
            ds_queue_enqueue(trail_positions, [x, y]);

            // Limita o tamanho do rastro
            if(ds_queue_size(trail_positions) > trail_length){
                ds_queue_dequeue(trail_positions);
            }

            // Durante o movimento, o jogador não pode tomar dano e gasta toda a stamina
            if(move_speed > 0){
                can_take_dmg = false;    
                alarm[6] = 20;
                global.stamina = 0;
				global.can_attack = false;
            }

        } else {
            // Se o jogador chegou ao alvo, passa para o próximo ponto no caminho
            path_position_index++;

            // Se o jogador chegou ao último ponto, finaliza o movimento
            if(path_position_index >= ds_list_size(path_list)){
                moving_along_path = false;
                path_position_index = ds_list_size(path_list) - 1;
                move_speed = 0;
                global.slashing = false;  // Desativa o modo de corte
            }

            // Verifica se há um inimigo na posição alvo e aplica dano
            var _enemy_index = instance_position(_target_x, _target_y, obj_enemy_par);
            if(_enemy_index != noone){
                _enemy_index.vida -= 3;  // Diminui a vida do inimigo
                _enemy_index.emp_dir = point_direction(obj_player.x, obj_player.y, _enemy_index.x, _enemy_index.y);  // Define a direção de empurrão do inimigo
                _enemy_index.state = ENEMY_STATES.HIT;  // Define o estado de dano no inimigo
                _enemy_index.alarm[0] = 3;  // Alarme para ações relacionadas ao estado de dano
                _enemy_index.alarm[1] = 10;
                _enemy_index.alarm[5] = 80;
                _enemy_index.emp_veloc = 20;  // Velocidade de empurrão
                _enemy_index.hit_alpha = 1;  // Indica a animação de acerto

                // Adiciona a posição do ataque ao rastro fixo
                ds_list_add(trail_fixed_positions, [x, y, direction]);
                ds_list_add(trail_fixed_timer, 30);

                // Torna visível o efeito de tremor ao atingir inimigos
                layer_set_visible("screenshake_damaging_enemies", 1);
            }
            layer_set_visible("screenshake_damaging_enemies", 0);  // Reseta o tremor após o ataque
        }
    } else {
        // Se não há mais pontos no caminho, para o movimento
        moving_along_path = false;
    }
}
#endregion

#region Regeneração de Stamina
// Controla o tempo de regeneração da stamina
if(stamina_timer_regen > 0){
    stamina_timer_regen--;
} else {
    // Regenera a stamina até o máximo
    if(global.stamina < global.stamina_max){
        global.stamina += 5;  // Aumenta a stamina em 5 unidades
        stamina_timer_regen = stamina_timer;  // Reseta o temporizador
    }
}
// Garante que a stamina não ultrapasse o valor máximo
global.stamina = clamp(global.stamina, 0, global.stamina_max);
#endregion

#endregion

#region dust walk
if(xprevious != x and candust == true){
	candust = false;
	alarm[7] = 10;
	var _random_time = irandom_range(-1, 2);
	alarm_set(3, 8 + _random_time);
	part_particles_create(obj_particle_setup.particle_system_dust, x, y + 12, obj_particle_setup.particle_dust, 10);
}
if(yprevious != y and candust == true){
	candust = false;
	alarm[7] = 10;
	var _random_time = irandom_range(-1, 2);
	alarm_set(3, 8 + _random_time);
	part_particles_create(obj_particle_setup.particle_system_dust, x, y + 12, obj_particle_setup.particle_dust, 10);
}
#endregion

#region hit indication
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion