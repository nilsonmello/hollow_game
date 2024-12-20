#region screenshake layer and particles
with(other){

	#region particle leafs
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_sprite(_ptype1, spr_leaf, false, true, false);
	part_type_subimage(_ptype1, choose(0, 1, 2, 3))
	part_type_size(_ptype1, 1, 1, 0, 0);
	part_type_scale(_ptype1, 1, 1);

	var _spd = 2;
	_spd = lerp(_spd, 0, .6);

	part_type_speed(_ptype1, _spd, _spd, 0, 0);
	part_type_direction(_ptype1, 0, 359, 0, 0);
	part_type_gravity(_ptype1, .02, 270)
	part_type_orientation(_ptype1, 0, 0, 0, 0, true);
	part_type_colour3(_ptype1, $FFFFFF, $FFFFFF, $FFFFFF);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, false);
	part_type_life(_ptype1, 40, 40);
	part_type_alpha2(_ptype1, 1, .1);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_burst(_ps, _pemit1, _ptype1, 8);

	part_system_position(_ps, x, y);
	#endregion
	
	#region dot particle
	var _ps2 = part_system_create();
	part_system_draw_order(_ps2, true);

	//Emitter
	var _ptype2 = part_type_create();
	part_type_shape(_ptype2, pt_shape_pixel);
	part_type_size(_ptype2, 1, 1, 0, 0);
	part_type_scale(_ptype2, 1, 1);
	part_type_speed(_ptype2, 1, 1, 0, 0);
	part_type_direction(_ptype2, 0, 359, 0, 0);
	part_type_gravity(_ptype2, 0, 270);
	part_type_orientation(_ptype2, 0, 0, 0, 0, false);
	part_type_colour3(_ptype2, $FFFFFF, $FFFFFF, $FFFFFF);
	part_type_alpha3(_ptype2, 1, 1, 1);
	part_type_blend(_ptype2, false);
	part_type_life(_ptype2, 30, 30);

	var _pemit2 = part_emitter_create(_ps2);
	part_emitter_region(_ps2, _pemit2, -16, 16, -16, 16, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps2, _pemit2, _ptype2, 11);

	part_system_position(_ps2, x, y);
	#endregion

instance_destroy();
}
#endregion