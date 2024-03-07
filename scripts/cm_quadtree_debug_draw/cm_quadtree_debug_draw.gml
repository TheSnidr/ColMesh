function cm_quadtree_debug_draw(quadtree, tex = -1, color = c_teal, mask = 0)
{
	var region = cm_quadtree_get_region(quadtree, CM_QUADTREE_AABB);
	cm_list_debug_draw(region, tex, color, mask);
}