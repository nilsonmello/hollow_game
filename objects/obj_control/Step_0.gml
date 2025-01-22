//temporary list to store detected enemies
var _temp_list = ds_list_create();

//detect enemies within a large radius
var _enemies = collision_circle_list(x, y, 10000, obj_enemy_par, false, false, _temp_list, false);

//if there are enemies in the area
if (_enemies > 0) {
    //iterate through the temporary list of enemies
    for (var i = 0; i < ds_list_size(_temp_list); i++) {
        //get the enemy instance from the list
        var _enemy = _temp_list[| i];
        
        //variable to check if the enemy is already in the global list
        var already_in_list = false;

        //iterate through the global list of enemies
        for (var j = 0; j < ds_list_size(global.enemy_list); j++) {
            //if the enemy is already in the global list, mark as true
            if (global.enemy_list[| j] == _enemy) {
                already_in_list = true;
                break;
            }
        }
        //add to the global list if not already present
        if (!already_in_list) {
            ds_list_add(global.enemy_list, _enemy);
        }
    }
}

//destroy the temporary list
ds_list_destroy(_temp_list);

//activate or deactivate enemy lock based on the detected count
if (_enemies > 0) {
    global.hooking = true;
} else {
    global.hooking = false;  
}

//if enemy lock is active
if (global.hooking) {
    //remove destroyed enemies from the global list and update the index
    for (var i = ds_list_size(global.enemy_list) - 1; i >= 0; i--) {
        var _enemy = global.enemy_list[| i];
        if (!instance_exists(_enemy)) {
            ds_list_delete(global.enemy_list, i);
            //adjust the index if the destroyed enemy was the selected one
            if (i == global.index) {
                global.index = (i < ds_list_size(global.enemy_list)) ? i : 0;
            }
        }
    }

    //ensure the index is valid if there are still enemies in the list
    if (ds_list_size(global.enemy_list) > 0) {
        global.index = clamp(global.index, 0, ds_list_size(global.enemy_list) - 1);

        //get the enemy selected by the current index
        var _selected = global.enemy_list[| global.index];
        if (instance_exists(_selected)) {
            with (_selected) {
                alligned = true;
            }
        }

        //change the index upwards when scrolling the mouse wheel up
        if (mouse_wheel_up()) {
            //deselect the currently selected enemy
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = false;
                }
            }

            //update the index to the next enemy
            global.index = (global.index + 1) mod ds_list_size(global.enemy_list);

            //mark the next enemy as selected
            _selected = global.enemy_list[| global.index];
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = true;
                }
            }
        }
        
        //change the index downwards when scrolling the mouse wheel down
        if (mouse_wheel_down()) {
            //deselect the currently selected enemy
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = false;
                }
            }
        
            //update the index to the previous enemy
            global.index = (global.index - 1 + ds_list_size(global.enemy_list)) mod ds_list_size(global.enemy_list);
        
            //mark the previous enemy as selected
            _selected = global.enemy_list[| global.index];
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = true;
                }
            }
        }
        
    } else {
        //if there are no enemies in the list, reset the index
        global.index = -1;
    }
} else {
    //deactivate the lock and deselect all enemies
    global.index = -1;
    with (obj_enemy_par) {
        alligned = false;
    }
}
