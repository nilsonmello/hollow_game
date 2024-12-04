#region variáveis de movimento
timer = 0;
state_timer = 0;
sprite_index = spr_player_idle;

move_dir = 0;
andar = false;

spd_h = 0;
spd_v = 0;

spd = 1.2;

dash_dir = 0;
dash_veloc = 12;

can_take_dmg = true;

emp_veloc = 4;
emp_dir = 0;

alarm[0] = 0;
alarm[1] = 0;
#endregion

#region hability variables
can_activate_slash = false
area = 20;

enemy_list = ds_list_create();
path_list = ds_list_create();

moving_along_path = false;
path_position_index = 0;

move_speed = 0;

stamina_timer = 20;
stamina_timer_regen = 0;

trail_length = 10;
trail_positions = ds_queue_create();
trail_thickness = 2;

candust = true;

trail_fixed_positions = ds_list_create();
trail_fixed_timer = ds_list_create();
temp = 0;

line_timer = 0;
line_at = 0;

advance_speed = .2
#endregion

#region combo variables
advance_x = 0;
advance_y = 0;

advancing = false;

timer = 0;
h_atk = false

parry_time = 20;
parry_cooldown = 70;

holded_attack = false;
clicked_attack = false;
#endregion

#region state machine

//variáveis de estado
enum STATES{
    IDLE,
    MOVING,
    DASH,
	PARRY,
    HEAL,
    ATTAKING,
	LINE_ATK,
	CIRCULLAR_ATK,
	CHARGED_ATK,
    HIT,
    DEATH,
}

//estado atual
state = STATES.MOVING;
#endregion

#region player regen
can_heal = true;
timer_heal = 0;
alarm[2] = 0;

function player_heal(){
	
    if(global.energy >= global.cost_r){
        global.life_at += global.life * 0.2;
        if(global.life_at > global.life){
            global.life_at = global.life;
        }
        global.energy -= global.cost_r;
    }
}
#endregion

#region hit variables
hit_color = c_white;
hit_alpha = 0;
#endregion

#region preserving directional sprites
function nearest_cardinal_direction(_direction){
    var _directions = [0, 90, 180, 270];
    
    _direction = _direction mod 360;
    if (_direction < 0) _direction += 360;

    var _min_diff = 360;
    var _nearest_direction = _directions[0];
    
    for(var _i = 0; _i < array_length(_directions); _i++){
        var _diff = abs(_direction - _directions[_i]);
        
        if(_diff < _min_diff){
            _min_diff = _diff;
            _nearest_direction = _directions[_i];
        }
    }
    
    return _nearest_direction;
}
#endregion

#region particles

#region healing particles
ps = part_system_create();
part_system_draw_order(ps, true);
part_system_depth(ps, 100);

//globe sphere
ptype1 = part_type_create();
part_type_shape(ptype1, pt_shape_sphere);

part_type_size(ptype1, .2, .5, 0.01, 0);
part_type_scale(ptype1, 1, 1);
part_type_speed(ptype1, 0, 0, 0, 0);
part_type_direction(ptype1, 0, 0, 0, 0);
part_type_gravity(ptype1, 0, 0);
part_type_orientation(ptype1, 0, 0, 0, 0, false);
part_type_colour3(ptype1, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype1, 0, .5, 0);
part_type_blend(ptype1, false);
part_type_life(ptype1, 60, 60);

// pixel
ptype2 = part_type_create();
part_type_shape(ptype2, pt_shape_pixel);

part_type_size(ptype2, 1, 1, 0.01, 0);
part_type_scale(ptype2, 1, 1);
part_type_speed(ptype2, 1, 1, 0, 0);
part_type_direction(ptype2, 90, 90, 0, 0);
part_type_gravity(ptype2, 0, 0);
part_type_orientation(ptype2, 0, 0, 0, 0, false);
part_type_colour3(ptype2, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype2, 0, .5, 0);
part_type_blend(ptype2, false);
part_type_life(ptype2, 30, 30);

//lines
ptype3 = part_type_create();
part_type_sprite(ptype3, spr_line_effect, 0, 0, 0);

part_type_size(ptype3, .2, .5, 0.01, 0);
part_type_scale(ptype3, 1, 1);
part_type_speed(ptype3, .5, .5, 0, 0);
part_type_direction(ptype3, 90, 90, 0, 0);
part_type_gravity(ptype3, 0, 0);
part_type_orientation(ptype3, 0, 0, 0, 0, false);
part_type_colour3(ptype3, $FFFFFF, $FFFFFF, $FFFFFF);
part_type_alpha3(ptype3, .5, 1, 0);
part_type_blend(ptype3, false);
part_type_life(ptype3, 30, 30);

emitter = part_emitter_create(ps);
emitter2 = part_emitter_create(ps);
#endregion

#region walk particle
particle_system_dust = part_system_create_layer("Instance_particle", true);
particle_dust = part_type_create();

part_type_sprite(particle_dust, spr_dust, 0, 0, 0);
part_type_subimage(particle_dust, 0);
part_type_size(particle_dust, .2, .8, .001, 0)

part_type_direction(particle_dust, 0, 180, 0, 1);
part_type_speed(particle_dust, .1, .2, -0.004, 0);

part_type_life(particle_dust, 50, 70);
part_type_orientation(particle_dust, 0, 180, .1, 1, 0);
part_type_alpha3(particle_dust, 0.6, 0.4, 0.1);
#endregion

#region player shadow
particle_system = part_system_create_layer("Instance_particle", true);

particle_shadow = part_type_create();

part_type_sprite(particle_shadow, spr_player_idle, 0, 0, 1);
part_type_subimage(particle_shadow, 0)
part_type_size(particle_shadow, 1, 1, 0, 0);
part_type_life(particle_shadow, 25, 45);
part_type_alpha1(particle_shadow, 0.5);

var _red = make_color_rgb(53, 43, 66);
var _red_2 = make_color_rgb(67, 67, 106);
var _red_3 = make_color_rgb(75, 128, 202);

part_type_color3(particle_shadow, _red, _red_2, _red_3);
#endregion

#endregion