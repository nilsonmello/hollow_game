//layers for the orbiting state
var front_layer_id = layer_get_id("Instances_bellow");
var back_layer_id = layer_get_id("Instances_above");

//orbiting state
if (state == "orbiting") {
    
    //reset the target
    target_enemy = noone;
    
    //increasing the angle
    orbit_angle += orbit_speed;
    
    //distance x and y to do the orbit
    var orbit_distance_x = orbit_distance;
    var orbit_distance_y = orbit_distance * 0.5;
    
    //creating the movement
    var new_x = lengthdir_x(orbit_distance_x, orbit_angle);
    var new_y = lengthdir_y(orbit_distance_y, orbit_angle);
    
    //keeping it near by the player
    x = obj_player.x + new_x;
    y = obj_player.y + new_y;
    
    //using y to change the hook layer during the orbit
    if (y > obj_player.y) {
        layer = back_layer_id;
    } else {
        layer = front_layer_id;
    }
    
    //launching the hoook
    if (keyboard_check_pressed(ord("E"))) {
        //closing the orbit
        orbit_distance = 0;
        orbit_angle = 0;
        orbit_speed = 0;
        
        //centralizing with the player
        x = obj_player.x;
        y = obj_player.y;
        
        //choose direction
        var mouse_dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y);
        
        //inicial and final direction
        state = "launched";
        launch_origin_x = obj_player.x;
        launch_origin_y = obj_player.y;
        dir = mouse_dir;
    }
}

//launched state
if (state == "launched") {
    //if the enemy is existent
    if (global.index != -1 && global.index < ds_list_size(global.enemy_list)) {
        //keep the information of the enemy
        var selected_enemy = global.enemy_list[| global.index];
        
        //if he exists
        if (instance_exists(selected_enemy)) {
            
            //setting x and y variables
            var enemy_x = selected_enemy.x;
            var enemy_y = selected_enemy.y;
            
            //choosing direction
            dir = point_direction(x, y, enemy_x, enemy_y);

            //moving the hook
            x += lengthdir_x(spd, dir);
            y += lengthdir_y(spd, dir);
            
            //if the hook reach the target
            if (point_distance(x, y, enemy_x, enemy_y) < 10) {
                //change the state and set the target
                state = "retracting";
                target_enemy = selected_enemy;
            }
        } else {
            //normal return to the player
            state = "retracting";
        }
        
        //reach the enemy
        var _enemy = instance_place(x, y, obj_enemy_par);
        //if he exists
        if (instance_exists(_enemy)) {
            //change the state and push the enemy
            state = "retracting";
            target_enemy = _enemy;
            with (target_enemy) {
                path_end()
            }
        }
        
        //if reach a wall
        if (place_meeting(x, y, obj_wall)) {
            wall_type = 0;
            //change state and pull to the wall
            state = "retracting";
            target_wall = true;
            wall_x = x;     
            wall_y = y;
            wall_exists = true;
        }
        
        //if reach a wall
        if (place_meeting(x, y, obj_hook_move)) {
            wall_type = 1;
            //change state and pull to the wall
            state = "retracting";
            target_wall = true;
            wall_x = x;     
            wall_y = y;
            wall_exists = true;
        }
    } else {
        //if it didnt reach nothing, launch in the direction of the mouse and return
        target_enemy = noone;
        x += lengthdir_x(spd, dir);
        y += lengthdir_y(spd, dir);
        
        //if reach the max distance, return
        if (point_distance(launch_origin_x, launch_origin_y, x, y) >= max_dist) {
            state = "retracting";
        }
        
        //if reach an enemy, retract 
        var _enemy = instance_place(x, y, obj_enemy_par);
        if (instance_exists(_enemy)) {
            state = "retracting";
            target_enemy = _enemy;
        } 
        //if reach a wall, retract 
        if (place_meeting(x, y, obj_wall)) {
            wall_type = 0;
            state = "retracting";
            target_wall = true;
            wall_x = x;     
            wall_y = y;
            wall_exists = true;
        }
        
        //if reach a wall, retract 
        if (place_meeting(x, y, obj_hook_move)) {
            wall_type = 1;
            state = "retracting";
            target_wall = true;
            wall_x = x;     
            wall_y = y;
            wall_exists = true;
        }
    }
}

