//recoil x and y when the enemy shoots
var _recoil_x = lengthdir_x(recoil_gun, weapon_dir);
var _recoil_y = lengthdir_y(recoil_gun, weapon_dir);

//drawing the weapon
if(current_weapon != vazio){
draw_sprite_ext(current_weapon.weapon_sprite, 0, weapon_x - _recoil_x, weapon_y - _recoil_y, image_xscale, image_yscale, weapon_dir, c_white, 1);
}