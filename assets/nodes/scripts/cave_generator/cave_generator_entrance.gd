class_name CaveGeneratorEntrance

var point0: CaveGeneratorPoint = CaveGeneratorPoint.new()
var point1: CaveGeneratorPoint = CaveGeneratorPoint.new()
var bisector_point: CaveGeneratorPoint = CaveGeneratorPoint.new()
var height: float = 0
var id: int = 0

func set_bisector_point() -> void:
	var point: CaveGeneratorPoint = CaveGeneratorPoint.new()
	
	point.x = (point1.x - point0.x) / 2
	point.z = (point1.z - point0.z) / 2
	
	bisector_point = point
	
func set_points(bisector_point: CaveGeneratorPoint, width: float):
	pass
	
func generate(bp: CaveGeneratorPoint, w: float, a: float) -> void:
	bisector_point = bp
	var half_w: float = w/2
	
	point0.x = bp.x - half_w
	point0.z = bp.z
	point1.x = bp.x + half_w
	point0.z = bp.z
	
	point0.rotate_around_point(bp, a)
	point1.rotate_around_point(bp, -a)

func get_two_closest_entrnaces(entrances: Array[CaveGeneratorEntrance]) -> Array[int]:
	var closest_entrances: Array[int] = []
	var distances: Array[float] = []
	
	if len(entrances) < 3:
		for i in range(0, len(entrances)):
			var entrance = entrances[i]
			if id != entrance.id:
				closest_entrances.append(i)
		return closest_entrances
		
	for i in range(0, len(entrances)):
		var entrance = entrances[i]
		
		if entrance.id == id:
			distances.append(null)
			continue
		
		var p0 = entrance.bisector_point
		var p1 = bisector_point
		var dist = CaveGeneratorMath.CalcDist(p0, p1)
		closest_entrances.append(i)
		distances.append(dist)
		
	for i in range(0, len(closest_entrances)):
		for j in range(0, len(closest_entrances) - 1):
			if (distances[j] != null or distances[j+1] == null) and distances[j] > distances[j+1]:
				var d_temp = distances[j]
				var ce_temp = closest_entrances[j]
				distances[j] = distances[j+1]
				distances[j+1] = d_temp
				closest_entrances[j] = closest_entrances[j+1]
				closest_entrances[j+1] = ce_temp
	
	return [closest_entrances[0], closest_entrances[1]]
