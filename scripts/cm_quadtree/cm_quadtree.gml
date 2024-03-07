// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum CM_ARGS_QUADTREE
{
	TYPE,
	CHILD1,
	CHILD2,
	CHILD3,
	CHILD4,
	AABB,
	REGIONSIZE,
	MAXSUBDIVISIONS,
	MAXOBJECTS,
	NUM
}

#macro CM_QUADTREE_BEGIN		var quadtree = array_create(CM_ARGS_QUADTREE.NUM, CM_OBJECTS.QUADTREE)
#macro CM_QUADTREE_TYPE			quadtree[@ CM_ARGS_QUADTREE.TYPE]
#macro CM_QUADTREE_REGIONSIZE	quadtree[@ CM_ARGS_QUADTREE.REGIONSIZE]
#macro CM_QUADTREE_MAXSUBDIVS	quadtree[@ CM_ARGS_QUADTREE.MAXSUBDIVISIONS]
#macro CM_QUADTREE_AABB			quadtree[@ CM_ARGS_QUADTREE.AABB]
#macro CM_QUADTREE_MAXOBJECTS	quadtree[@ CM_ARGS_QUADTREE.MAXOBJECTS]
#macro CM_QUADTREE_END			return quadtree

function cm_quadtree(x1, y1, z1, sidelength, maxsubdivisions, maxobjectsperregion)
{
	CM_QUADTREE_BEGIN;
	CM_QUADTREE_AABB = [x1, y1, z1, x1 + sidelength, y1 + sidelength, z1 + sidelength];
	CM_QUADTREE_REGIONSIZE = sidelength / 2;
	CM_QUADTREE_MAXSUBDIVS = maxsubdivisions;
	CM_QUADTREE_MAXOBJECTS = maxobjectsperregion;
	CM_QUADTREE_END;
}