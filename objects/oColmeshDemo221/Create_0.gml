//-----------------------------------------------------
//	Create a new colmesh for the level
globalvar levelColmesh;
//levelColmesh = cm_octree(100);
//levelColmesh = cm_quadtree(100);
//levelColmesh = cm_spatialhash(100);
//levelColmesh = cm_list();

levelColmesh = undefined;//cm_load("ColMeshCache.ini");
if (is_undefined(levelColmesh))
{
	var regionsize = 100;
    levelColmesh = cm_octree(regionsize);
    cm_add_obj(levelColmesh, "Level.obj");
    cm_save(levelColmesh, "ColMeshCache.ini");
}

//-----------------------------------------------------
//	Load level geometry from obj and add it to the levelColmesh
var matrix = matrix_build(room_width / 2, room_height / 2, 0, -90, 0, 0, 1, - 1, 1);
cm_add_obj(levelColmesh, "ColMesh Demo/Demo1Level.obj", matrix, true);

//-----------------------------------------------------
//  Load tree model and add 10 copies of it to the level
var treeMesh = cm_spatialhash(50);
var matrix = matrix_build(0, 0, 0, -90, 0, 0, 25, - 25, 25);
cm_add_obj(treeMesh, "ColMesh Demo/SmallTreeLowPoly.obj", matrix, true);
repeat 10
{
	var xx = random(room_width);
	var yy = random(room_height);
	var ray = cm_cast_ray(levelColmesh, cm_ray(xx, yy, 1000, xx, yy, -1000));
	var zz = cm_ray_get_z(ray);
	var scale = .8 + random(.4);
	cm_add(levelColmesh, cm_dynamic(treeMesh, matrix_build(xx, yy, zz, 0, 0, random(360), scale, scale, scale), false));
}


//-----------------------------------------------------
//	Initialize the baked vertex buffers
bakedColmesh = -1;
currentRegion = cm_list();
bakedRegion = vertex_create_buffer();

//-----------------------------------------------------
//	Player variables
z = 500;
radius = 10;
height = 25;
prevX = x;
prevY = y;
prevZ = z;
xup = 0;
yup = 0;
zup = 1;
ground = false;
charMat = matrix_build(x, y, z, 0, 0, 0, 1, 1, height);
slopeAngle = 46;
precision = 5;
mask = CM_GROUP_SOLID;

//-----------------------------------------------------
//	Create a collider for the player
collider = cm_collider(x, y, z, xup, yup, zup, radius, height, slopeAngle, precision, mask);

//-----------------------------------------------------
//	Enable 3D projection
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-80, -window_get_width() / window_get_height(), 1, 32000));
yaw = 90;
pitch = 45;
global.disableDraw = false;