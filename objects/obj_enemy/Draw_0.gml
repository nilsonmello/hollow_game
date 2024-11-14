event_inherited();

switch(vida){
	case 3:
		draw_sprite(spr_warning, 9, x, y + 15);
	break;
	
	case 2:
		draw_sprite(spr_warning, 10, x, y + 15);
	break;
	
	case 1:
		draw_sprite(spr_warning, 11, x, y + 15);
	break;
}

var _direction = point_direction(x, y, obj_player.x, obj_player.y);
                    
var _attack_range_x = 16;
var _attack_range_y = 16;
var _attack_offset = 2;

var _rect_x1 = x + lengthdir_x(_attack_offset, _direction) - _attack_range_x / 2;
var _rect_y1 = y + lengthdir_y(_attack_offset, _direction) - _attack_range_y / 2;
var _rect_x2 = x + lengthdir_x(_attack_offset, _direction) + _attack_range_x / 2;
var _rect_y2 = y + lengthdir_y(_attack_offset, _direction) + _attack_range_y / 2;


draw_rectangle(_rect_x1, _rect_y1, _rect_x2, _rect_y2, false);