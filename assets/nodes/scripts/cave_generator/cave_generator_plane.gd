class_name CaveGeneratorPlane

var entrances: Array[CaveGeneratorEntrance] = []
var radius: float = 0
var circumference: float = 0

var rng = RandomNumberGenerator.new()
	
func generate_entrances(
	parent_entrance: CaveGeneratorEntrance,
	min_width: float, 
	max_width: float, 
	min_height: float, 
	max_height: float,
	min_angle: float,
	max_angle: float, 
	min_margin: float,
	min_entrances: int = 2,
	max_entrances: int = 4,
	polygon_sides: int = 4
	) -> void:
	var sides_with_doors: Array[bool] = []
	for i in range(0, polygon_sides):
		sides_with_doors.append(false)
	sides_with_doors[0] = true
	var new_entrances: Array[CaveGeneratorEntrance] = []
	var n = rng.randi_range(min_entrances, max_entrances)
	
	for i in range(1, n):
		var in_arr: bool = true
		while in_arr:
			var rand_index: int = rng.randi_range(1, polygon_sides-1)
			if sides_with_doors[rand_index] == false:
				in_arr = false
				sides_with_doors[rand_index] = true
	
	var poly_angle = CaveGeneratorMath.CalcPolygonAngle(polygon_sides)
	for i in range(0, n):
		if sides_with_doors[i] == false:
			continue
		
		var entrance: CaveGeneratorEntrance = CaveGeneratorEntrance.new()
