function cm_octree_debug_draw(octree, tex = -1, color = c_teal, mask = 0)
{
	var region = cm_octree_get_region(octree, CM_OCTREE_AABB);
	cm_list_debug_draw(region, tex, color, mask);
}