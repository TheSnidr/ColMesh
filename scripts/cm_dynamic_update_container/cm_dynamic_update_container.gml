// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_dynamic_update_container(dynamic, container)
{
	var AABB = CM_DYNAMIC_AABB;
	var AABBPREV = CM_DYNAMIC_AABBPREV;
	
	var containerType = container[CM_TYPE];
	if (containerType == CM_OBJECTS.SPATIALHASH)
	{
		var rsize = container[CM_ARGS_SPATIALHASH.REGIONSIZE];
		if (floor(AABBPREV[0] / rsize) != floor(AABB[0] / rsize) ||
			floor(AABBPREV[1] / rsize) != floor(AABB[1] / rsize) ||
			floor(AABBPREV[2] / rsize) != floor(AABB[2] / rsize) ||
			floor(AABBPREV[3] / rsize) != floor(AABB[3] / rsize) ||
			floor(AABBPREV[4] / rsize) != floor(AABB[4] / rsize) ||
			floor(AABBPREV[5] / rsize) != floor(AABB[5] / rsize))
		{
			dynamic[@ CM_ARGS_DYNAMIC.AABB] = AABBPREV;
			cm_spatialhash_remove(container, dynamic);
			dynamic[@ CM_ARGS_DYNAMIC.AABB] = AABB;
			cm_spatialhash_add(container, dynamic);
		}
		return true;
	}
	if (containerType == CM_OBJECTS.QUADTREE)
	{
		var aabb = container[CM_ARGS_QUADTREE.AABB];
		var rsize = container[CM_ARGS_QUADTREE.REGIONSIZE] / (1 << container[CM_ARGS_QUADTREE.MAXSUBDIVISIONS]);
		if (floor(AABBPREV[0] / rsize) != floor(AABB[0] / rsize) ||
			floor(AABBPREV[1] / rsize) != floor(AABB[1] / rsize) ||
			floor(AABBPREV[3] / rsize) != floor(AABB[3] / rsize) ||
			floor(AABBPREV[4] / rsize) != floor(AABB[4] / rsize))
		{
			CM_DYNAMIC_AABB = AABBPREV;
			cm_quadtree_remove(container, dynamic);
			CM_DYNAMIC_AABB = AABB;
			cm_quadtree_add(container, dynamic);
		}
		return true;
	}
	if (containerType == CM_OBJECTS.OCTREE)
	{
		var aabb = container[CM_ARGS_OCTREE.AABB];
		var rsize = container[CM_ARGS_OCTREE.REGIONSIZE] / (1 << container[CM_ARGS_OCTREE.MAXSUBDIVISIONS]);
		if (floor(AABBPREV[0] / rsize) != floor(AABB[0] / rsize) ||
			floor(AABBPREV[1] / rsize) != floor(AABB[1] / rsize) ||
			floor(AABBPREV[2] / rsize) != floor(AABB[2] / rsize) ||
			floor(AABBPREV[3] / rsize) != floor(AABB[3] / rsize) ||
			floor(AABBPREV[4] / rsize) != floor(AABB[4] / rsize) ||
			floor(AABBPREV[5] / rsize) != floor(AABB[5] / rsize))
		{
			CM_DYNAMIC_AABB = AABBPREV;
			cm_octree_remove(container, dynamic);
			CM_DYNAMIC_AABB = AABB;
			cm_octree_add(container, dynamic);
		}
		return true;
	}
	return false;
}