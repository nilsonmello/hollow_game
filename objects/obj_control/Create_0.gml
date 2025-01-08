#region mouse

//mouse limiter variables
orb_rad = 100;
orb_angle = 0;

//removing cursor
window_set_cursor(cr_none);
#endregion

randomize();

global.part_sist = part_system_create();

part_system_depth(global.part_sist, -100);