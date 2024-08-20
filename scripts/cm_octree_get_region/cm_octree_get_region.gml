function cm_octree_get_region(octree, AABB)
{
	static calldepth = 0;
	static regions = array_create(CM_TREE_MAXDEPTH);
	var region = regions[calldepth];
	if (!is_array(region))
	{
		region = cm_list();
		regions[calldepth] = region;
	}
	var oct_aabb = CM_OCTREE_AABB;
	var issubdivided = CM_OCTREE_SUBDIVIDED;
	
	//If the AABB is outside the octree, exit early
	if (oct_aabb[0] > AABB[3] || oct_aabb[3] < AABB[0] || oct_aabb[1] > AABB[4] || oct_aabb[4] < AABB[1] || oct_aabb[2] > AABB[5] || oct_aabb[5] < AABB[2])
	{
		region[CM_LIST.NEGATIVESIZE] = 0;
		return region;
	}
	
	//If the octree is entirely inside the AABB, return all objects in this octree
	if (!issubdivided || (oct_aabb[0] >= AABB[0] && oct_aabb[1] >= AABB[1] && oct_aabb[2] >= AABB[2] && oct_aabb[3] <= AABB[3] && oct_aabb[4] <= AABB[4] && oct_aabb[5] <= AABB[5]))
	{
		return CM_OCTREE_OBJECTLIST;
	}
	
	++ calldepth;
	var listsize = CM_LIST_NUM;
	var rsize = CM_OCTREE_SIZE / 2;
	
	var x1 = (AABB[0] - oct_aabb[0] > rsize);
	var y1 = (AABB[1] - oct_aabb[1] > rsize);
	var z1 = (AABB[2] - oct_aabb[2] > rsize);
	var x2 = (AABB[3] - oct_aabb[0] > rsize);
	var y2 = (AABB[4] - oct_aabb[1] > rsize);
	var z2 = (AABB[5] - oct_aabb[2] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			for (var zz = z1; zz <= z2; ++zz)
			{
				var child = octree[CM_OCTREE.CHILD1 + xx + 2 * yy + 4 * zz];
				if (!is_array(child)) continue;
				
				var list = cm_octree_get_region(child, AABB);
				var len = CM_LIST_SIZE;
				array_copy(region, listsize, list, CM_LIST_NUM, len);
				listsize += len;
			}
		}
	}
	if (-- calldepth == 0)
	{
		listsize = array_unique_ext(region, 0, listsize);
	}
	region[CM_LIST.NEGATIVESIZE] = CM_LIST_NUM - listsize;
	return region;
}