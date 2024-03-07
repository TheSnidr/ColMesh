function cm_cylinder_cast_ray(cylinder, ray)
{
	/*
		Source:
		Inigo Quilez, 2016
		https://www.shadertoy.com/view/4lcSRn
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_CYLINDER_GROUP) == 0){return ray;}
	
	var x1 = CM_CYLINDER_X1;
	var y1 = CM_CYLINDER_Y1;
	var z1 = CM_CYLINDER_Z1;
	var x2 = CM_CYLINDER_X2;
	var y2 = CM_CYLINDER_Y2;
	var z2 = CM_CYLINDER_Z2;
	var R  = CM_CYLINDER_R;
	var rox = CM_RAY_X1;
	var roy = CM_RAY_Y1;
	var roz = CM_RAY_Z1;
	var rdx = CM_RAY_X2 - rox;
	var rdy = CM_RAY_Y2 - roy;
	var rdz = CM_RAY_Z2 - roz;
	var bax = x2 - x1;
	var bay = y2 - y1;
	var baz = z2 - z1;
	var oax = rox - x1;
	var oay = roy - y1;
	var oaz = roz - z1;
	var rayLen = point_distance_3d(ray[0], ray[1], ray[2], ray[3], ray[4], ray[5]);
	rdx /= rayLen;
	rdy /= rayLen;
	rdz /= rayLen;
	var baba = dot_product_3d(bax, bay, baz, bax, bay, baz);
	var bard = dot_product_3d(bax, bay, baz, rdx, rdy, rdz);
	var baoa = dot_product_3d(bax, bay, baz, oax, oay, oaz);
	var rdoa = dot_product_3d(rdx, rdy, rdz, oax, oay, oaz);
	var oaoa = dot_product_3d(oax, oay, oaz, oax, oay, oaz);
	var a = baba - bard * bard;
	var b = baba * rdoa - baoa * bard;
	var c = baba * oaoa - baoa * baoa - R * R * baba;
	var h = b * b - a * c;
	
	if (h < 0) return ray;
	
	h = sqrt(h);
	var t = - (b + h) / a;
	var l = baoa + t * bard;
	if (t >= 0 && t <= CM_RAY_T * rayLen && l > 0 && l < baba)
	{
		//Body
		var itsX = rox + rdx * t;
		var itsY = roy + rdy * t;
		var itsZ = roz + rdz * t;
		var n = clamp(dot_product_3d(itsX - x1, itsY - y1, itsZ - z1, bax, bay, baz) / baba, 0, 1);
	
		CM_RAY_T = t / rayLen;
		CM_RAY_HIT = true;
		CM_RAY_HITX = itsX;
		CM_RAY_HITY = itsY;
		CM_RAY_HITZ = itsZ;
		CM_RAY_NX = (oax + t * rdx - bax * l / baba) / R;
		CM_RAY_NY = (oay + t * rdy - bay * l / baba) / R;
		CM_RAY_NZ = (oaz + t * rdz - baz * l / baba) / R;
		CM_RAY_OBJECT = cylinder;
	}
	else
	{
		//Caps
		t = (((l < 0) ? 0 : baba) - baoa) / bard;
		if (t >= 0 && t <= CM_RAY_T * rayLen && abs(b + a * t) < h)
		{
			var ba = sign(l) / sqrt(baba);
			CM_RAY_T = t / rayLen;
			CM_RAY_HIT = true;
			CM_RAY_HITX = rox + rdx * t;
			CM_RAY_HITY = roy + rdy * t;
			CM_RAY_HITZ = roz + rdz * t;
			CM_RAY_NX = bax * ba;
			CM_RAY_NY = bay * ba;
			CM_RAY_NZ = baz * ba;
			CM_RAY_OBJECT = cylinder;
		}
	}

	return ray;
}