#region constructor
function scr_create_weapon(_name, _dmg, _spd, _fire_rate, _bullet_sprite, _automatic, _bps, _weapon_spr, _custom_function, _wall_colide, _cost_per_shot, _recoil){
    return{
        name: _name,
        damage: _dmg,
        fire_rate: _fire_rate,
        bullet_sprite: _bullet_sprite,
        automatic: _automatic,
        bp_shoot: _bps,
        cost_per_shot: _cost_per_shot,
        shot_cooldown: 0,
        can_shoot: true,
        weapon_sprite: _weapon_spr,
        custom_function: _custom_function,
        coliding_walls: _wall_colide,
		recoil_player: _recoil,
		b_spd: _spd,

		shoot: function(_x, _y){
		    if(global.energy >= cost_per_shot && shot_cooldown <= 0 && can_shoot){
        
		        recoil = recoil_player;
        
		        var _spread = 6;
		        var _base_dir = point_direction(_x, _y, mouse_x, mouse_y);
				var _spread_max = 10;

				for (var _i = 0; _i < bp_shoot; _i++) {
				    var _bullet = instance_create_layer(_x, _y, "Instances", obj_bullet);
				    _bullet.sprite_index = bullet_sprite;
				    _bullet.speed = b_spd;
				    _bullet.damage = damage;
				    _bullet.x = _x;
				    _bullet.y = _y;

				    var _random_spread = random_range(-_spread_max, _spread_max);
					if(automatic){
						_bullet.direction = _base_dir + _random_spread;
					}else{
						var _dir = _base_dir + (_spread * (_i - (bp_shoot - 1) / 2));
						_bullet.direction = _dir;
					}

				    _bullet.custom_function = function(_bullet) {
				        custom_function(_bullet);
				    };

				    _bullet.coliding_walls = function(_bullet) {
				        coliding_walls(_bullet);
				    };
				}

		        global.energy -= cost_per_shot;
		        shot_cooldown = fire_rate;
		        can_shoot = false;
		    }
		},

        update_cooldown: function(){
            if(shot_cooldown > 0){
                shot_cooldown -= 1;
            }
            if(shot_cooldown <= 0 && !can_shoot){ 
                can_shoot = true;
            }
        },
    };
}
#endregion

#region guns
vazio = scr_create_weapon("vazio", 0, 0, 0, 0, 0, false, 0, function(){}, function(){}, 0, 0);

shotgun = scr_create_weapon("Shotgun", 1, 4, 100, spr_bullet, false, 5, spr_weapon, function colide_shotgun(_bullet){
    with(other){
        state = ENEMY_STATES.HIT;
        path_end();
        alarm[0] = 6;
        var _dir = point_direction(other.x, other.y, x, y);
        emp_dir = _dir;
        emp_veloc = 6;
        vida -= 1;
		hit_alpha = 1;
    }
    instance_destroy(_bullet);
}, function wall_colide(_bullet){instance_destroy(_bullet);}, 5, 6);

pistol = scr_create_weapon("Pistol", 2, 4, 100, spr_bullet, false, 1, spr_weapon_2, function colide_pistol(_bullet){
    with(other){
        state = ENEMY_STATES.HIT;
        path_end();
        alarm[0] = 6;
        var _dir = point_direction(other.x, other.y, x, y);
        emp_dir = _dir;
        emp_veloc = 6;
        vida -= 2;
		hit_alpha = 1;
    }
    instance_destroy(_bullet);
}, function wall_colide(_bullet){instance_destroy(_bullet);}, 3, 3);

rifle = scr_create_weapon("Rifle", 1, 5, 20, spr_bullet, true, 1, spr_weapon_3, function colide_rifle(_bullet){
    with(other){
        state = ENEMY_STATES.HIT;
        path_end();
        alarm[0] = 6;
        var _dir = point_direction(other.x, other.y, x, y);
        emp_dir = _dir;
        emp_veloc = 6;
        vida -= 1;
		hit_alpha = 1;
    }
    instance_destroy(_bullet);
}, function wall_colide(_bullet){instance_destroy(_bullet);}, 1, 2);

sniper = scr_create_weapon("sniper", 4, 6, 100, spr_bullet, false, 1, spr_weapon_4, function colide_rifle(_bullet){
    with(other){
        state = ENEMY_STATES.HIT;
        path_end();
        alarm[0] = 6;
        var _dir = point_direction(other.x, other.y, x, y);
        emp_dir = _dir;
        emp_veloc = 6;
        vida -= 4;
		hit_alpha = 1;
    }
    instance_destroy(_bullet);
}, function wall_colide(_bullet){instance_destroy(_bullet);}, 5, 5);

current_weapon = vazio;
#endregion

#region variables
shoots = 0;

weapon_dir = 0;
weapon_id = 0;

weapon_x = 0;
weapon_y = 0;

alvo_x = 0;
alvo_y = 0;

aiming = false;

weapon_slots = array_create(3, vazio);
slot_at = 0;

recoil = 0;
recoil_force = 0;

recoil_gun = 0;
can_shoot = true;
#endregion