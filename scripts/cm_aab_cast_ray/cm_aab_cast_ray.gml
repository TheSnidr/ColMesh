function cm_aab_cast_ray(aab, ray)
{
	/*
		A supplementary function, not meant to be used by itself.
		Used by colmesh.castRay
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_AAB_GROUP) == 0){return ray;}
	
	var cx = CM_AAB_X;
	var cy = CM_AAB_Y;
	var cz = CM_AAB_Z;
	var halfX = CM_AAB_HALFX;
	var halfY = CM_AAB_HALFY;
	var halfZ = CM_AAB_HALFZ;
	
	var x1 = (CM_RAY_X1 - cx) / halfX;
	var y1 = (CM_RAY_Y1 - cy) / halfY;
	var z1 = (CM_RAY_Z1 - cz) / halfZ;
	var x2 = (CM_RAY_X2 - cx) / halfX;
	var y2 = (CM_RAY_Y2 - cy) / halfY;
	var z2 = (CM_RAY_Z2 - cz) / halfZ;
	var T = CM_RAY_T;
		
	var t, nx, ny, nz;
	if (x2 != x1 && abs(x1) > 1)
	{
		var s = sign(x1 - x2);
		t = (s - x1) / (x2 - x1);
		if (t >= 0 && t <= T)
		{
			var itsY = lerp(y1, y2, t);
			var itsZ = lerp(z1, z2, t);
			if (abs(itsY) <= 1 && abs(itsZ) <= 1)
			{
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = cx + s * halfX;
				CM_RAY_HITY = cy + itsY * halfY;
				CM_RAY_HITZ = cz + itsZ * halfZ;
				CM_RAY_NX = sign(x1);
				CM_RAY_NY = 0;
				CM_RAY_NZ = 0;
				CM_RAY_OBJECT = aab;
				return ray;
			}
		}
	}
	if (y2 != y1 && abs(y1) > 1)
	{
		var s = sign(y1 - y2);
		t = (s - y1) / (y2 - y1);
		if (t >= 0 && t <= T)
		{
			var itsX = lerp(x1, x2, t);
			var itsZ = lerp(z1, z2, t);
			if (abs(itsX) <= 1 && abs(itsZ) <= 1)
			{
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = cx + itsX * halfX;
				CM_RAY_HITY = cy + s * halfY;
				CM_RAY_HITZ = cz + itsZ * halfZ;
				CM_RAY_NX = 0;
				CM_RAY_NY = sign(y1);
				CM_RAY_NZ = 0;
				CM_RAY_OBJECT = aab;
				return ray;
			}
		}
	}
	if (z2 != z1 && abs(z1) > 1)
	{
		var s = sign(z1 - z2);
		t = (s - z1) / (z2 - z1);
		if (t >= 0 && t <= T)
		{
			var itsX = lerp(x1, x2, t);
			var itsY = lerp(y1, y2, t);
			if (abs(itsX) <= 1 && abs(itsY) <= 1)
			{
				CM_RAY_T = t;
				CM_RAY_HIT = true;
				CM_RAY_HITX = cx + itsX * halfX;
				CM_RAY_HITY = cy + itsY * halfY;
				CM_RAY_HITZ = cz + s * halfZ;
				CM_RAY_NX = 0;
				CM_RAY_NY = 0;
				CM_RAY_NZ = sign(z1);
				CM_RAY_OBJECT = aab;
				return ray;
			}
		}
	}
	return ray;
}