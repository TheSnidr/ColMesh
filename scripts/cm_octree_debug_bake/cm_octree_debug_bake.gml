/*
	This function will let you bake this shape into a vertex buffer.
	Useful for batching shapes together when debugging.
*/

function cm_octree_debug_bake(octree, vbuff, matrix, mask = 0, hrep = 1, vrep = 1, color = -1)
{
	var region = cm_octree_get_region(octree, CM_OCTREE_AABB);
	cm_list_debug_bake(region, vbuff, matrix, mask, hrep, vrep, color);
}