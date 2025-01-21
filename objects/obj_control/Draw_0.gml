//hud
draw_sprite_ext(spr_hud, 0, obj_player.x, obj_player.y - 19, 1, 1, 0, c_white, 1);

//life
draw_sprite_stretched_ext(spr_bar, 0, obj_player.x - 15, obj_player.y - 23, global.life_at * 21, 4 div 2, c_white, 1);

//energy
draw_sprite_stretched_ext(spr_bar, 0, obj_player.x - 15, obj_player.y - 20, global.energy * 14, 4 div 3, c_white, 1);

//healing count
var _heal = floor(global.energy / global.cost_r);

//drawing total healings
if(_heal >= 1 && _heal <= 3){
    for(var _i = 0; _i < _heal; _i++){
        draw_sprite_ext(spr_cure, 0, obj_player.x - 14 + 8 * _i, obj_player.y - 17, 1, 1, 0, c_white, 1);
    }
}

//changing the mouse sprite
if (global.hooking && ds_list_size(global.enemy_list) > 0) {
    draw_sprite(spr_dot, image_index, mouse_x, mouse_y);
} else {
    draw_sprite(spr_mouse, image_index, mouse_x, mouse_y);
}

if (keyboard_check(ord("J"))) {
    mp_grid_draw(global.mp_grid);
}