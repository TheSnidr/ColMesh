// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum CM_LIST
{
	TYPE,
	NEGATIVESIZE,
	NUM
}

#macro CM_LIST_BEGIN		var list = array_create(CM_LIST.NUM, CM_OBJECTS.LIST)
#macro CM_LIST_TYPE			list[@ CM_LIST.TYPE]
#macro CM_LIST_NEGATIVESIZE	list[@ CM_LIST.NEGATIVESIZE]
#macro CM_LIST_END			return list
#macro CM_LIST_NUM			CM_LIST.NUM
#macro CM_LIST_SIZE			(- list[CM_LIST.NEGATIVESIZE])

/// @func cm_list([object1], [object2], ...)
function cm_list()
{
	CM_LIST_BEGIN;
	CM_LIST_NEGATIVESIZE = 0;
	
	var i = 0;
	repeat (argument_count)
	{
		cm_list_add(list, argument[i++]);
	}
	
	CM_LIST_END;
}