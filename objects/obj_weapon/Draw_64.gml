var _width = 10;
var _height = 4;

draw_sprite_stretched(spr_bar, 0, 20, 15, global.energy * _width, _height);

for(var _i = 0; _i < shoots; _i++){
	draw_sprite(spr_bullet_hud, 0, 50 + 10 * _i, 60);
}

var _heal = floor(global.energy / global.cost_r);

if(_heal >= 1 && _heal <= 3){
    for (var _i = 0; _i < _heal; _i++) {
        draw_sprite(spr_bullet_hud, 1, 10, 20 + 40 * _i);
    }
}

draw_sprite_ext(spr_enemy_life_2, 0, 90, 20, 5, 5, 0, c_white, 1);