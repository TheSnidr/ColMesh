function cm_list_add(list, object)
{
	//If the object is an object list (which is what's created when loading a mesh), add each element individually
	if (object[CM_TYPE] == CM_OBJECTS.LIST)
	{
		array_copy(list, array_length(list), object, CM_LIST_NUM, - object[CM_LIST.NEGATIVESIZE]);
		list[@ CM_LIST.NEGATIVESIZE] += object[CM_LIST.NEGATIVESIZE];
		return object;
	}
	
	array_push(list, object);
	CM_LIST_NEGATIVESIZE -= 1;
	return object;
}