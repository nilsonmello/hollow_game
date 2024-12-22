var _player_y = obj_player.y;
var _player_x = obj_player.x;


var _margin_x = 16;
var _margin_y = 16;

var _tree_top = y - sprite_height * 0.5 - _margin_y;
var _tree_bottom = y + _margin_y;
var _tree_left = x - sprite_width * 0.5 - _margin_x;
var _tree_right = x + sprite_width * 0.5 + _margin_x;

if(_player_y > _tree_top && _player_y < _tree_bottom 
    && _player_x > _tree_left && _player_x < _tree_right){
    image_alpha = lerp(image_alpha, 0.2, 0.1);
}else{
    image_alpha = lerp(image_alpha, 1, 0.1);
}