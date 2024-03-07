function cm_ray_clear(ray, x1, y1, z1, x2, y2, z2, mask = -1)
{
	if (!is_array(ray)){return cm_ray(x1, y1, z1, x2, y2, z2, mask);}
	CM_RAY_X1 = x1;
	CM_RAY_Y1 = y1;
	CM_RAY_Z1 = z1;
	CM_RAY_X2 = x2;
	CM_RAY_Y2 = y2;
	CM_RAY_Z2 = z2;
	CM_RAY_MASK = mask;
	CM_RAY_T = 1;
	CM_RAY_HIT = false;
	CM_RAY_OBJECT = 0;
	CM_RAY_HITX = x2;
	CM_RAY_HITY = y2;
	CM_RAY_HITZ = z2;
	CM_RAY_END
}