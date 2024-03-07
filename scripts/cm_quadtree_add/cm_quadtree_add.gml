function cm_quadtree_add(quadtree, object)
{
	//If the object is an object list (which is what's created when loading a mesh), add each element individually
	if (object[CM_TYPE] == CM_OBJECTS.LIST)
	{
		var num = array_length(object);
		for (var i = CM_LIST_NUM; i < num; ++ i)
		{
			cm_quadtree_add(quadtree, object[i]);
		}
		return object;
	}
	
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
			if (!is_array(child))
			{
				child = cm_list();
				quadtree[ind] = child;
			}
			
			if (child[CM_TYPE] == CM_OBJECTS.LIST)
			{
				//Add the object to the child list
				cm_list_add(child, object);
				
				//Check if the child list needs to be subdivided
				if (array_length(child) - CM_LIST_NUM > maxobjects && subdivisions > 0)
				{
					//The child list is full! Subdivide it into four new quadrants.
					var newChild = cm_quadtree(aabb[0] + rsize * xx, aabb[1] + rsize * yy, aabb[2], rsize, subdivisions - 1, maxobjects);
					quadtree[ind] = newChild;
					
					//Make sure the vertical dimension of the AABB remains unchanged
					newChild[CM_ARGS_QUADTREE.AABB][2] = aabb[2];
					newChild[CM_ARGS_QUADTREE.AABB][5] = aabb[5];
					
					//Copy over the contents of the child
					cm_quadtree_add(newChild, child);
				}
			}
			else
			{
				//Add the object recursively to the child quadtree
				cm_quadtree_add(child, object);
			}
		}
	}
	return object;
}