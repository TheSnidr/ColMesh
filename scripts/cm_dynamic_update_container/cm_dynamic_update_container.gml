// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_dynamic_update_container(dynamic, container)
{
	var AABB = CM_DYNAMIC_AABB;
	var AABBPREV = CM_DYNAMIC_AABBPREV;
	
	var containerType = container[CM_TYPE];
	if (containerType == CM_OBJECTS.SPATIALHASH)
	{
		var rsize = container[CM_SPATIALHASH.REGIONSIZE];
		if (floor(AABBPREV[0] / rsize) != floor(AABB[0] / rsize) ||
			floor(AABBPREV[1] / rsize) != floor(AABB[1] / rsize) ||
			floor(AABBPREV[2] / rsize) != floor(AABB[2] / rsize) ||
			floor(AABBPREV[3] / rsize) != floor(AABB[3] / rsize) ||
			floor(AABBPREV[4] / rsize) != floor(AABB[4] / rsize) ||
			floor(AABBPREV[5] / rsize) != floor(AABB[5] / rsize))
		{
			CM_DYNAMIC_AABB = AABBPREV;
			cm_spatialhash_remove(container, dynamic);
			CM_DYNAMIC_AABB = AABB;
			cm_spatialhash_add(container, dynamic);
		}
		return true;
	}
	if (containerType == CM_OBJECTS.QUADTREE)
	{
		var aabb = container[CM_QUADTREE.AABB];
		var rsize = container[CM_QUADTREE.REGIONSIZE];
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
		var rsize = container[CM_OCTREE.REGIONSIZE];
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