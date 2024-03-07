// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum CM_ARGS_OCTREE
{
	TYPE,
	CHILD1,
	CHILD2,
	CHILD3,
	CHILD4,
	CHILD5,
	CHILD6,
	CHILD7,
	CHILD8,
	AABB,
	REGIONSIZE,
	MAXSUBDIVISIONS,
	MAXOBJECTS,
	NUM
}

#macro CM_OCTREE_BEGIN		var octree = array_create(CM_ARGS_OCTREE.NUM, CM_OBJECTS.OCTREE)
#macro CM_OCTREE_TYPE		octree[@ CM_ARGS_OCTREE.TYPE]
#macro CM_OCTREE_REGIONSIZE	octree[@ CM_ARGS_OCTREE.REGIONSIZE]
#macro CM_OCTREE_MAXSUBDIVS	octree[@ CM_ARGS_OCTREE.MAXSUBDIVISIONS]
#macro CM_OCTREE_AABB		octree[@ CM_ARGS_OCTREE.AABB]
#macro CM_OCTREE_MAXOBJECTS	octree[@ CM_ARGS_OCTREE.MAXOBJECTS]
#macro CM_OCTREE_END		return octree

function cm_octree(x1, y1, z1, sidelength, maxsubdivisions, maxobjectsperregion)
{
	CM_OCTREE_BEGIN;
	CM_OCTREE_AABB = [x1, y1, z1, x1 + sidelength, y1 + sidelength, z1 + sidelength];
	CM_OCTREE_REGIONSIZE = sidelength / 2;
	CM_OCTREE_MAXSUBDIVS = maxsubdivisions;
	CM_OCTREE_MAXOBJECTS = maxobjectsperregion;
	CM_OCTREE_END;
}