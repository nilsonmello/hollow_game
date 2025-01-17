//lista temporária
var _temp_list = ds_list_create();

//perceber inimigos
var _enemies = collision_circle_list(x, y, 10000, obj_enemy_par, false,false, _temp_list, false);

//caso existam
if (_enemies > 0) {
    //itera pelos inimigos
    for (var i = 0; i < ds_list_size(_temp_list); i++) {
        //instancia os inimigos na lista
        var _enemy = _temp_list[| i]
        
        //variavel apra impedir adicionar a mesma instancia duas vezes
        var already_in_list = false;
        //itera novamente agora pela lista global
        for (var j = 0; j < ds_list_size(global.enemy_list); j++) {
            //caso ele já esteja na lista, variavel verdadeira
            if (global.enemy_list[| j] == _enemy) {
                already_in_list = true;
                break;
            }
        }
        //adiciona apenas se não estiver na lista
        if (!already_in_list) {
            ds_list_add(global.enemy_list, _enemy);
        }
    }
}

//destrói a lista temporária
ds_list_destroy(_temp_list);

//apertar F para a trava
if (keyboard_check_pressed(ord("F"))) {
    global.hooking = !global.hooking;
}

// Caso ative a trava
if (global.hooking) {
    //tirar inimigos destruídos da lista e atualizar o índice
    for (var i = ds_list_size(global.enemy_list) - 1; i >= 0; i--) {
        var _enemy = global.enemy_list[| i];
        if (!instance_exists(_enemy)) {
            ds_list_delete(global.enemy_list, i);
            //se o inimigo destruído era o selecionado, ajustar o índice para o próximo
            if (i == global.index) {
                global.index = (i < ds_list_size(global.enemy_list)) ? i : 0;
            }
        }
    }

    // se ainda existirem inimigos, garantir que o índice seja válido
    if (ds_list_size(global.enemy_list) > 0) {
        global.index = clamp(global.index, 0, ds_list_size(global.enemy_list) - 1);

        //selecionar o inimigo no índice atual
        var _selected = global.enemy_list[| global.index];
        if (instance_exists(_selected)) {
            with (_selected) {
                alligned = true;
            }
        }

        //mudar indice no R
        if (keyboard_check_pressed(ord("R"))) {
            // Desmarcar o inimigo atual
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = false;
                }
            }

            // aatualizar o indice
            global.index = (global.index + 1) mod ds_list_size(global.enemy_list);

            // Marcar o próximo inimigo
            _selected = global.enemy_list[| global.index];
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = true;
                }
            }
        }
    } else {
        // Se não tiver inimigos na lista, resetar o índice
        global.index = -1;
    }
} else {
    // desativar a trava
    global.index = -1;
    with (obj_enemy_par) {
        alligned = false;
    }
}