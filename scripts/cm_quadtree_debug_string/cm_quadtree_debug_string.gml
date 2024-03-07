function cm_quadtree_debug_string(quadtree)
{
	static leaves = 0;
	static calldepth = 0;
	if (calldepth == 0)
	{
		leaves = 0;
	}
	++ calldepth;
	
	var i = CM_ARGS_QUADTREE.CHILD1;
	repeat 4
	{
		var child = quadtree[i++];
		if (!is_array(child)) continue;
		if (child[CM_TYPE] == CM_OBJECTS.LIST)
		{
			++ leaves;
			continue;
		}
		cm_quadtree_debug_string(child);
	}
	
	-- calldepth;
	
	return $"[Quadtree: Min region size: {2 * CM_QUADTREE_REGIONSIZE / (1 << CM_QUADTREE_MAXSUBDIVS)}, Max objects: {CM_QUADTREE_MAXOBJECTS}, Leaf regions: {leaves}, AABB: {CM_QUADTREE_AABB}";
}