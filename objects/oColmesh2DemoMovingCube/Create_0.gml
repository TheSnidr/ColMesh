/// @description
size = 64;
z = 32;

var M = matrix_build_identity();

shape = cm_add(levelColmesh, cm_dynamic(cm_aab(0, 0, 0, size, size, size), M, false));