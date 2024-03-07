/*
	This function will let you bake this shape into a vertex buffer.
	Useful for batching shapes together when debugging.
*/

function cm_list_debug_bake(list, vbuff, matrix, mask = 0, hrep = 1, vrep = 1, color = -1)
{
	var i = CM_LIST_NUM;
	repeat (CM_LIST_SIZE)
	{
		var object = list[i++];
		CM_VBUFF_BAKE(object, vbuff, matrix, mask, hrep, vrep, color);
	}
}