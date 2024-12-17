//scale, height and width variables
var _width = 10;
var _height = 4;
var _escx = 1;
var _escy = 1;

//player informations hud
draw_sprite_ext(spr_hud, 0, 60, 45, _escx, _escy, 0, c_white, 1);

//energy bar stretched
draw_sprite_stretched(spr_bar, 0, 10, 42, global.energy * 46, _height);

//healing numbers
var _heal = floor(global.energy / global.cost_r);

//drawing healing
if(_heal >= 1 && _heal <= 3){
    for (var _i = 0; _i < _heal; _i++) {
        draw_sprite_ext(spr_hud, 2, 13 + 5 * _i, 30, _escx, _escy, 0, c_white, 1);
    }
}


//player life
var _life = global.life_at/2;

//drawing player actual life
if(_life >= 1 && _life <= 5){
    for (var _i = 0; _i < _life; _i++) {
        draw_sprite_ext(spr_hud, 1, 40 + 16 * _i, 28, _escx, _escy, 0, c_white, 1);
    }
}