global.executed = false;

//life and max life
global.life = 10;
global.life_at = global.life;

// energy
global.energy = 0;

// max energy
global.energy_max = 15;

global.cost_r = 5; // regen cost
global.cost_hab = 2;
// energy
global.energy = global.energy_max;

//player dash
global.is_dashing = false;

//atk cooldown
global.can_attack = false;

//number of attacks
global.combo = 0;

//using parry
global.parry = false;

//player heal
global.healing = false;

#region basic attack upgrades
//critical attack chance
global.critical = 0;

//can deflect bullets
global.deflect_bullets = true;
#endregion

#region dash upgrades
//variable to upgrade the chain dash
global.dash_cooldown = 23;

//during dash shield
global.shield = false;
#endregion

//variable to keep the information of the enemy
global.target_enemy = 0

//i can use the line attack
global.line_ready = false;

//the timer for the use of the hability
global.line_attack_timer = 0;

//timer for the line hability
global.parry_timer = 0;

global.hooking = false;
