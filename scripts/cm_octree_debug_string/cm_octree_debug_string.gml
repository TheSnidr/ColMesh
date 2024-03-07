function cm_octree_debug_string(octree)
{
	static leaves = 0;
	static calldepth = 0;
	if (calldepth == 0)
	{
		leaves = 0;
	}
	++ calldepth;
	
	var i = CM_ARGS_OCTREE.CHILD1;
	repeat 8
	{
		var child = octree[i++];
		if (!is_array(child)) continue;
		if (child[CM_TYPE] == CM_OBJECTS.LIST)
		{
			++ leaves;
			continue;
		}
		cm_octree_debug_string(child);
	}
	
	-- calldepth;
	
	return $"[Octree: Min region size: {2 * CM_OCTREE_REGIONSIZE / (1 << CM_OCTREE_MAXSUBDIVS)}, Max objects: {CM_OCTREE_MAXOBJECTS}, Leaf regions: {leaves}, AABB: {CM_OCTREE_AABB}";
}