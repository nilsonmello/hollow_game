with(other){
	if(can_take_dmg){
		state = STATES.HIT;
		alarm[5] = 10;
		hit_alpha = 1;
		emp_dir = point_direction(other.x, other.y, x, y);
		emp_veloc = 6;
		global.life_at -= 2;

		can_take_dmg = false;
		alarm[6] = 60;
		obj_control.alarm[0] = 60;
	}
}