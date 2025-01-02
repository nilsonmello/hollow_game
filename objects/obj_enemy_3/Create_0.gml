event_inherited();

//enemy weapon and weapon ID
my_weapon = instance_create_layer(x, y, "Instances_enemies", obj_weapon_enemy);
my_weapon.weapon_id = self;

//inicial my_weapon events
with(my_weapon){
current_weapon = pistol;
}

moved = false;
recovery_time = 0;
move_direction = 0;