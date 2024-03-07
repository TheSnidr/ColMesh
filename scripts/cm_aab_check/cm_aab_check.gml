/*
	This function displaces the collider out of the give shape.
*/

function cm_aab_check(aab, collider, mask = collider[CM.MASK])
{
	if (mask != 0 && (mask & CM_AAB_GROUP) == 0){return false;}
	
	//Read collider array
	var X = collider[CM.X];
	var Y = collider[CM.Y];
	var Z = collider[CM.Z];
	var radius = collider[CM.R];
	var height = collider[CM.H];
	
	if (height != 0)
	{
		var xup = collider[CM.XUP];
		var yup = collider[CM.YUP];
		var zup = collider[CM.ZUP];
		var cx = CM_AAB_X;
		var cy = CM_AAB_Y;
		var cz = CM_AAB_Z;
		var halfX = CM_AAB_HALFX;
		var halfY = CM_AAB_HALFY;
		var halfZ = CM_AAB_HALFZ;
		
		//Check bottom of capsule
		var xx = X - cx;
		var yy = Y - cy;
		var zz = Z - cz;
		var px = cx + clamp(xx / halfX, -1, 1) * halfX;
		var py = cy + clamp(yy / halfY, -1, 1) * halfY;
		var pz = cz + clamp(zz / halfZ, -1, 1) * halfZ;
		var d = dot_product_3d(px - X, py - Y, pz - Z, xup, yup, zup);
		d = clamp(d, 0, height);
		var rx1 = X + xup * d;
		var ry1 = Y + yup * d;
		var rz1 = Z + zup * d;
		var d1 = CM_SQR(rx1 - px, ry1 - py, rz1 - pz);
		
		//Check top of capsule
		xx += xup * height;
		yy += yup * height;
		zz += zup * height;
		var px = cx + clamp(xx / halfX, -1, 1) * halfX;
		var py = cy + clamp(yy / halfY, -1, 1) * halfY;
		var pz = cz + clamp(zz / halfZ, -1, 1) * halfZ;
		var d = dot_product_3d(px - X, py - Y, pz - Z, xup, yup, zup);
		d = clamp(d, 0, height);
		var rx2 = X + xup * d;
		var ry2 = Y + yup * d;
		var rz2 = Z + zup * d;
		var d2 = CM_SQR(rx2 - px, ry2 - py, rz2 - pz);
		if (d2 < d1)
		{
			X = rx2;
			Y = ry2;
			Z = rz2;
		}
		else
		{
			X = rx1;
			Y = ry1;
			Z = rz1;
		}
	}
	
	var cx = CM_AAB_X;
	var cy = CM_AAB_Y;
	var cz = CM_AAB_Z;
	var halfX = CM_AAB_HALFX;
	var halfY = CM_AAB_HALFY;
	var halfZ = CM_AAB_HALFZ;
	
	//Find normalized block space position
	var bx = (X - cx) / halfX;
	var by = (Y - cy) / halfY;
	var bz = (Z - cz) / halfZ;
		
	//If the center of the sphere is inside the cube, normalize the largest axis
	if (max(abs(bx), abs(by), abs(bz)) <= 1)
	{
		return true;
	}
	
	//Nearest point on the cube
	var d = point_distance_3d(X, Y, Z, cx + clamp(bx, -1, 1) * halfX, cy + clamp(by, -1, 1) * halfY, cz + clamp(bz, -1, 1) * halfZ);
	if (d >= radius) return false;
	
	return true;
}