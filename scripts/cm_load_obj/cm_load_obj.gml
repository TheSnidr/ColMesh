// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_load_obj(filename, matrix = undefined, singlesided = true, smoothnormals = false, group = 0)
{
	static read_face = function(faceList, str) 
	{
		gml_pragma("forceinline");
		str = string_delete(str, 1, string_pos(" ", str))
		if (string_char_at(str, string_length(str)) == " ")
		{
			//Make sure the string doesn't end with an empty space
			str = string_copy(str, 0, string_length(str) - 1);
		}
		var triNum = string_count(" ", str);
		var vertString = array_create(triNum + 1);
		for (var i = 0; i < triNum; i ++)
		{
			//Add vertices in a triangle fan
			vertString[i] = string_copy(str, 1, string_pos(" ", str));
			str = string_delete(str, 1, string_pos(" ", str));
		}
		vertString[i--] = str;
		while i--
		{
			for (var j = 2; j >= 0; j --)
			{
				var vstr = vertString[(i + j) * (j > 0)];
				var v = 0, n = 0;
				//If the vertex contains a position, texture coordinate and normal
				if string_count("/", vstr) == 2 and string_count("//", vstr) == 0
				{
					v = abs(real(string_copy(vstr, 1, string_pos("/", vstr) - 1)));
					vstr = string_delete(vstr, 1, string_pos("/", vstr));
					n = abs(real(string_delete(vstr, 1, string_pos("/", vstr))));
				}
				//If the vertex contains a position and a texture coordinate
				else if string_count("/", vstr) == 1
				{
					v = abs(real(string_copy(vstr, 1, string_pos("/", vstr) - 1)));
				}
				//If the vertex only contains a position
				else if (string_count("/", vstr) == 0)
				{
					v = abs(real(vstr));
				}
				//If the vertex contains a position and normal
				else if string_count("//", vstr) == 1
				{
					vstr = string_replace(vstr, "//", "/");
					v = abs(real(string_copy(vstr, 1, string_pos("/", vstr) - 1)));
					n = abs(real(string_delete(vstr, 1, string_pos("/", vstr))));
				}
				ds_list_add(faceList, [v-1, n-1]);
			}
		}
	}
	static read_line = function(str) 
	{
		gml_pragma("forceinline");
		str = string_delete(str, 1, string_pos(" ", str));
		var retNum = string_count(" ", str) + 1;
		var ret = array_create(retNum);
		for (var i = 0; i < retNum; i ++)
		{
			var pos = string_pos(" ", str);
			if (pos == 0)
			{
				pos = string_length(str);
				ret[i] = real(string_copy(str, 1, pos)); 
				break;
			}
			ret[i] = real(string_copy(str, 1, pos)); 
			str = string_delete(str, 1, pos);
		}
		return ret;
	}
	var file = file_text_open_read(filename);
	if (file == -1){colmesh_debug_message("Failed to load model " + string(filename)); return -1;}
	cm_debug_message("Script cm_mesh_load_from_obj: Loading obj file " + string(filename));

	//Create the necessary lists
	var V = ds_list_create();
	var N = ds_list_create();
	var F = ds_list_create();

	//Read .obj as textfile
	var str, type;
	while !file_text_eof(file)
	{
		str = string_replace_all(file_text_read_string(file),"  "," ");
		//Different types of information in the .obj starts with different headers
		switch string_copy(str, 1, string_pos(" ", str)-1)
		{
			//Load vertex positions
			case "v":
				ds_list_add(V, read_line(str));
				break;
			//Load vertex normals
			case "vn":
				ds_list_add(N, read_line(str));
				break;
			//Load faces
			case "f":
				read_face(F, str);
				break;
		}
		file_text_readln(file);
	}
	file_text_close(file);

	//Loop through the loaded information and generate a model
	var v, v1, v2, v3, n1, n2, n3, l1, l2, l3, vn;
	var vertNum = ds_list_size(F);
	var mesh = array_create(CM_LIST_NUM + (vertNum div 3));
	mesh[@ CM_ARGS_LIST.TYPE] = CM_OBJECTS.LIST;
	mesh[@ CM_ARGS_LIST.NEGATIVESIZE] = - (vertNum div 3);
	if (is_array(matrix))
	{
		for (var f = 0; f < vertNum; f += 3)
		{
			//Add the vertex to the model buffer
			if (smoothnormals)
			{
				vn = F[| f];
				v1 = V[| vn[0]];
				n1 = N[| vn[1]];
				if !is_array(v1){v1 = [0, 0, 0];}
				if !is_array(n1)
				{
					f -= 3;
					smoothnormals = false;
					cm_debug_message("Error in function cm_load_obj: Trying to load an OBJ with smooth normals, but the OBJ format does not contain normals. Loading with flat normals instead.");
					continue;
				}
				v1 = matrix_transform_vertex(matrix, v1[0], v1[1], v1[2]);
				n1 = matrix_transform_vertex(matrix, n1[0], n1[1], n1[2], 0);
				l1 = point_distance_3d(0, 0, 0, n1[0], n1[1], n1[2]);
				n1[0] /= l1; n1[1] /= l1; n1[2] /= l1;
				
				vn = F[| f+1];
				v2 = V[| vn[0]];
				n2 = N[| vn[1]];
				if !is_array(v2){v2 = [0, 0, 0];}
				if !is_array(n2){n2 = [0, 0, 1];}
				v2 = matrix_transform_vertex(matrix, v2[0], v2[1], v2[2]);
				n2 = matrix_transform_vertex(matrix, n2[0], n2[1], n2[2], 0);
				l2 = point_distance_3d(0, 0, 0, n2[0], n2[1], n2[2]);
				n2[0] /= l2; n2[1] /= l2; n2[2] /= l2;
				
				vn = F[| f+2];
				v3 = V[| vn[0]];
				n3 = N[| vn[1]];
				if !is_array(v3){v3 = [0, 0, 0];}
				if !is_array(n3){n3 = [0, 0, 1];}
				v3 = matrix_transform_vertex(matrix, v3[0], v3[1], v3[2]);
				n3 = matrix_transform_vertex(matrix, n3[0], n3[1], n3[2], 0);
				l3 = point_distance_3d(0, 0, 0, n3[0], n3[1], n3[2]);
				n3[0] /= l3; n3[1] /= l3; n3[2] /= l3;
		
				mesh[@ CM_LIST_NUM + (f div 3)] = cm_triangle(singlesided, v1[0], v1[1], v1[2], v2[0], v2[1], v2[2], v3[0], v3[1], v3[2], n1, n2, n3, group);
			}
			else
			{
				v = V[| F[| f][0]];
				if !is_array(v){v = [0, 0, 0];}
				v1 = matrix_transform_vertex(matrix, v[0], v[1], v[2]);
				v = V[| F[| f+1][0]];
				if !is_array(v){v = [0, 0, 0];}
				v2 = matrix_transform_vertex(matrix, v[0], v[1], v[2]);
				v = V[| F[| f+2][0]];
				if !is_array(v){v = [0, 0, 0];}
				v3 = matrix_transform_vertex(matrix, v[0], v[1], v[2]);
		
				mesh[@ CM_LIST_NUM + (f div 3)] = cm_triangle(singlesided, v1[0], v1[1], v1[2], v2[0], v2[1], v2[2], v3[0], v3[1], v3[2], group);
			}
		}
	}
	else
	{
		for (var f = 0; f < vertNum; f += 3)
		{
			//Add the vertex to the model buffer
			if (smoothnormals)
			{
				vn = F[| f];
				v1 = V[| vn[0]];
				n1 = N[| vn[1]];
				if !is_array(v1){v1 = [0, 0, 0];}
				if !is_array(n1)
				{
					f -= 3;
					smoothnormals = false;
					continue;
				}
				
				vn = F[| f+1];
				v2 = V[| vn[0]];
				n2 = N[| vn[1]];
				if !is_array(v2){v2 = [0, 0, 0];}
				if !is_array(n2){n2 = [0, 0, 1];}
				
				vn = F[| f+2];
				v3 = V[| vn[0]];
				n3 = N[| vn[1]];
				if !is_array(v3){v3 = [0, 0, 0];}
				if !is_array(n3){n3 = [0, 0, 1];}
		
				mesh[@ CM_LIST_NUM + (f div 3)] = cm_triangle(singlesided, v1[0], v1[1], v1[2], v2[0], v2[1], v2[2], v3[0], v3[1], v3[2], n1, n2, n3, group);
			}
			else
			{
				v1 = V[| F[| f][0]];
				if !is_array(v1){v1 = [0, 0, 0];}
				v2 = V[| F[| f+1][0]];
				if !is_array(v2){v2 = [0, 0, 0];}
				v3 = V[| F[| f+2][0]];
				if !is_array(v3){v3 = [0, 0, 0];}
		
				mesh[@ CM_LIST_NUM + (f div 3)] = cm_triangle(singlesided, v1[0], v1[1], v1[2], v2[0], v2[1], v2[2], v3[0], v3[1], v3[2], group);
			}
		}
	}
	ds_list_destroy(F);
	ds_list_destroy(V);
	cm_debug_message("Script cm_mesh_load_from_obj: Successfully loaded obj " + string(filename));
	return mesh;
}