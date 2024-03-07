enum CM_ARGS_DISK
{
	TYPE, 
	GROUP,
	X, 
	Y, 
	Z,
	NX,
	NY,
	NZ,
	BIGRADIUS,
	SMALLRADIUS,
	NUM
}

#macro CM_DISK_BEGIN		var disk = array_create(CM_ARGS_DISK.NUM, CM_OBJECTS.DISK)
#macro CM_DISK_TYPE			disk[@ CM_ARGS_DISK.TYPE]
#macro CM_DISK_GROUP		disk[@ CM_ARGS_DISK.GROUP]
#macro CM_DISK_X			disk[@ CM_ARGS_DISK.X]
#macro CM_DISK_Y			disk[@ CM_ARGS_DISK.Y]
#macro CM_DISK_Z			disk[@ CM_ARGS_DISK.Z]
#macro CM_DISK_NX			disk[@ CM_ARGS_DISK.NX]
#macro CM_DISK_NY			disk[@ CM_ARGS_DISK.NY]
#macro CM_DISK_NZ			disk[@ CM_ARGS_DISK.NZ]
#macro CM_DISK_BIGRADIUS	disk[@ CM_ARGS_DISK.BIGRADIUS]
#macro CM_DISK_SMALLRADIUS	disk[@ CM_ARGS_DISK.SMALLRADIUS]
#macro CM_DISK_END			return disk

function cm_disk(x, y, z, nx, ny, nz, bigradius, smallradius, group = CM_GROUP_SOLID)
{
	var n = point_distance_3d(0, 0, 0, nx, ny, nz);
	CM_DISK_BEGIN;
	CM_DISK_GROUP = group;
	CM_DISK_X = x;
	CM_DISK_Y = y;
	CM_DISK_Z = z;
	CM_DISK_NX = nx / n;
	CM_DISK_NY = ny / n;
	CM_DISK_NZ = nz / n;
	CM_DISK_BIGRADIUS = bigradius;
	CM_DISK_SMALLRADIUS = smallradius;
	CM_DISK_END;
}