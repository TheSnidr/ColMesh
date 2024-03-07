//-----------------------------------------------------
//	Verlet integration
fric = 1 - .4;
spdX = (x - prevX) * fric;
spdY = (y - prevY) * fric;
spdZ = (z - prevZ) * (1 - 0.01);

prevX = x;
prevY = y;
prevZ = z;

//-----------------------------------------------------
//	Controls
var jump = keyboard_check_pressed(vk_space);
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("W")) - keyboard_check(ord("S"));
if (h != 0 && v != 0)
{	//If walking diagonally, divide the input vector by its own length
	var s = 1 / sqrt(2);
	h *= s;
	v *= s;
}

//-----------------------------------------------------
//	Accelerate
acc = 2;
spdX += acc * h;
spdY += - acc * v;
spdZ += - 1 + jump * ground * 15;

//-----------------------------------------------------
//	Apply movement
x += spdX;
y += spdY;
z += spdZ;

//-----------------------------------------------------
//	Apply the previous step's delta matrix
var D = cm_collider_get_delta_matrix(collider);
if (is_array(D))
{
	charMat[12] = x;
	charMat[13] = y;
	charMat[14] = z;
	charMat = matrix_multiply(charMat, D);
	prevX += charMat[12] - x;
	prevY += charMat[13] - y;
	prevZ += charMat[14] - z;
	x = charMat[12];
	y = charMat[13];
	z = charMat[14];
}

//-----------------------------------------------------
//	Avoid level geometry by stepping towards the target position
if cm_collider_step_towards(collider, levelColmesh, x, y, z, CM_GROUP_SOLID)
{
	x = collider[CM.X];
	y = collider[CM.Y];
	z = collider[CM.Z];
}
ground = collider[CM.GROUND];

//-----------------------------------------------------
//	Check for collisions with triggers, and perform their collision functions if there is a collision
cm_collider_activate_triggers(collider, levelColmesh, CM_GROUP_TRIGGER);

//-----------------------------------------------------
//	Put player in the middle of the map if it falls off
if (z < -400)
{
	x = room_width / 2;
	y = room_height / 2;
	z = 500;
	prevX = x;
	prevY = y;
	prevZ = z;
	collider[CM.X] = x;
	collider[CM.Y] = y;
	collider[CM.Z] = z;
}

//-----------------------------------------------------
//	Update character matrix
charMat[12] = x;
charMat[13] = y;
charMat[14] = z;
charMat[0] += h * .2;
charMat[1] -= v * .2;
cm_matrix_orthogonalize(charMat);

//-----------------------------------------------------
//	Move camera
yaw += keyboard_check(vk_right) - keyboard_check(vk_left)
var d = 300;
global.camX = x + d * dcos(yaw) * dcos(pitch);
global.camY = y + d * dsin(yaw) * dcos(pitch);
global.camZ = z + d * dsin(pitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(global.camX, global.camY, global.camZ, x, y, z, xup, yup, zup));