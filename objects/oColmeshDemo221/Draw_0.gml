//-----------------------------------------------------
//	Cast a ray from the camera onto the level geometry
if global.disableDraw{exit;}
var V = matrix_get(matrix_view);
var P = matrix_get(matrix_projection);
var mx = window_mouse_get_x() / window_get_width();
var my = window_mouse_get_y() / window_get_height();
var v = cm_2d_to_3d(V, P, mx, my);
var ray = cm_cast_ray(levelColmesh, cm_ray(global.camX, global.camY, global.camZ, global.camX + v[0] * 3000, global.camY + v[1] * 3000, global.camZ + v[2] * 3000));
var rayx = cm_ray_get_x(ray);
var rayy = cm_ray_get_y(ray);
var rayz = cm_ray_get_z(ray);
cm_debug_draw(cm_sphere(rayx, rayy, rayz, 5), -1, c_red);

//-----------------------------------------------------
//	Cast a ray from player to intersected point
ray = cm_cast_ray(levelColmesh, cm_ray(x, y, z + height, rayx, rayy, rayz));
cm_ray_draw(ray, -1, c_red, 2);
var rayx = cm_ray_get_x(ray);
var rayy = cm_ray_get_y(ray);
var rayz = cm_ray_get_z(ray);
cm_debug_draw(cm_sphere(rayx, rayy, rayz, 5), -1, c_red);

//-----------------------------------------------------
//	Exit draw event if drawing is disabled
if global.disableDraw{exit;}

//-----------------------------------------------------
//	Draw level geometry. Bake to vertex buffer if this hasn't been done
if (bakedColmesh < 0)
{
	bakedColmesh = vertex_create_buffer();
	cm_vbuff_begin(bakedColmesh);
	cm_vbuff_bake(levelColmesh, bakedColmesh, matrix_build_identity(), CM_GROUP_SOLID, 1, 1, c_green);
	cm_vbuff_end(bakedColmesh);
}
shader_set(sh_cm_debug);
shader_set_uniform_f(shader_get_uniform(sh_cm_debug, "u_radius"), 0);
shader_set_uniform_f(shader_get_uniform(sh_cm_debug, "u_color"), color_get_red(c_teal) / 255, color_get_green(c_teal) / 255, color_get_blue(c_teal) / 255, 1);
cm_vbuff_submit(bakedColmesh);
shader_reset();

//-----------------------------------------------------
//	Draw current region. Bake to vertex buffer if this hasn't been done
var region = cm_get_region(levelColmesh, cm_collider_get_aabb(collider));
var num = region[CM_LIST.SIZE];
array_resize(region, num);
if ((!array_equals(region, currentRegion) || bakedRegion < 0) && num > CM_LIST.NUM)
{
	array_resize(currentRegion, array_length(region));
	array_copy(currentRegion, 0, region, 0, array_length(region));
	vertex_delete_buffer(bakedRegion);
	bakedRegion = vertex_create_buffer();
	cm_vbuff_begin(bakedRegion);
	cm_vbuff_bake(currentRegion, bakedRegion);
	cm_vbuff_end(bakedRegion);
}
if (num > CM_LIST.NUM)
{
	cm_vbuff_submit(bakedRegion);
}