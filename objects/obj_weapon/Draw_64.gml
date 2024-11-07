var _width = 10;
var _height = 4;
var _escx = 1;
var _escy = 1;

draw_sprite_ext(spr_hud, 0, 60, 45, _escx, _escy, 0, c_white, 1);

switch(current_weapon){
	case pistol:
		draw_sprite_ext(spr_weapons_hud, 1, 24, 65, _escx, _escy, 0, c_white, 1);
	break;
	
	case rifle:
		draw_sprite_ext(spr_weapons_hud, 0, 25, 65, _escx, _escy, 0, c_white, 1);
	break;
	
	case shotgun:
		draw_sprite_ext(spr_weapons_hud, 2, 24, 65, _escx, _escy, 0, c_white, 1);
	break;
	
	case sniper:
		draw_sprite_ext(spr_weapons_hud, 3, 24, 65, _escx, _escy, 0, c_white, 1);
	break;
}

draw_sprite_stretched(spr_bar, 0, 10, 42, global.energy * 46, _height);

draw_sprite_stretched(spr_bar, 0, 34, 13, global.stamina * 5 + 30, _height);

var _heal = floor(global.energy / global.cost_r);

if(_heal >= 1 && _heal <= 3){
    for (var _i = 0; _i < _heal; _i++) {
        draw_sprite_ext(spr_hud, 2, 13 + 5 * _i, 30, _escx, _escy, 0, c_white, 1);
    }
}

var _life = global.life_at/2;

if(_life >= 1 && _life <= 5){
    for (var _i = 0; _i < _life; _i++) {
        draw_sprite_ext(spr_hud, 1, 40 + 16 * _i, 28, _escx, _escy, 0, c_white, 1);
    }
}

