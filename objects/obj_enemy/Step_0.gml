// State Machine for Enemy with corrections to speed management
size = 1;

#region variables and timers
event_inherited();

// Case enemy is dead
if (vida <= 0) {
    state = ENEMY_STATES.DEATH;
}

// Time between attacks
if (time_per_attacks > 0) {
    time_per_attacks--;
}
#endregion

switch (state) {
    #region choose
    case ENEMY_STATES.CHOOSE:
        state_time = irandom_range(70, 120);
        state = choose(ENEMY_STATES.MOVE, ENEMY_STATES.IDLE);

        x_point = irandom_range(0, room_width);
        y_point = irandom_range(0, room_height);
    break;
    #endregion

    #region idle
    case ENEMY_STATES.IDLE:
        state_time--;

        if (state_time <= 0) {
            state = ENEMY_STATES.CHOOSE;
        }

        if (timer_check <= 0) {
            check_for_player(range);
    
        }
    break;
    #endregion

    #region movement
    case ENEMY_STATES.MOVE:
        state_time--;

        var _dir = point_direction(x, y, x_point, y_point);

        vel_h = lengthdir_x(vel_mov, _dir);
        vel_v = lengthdir_y(vel_mov, _dir);

        enemy_colide();

        if (distance_to_point(x_point, y_point) > vel_h && distance_to_point(x_point, y_point) > vel_v) {
            x += vel_h;
            y += vel_v;
        } else {
            state = ENEMY_STATES.CHOOSE;
        }

        if (state_time <= 0) {
            state = ENEMY_STATES.CHOOSE;
        }
        if (timer_check <= 0) {
            check_for_player(range);
    
        }
    break;
    #endregion

    case ENEMY_STATES.STOP:
        attacking = false;
        state_time--;
        timer_check = 50;

        var _target_x, _target_y;
        var _path_found = false;
        var _attempts = 0;
        var _max_attempts = 10;

        while (!_path_found && _attempts < _max_attempts) {
            _target_x = x + irandom_range(-100, 100);
            _target_y = y + irandom_range(-100, 100);

            var _min_dist_ok = true;
            var _list = ds_list_create();
            var _rec = collision_rectangle_list(_target_x - 20, _target_y - 20, _target_x + 20, _target_y + 20, obj_enemy_par, false, false, _list, false);

            if (ds_list_size(_list) > 0) {
                _min_dist_ok = false;
            }

            ds_list_destroy(_list);

            if (_min_dist_ok) {
                mp_grid_clear_all(global.mp_grid);
                mp_grid_add_instances(global.mp_grid, obj_wall, false);
                mp_grid_add_instances(global.mp_grid, obj_enemy_par, false);

                if (mp_grid_path(global.mp_grid, path, x, y, _target_x, _target_y, true)) {
                    _path_found = true;
                }
            }

            _attempts++;
        }

        if (_path_found) {
            path_start(path, move_speed, path_action_stop, false);
            state_time = irandom_range(30, 60);
        } else {
            state = ENEMY_STATES.MOVE;
            state_time = irandom_range(80, 120);
        }
        break;
    
    
    #region hit
    case ENEMY_STATES.HIT:
        attacking = false;
        warning = false;

        timer_hit_at++;
        time_per_attacks = 40;

        if (emp_timer > 0) {
            emp_timer--;

            vel_h = lengthdir_x(emp_veloc, emp_dir);
            vel_v = lengthdir_y(emp_veloc, emp_dir);

            emp_veloc = lerp(emp_veloc, 0, .01);

            enemy_colide();

            x += vel_h;
            y += vel_v;
        }

        if (timer_hit_at >= timer_hit) {
            state = ENEMY_STATES.IDLE;
            hit = true;
            attack = false;
            timer_hit_at = 0;
        }
    break;
    #endregion

    #region knocked
    case ENEMY_STATES.KNOCKED:
        stamina_at += .5;
        if (stamina_at < stamina_t) {
            if (hit) {
                hit = false;
                alarm[1] = 0;
            }

            if (emp_timer > 0) {
                emp_timer--;
                vel_h = lengthdir_x(emp_veloc, emp_dir);
                vel_v = lengthdir_y(emp_veloc, emp_dir);

                emp_veloc = lerp(emp_veloc, 0, .01);

                enemy_colide();

                x += vel_h;
                y += vel_v;
            }
        } else {
            state = ENEMY_STATES.IDLE;
            hit = true;
            attack = false;
            knocked = false;
        }
    break;
    #endregion

    #region waiting attack
    case ENEMY_STATES.WAITING:
        attacking = true;

        enemy_colide();

        if (time_per_attacks <= 0) {
            warning = true;
            atk_wait--;

            if (atk_wait <= 0) {
                atk_time = 8
                state = ENEMY_STATES.ATTACK;
                dire = point_direction(x, y, obj_player.x, obj_player.y);
            }
        } else {
            state = ENEMY_STATES.MOVE;
        }
    break;
    #endregion

    #region attack
    case ENEMY_STATES.ATTACK:
        atk_time--;
        warning = false;
        vel_mov = 10
        if (atk_time > 0) {
            vel_mov = lerp(vel_mov, 0, 0.2);
            vel_h = lengthdir_x(vel_mov, dire);
            vel_v = lengthdir_y(vel_mov, dire);
    
            enemy_colide();
    
            x += vel_h;
            y += vel_v;
    
            if (!has_attacked) {
                enemy_attack();
            }
        } else {
            vel_mov = .9;
            state = ENEMY_STATES.MOVE;
            attacking = false;
            has_attacked = false;
            time_per_attacks = 110;
        }
    break;
    #endregion
    

    #region death
    case ENEMY_STATES.DEATH:
        part_particles_create(particle_system_explosion, x, y, particle_circle, 1);
        part_particles_create(particle_system_explosion, x, y, particle_explosion, 8);
        part_particles_create(particle_system_explosion, x, y, particle_explosion_2, 8);

        var _chances = irandom(2);

        if (_chances == 2) {
            repeat (1) {
                var p = instance_create_layer(x, y, "Instances_player", obj_energy_dust);
                p.dist = point_distance(obj_player.x, obj_player.y, x, y);
                p.angle = point_direction(obj_player.x, obj_player.y, x, y);
            }
        }
        instance_destroy();
    break;
    #endregion
}

vel_mov = .9;