class_name CaveGeneratorPoint

var x: float = 0
var z: float = 0

	
func rotate_around_point(p1: CaveGeneratorPoint, angle: float) -> void:
	var p: CaveGeneratorPoint = CaveGeneratorPoint.new()
	var rad = CaveGeneratorMath.DegToRad(angle)
	
	x = x - p1.x
	z = z - p1.z
	
	x = x*cos(rad) - z*sin(rad)
	z = z*cos(rad) + x*sin(rad)
	
	x += p1.x
	z += p1.z
