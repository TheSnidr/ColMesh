/// @description

//Cast a ray from high above to the ground so that the coin is placed onto the ground
var ray = cm_cast_ray(levelColmesh, cm_ray(x, y, 1000, x, y, -100));
if (!CM_RAY_HIT)
{
	//The ray didn't hit anything, for some reason. Destroy this coin.
	instance_destroy();
	exit;
}
radius = 10;
z = CM_RAY_HITZ + radius;
zstart = z;

//Create a collision function for the coin, telling it to destroy itself and remove its shape from the level ColMesh
colFunc = function()
{
	instance_destroy();									//This will destroy the current instance of oCoin
	cm_remove(levelColmesh, shape);						//"shape" is oCoin's shape variable. Remove it from the ColMesh
	audio_play_sound(sndColmeshDemo2Coin, 0, false);	//Play coin pickup sound
}

//Create a spherical collision shape for the coin
//Give the coin the collision function we created. 
//The collision function will be executed if the player collides with the coin, using colmesh.displaceCapsule.
shape = cm_add(levelColmesh, cm_sphere(x, y, z, radius, CM_GROUP_TRIGGER));
cm_custom_parameter_set(shape, colFunc);