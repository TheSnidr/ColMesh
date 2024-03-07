function cm_box_cast_ray(box, ray)
{
	/*
		A supplementary function, not meant to be used by itself.
		Used by colmesh.castRay
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_BOX_GROUP) == 0){return ray;}
	
	var M = CM_BOX_M;
	var I = CM_BOX_I;
	var T = CM_RAY_T;
	
	//Algorithm created by TheSnidr
	var o = matrix_transform_vertex(I, ray[0], ray[1], ray[2]);
	var e = matrix_transform_vertex(I, ray[3], ray[4], ray[5]);
	var x1 = o[0], y1 = o[1], z1 = o[2];
	var x2 = e[0], y2 = e[1], z2 = e[2];
	
	var nx = 0, ny = 0, nz = 1;
	if (x2 != x1 && abs(x1) > 1)
	{
		var s = sign(x1 - x2);
		var t = (s - x1) / (x2 - x1);
		if (t >= 0 && t <= T)
		{
			var itsY = lerp(y1, y2, t);
			var itsZ = lerp(z1, z2, t);
			if (abs(itsY) <= 1 && abs(itsZ) <= 1)
			{
				var n = s / point_distance_3d(0, 0, 0, M[0], M[1], M[2]);
				var p = matrix_transform_vertex(M, s, itsY, itsZ);
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = p[0];
				CM_RAY_HITY = p[1];
				CM_RAY_HITZ = p[2];
				CM_RAY_NX = M[0] * n;
				CM_RAY_NY = M[1] * n;
				CM_RAY_NZ = M[2] * n;
				CM_RAY_OBJECT = box;
				return ray;
			}
		}
	}
	if (y2 != y1 && abs(y1) > 1)
	{
		var s = sign(y1 - y2);
		var t = (s - y1) / (y2 - y1);
		if (t >= 0 && t <= T)
		{
			var itsX = lerp(x1, x2, t);
			var itsZ = lerp(z1, z2, t);
			if (abs(itsX) <= 1 && abs(itsZ) <= 1)
			{
				var n = s / point_distance_3d(0, 0, 0, M[4], M[5], M[6]);
				var p = matrix_transform_vertex(M, itsX, s, itsZ);
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = p[0];
				CM_RAY_HITY = p[1];
				CM_RAY_HITZ = p[2];
				CM_RAY_NX = M[4] * n;
				CM_RAY_NY = M[5] * n;
				CM_RAY_NZ = M[6] * n;
				CM_RAY_OBJECT = box;
				return ray;
			}
		}
	}
	if (z2 != z1 && abs(z1) > 1)
	{
		var s = sign(z1 - z2);
		var t = (s - z1) / (z2 - z1);
		if (t >= 0 && t <= T)
		{
			var itsX = lerp(x1, x2, t);
			var itsY = lerp(y1, y2, t);
			if (abs(itsX) <= 1 && abs(itsY) <= 1)
			{
				var n = s / point_distance_3d(0, 0, 0, M[8], M[9], M[10]);
				var p = matrix_transform_vertex(M, itsX, itsY, s);
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = p[0];
				CM_RAY_HITY = p[1];
				CM_RAY_HITZ = p[2];
				CM_RAY_NX = M[8] * n;
				CM_RAY_NY = M[9] * n;
				CM_RAY_NZ = M[10] * n;
				CM_RAY_OBJECT = box;
				return ray;
			}
		}
	}
	return ray;
}