draw_self();

var _width = 10;
var _height = 4;
var _escx = 1;
var _escy = 1;

var _c1 = make_color_rgb(255, 255, 255);

//hud
draw_sprite_ext(spr_hud, 0, obj_player.x, obj_player.y - 22, _escx, _escy, 0, c_white, 1);

//life
draw_sprite_stretched_ext(spr_bar, 0, obj_player.x - 15, obj_player.y - 29, global.life_at * 21, _height div 2, c_white, 1);

//energy
draw_sprite_stretched_ext(spr_bar, 0, obj_player.x - 15, obj_player.y - 26, global.energy * 14, _height div 2, c_white, 1);

var _heal = floor(global.energy / global.cost_r);
//


if(_heal >= 1 && _heal <= 3){
    for(var _i = 0; _i < _heal; _i++){
        draw_sprite_ext(spr_cure, 0, obj_player.x - 13 + 8 * _i, obj_player.y - 21, _escx, _escy, 0, c_white, 1);
    }
}
