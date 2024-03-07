function cm_dynamic_cast_ray(dynamic, ray)
{
	//Avoid creating arrays on the fly by storing a local array for each recursion level
	static rays = array_create(CM_MAX_RECURSIONS);
	
	//Transform the ray to the dynamic's local space
	var I = CM_DYNAMIC_I;
	var p1 = matrix_transform_vertex(I, CM_RAY_X1, CM_RAY_Y1, CM_RAY_Z1);
	var p2 = matrix_transform_vertex(I, CM_RAY_X2, CM_RAY_Y2, CM_RAY_Z2);
	var localRay = cm_ray_clear(rays[CM_RECURSION], p1[0], p1[1], p1[2], p2[0], p2[1], p2[2], CM_RAY_MASK);
	rays[CM_RECURSION] = localRay;
	localRay[CM_RAY.T] = CM_RAY_T;
	
	//Increase recursion counter and perform a ray cast in local space
	++ CM_RECURSION;
	cm_cast_ray(CM_DYNAMIC_OBJECT, localRay);
	-- CM_RECURSION;
	
	//There was no intersection. Return the un-altered array
	if (!localRay[CM_RAY.HIT]) return ray;
	
	//Transform back to world-space
	CM_RAY_T = localRay[CM_RAY.T];
	var M = CM_DYNAMIC_M;
	var e = matrix_transform_vertex(M, localRay[CM_RAY.X], localRay[CM_RAY.Y], localRay[CM_RAY.Z]);
	var n = matrix_transform_vertex(M, localRay[CM_RAY.NX],   localRay[CM_RAY.NY],   localRay[CM_RAY.NZ],   0);
	CM_RAY_HITX = e[0];
	CM_RAY_HITY = e[1];
	CM_RAY_HITZ = e[2];
	CM_RAY_NX = n[0];
	CM_RAY_NY = n[1];
	CM_RAY_NZ = n[2];
	
	CM_RAY_HIT = true;
	CM_RAY_OBJECT = dynamic;
	
	return ray;
}