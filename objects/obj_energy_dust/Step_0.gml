//increasing the angle and decreasing the distance
angle += 5;
dist -= 1;

//moving the object
x = obj_player.x + lengthdir_x(dist, angle);
y = obj_player.y + lengthdir_y(dist, angle);