var _dir = point_direction(x, y, mouse_x, mouse_y);
image_angle = _dir;

var _recoil_x = lengthdir_x(recoil, weapon_dir);
var _recoil_y = lengthdir_y(recoil, weapon_dir);

if(aiming && current_weapon != vazio){
	draw_sprite_ext(current_weapon.weapon_sprite, 0, weapon_x - _recoil_x, weapon_y - _recoil_y, 1, 1, weapon_dir, c_white, 1);
}