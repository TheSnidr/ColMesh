function cm_octree_add(octree, object)
{
	//If the object is an object list (which is what's created when loading a mesh), add each element individually
	if (object[CM_TYPE] == CM_OBJECTS.LIST)
	{
		var num = array_length(object);
		for (var i = CM_LIST_NUM; i < num; ++i)
		{
			cm_octree_add(octree, object[i]);
		}
		return object;
	}
	
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
				if (!is_array(child))
				{
					child = cm_list();
					octree[ind] = child;
				}
				
				//Don't add the object if it doesn't intersect with the region
				if (!cm_intersects_cube(object, rsize, aabb[0] + rsize * (.5+xx), aabb[1] + rsize * (.5+yy), aabb[2] + rsize * (.5+zz))) continue;
				
				if (child[CM_TYPE] == CM_OBJECTS.LIST)
				{
					//Add the object to the child list
					cm_list_add(child, object);
					
					//Check if the child list needs to be subdivided
					if (array_length(child) - CM_LIST_NUM > maxobjects && subdivisions)
					{
						//The child list is full! Subdivide it into eight new octants.
						octree[ind] = cm_octree(aabb[0] + rsize * xx, aabb[1] + rsize * yy, aabb[2] + rsize * zz, rsize, subdivisions - 1, maxobjects);
						
						//Copy over the contents of the child
						cm_octree_add(octree[ind], child);
					}
				}
				else
				{
					//Add the object recursively to the child octree
					cm_octree_add(child, object);
				}
			}
		}
	}
	return object;
}