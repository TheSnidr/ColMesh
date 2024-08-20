function cm_quadtree_get_region(quadtree, AABB)
{
	static calldepth = 0;
	static regions = array_create(CM_TREE_MAXDEPTH);
	var region = regions[calldepth];
	if (!is_array(region))
	{
		region = cm_list();
		regions[calldepth] = region;
	}
	var quad_aabb = CM_QUADTREE_AABB;
	var issubdivided = CM_QUADTREE_SUBDIVIDED;
	
	//If the AABB is outside the quadtree, exit early
	if (quad_aabb[0] > AABB[3] || quad_aabb[3] < AABB[0] || quad_aabb[1] > AABB[4] || quad_aabb[4] < AABB[1])
	{
		region[CM_LIST.NEGATIVESIZE] = 0;
		return region;
	}
	
	//If the quadtree is entirely inside the AABB, return all objects in this quadtree
	if (!issubdivided || (quad_aabb[0] >= AABB[0] && quad_aabb[1] >= AABB[1] && quad_aabb[3] <= AABB[3] && quad_aabb[4] <= AABB[4]))
	{
		return CM_QUADTREE_OBJECTLIST;
	}
	
	++ calldepth;
	var listsize = CM_LIST_NUM;
	var rsize = CM_QUADTREE_SIZE / 2;
	
	var x1 = (AABB[0] - quad_aabb[0] > rsize);
	var y1 = (AABB[1] - quad_aabb[1] > rsize);
	var x2 = (AABB[3] - quad_aabb[0] > rsize);
	var y2 = (AABB[4] - quad_aabb[1] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			var child = quadtree[CM_QUADTREE.CHILD1 + xx + 2 * yy];
			if (!is_array(child)) continue;
				
			var list = cm_quadtree_get_region(child, AABB);
			var len = CM_LIST_SIZE;
			array_copy(region, listsize, list, CM_LIST_NUM, len);
			listsize += len;
		}
	}
	if (-- calldepth == 0)
	{
		listsize = array_unique_ext(region, 0, listsize);
	}
	region[CM_LIST.NEGATIVESIZE] = CM_LIST_NUM - listsize;
	return region;
}