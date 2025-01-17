// Atualizando a lista de inimigos
if (global.hooking) {
    ds_list_clear(global.enemy_list);  // Limpa a lista de inimigos

    var _temp_list = ds_list_create();
    var _num_enemies = collision_circle_list(x, y, 10000, obj_enemy_par, false, false, _temp_list, true);

    if (_num_enemies > 0) {
        for (var i = 0; i < ds_list_size(_temp_list); i++) {
            var enemy = _temp_list[| i];
            ds_list_add(global.enemy_list, enemy);
        }
    }

    ds_list_destroy(_temp_list);

    // Garantir que o índice de inimigo selecionado seja válido
    if (global.selected_enemy_index >= ds_list_size(global.enemy_list) || global.selected_enemy_index < 0) {
        global.selected_enemy_index = -1;  // Nenhum inimigo selecionado
    }

    // Se nenhum inimigo está selecionado (índice -1), desmarcar todos os inimigos
    if (global.selected_enemy_index == -1) {
        for (var i = 0; i < ds_list_size(global.enemy_list); i++) {
            var enemy = global.enemy_list[| i];
            if (instance_exists(enemy)) {
                with (enemy) {
                    alligned = false;
                }
            }
        }
    }
}

// Alternar inimigo com scroll para cima
if (keyboard_check_pressed(ord("F"))) {
    if (ds_list_size(global.enemy_list) > 0) {
        // Desmarcar o inimigo atual
        if (global.selected_enemy_index >= 0 && global.selected_enemy_index < ds_list_size(global.enemy_list)) {
            var current_enemy = global.enemy_list[| global.selected_enemy_index];
            if (instance_exists(current_enemy)) {
                with (current_enemy) {
                    alligned = false;
                }
            }
        }

        // Atualizar o índice
        global.selected_enemy_index = (global.selected_enemy_index + 1) mod ds_list_size(global.enemy_list);

        // Marcar o próximo inimigo como alinhado
        var next_enemy = global.enemy_list[| global.selected_enemy_index];
        if (instance_exists(next_enemy)) {
            with (next_enemy) {
                alligned = true;
            }
        }
    }
}



// Garantir que o índice da lista seja válido antes de usar
if (global.selected_enemy_index < 0 || global.selected_enemy_index >= ds_list_size(global.enemy_list)) {
    global.selected_enemy_index = -1;  // Nenhum inimigo selecionado
}

// Se o índice for -1, garantir que todos os inimigos não estejam alinhados
if (global.selected_enemy_index == -1) {
    for (var i = 0; i < ds_list_size(global.enemy_list); i++) {
        var enemy = global.enemy_list[| i];
        if (instance_exists(enemy)) {
            with (enemy) {
                alligned = false;
                show_debug_message("aqui")
            }
        }
    }
}
