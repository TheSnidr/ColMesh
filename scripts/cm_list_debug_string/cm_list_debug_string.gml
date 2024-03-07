function cm_list_debug_string(list)
{
	var str = $"[Object list: Number: {CM_LIST_SIZE}, Contents:";
	var i = CM_LIST_NUM;
	repeat CM_LIST_SIZE
	{
		var object = list[i++];
		str += "\n    " + CM_DEBUG_STRING(object);
	}
	return str + "]";
}