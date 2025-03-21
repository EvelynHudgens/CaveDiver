class_name Cave extends Node3D

var cave_script = preload("res://assets/nodes/scripts/cave.gd")

@onready var cave_manager: CaveManager = get_node("/root/Node3D/Caves")
@onready var snapping_points_parent = get_node("snapping_points")

var bounding_box: BoundingBox = BoundingBox.new()

var snap_points: SnapPoints = SnapPoints.new()
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snap_points.init_sps(snapping_points_parent.get_child_count())
	bounding_box.init_bounding_box(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cave_manager.current_cave != null:
		var in_cave = cave_manager.current_cave.get_instance_id() == get_instance_id()
		
		#if in_cave:
			#if snap_points.has_empty_children():
				#generate_to_layer(cave_manager.layers_to_render+1)
			#delete_layer(cave_manager.layers_to_render + 1)

func get_layer(layer: int, curr_cave: Cave = self, curr_layer: int = 0) -> Array[Cave]:
	var layer_arr: Array[Cave] = []
	if curr_layer == layer:
		layer_arr.append(curr_cave)
	else:
		for i in range(0, curr_cave.snap_points.size()):
			var child_cave: Cave = curr_cave.snap_points.get_child(i)
			if child_cave != null:
				var next_layer: Array[Cave] = get_layer(layer, child_cave, curr_layer+1)
				layer_arr.append_array(next_layer)
	return layer_arr
	
func generate_to_layer(layer: int, curr_layer: int = 0) -> void:
	generate_sub_caves()
	if curr_layer < layer:
		for child_index in range(0, snap_points.size()):
			var child: Cave = snap_points.get_child(child_index)
			child.generate_to_layer(layer, curr_layer+1)
	
func generate_layer(layer: int) -> void:
	var layer_to_gen: Array[Cave] = []
	var curr_layer = 0
	
	if curr_layer == layer:
		#	GEN LAYER
		pass
	else:
		pass

func generate_sub_caves() -> void:
	for i in range(0, snapping_points_parent.get_child_count()):
		if !snap_points.is_null(i):
			continue
			
		var cave_index = rng.randi_range(1, len(cave_manager.caves) - 1)
		var cave = cave_manager.caves[cave_index].instantiate()
		cave.set_script(cave_script)
		cave_manager.add_child(cave)
		snap_points.set_sp(i, cave, snapping_points_parent.get_child(i))
		
		var child_sp_parent = cave.get_node("snapping_points")
		var child_sp_index = rng.randi_range(0, child_sp_parent.get_child_count() - 1)
		var child_sp = child_sp_parent.get_child(child_sp_index)
		
		var parent_sp = snapping_points_parent.get_child(i)
		
		cave.rotate_x(parent_sp.global_rotation.x - child_sp.global_rotation.x)
		cave.rotate_z(parent_sp.global_rotation.z - child_sp.global_rotation.z)
		cave.rotate_y(parent_sp.global_rotation.y - child_sp.global_rotation.y - deg_to_rad(180))
		
		var delta_x = parent_sp.global_position.x - child_sp.global_position.x
		var delta_y = parent_sp.global_position.y - child_sp.global_position.y
		var delta_z = parent_sp.global_position.z - child_sp.global_position.z
		cave.global_position.x += delta_x
		cave.global_position.y += delta_y
		cave.global_position.z += delta_z
		cave.bounding_box.init_bounding_box(cave)
		cave.snap_points.set_sp(child_sp_index, self, child_sp)
	
func delete_sub_caves() -> void:
	var to_del_arr: Array[Cave] = []
	for i in range(cave_manager.get_child_count() - 1, -1, -1):
		var to_delete = true
		for j in range(0, snap_points.size()):
			if snap_points.is_null(j):
				continue
			var child_instance_id = snap_points.get_child(j).get_instance_id()
			var curr_instance_id = get_instance_id()
			var cave_parent_instance_id = cave_manager.get_child(i).get_instance_id()
			if child_instance_id == cave_parent_instance_id or curr_instance_id == cave_parent_instance_id:
				to_delete = false
				break
		if to_delete:
			var child_to_delete: Cave = cave_manager.get_child(i)
			to_del_arr.append(child_to_delete)
	for deletion in to_del_arr:
		deletion.queue_free()
		
	for i in range(cave_manager.get_child_count() - 1, -1, -1):
		var child: Cave = cave_manager.get_child(i)
		for j in range(0, child.snap_points.size()):
			var child_node: Cave = child.snap_points.get_child(j)
			var child_node_sp: Node3D = child.snap_points.get_sp(j)
			if !is_instance_valid(child_node) or !is_instance_valid(child_node_sp):
				child.snap_points.set_sp(j, null, null)

func delete_layer(layer: int) -> void:
	var layer_arr: Array[Cave] = get_layer(layer)
	for cave in layer_arr:
		cave.delete()
				
func delete():
	for child_index in range(0, snap_points.size()):
		var child = snap_points.get_child(child_index)
		if child == null:
			continue
		for sub_child_index in range(0, child.snap_points.size()):
			var sub_child = child.get_child(sub_child_index)
			if sub_child.get_instance_id() == get_instance_id():
				child.snap_points.set_sp(sub_child_index, null, null)
	queue_free()
