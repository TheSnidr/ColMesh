// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cm_ray_draw(ray, tex = -1, color = -1, radius = 5, mask = 0)
{
	cm_debug_draw(cm_capsule(CM_RAY_X1, CM_RAY_Y1, CM_RAY_Z1, CM_RAY_HITX, CM_RAY_HITY, CM_RAY_HITZ, radius), tex, color);
}