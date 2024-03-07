function cm_octree_remove(octree, object)
{
	var aabb = CM_OCTREE_AABB;
	var AABB = cm_get_aabb(object);
	if (AABB[0] > aabb[3] || AABB[1] > aabb[4] || AABB[2] > aabb[5] || AABB[3] < aabb[0] || AABB[4] < aabb[1] || AABB[5] < aabb[2]) return false;
	
	var rsize = CM_OCTREE_REGIONSIZE;
	var maxobjects = CM_OCTREE_MAXOBJECTS;
	var subdivisions = CM_OCTREE_MAXSUBDIVS;
	
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
				var ind = CM_ARGS_OCTREE.CHILD1 + xx + 2 * yy + 4 * zz;
				var child = octree[ind];
				if (!is_array(child)) continue;
				
				cm_remove(child, object);
				if (child[CM_TYPE] == CM_OBJECTS.LIST)
				{
					if (child[CM_ARGS_LIST.NEGATIVESIZE] == 0) // If the child list is empty
					{
						octree[ind] = -1;
					}
				}
				else if (!is_array(child[CM_ARGS_OCTREE.CHILD1]) 
					  && !is_array(child[CM_ARGS_OCTREE.CHILD2]) 
					  && !is_array(child[CM_ARGS_OCTREE.CHILD3]) 
					  && !is_array(child[CM_ARGS_OCTREE.CHILD4]) 
					  && !is_array(child[CM_ARGS_OCTREE.CHILD5])
					  && !is_array(child[CM_ARGS_OCTREE.CHILD6])
					  && !is_array(child[CM_ARGS_OCTREE.CHILD7]) 
					  && !is_array(child[CM_ARGS_OCTREE.CHILD8])){
					//If the child octree is empty, delete it
					octree[ind] = -1;
				}
			}
		}
	}
}