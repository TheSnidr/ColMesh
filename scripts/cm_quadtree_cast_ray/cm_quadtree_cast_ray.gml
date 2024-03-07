// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_quadtree_cast_ray(quadtree, ray)
{
	var aabb = CM_QUADTREE_AABB;
	var rsize = CM_QUADTREE_REGIONSIZE;
	
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
	var object = quadtree[CM_ARGS_QUADTREE.CHILD1 + rx + 2 * ry];
	if (is_array(object))
	{
		CM_CAST_RAY(object, ray);
	}
	
	//Perform a ray cast against subsequent regions in order
	var tx = (ldx == 0) ? 1 : (rsize - lox) / ldx;
	var ty = (ldy == 0) ? 1 : (rsize - loy) / ldy;
	repeat 2
	{
		var m = min(tx, ty);
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
		else
		{
			if (ty > t)
			{
				ry = !ry;
				t = ty;
			}
			ty = 1;
		}
		if (m == t)
		{
			var xx = abs(lox + ldx * t - rsize);
			var yy = abs(loy + ldy * t - rsize);
			var zz = loz + ldz * t;
			if (xx <= rsize && yy <= rsize && zz > 0 && zz <= aabb[5] - aabb[2])
			{
				object = quadtree[CM_ARGS_QUADTREE.CHILD1 + rx + 2 * ry];
				if (is_array(object))
				{
					CM_CAST_RAY(object, ray);
				}
			}
		}
	}
	return ray;
}