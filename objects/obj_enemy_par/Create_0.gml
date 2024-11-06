#region alarms
alarm[0] = 0;
alarm[1] = 0;
alarm[2] = 0;
alarm[3] = 0;
alarm[4] = 0;
alarm[5] = 0;
alarm[6] = 0;
alarm[7] = 0;
#endregion

#region attack and state
has_attacked = false;

path = path_add();

calc_path_timer = irandom(60);

state = ENEMY_STATES.MOVE;
#endregion