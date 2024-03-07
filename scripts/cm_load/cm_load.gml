// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_load(filename)
{
	ini_open(filename);
	var str = ini_read_string("Colmesh v2.0", "By TheSnidr, 2023", "");
	ini_close();
	
	return json_parse(str);
}