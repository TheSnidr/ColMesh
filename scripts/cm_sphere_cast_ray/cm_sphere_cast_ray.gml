function cm_sphere_cast_ray(sphere, ray)
{
	/*
		A supplementary function, not meant to be used by itself.
		Used by colmesh.castRay
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_SPHERE_GROUP) == 0){return ray;}
	
	var X = CM_SPHERE_X;
	var Y = CM_SPHERE_Y;
	var Z = CM_SPHERE_Z;
	var R = CM_SPHERE_R;
	
	var rox = CM_RAY_X1;
	var roy = CM_RAY_Y1;
	var roz = CM_RAY_Z1;
	var rdx = CM_RAY_X2 - rox;
	var rdy = CM_RAY_Y2 - roy;
	var rdz = CM_RAY_Z2 - roz;
	var dx = X - rox;
	var dy = Y - roy;
	var dz = Z - roz;

	var v = dot_product_3d(rdx, rdy, rdz, rdx, rdy, rdz);
	var d = dot_product_3d(dx, dy, dz, dx, dy, dz);
	var t = dot_product_3d(rdx, rdy, rdz, dx, dy, dz);
	var u = t * t + v * (R * R - d);
	
	if (u < 0){return ray;}
	
	u = sqrt(max(u, 0));
	if (t < u)
	{
		//The ray started inside the sphere
		//if (!doublesided){return -1;} //The ray started inside the sphere, and the sphere is not doublesided. There is no way this ray can intersect the sphere.
		t += u; //Project to the inside of the sphere
		if (t < 0){return ray;} //The sphere is behind the ray
	}
	else
	{
		//Project to the outside of the sphere
		t -= u;
		if (t > v)
		{
			//The sphere is too far away
			return ray;
		}
	}
	t /= v;
	if (t > CM_RAY_T){return ray;}
	var itsX = rox + rdx * t;
	var itsY = roy + rdy * t;
	var itsZ = roz + rdz * t;
	CM_RAY_T = t;
	CM_RAY_HIT = true;
	CM_RAY_HITX = itsX;
	CM_RAY_HITY = itsY;
	CM_RAY_HITZ = itsZ;
	CM_RAY_NX = (itsX - X) / R;
	CM_RAY_NY = (itsY - Y) / R;
	CM_RAY_NZ = (itsZ - Z) / R;
	CM_RAY_OBJECT = sphere;
	return ray;
}