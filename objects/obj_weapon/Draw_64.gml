draw_sprite_ext(spr_hud, 0, 120, 102, 2, 2, 0, c_white, 1);

switch(current_weapon){
	case pistol:
		draw_sprite_ext(spr_weapons_hud, 1, 49, 145, 2, 2, 0, c_white, 1);
	break;
	
	case rifle:
		draw_sprite_ext(spr_weapons_hud, 0, 51, 145, 2, 2, 0, c_white, 1);
	break;
	
	case shotgun:
		draw_sprite_ext(spr_weapons_hud, 2, 48, 145, 2, 2, 0, c_white, 1);
	break;
	
	case sniper:
		draw_sprite_ext(spr_weapons_hud, 3, 48, 145, 2, 2, 0, c_white, 1);
	break;
}

var _width = 10;
var _height = 4;
var _escx = 2;
var _escy = 2;

draw_sprite_stretched(spr_bar, 0, 70, 40, global.energy * _width, _height);

draw_sprite_stretched(spr_bar, 0, 20, 98, global.stamina * 2, _height);

var _heal = floor(global.energy / global.cost_r);

if(_heal >= 1 && _heal <= 3){
    for (var _i = 0; _i < _heal; _i++) {
        draw_sprite_ext(spr_hud, 2, 25 + 10 * _i, 70, _escx, _escy, 0, c_white, 1);
    }
}

var _life = global.life_at/2;

if(_life >= 1 && _life <= 5){
    for (var _i = 0; _i < _life; _i++) {
        draw_sprite_ext(spr_hud, 1, 80 + 32 * _i, 68, _escx, _escy, 0, c_white, 1);
    }
}

