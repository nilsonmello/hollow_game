hsp = 0;
vsp = 0;

dash_timer = 0;

p_dir = 0;
p_time = 0;

attack_cooldown = 0;

list_colision = [
obj_wall,
obj_enemy_par,
obj_ambient
];

can_take_dmg = true;

sprite_index = spr_player_idle

lsm_init();

function apply_movement(move_h, move_v) {
    hsp += (MAX_HSP * move_h - hsp) * ACC;
    vsp += (MAX_VSP * move_v - vsp) * ACC;
}

function create_hitbox(_x, _y, _dir, _offset, _speed, _alarm_time) {
    var _sw_x = _x + lengthdir_x(_offset, _dir);
    var _sw_y = _y + lengthdir_y(_offset, _dir);

    var _sw = instance_create_depth(_sw_x, _sw_y, depth - 1, obj_hitbox);
    _sw.direction = _dir;
    _sw.image_angle = _dir
    _sw.speed = lerp(speed, _speed, .1);
    _sw.alarm[0] = _alarm_time;

    return _sw;
}

function handle_attack() {
    if (global.combo_timer > 0) global.combo_timer--;
    if (attack_cooldown > 0) attack_cooldown--;

    if (global.combo_timer <= 0 && global.combo > 0) {
        global.combo = 0;
    }
    
    if (global.combo = 3) {
        global.combo = 0;
    }

    if (INP.attack() && attack_cooldown <= 0) {
        global.can_move = false;

        attack_cooldown = ATTACK_COOLDOWN_DURATION;

        var _dir = point_direction(x, y, mouse_x, mouse_y);
        var _sw = create_hitbox(x, y, _dir, 0, 20, 10);
        
        switch (global.combo) {
            case 1:
                _sw.sprite_index = spr_hitbox;
            break;
            
            case 2:
                _sw.sprite_index = spr_hitbox_2;
            break;
            
            case 3:
                _sw.sprite_index = spr_hitbox_3;
            break;
        }

        hsp = lengthdir_x(8, _dir);
        vsp = lengthdir_y(8, _dir);

        global.combo_timer = COMBO_RESET_TIME;
    }
}

function handle_parry() {
    if (INP.parry()) {
        var _dir = point_direction(x, y, mouse_x, mouse_y);
        var _p = create_hitbox(x, y, _dir, 20, 0, 10);
        _p.sprite_index = spr_hitbox_parry;
        
        global.parry = true;
        global.can_move = false;
    }
}

lsm_add_free_state({
    step: function() {
        if (INP.dash()) {
            lsm_change("dash");
            return;
        }

        handle_parry(); 
        handle_attack();
        
        global.combo = clamp(global.combo, 0, 3);
    },
    draw: function() {
        var _spr_dir = floor((point_direction(x, y, mouse_x, mouse_y) + 90) / 180) % 2;
        switch (_spr_dir) {
            case 0:
                image_xscale = 1
            break
            case 1:
                image_xscale = -1
            break
        }
        
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, image_alpha)
    }
});

// Estado Idle
lsm_add("idle", {
    step: function() {
        var move_h = INP.r() - INP.l();
        var move_v = INP.d() - INP.u();

        if (move_h != 0 || move_v != 0) {
            lsm_change("run");
        } else {
            hsp = lerp(hsp, 0, DCC);
            vsp = lerp(vsp, 0, DCC);
        }
    },
    draw: function() {
        sprite_index = spr_player_idle
    },
});

// Estado Run
lsm_add("run", {
    step: function() {
        var move_h = INP.r() - INP.l();
        var move_v = INP.d() - INP.u();
        
        apply_movement(move_h, move_v);

        if (move_h == 0 && move_v == 0) {
            lsm_change("idle");
        }

        if (current_state == "sliding") {
            lsm_change("sliding");
        }
    },
    draw: function() {
        sprite_index = spr_player_walk_rl;
    },
});

// Estado Dash
lsm_add("dash", {
    enter: function() {
        dash_timer = DASH_DURATION;
        var move_h = INP.r() - INP.l();
        var move_v = INP.d() - INP.u();
        hsp = DASH_SPEED * move_h;
        vsp = DASH_SPEED * move_v;
    },
    step: function() {
        if (dash_timer > 0) dash_timer--;
        if (dash_timer <= 0) {
            lsm_change("run");
        }
    }
});

// Estado Hit
lsm_add("hit", {
    enter: function() {
        p_dir = point_direction(x, y, mouse_x, mouse_y);
    },
    step: function() {
        if (p_time > 0) {
            var move_x = lengthdir_x(P_SPD, p_dir);
            var move_y = lengthdir_y(P_SPD, p_dir);
            hsp = move_x;
            vsp = move_y;
            p_time--;
        } else {
            lsm_change("run");
        }
    }
});

// Estado Morte
lsm_add("morte", {
    enter: function() {
        game_restart();
    },
});

// Estado Sliding
lsm_add("sliding", {
    enter: function() {
        var _dir_to_wall = point_direction(x, y, global.wall_x, global.wall_y);
        hsp = lengthdir_x(10, _dir_to_wall);
        vsp = lengthdir_y(10, _dir_to_wall);
    },
    step: function() {
        move_x(hsp, list_colision);
        move_y(vsp, list_colision);
        
        hsp = lerp(hsp, 0, .05);
        vsp = lerp(vsp, 0, .05);
        
        if (abs(hsp) < 1 && abs(vsp) < 1) {
            lsm_change("idle");
        }
    },
});

current_state = "idle";

if (!instance_exists(obj_hook)) {
    var _hook = instance_create_layer(x, y, "Instances_player", obj_hook);
}