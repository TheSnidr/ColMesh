/// @description
size = 64;
z = size / 2;
colour = [.4, .5, .8];

var M = matrix_build(x, y, z, random(90), random(90), random(90), random_range(.5, 4), 1, 1);

shape = cm_add(levelColmesh, cm_dynamic(cm_aab(0, 0, 0, size, size, size), M, false));