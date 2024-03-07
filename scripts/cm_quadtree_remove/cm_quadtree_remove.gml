function cm_quadtree_remove(quadtree, object)
{
	var aabb = CM_QUADTREE_AABB;
	var AABB = cm_get_aabb(object);
	if (AABB[0] > aabb[3] || AABB[1] > aabb[4] || AABB[2] > aabb[5] || AABB[3] < aabb[0] || AABB[4] < aabb[1] || AABB[5] < aabb[2]) return false;
	
	var rsize = CM_QUADTREE_REGIONSIZE;
	var maxobjects = CM_QUADTREE_MAXOBJECTS;
	var subdivisions = CM_QUADTREE_MAXSUBDIVS;
	
	var x1 = (AABB[0] - aabb[0] > rsize);
	var y1 = (AABB[1] - aabb[1] > rsize);
	var x2 = (AABB[3] - aabb[0] > rsize);
	var y2 = (AABB[4] - aabb[1] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			var ind = CM_ARGS_QUADTREE.CHILD1 + xx + 2 * yy;
			var child = quadtree[ind];
			if (!is_array(child)) continue;
			
			cm_remove(child, object);
			if (child[CM_TYPE] == CM_OBJECTS.LIST)
			{
				if (array_length(child) == CM_LIST_NUM) // If the child list is empty
				{
					quadtree[ind] = -1;
				}
			}
			else if (!is_array(child[CM_ARGS_QUADTREE.CHILD1]) 
					&& !is_array(child[CM_ARGS_QUADTREE.CHILD2]) 
					&& !is_array(child[CM_ARGS_QUADTREE.CHILD3]) 
					&& !is_array(child[CM_ARGS_QUADTREE.CHILD4])){
				//If the child octree is empty, delete it
				quadtree[ind] = -1;
			}
		}
	}
}