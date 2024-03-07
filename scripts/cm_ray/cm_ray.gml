// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum CM_RAY
{
	TYPE,
	X,
	Y,
	Z,
	NX,
	NY,
	NZ,
	HIT,
	X1, 
	Y1, 
	Z1, 
	X2,
	Y2,
	Z2,
	OBJECT,
	HITMAP,
	T,
	MASK,
	NUM
}

#macro CM_RAY_BEGIN			var ray = array_create(CM_RAY.NUM, CM_OBJECTS.RAY)
#macro CM_RAY_X1			ray[@ CM_RAY.X1]
#macro CM_RAY_Y1			ray[@ CM_RAY.Y1]
#macro CM_RAY_Z1			ray[@ CM_RAY.Z1]
#macro CM_RAY_X2			ray[@ CM_RAY.X2]
#macro CM_RAY_Y2			ray[@ CM_RAY.Y2]
#macro CM_RAY_Z2			ray[@ CM_RAY.Z2]
#macro CM_RAY_OBJECT		ray[@ CM_RAY.OBJECT]
#macro CM_RAY_HIT			ray[@ CM_RAY.HIT]
#macro CM_RAY_HITX			ray[@ CM_RAY.X]
#macro CM_RAY_HITY			ray[@ CM_RAY.Y]
#macro CM_RAY_HITZ			ray[@ CM_RAY.Z]
#macro CM_RAY_NX			ray[@ CM_RAY.NX]
#macro CM_RAY_NY			ray[@ CM_RAY.NY]
#macro CM_RAY_NZ			ray[@ CM_RAY.NZ]
#macro CM_RAY_T				ray[@ CM_RAY.T]
#macro CM_RAY_MASK			ray[@ CM_RAY.MASK]
#macro CM_RAY_END			return ray

function cm_ray(x1, y1, z1, x2, y2, z2, mask = 0)
{
	CM_RAY_BEGIN;
	CM_RAY_X1 = x1;
	CM_RAY_Y1 = y1;
	CM_RAY_Z1 = z1;
	CM_RAY_X2 = x2;
	CM_RAY_Y2 = y2;
	CM_RAY_Z2 = z2;
	CM_RAY_OBJECT = 0;
	CM_RAY_HIT = false;
	CM_RAY_HITX = x2;
	CM_RAY_HITY = y2;
	CM_RAY_HITZ = z2;
	CM_RAY_MASK = mask;
	CM_RAY_T = 1;
	CM_RAY_END
}