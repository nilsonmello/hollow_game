/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

// Inherit the parent event
event_inherited();

function scr_colide(){
	if(place_meeting(x + vel_h, y, obj_wall)){
		while(!place_meeting(x + sign(vel_h), y, obj_wall)){
			x  = x + sign(vel_h);
		}
		vel_h = 0;	
	}
	if(place_meeting(x, y + vel_v, obj_wall)){
		while(!place_meeting(x, y + sign(vel_v), obj_wall)){
			y  = y + sign(vel_v);
		}
		vel_v = 0;	
	}	
}

