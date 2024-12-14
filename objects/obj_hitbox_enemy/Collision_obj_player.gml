#region collision
//with the player
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
#endregion