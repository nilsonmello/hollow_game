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

//caso aperte F habilita a trava de inimigo
if (keyboard_check_pressed(ord("F"))) {
    global.hooking = !global.hooking;
}

//caso ative a trava
if (global.hooking) {
    //R para mudar o indice
    if (keyboard_check_pressed(ord("R"))) {
        
        //contagem do indice de acordo com o tamanho da lista
        if (ds_list_size(global.enemy_list) > 0) {
            if (global.index < ds_list_size(global.enemy_list) - 1) {
                global.index++;    
            } else {
                global.index = 0;
            }
            
            //o atual e o anterior dos inimigos
            var _selected = global.enemy_list[| global.index];
            var _previous = global.enemy_list[| (global.index == 0) ? ds_list_size(global.enemy_list) - 1 : global.index - 1];
            
            //ativa a marca do atual e desmarca a do anterior
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = true;
                }   
            } else {
              ds_list_delete(global.enemy_list, global.index);
              global.index = -1;  
            }
            with (_previous) {
                alligned = false;
            }
        }
    }
//caso desative a trava, index -1 e destrava o inimigo atual    
} else {
    global.index = -1;
    with (obj_enemy_par) {
        alligned = false;
    }
}

show_debug_message(global.index)