//state retracting
if (state == "retracting") {
    //if hit a wall
    if (target_wall && wall_exists) {
            //keep direction, distance to stop and distance to the wall
        var _dir_to_wall = point_direction(obj_player.x, obj_player.y, wall_x, wall_y);
        var _stop_dist = 30;
        var _dist_to_wall = point_distance(obj_player.x, obj_player.y, wall_x, wall_y);
        
        switch (wall_type) {
            case 0:
                //while distance to the wall is bigger tha stop_dist
                if (_dist_to_wall > _stop_dist) {
                    //move the player
                    obj_player.x += lengthdir_x(spd, _dir_to_wall);
                    obj_player.y += lengthdir_y(spd, _dir_to_wall);
                } else {
                    //stop the player and change the state
                    state = "orbiting";
                    
                    //initial x and y for the launch
                    launch_origin_x = obj_player.x;
                    launch_origin_y = obj_player.y;
                    
                    //reseting target_wall
                    if (target_wall) {
                        wall_exists = false;
                    }
                    
                    //reseting the orbit variables
                    orbit_distance = 10;
                    orbit_angle = 0;
                    orbit_speed = 1;
                }
            break;
            
            case 1:
                //while distance to the wall is bigger tha stop_dist
                if (_dist_to_wall > _stop_dist && !is_drifting) {
                    //move the player
                    obj_player.x += lengthdir_x(spd, _dir_to_wall);
                    obj_player.y += lengthdir_y(spd, _dir_to_wall);
                } else {
                    
                    is_drifting = true;
                    
                    if (is_drifting) {
                        //stop the player and change the state
                        state = "orbiting";
                        
                        //initial x and y for the launch
                        launch_origin_x = obj_player.x;
                        launch_origin_y = obj_player.y;
                        
                        //reseting target_wall
                        if (target_wall) {
                            wall_exists = false;
                        }
                        
                        //reseting the orbit variables
                        orbit_distance = 10;
                        orbit_angle = 0;
                        orbit_speed = 1; 
                    }
                }
            break;
        }
    } else {
        //direction to return
        var _dir_back = point_direction(x, y, obj_player.x, obj_player.y);
        
        //moving the hook
        x += lengthdir_x(spd, _dir_back);
        y += lengthdir_y(spd, _dir_back);
        
        
        //check if the target enemy exists
        if (instance_exists(target_enemy)) {
            //switching the case based on the enemy size
            switch (target_enemy.size) {
                case 1:
                    //check if the target enemy still exists
                    if (instance_exists(target_enemy)) {
                        //end the enemy's current path
                        with (target_enemy) {
                            path_end()
                        }
                        //calculate the distance to the player
                        var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
                
                        //if the distance is greater than 40, move the enemy
                        if (_dist_to_player > 40) {
                            target_enemy.x = x;
                            target_enemy.y = y;
                        } else {
                            //otherwise, move the enemy closer to the player
                            var _front_dir = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                            var _stop_dist = 20;
                            target_enemy.x = obj_player.x + lengthdir_x(_stop_dist, _front_dir);
                            target_enemy.y = obj_player.y + lengthdir_y(_stop_dist, _front_dir);
                        }
                    }
            
                    //if the hook reaches near the player, trigger an action
                    if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                        if (instance_exists(target_enemy)) {
                            //set the enemy state to HIT and apply force
                            with (target_enemy) {
                                state = ENEMY_STATES.HIT;
                                emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                                emp_veloc = 6;
                            }
                        }
                        //switch to orbiting state
                        state = "orbiting";
                        
                        //set new orbit parameters
                        launch_origin_x = obj_player.x;
                        launch_origin_y = obj_player.y;
                        
                        orbit_distance = 10;
                        orbit_angle = 0;
                        orbit_speed = 1;
                    }
                    break;
                
                case 2:
                    //check if the enemy is not knocked
                    if (target_enemy.state != ENEMY_STATES.KNOCKED){
                        //check if the hook hits the wall and exists
                        if (target_wall && wall_exists) {
                            var _dir_to_wall = point_direction(obj_player.x, obj_player.y, wall_x, wall_y);
                            var _stop_dist = 30;
                            var _dist_to_wall = point_distance(obj_player.x, obj_player.y, wall_x, wall_y);
                    
                            //move towards the wall if needed
                            if (_dist_to_wall > _stop_dist) {
                                obj_player.x += lengthdir_x(spd, _dir_to_wall);
                                obj_player.y += lengthdir_y(spd, _dir_to_wall);
                            } else {
                                //switch to orbiting state
                                state = "orbiting";
                                
                                //set new orbit parameters
                                launch_origin_x = obj_player.x;
                                launch_origin_y = obj_player.y;
                                
                                if (target_wall) {
                                    wall_exists = false;
                                }
                        
                                orbit_distance = 10;
                                orbit_angle = 0;
                                orbit_speed = 1;
                            }
                        } else {
                            //if no wall hit, move the player towards the enemy
                            if (instance_exists(target_enemy)) {
                                with (target_enemy) {
                                    path_end()
                                }
                                var _dir_to_enemy = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                                var _stop_dist = 40;
                                var _dist_to_enemy = point_distance(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                        
                                //move the player closer to the enemy if necessary
                                if (_dist_to_enemy > _stop_dist) {
                                    obj_player.x += lengthdir_x(spd, _dir_to_enemy);
                                    obj_player.y += lengthdir_y(spd, _dir_to_enemy);
                                } else {
                                    //switch to orbiting state
                                    state = "orbiting";
                                    
                                    //set new orbit parameters
                                    launch_origin_x = obj_player.x;
                                    launch_origin_y = obj_player.y;
                                    
                                    orbit_distance = 10;
                                    orbit_angle = 0;
                                    orbit_speed = 1;
                                }
                            } else {
                                //if no enemy, move back to the player
                                var _dir_back = point_direction(x, y, obj_player.x, obj_player.y);
                                x += lengthdir_x(spd, _dir_back);
                                y += lengthdir_y(spd, _dir_back);
                        
                                //if close enough, start orbiting
                                if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                                    state = "orbiting";
                                    
                                    launch_origin_x = obj_player.x;
                                    launch_origin_y = obj_player.y;
                                    
                                    orbit_distance = 10;
                                    orbit_angle = 0;
                                    orbit_speed = 1;
                                }
                            }
                        }
                    } else {
                        //if the enemy is knocked, move the enemy closer
                        if (instance_exists(target_enemy)) {
                            var _dist_to_player = point_distance(target_enemy.x, target_enemy.y, obj_player.x, obj_player.y);
                    
                            //if the distance is greater than 40, move the enemy
                            if (_dist_to_player > 40) {
                                target_enemy.x = x;
                                target_enemy.y = y;
                            } else {
                                //otherwise, move the enemy closer to the player
                                var _front_dir = point_direction(obj_player.x, obj_player.y, target_enemy.x, target_enemy.y);
                                var _stop_dist = 20;
                                target_enemy.x = obj_player.x + lengthdir_x(_stop_dist, _front_dir);
                                target_enemy.y = obj_player.y + lengthdir_y(_stop_dist, _front_dir);
                            }
                        }
                
                        //if the hook is close to the player, trigger the action
                        if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                            if (instance_exists(target_enemy)) {
                                with (target_enemy) {
                                    state = ENEMY_STATES.HIT;
                                    emp_dir = point_direction(x, y, obj_player.x, obj_player.y);
                                    emp_veloc = 6;
                                }
                            }
                            state = "orbiting";
                            
                            launch_origin_x = obj_player.x;
                            launch_origin_y = obj_player.y;
                            
                            orbit_distance = 10;
                            orbit_angle = 0;
                            orbit_speed = 1;
                        }
                    }
                    break;
            }
        } else {
            //if no target enemy, check if the hook is close to the player and switch to orbiting state
            if (point_distance(x, y, obj_player.x, obj_player.y) < 5) {
                state = "orbiting";
                
                launch_origin_x = obj_player.x;
                launch_origin_y = obj_player.y;
                
                orbit_distance = 10;
                orbit_angle = 0;
                orbit_speed = 1;
            }
        }
    }
}