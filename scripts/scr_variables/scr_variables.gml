//life and max life
global.life = 10;
global.life_at = global.life;

// energy
global.energy = 0;

// max energy
global.energy_max = 15;

global.cost_r = 5; // regen cost
global.cost_hab = 5;

// energy
global.energy = global.energy_max;

//slow enemies
global.slow_motion = false;

//player dash
global.is_dashing = false;

//atk cooldown
global.can_attack = false;

//hability verification
global.slashing = false;

//number of attacks
global.combo = 0;

//using parry
global.parry = false;

//hability check enemies
global.marked = 10;

//hability area range
global.hab_range = 110;

//area slash damage
global.hab_dmg = 1;

//player heal
global.healing = false;

#region basic attack upgrades
//critical attack chance
global.critical = 0;

//can use the charged attack
global.area_attack = true;

//can deflect bullets
global.deflect_bullets = true;
#endregion

#region dash upgrades
//variable to upgrade the chain dash
global.dash_cooldown = 23;

//during dash shield
global.shield = false;
#endregion
