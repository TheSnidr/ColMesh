function cm_capsule_cast_ray(capsule, ray)
{
	/*
		Source:
		Inigo Quilez, 2016
		https://www.shadertoy.com/view/Xt3SzX
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_CAPSULE_GROUP) == 0){return ray;}
	
	var x1 = CM_CAPSULE_X1;
	var y1 = CM_CAPSULE_Y1;
	var z1 = CM_CAPSULE_Z1;
	var x2 = CM_CAPSULE_X2;
	var y2 = CM_CAPSULE_Y2;
	var z2 = CM_CAPSULE_Z2;
	var R  = CM_CAPSULE_R;
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
	var i = baoa + t * bard;
	if (i <= 0 || i >= baba)
	{
		//caps
		var ocx = (i <= 0) ? oax : rox - x2;
		var ocy = (i <= 0) ? oay : roy - y2;
		var ocz = (i <= 0) ? oaz : roz - z2;
		b = dot_product_3d(rdx, rdy, rdz, ocx, ocy, ocz);
		c = dot_product_3d(ocx, ocy, ocz, ocx, ocy, ocz) - R * R;
		h = b * b - c;
		if (h > 0) t = - b - sqrt(h);
	}
	if (t < 0 || t > CM_RAY_T * rayLen){return ray;}
	
	var itsX = rox + rdx * t;
	var itsY = roy + rdy * t;
	var itsZ = roz + rdz * t;
	var n = clamp(dot_product_3d(itsX - x1, itsY - y1, itsZ - z1, bax, bay, baz) / baba, 0, 1);
	
	CM_RAY_T = t / rayLen;
	CM_RAY_HIT = true;
	CM_RAY_HITX = itsX;
	CM_RAY_HITY = itsY;
	CM_RAY_HITZ = itsZ;
	CM_RAY_NX = (itsX - lerp(x1, x2, n)) / R;
	CM_RAY_NY = (itsY - lerp(x1, x2, n)) / R;
	CM_RAY_NZ = (itsZ - lerp(x1, x2, n)) / R;
	CM_RAY_OBJECT = capsule;
	return ray;
}