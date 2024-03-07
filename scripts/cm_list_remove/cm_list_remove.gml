function cm_list_remove(list, object)
{
	var ind = array_get_index(list, object);
	if (ind < CM_LIST_NUM) return false;
	array_delete(list, ind, 1);
	CM_LIST_NEGATIVESIZE += 1;
}