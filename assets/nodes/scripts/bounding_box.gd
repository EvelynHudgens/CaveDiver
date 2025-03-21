class_name BoundingBox

var xmin = 0
var xmax = 0
var ymin = 0
var ymax = 0
var zmin = 0
var zmax = 0

func init_bounding_box(p: Node3D) -> void:
	if p.get_child_count() == 0:
		return
	var first_child = p.get_child(0)
	xmin = first_child.global_position.x
	xmax = first_child.global_position.x
	ymin = first_child.global_position.y
	ymax = first_child.global_position.y
	zmin = first_child.global_position.z
	zmax = first_child.global_position.z
	for i in range(0, p.get_child_count()):
		var child: Node3D = p.get_child(i)
		
		if child.global_position.x < xmin:
			xmin = child.global_position.x
		elif child.global_position.x > xmax:
			xmax = child.global_position.x
		elif child.global_position.y < ymin:
			ymin = child.global_position.y
		elif child.global_position.y > ymax:
			ymax = child.global_position.y
		elif child.global_position.z < zmin:
			zmin = child.global_position.z
		elif child.global_position.z > zmax:
			zmax = child.global_position.z
			
func v3_in_bb(v: Vector3) -> bool:
	var c0 = v.x > xmin
	var c1 = v.x < xmax
	var c2 = v.y > ymin
	var c3 = v.y < ymax
	var c4 = v.z > zmin
	var c5 = v.z < zmax
	return c0 and c1 and c2 and c3 and c4 and c5
