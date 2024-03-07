/// @description
if global.disableDraw{exit;}

//-----------------------------------------------------
//	Draw circular shadow beneath the player
matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, radius, radius, - 200), charMat));
draw_circular_shadow(.5);
matrix_set(matrix_world, matrix_build_identity());

//-----------------------------------------------------
//	Draw player
cm_debug_draw(cm_collider_get_capsule(collider));

//-----------------------------------------------------
//	Draw player's nose
cm_debug_draw(cm_sphere(x + charMat[0] * radius, y + charMat[1] * radius, z + height, radius / 5), -1, make_colour_rgb(110, 127, 200));