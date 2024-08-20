function cm_spatialhash_debug_draw(spatialhash, tex = -1, color = -1, mask = 0)
{
	static region = cm_list();
	var map = CM_SPATIALHASH_MAP;
	var names = struct_get_names(map);
	var size = CM_LIST_NUM;
	var i = 0;
	repeat array_length(names)
	{
		var local = map[$ names[i++]];
		var num = - local[CM_LIST.NEGATIVESIZE];
		array_copy(region, size, local, CM_LIST_NUM, num);
		size += num;
	}
	size = array_unique_ext(region, 0, size);
	region[CM_LIST.NEGATIVESIZE] = CM_LIST_NUM - size;
	cm_list_debug_draw(region, tex, color, mask);
}