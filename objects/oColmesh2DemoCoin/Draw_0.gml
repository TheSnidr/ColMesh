/// @description
if global.disableDraw{exit;}
var angle = current_time / 300 + x + y + z;
var x1 = x - radius / 10 * cos(angle);
var y1 = y - radius / 10 * sin(angle);
var z1 = z;
var x2 = x + radius / 10 * cos(angle);
var y2 = y + radius / 10 * sin(angle);
var z2 = z;
cm_debug_draw(cm_cylinder(x1, y1, z1, x2, y2, z2, radius), -1, c_yellow);