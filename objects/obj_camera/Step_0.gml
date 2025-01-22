//check if the target exists
if (instance_exists(view_target)) {
    //check if the player is in the "hooking" state
    if (global.hooking) {
        //initialize a variable to hold the current enemy
        var _enemy = undefined;
        
        //if there are enemies in the list, and the current index is valid
        if (ds_list_size(global.enemy_list) > 0 && global.index >= 0 && global.index < ds_list_size(global.enemy_list)) {
            //assign the enemy at the current index to _enemy
            _enemy = global.enemy_list[| global.index];

            //check if the enemy no longer exists
            if (!instance_exists(_enemy)) {
                //remove the enemy from the list
                ds_list_delete(global.enemy_list, global.index);
                //adjust the index to ensure it's within the list range
                global.index = (global.index >= ds_list_size(global.enemy_list)) ? 0 : global.index;
                
                //if there are still enemies in the list
                if (ds_list_size(global.enemy_list) > 0) {
                    //assign the new enemy at the updated index to _enemy
                    _enemy = global.enemy_list[| global.index];
                } else {
                    //if no enemies remain, set _enemy to undefined
                    _enemy = undefined;
                }
            }
        }

        //if an enemy exists
        if (instance_exists(_enemy)) {
            
            //calculate the horizontal and vertical distance between the player and the enemy
            var dist_x = abs(view_target.x - _enemy.x);
            var dist_y = abs(view_target.y - _enemy.y);
            
            //determine the maximum distance (used for zoom scaling)
            var distance = max(dist_x, dist_y);
            
            //calculate the zoom scale based on the distance, clamped between 1 and 2
            var target_zoom = clamp(1 + (distance / 1000), 1, 2);
            //smoothly interpolate the zoom scale
            zoom_scale = lerp(zoom_scale, target_zoom, 0.1);
            
            //adjust the width and height of the camera view based on the zoom scale
            global.view_width = resolution_width div resolution_scale * zoom_scale;
            global.view_height = resolution_height div resolution_scale * zoom_scale;
            
            //resize the application surface to match the new camera size
            surface_resize(application_surface, global.view_width * resolution_scale, global.view_height * resolution_scale);
            //adjust the GUI size to match the new view dimensions
            display_set_gui_size(global.view_width, global.view_height);

            //calculate the target position to center the camera between the player and the enemy
            var target_x = (view_target.x + _enemy.x) / 2;
            var target_y = (view_target.y + _enemy.y) / 2;
        } else {
            //if no enemy exists, set the camera to focus on the player only
            var target_x = view_target.x;
            var target_y = view_target.y;
        }

        //smoothly interpolate the camera's X position towards the target position
        x = lerp(x, target_x - global.view_width / 2, view_spd);
        //smoothly interpolate the camera's Y position towards the target position
        y = lerp(y, target_y - global.view_height / 2, view_spd);

        //clamp the camera's X position to ensure it stays within the room boundaries
        x = clamp(x, 0, room_width - global.view_width);
        //clamp the camera's Y position to ensure it stays within the room boundaries
        y = clamp(y, 0, room_height - global.view_height);

        //set the camera's view position
        camera_set_view_pos(view_camera[0], x, y);
    } else {
        //if the player is not "hooking", center the camera between the player and the mouse
        var target_x = lerp(view_target.x, mouse_x, 0.3);
        var target_y = lerp(view_target.y, mouse_y, 0.3);

        //smoothly interpolate the camera's x position towards the target position
        x = lerp(x, target_x - global.view_width / 2, view_spd);
        //smoothly interpolate the camera's y position towards the target position
        y = lerp(y, target_y - global.view_height / 2, view_spd);

        //clamp the camera's X position to ensure it stays within the room boundaries
        x = clamp(x, 0, room_width - global.view_width);
        //clamp the camera's Y position to ensure it stays within the room boundaries
        y = clamp(y, 0, room_height - global.view_height);

        //set the camera's view position
        camera_set_view_pos(view_camera[0], x, y);
    }
}

//#region screenshake control
if (alarm[1] > 0) {
    //show the screen shake effect layer when the alarm is active
    layer_set_visible("screenshake_damaging_enemies", 1);
} else {
    //hide the screen shake effect layer when the alarm is inactive
    layer_set_visible("screenshake_damaging_enemies", 0);
}
//#endregion