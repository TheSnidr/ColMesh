function cm_torus_cast_ray(torus, ray)
{
	/*
		A supplementary function, not meant to be used by itself.
		Used by colmesh.castRay
		Changes the global array cmRay if the ray intersects the shape
		This is an approximation using the same principle as ray marching
	*/
	if (CM_RAY_MASK != 0 && (CM_RAY_MASK & CM_TORUS_GROUP) == 0){return ray;}
	
	var repetitions = 14;
	
	var X = CM_TORUS_X;
	var Y = CM_TORUS_Y;
	var Z = CM_TORUS_Z;
	var rayx = CM_RAY_X1;
	var rayy = CM_RAY_Y1;
	var rayz = CM_RAY_Z1;
	var x1 = rayx - X;
	var y1 = rayy - Y;
	var z1 = rayz - Z;
	var dx = CM_RAY_X2 - rayx;
	var dy = CM_RAY_Y2 - rayy;
	var dz = CM_RAY_Z2 - rayz;
	var nx = CM_TORUS_NX;
	var ny = CM_TORUS_NY;
	var nz = CM_TORUS_NZ;
	var R = CM_TORUS_BIGRADIUS;
	
	var sx = ny * z1 - nz * y1;
	var sy = nz * x1 - nx * z1;
	var sz = nx * y1 - ny * x1;
	var s = point_distance_3d(0, 0, 0, sx, sy, sz);
	sx /= s;
	sy /= s;
	sz /= s;
	var tx = sy * nz - sz * ny;
	var ty = sz * nx - sx * nz;
	var tz = sx * ny - sy * nx;
	
	var lox = dot_product_3d(x1, y1, z1, tx, ty, tz) / R;
	var loy = 0; //Per definition
	var loz = dot_product_3d(x1, y1, z1, nx, ny, nz) / R;
	
	var ldx = dot_product_3d(dx, dy, dz, tx, ty, tz) / R;
	var ldy = dot_product_3d(dx, dy, dz, sx, sy, sz) / R;
	var ldz = dot_product_3d(dx, dy, dz, nx, ny, nz) / R;
	
	var l = point_distance_3d(0, 0, 0, ldx, ldy, ldz);
	ldx /= l;
	ldy /= l;
	ldz /= l;
	var p = 0, n = 0, t = 0;
	var radiusRatio = CM_TORUS_SMALLRADIUS / CM_TORUS_BIGRADIUS;
	repeat repetitions 
	{
		p = n;
		n = (point_distance(0, 0, point_distance(0, 0, lox, loy) - 1, loz) - radiusRatio);
		t += n;
		if ((p > 0 && n > R) || t > l || t < 0) return ray; //The ray missed or didn't reach the torus
		lox += ldx * n;	
		loy += ldy * n;
		loz += ldz * n;
	}
	if (n > p) return ray; //If the new distance estimate is larger than the previous one, the ray must have missed a close point and is moving away from the object 
	
	t /= l;
	if (t > CM_RAY_T){return ray;}
	var itsX = lerp(CM_RAY_X1, CM_RAY_X2, t);
	var itsY = lerp(CM_RAY_Y1, CM_RAY_Y2, t);
	var itsZ = lerp(CM_RAY_Z1, CM_RAY_Z2, t);
	
	var ringx = itsX - X;
	var ringy = itsY - Y;
	var ringz = itsZ - Z;
	var dp = dot_product_3d(ringx, ringy, ringz, nx, ny, nz);
	ringx -= nx * dp;
	ringy -= ny * dp;
	ringz -= nz * dp;
	var l = point_distance_3d(ringx, ringy, ringz, 0, 0, 0);
	
	if (l == 0) return ray;
	var _d = R / l;
	ringx = X + ringx * _d;
	ringy = Y + ringy * _d;
	ringz = Z + ringz * _d;
	
	var n = point_distance_3d(itsX, itsY, itsZ, ringx, ringy, ringz);
	if (n == 0) return ray;
	
	CM_RAY_T = t;
	CM_RAY_HIT = true;
	CM_RAY_HITX = itsX;
	CM_RAY_HITY = itsY;
	CM_RAY_HITZ = itsZ;
	CM_RAY_NX = (itsX - ringx) / n;
	CM_RAY_NY = (itsY - ringy) / n;
	CM_RAY_NZ = (itsZ - ringz) / n;
	CM_RAY_OBJECT = torus;
	return ray;
}