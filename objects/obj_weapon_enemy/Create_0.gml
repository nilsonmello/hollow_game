#region constructor
function scr_create_weapon(_name, _dmg, _fire_rate, _bullet_sprite, _automatic, _bps, _weapon_spr, _custom_function, _reflect_function, _colide){
    return{
        name: _name,
        damage: _dmg,
        fire_rate: _fire_rate,
        bullet_sprite: _bullet_sprite,
        automatic: _automatic,
        bp_shoot: _bps,
        shot_cooldown: 0,
        weapon_sprite: _weapon_spr,
        custom_function: _custom_function,
        reflect_function: _reflect_function,
        colide: _colide,

        shoot: function(_x, _y){
            if(shot_cooldown <= 0){
                var _spread = 6;
                var _base_dir = point_direction(_x, _y, obj_player.x, obj_player.y);

                for(var _i = 0; _i < bp_shoot; _i++){
                    var _bullet = instance_create_layer(_x, _y, "Instances_player", obj_bullet);
                    _bullet.sprite_index = bullet_sprite;
                    _bullet.speed = 3;
                    _bullet.damage = damage;
                    _bullet.x = _x;
                    _bullet.y = _y;

                    // Atribuir funções
                    _bullet.custom_function = custom_function;
                    _bullet.reflect_function = reflect_function;
                    _bullet.colide_walls = colide;

                    var _dir = _base_dir + (_spread * (_i - (bp_shoot - 1) / 2));
                    _bullet.direction = _dir;
                }
                shot_cooldown = fire_rate;
            }
        },

        update_cooldown: function(){
            if(shot_cooldown > 0){
                shot_cooldown -= 1;
            }
        },
    };
}

#endregion

#region guns
vazio = scr_create_weapon("vazio", 0, 0, 0, 0, false, 0, function(){}, function(){}, function(){});

pistol = scr_create_weapon("Pistol", 5, 10, spr_dust, false, 1, spr_pistol, 
    function colide_pistol(_bullet){
        with(other){
            if(can_take_dmg){
                state = STATES.HIT;
                hit_timer = 10;
                hit_alpha = 1;
                emp_dir = point_direction(other.x, other.y, x, y);
                emp_veloc = 6;
                global.life_at -= 2;
                global.combo = 0;

                can_take_dmg = false;
                hit_cooldown = 60;
                obj_control.alarm[0] = 60;
            }
        }
        instance_destroy(_bullet);
    },

    function reflect_function(_bullet){
        with(other){
            escx = 1.5;
            escy = 1.5;
            hit_alpha = 1;
            timer_hit = 5;
            emp_dir = point_direction(obj_player.x, obj_player.y, x, y);
            global.combo++;
    
            stamina_at -= 50;
    
            if(stamina_at <= 0){
                knocked = true;
            }
    
            switch(knocked){
                case 0:
                    part_particles_create(particle_hit, x, y, particle_slash, 1);
                    state = ENEMY_STATES.HIT;
                    emp_timer = 5;
                    emp_veloc = 6;
                    alarm[2] = 30;
                break;
    
                case 1:
                    state = ENEMY_STATES.KNOCKED;
                    vida -= 1;
                    hit = false;
                    alarm[1] = 10;
                    alarm[2] = 30;
                break;
            }
        }
        instance_destroy(_bullet);
    }, 

    function colide_walls(_bullet){
        //bush information
        var _colide = collision_circle(_bullet.x, _bullet.y, 20, obj_bush, false, false);
        var _colide_2 = collision_circle(_bullet.x, _bullet.y, 20, obj_box, false, false);
        
        //apply the attack to bushes
        if(_colide){
            if(_colide.image_index == 0){
                var _part_num = irandom_range(7, 12);
                
                repeat(_part_num){
                    var _inst = instance_create_layer(_colide.x + irandom_range(-2, 2), _colide.y - 8, "Instances_player", obj_b_part);
                    _inst.direction = point_direction(_bullet.x, _bullet.y, _colide.x, _colide.y) + irandom_range(90, -90);
                    _inst.image_index = irandom(4);
                    obj_camera.alarm[1] = 5;
                }                
            }
            
            with(_colide){
                image_index = 1;
            }
        }
        
      if(_colide_2){
          var _part = irandom_range(7, 12);
          
          repeat(_part){
             var _inst = instance_create_layer(_colide_2.x + irandom_range(-2, 2), _colide_2.y - 8, "Instances_player", obj_b_part);
             _inst.direction = point_direction(_bullet.x, _bullet.y, _colide_2.x, _colide_2.y) + irandom_range(90, -90);
              _inst.image_index = irandom_range(5, 8);
              obj_camera.alarm[1] = 5;
          }
      } 
        
        with(_colide_2){
            instance_destroy();
        }
        
        instance_destroy(_bullet);
    }
);


current_weapon = vazio;
#endregion

#region variables

//ewapon direction and ID
weapon_dir = 0;
weapon_id = 0;

//weapon x and y
weapon_x = 0;
weapon_y = 0;

//target for the weapon and bullet
alvo_x = 0;
alvo_y = 0;

//recoil intense
recoil_gun = 0;
#endregion