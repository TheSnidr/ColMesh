/// @description
var M = matrix_build(x + 200 * sin(current_time/1000), y, z, 0, 0, 0, 1, 1, 1);

cm_dynamic_set_matrix(shape, M, true);
cm_dynamic_update_container(shape, levelColmesh);