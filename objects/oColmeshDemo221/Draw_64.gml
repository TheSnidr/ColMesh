/// @description

draw_text(10, 10, fps);
/*

var str = "Move with WASD + space"
	+ "\nSwitch demos: 1-5"
	+ "\nQ: Unlimit FPS. FPS: " + string(fps) + " / " + string(game_get_speed(gamespeed_fps))
	+ "\nE: Draw active colliders"
	+ "\nR: Disable drawing"
	+ "\nH: Hide text"
	+ "\n" + global.demoText;
draw_set_color(c_black);
draw_text(9, 9, str);
draw_text(11, 9, str);
draw_text(9, 11, str);
draw_text(11, 11, str);
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(10, 10, str);