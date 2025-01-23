//temporary list to store detected enemies
var _temp_list = ds_list_create();

//detect enemies within a large radius
var _enemies = collision_circle_list(x, y, 10000, obj_enemy_par, false, false, _temp_list, false);

//if there are enemies in the area
if (_enemies > 0) {
    for (var i = 0; i < ds_list_size(_temp_list); i++) {
        var _enemy = _temp_list[| i];
        if (ds_list_find_index(global.enemy_list, _enemy) == -1) {
            ds_list_add(global.enemy_list, _enemy);
        }
    }
}

//destroy the temporary list
ds_list_destroy(_temp_list);

//check proximity to player
var _near = false;
for (var i = ds_list_size(global.enemy_list) - 1; i >= 0; i--) {
    var _enemy = global.enemy_list[| i];
    if (!instance_exists(_enemy)) {
        ds_list_delete(global.enemy_list, i);
        continue;
    }
    if (point_distance(obj_player.x, obj_player.y, _enemy.x, _enemy.y) < 200) {
        _near = true;
    }
}

//save the previous hooking state
var prev_hooking = global.hooking;

//activate or deactivate enemy lock based on proximity
global.hooking = (_enemies > 0 && _near);

//if hooking was just activated, set the closest enemy as the initial target
if (global.hooking && !prev_hooking) {
    var closest_distance = 999999;
    var closest_index = -1;

    for (var i = 0; i < ds_list_size(global.enemy_list); i++) {
        var _enemy = global.enemy_list[| i];
        if (instance_exists(_enemy)) {
            var _distance = point_distance(obj_player.x, obj_player.y, _enemy.x, _enemy.y);
            if (_distance < closest_distance) {
                closest_distance = _distance;
                closest_index = i;
            }
        }
    }

    //set the closest enemy as the current target
    if (closest_index != -1) {
        global.index = closest_index;
    } else {
        global.index = 0;
    }
}

//if enemy lock is active
if (global.hooking) {
    if (ds_list_size(global.enemy_list) > 0) {
        //ensure the index is valid
        global.index = clamp(global.index, 0, ds_list_size(global.enemy_list) - 1);

        //get the currently selected enemy
        var _selected = global.enemy_list[| global.index];
        if (instance_exists(_selected)) {
            with (_selected) {
                alligned = true;
            }
        }

        //change selection with mouse wheel
        if (mouse_wheel_up()) {
            //deselect the current enemy
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = false;
                }
            }

            //move to the next enemy
            global.index = (global.index + 1) mod ds_list_size(global.enemy_list);

        } else if (mouse_wheel_down()) {
            //deselect the current enemy
            if (instance_exists(_selected)) {
                with (_selected) {
                    alligned = false;
                }
            }

            //move to the previous enemy
            global.index = (global.index - 1 + ds_list_size(global.enemy_list)) mod ds_list_size(global.enemy_list);
        }

        //mark the newly selected enemy
        _selected = global.enemy_list[| global.index];
        if (instance_exists(_selected)) {
            with (_selected) {
                alligned = true;
            }
        }
    } else {
        //if no enemies in the list, reset the index
        global.index = -1;
    }
} else {
    //deactivate the lock and deselect all enemies
    global.index = -1;
    with (obj_enemy_par) {
        alligned = false;
    }
}
