/// @description
var spd = game_get_speed(gamespeed_fps);
game_set_speed((spd == 60) ? 9999 : 60, gamespeed_fps);