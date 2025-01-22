

//animation frames
if(frame < 6){
    frame += .4
}else{
    frame = 6;
}

#region hit alpha
//decreases the hit_alpha value
hit_alpha = lerp(hit_alpha, 0, 0.1);
#endregion

#region stamina
if(stamina_at <= 10){
	knocked = true;
}

stamina_at = clamp(stamina_at, 0, stamina_t);
#endregion