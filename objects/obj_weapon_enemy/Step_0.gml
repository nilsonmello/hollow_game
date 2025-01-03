#region cooldown e direção
//weapon cooldown
current_weapon.update_cooldown();
//weapon direction
weapon_dir = point_direction(x, y, alvo_x, alvo_y);

//inicial point
x = weapon_id.x;
y = weapon_id.y;

//final point
weapon_x = x + lengthdir_x(10, weapon_dir);
weapon_y = y + lengthdir_y(10, weapon_dir);
#endregion

//lerp recoil
recoil_gun = lerp(recoil_gun, 0, .5);