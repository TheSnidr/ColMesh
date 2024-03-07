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
	var aabb = CM_OCTREE_AABB;
	if (aabb[0] > AABB[3] || aabb[3] < AABB[0] || aabb[1] > AABB[4] || aabb[4] < AABB[1] || aabb[2] > AABB[5] || aabb[5] < AABB[2])
	{
		region[CM_ARGS_LIST.NEGATIVESIZE] = 0;
		return region;
	}
	
	++ calldepth;
	var size = CM_LIST_NUM;
	var rsize = CM_OCTREE_REGIONSIZE;
	
	var x1 = (AABB[0] - aabb[0] > rsize);
	var y1 = (AABB[1] - aabb[1] > rsize);
	var z1 = (AABB[2] - aabb[2] > rsize);
	var x2 = (AABB[3] - aabb[0] > rsize);
	var y2 = (AABB[4] - aabb[1] > rsize);
	var z2 = (AABB[5] - aabb[2] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			for (var zz = z1; zz <= z2; ++zz)
			{
				var child = octree[CM_ARGS_OCTREE.CHILD1 + xx + 2 * yy + 4 * zz];
				if (!is_array(child)) continue;
				
				var list = global.__cmi_get_region[child[CM_TYPE]](child, AABB);
				var len = CM_LIST_SIZE;
				array_copy(region, size, list, CM_LIST_NUM, len);
				size += len;
			}
		}
	}
	if (-- calldepth == 0)
	{
		size = array_unique_ext(region, 0, size);
	}
	region[CM_ARGS_LIST.NEGATIVESIZE] = CM_LIST_NUM - size;
	return region;
}