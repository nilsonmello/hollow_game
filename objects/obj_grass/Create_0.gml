image_index = choose(0, 1, 2);

grid_t = 30;

var grid_x = room_width div grid_t;
var grid_y = room_height div grid_t;

surface_grass = surface_create(room_width, room_height);
surface_set_target(surface_grass);

function is_wall_present(_x, _y){
    var wall_found = false;
    
    if(collision_point(_x, _y, obj_wall, false, true) ||
    collision_point(_x - grid_t / 2, _y - grid_t / 2, obj_wall, false, true) ||
    collision_point(_x + grid_t / 2, _y - grid_t / 2, obj_wall, false, true) ||
    collision_point(_x - grid_t / 2, _y + grid_t / 2, obj_wall, false, true) ||
    collision_point(_x + grid_t / 2, _y + grid_t / 2, obj_wall, false, true)){
        wall_found = true;
    }

    return wall_found;
}


for(var xx = 0; xx < grid_x; xx++){
    for(var yy = 0; yy < grid_y; yy++){
        var cell_x = xx * grid_t + grid_t / 2;
        var cell_y = yy * grid_t + grid_t / 2;

        if(!is_wall_present(cell_x, cell_y)){
            var rng = irandom(2);
            for(var k = 0; k < rng; k++){
                draw_sprite(spr_grass, irandom(sprite_get_number(spr_grass) - 1), cell_x + irandom(grid_t) - grid_t / 2, cell_y + irandom(grid_t / 2) - grid_t / 4);
            }
        }
    }
}

surface_reset_target();