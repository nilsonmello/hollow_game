//life and max life
global.life = 10;
global.life_at = global.life;

//stamina and max stamina
global.stamina_max = 100;
global.stamina = global.stamina_max;

// energy
global.energy = 0;

global.t = 50; // per combat shoots
global.c = 3;  // per combat regen
global.cost_r = 5; // regen cost
global.cost_s = 0; // bullet cost

// max energy
global.energy_max = (global.t * global.cost_s) + (global.c * global.cost_r);

// energy
global.energy = global.energy_max;

//slow enemies
global.slow_motion = false;

global.is_dashing = false;