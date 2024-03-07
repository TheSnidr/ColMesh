function cm_list_debug_draw(list, tex = -1, color = c_teal, mask = 0)
{
	var i = CM_LIST_NUM;
	repeat (CM_LIST_SIZE)
	{
		cm_debug_draw(list[i++], tex, color, mask);
	}
}