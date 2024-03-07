function cm_octree_cast_ray(octree, ray)
{
	var aabb = CM_OCTREE_AABB;
	var rsize = CM_OCTREE_REGIONSIZE;
	
	var t = cm_ray_constrain(ray, aabb);
	if (t >= CM_RAY_T)
	{
		return ray;
	}
	
	var lox = CM_RAY_X1 - aabb[0];
	var loy = CM_RAY_Y1 - aabb[1];
	var loz = CM_RAY_Z1 - aabb[2];
	var ldx = CM_RAY_X2 - CM_RAY_X1;
	var ldy = CM_RAY_Y2 - CM_RAY_Y1;
	var ldz = CM_RAY_Z2 - CM_RAY_Z1;
	
	//Perform a ray cast against the first region the ray hits
	var rx = (lox + ldx * t > rsize);
	var ry = (loy + ldy * t > rsize);
	var rz = (loz + ldz * t > rsize);
	var object = octree[CM_ARGS_OCTREE.CHILD1 + rx + 2 * ry + 4 * rz];
	if (is_array(object))
	{
		CM_CAST_RAY(object, ray);
	}
	
	//Perform a ray cast against subsequent regions in order
	var tx = (ldx == 0) ? 1 : (rsize - lox) / ldx;
	var ty = (ldy == 0) ? 1 : (rsize - loy) / ldy;
	var tz = (ldz == 0) ? 1 : (rsize - loz) / ldz;
	repeat 3
	{
		var m = min(tx, ty, tz);
		if (m >= CM_RAY_T) return ray;
		if (m == tx)
		{
			if (tx > t)
			{
				rx = !rx;
				t = tx;
			}
			tx = 1;
		}
		else if (m == ty)
		{
			if (ty > t)
			{
				ry = !ry;
				t = ty;
			}
			ty = 1;
		}
		else
		{
			if (tz > t)
			{
				rz = !rz;
				t = tz;
			}
			tz = 1;
		}
		if (m == t)
		{
			if (abs(lox + ldx * t - rsize) <= rsize && abs(loy + ldy * t - rsize) <= rsize && abs(loz + ldz * t - rsize) <= rsize)
			{
				object = octree[CM_ARGS_OCTREE.CHILD1 + rx + 2 * ry + 4 * rz];
				if (is_array(object))
				{
					CM_CAST_RAY(object, ray);
				}
			}
		}
	}
	return ray;
}