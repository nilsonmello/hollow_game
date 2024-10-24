//function execution
if(custom_function != undefined){
    custom_function(id); 
}
layer_set_visible("screenshake_damaging_enemies", 1);

var _target =  other;
		
if(instance_exists(_target)){
	var _target_x = _target.x;
	var _target_y = _target.y;
	
	var _angle = point_direction(x, y, _target_x, _target_y);
	
	var _direction_min = _angle + 135;
	var _direction_max = _angle + 225;
	
	var _particle = part_system_create();
	var _part_shoot = part_type_create();
	
	part_type_sprite(_part_shoot, spr_explosion, 0, 0, 0);
	part_type_size(_part_shoot, .2, .3, 0, 0);
	
	part_type_direction(_part_shoot, _direction_min, _direction_max, 0, 0);
	part_type_speed(_part_shoot, 3, 4, -0.1, 0);
	
	part_type_life(_part_shoot, 20, 25);
	part_type_alpha2(_part_shoot, 1, 0.1);
	
	part_particles_create(_particle, x, y, _part_shoot, 8);
	part_particles_create(part_sys, x, y, part_type, 3); 
}