class_name CaveManager extends Node3D

var caves: Array[PackedScene] = [
	preload("res://assets/nodes/base_cave.tscn"),
	preload("res://assets/nodes/c01.tscn"),
	preload("res://assets/nodes/c02.tscn")
]

@export var layers_to_render: int

@onready var character: Node3D = get_tree().get_root().get_node("/root/Node3D/CharacterBody3D")

var current_cave: Cave = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_cave = get_current_cave()
	generate_caves_to_layer(layers_to_render, current_cave)
	delete_node_above_layer(layers_to_render, current_cave)
	
func get_current_cave() -> Cave:
	for i in range(0, get_child_count()):
		var cave_i: Cave = get_child(i)
		
		if cave_i.bounding_box.v3_in_bb(character.global_position):
			return cave_i
	return current_cave
	
func get_next_layer(curr_layer: Array[Cave], completed_nodes: Array[Cave] = []) -> Array[Cave]:
	var layer_arr: Array[Cave] = []
	
	for cave in curr_layer:
		for child_index in range(0, cave.snap_points.size()):
			var child: Cave = cave.snap_points.get_child(child_index)
			if child != null:
				var completed: bool = false
				for comp_node in completed_nodes:
					if comp_node.get_instance_id() == child.get_instance_id():
						completed = true
						break
					if !completed:
						layer_arr.append(child)
				
	return layer_arr
	
func generate_caves_to_layer(layer: int, cave_node: Cave) -> void:
	var curr_layer_nodes: Array[Cave] = [cave_node]
	var new_layer_nodes: Array[Cave] = []
	for curr_layer in range(0, layer):
		new_layer_nodes = []
		for curr_cave in curr_layer_nodes:
			curr_cave.generate_sub_caves()
			for child_index in curr_cave.snap_points.size():
				var child: Cave = curr_cave.snap_points.get_child(child_index)
				if child != null:
					new_layer_nodes.append(child)
		curr_layer_nodes = new_layer_nodes
		
func get_nodes_and_layers(cave_node: Cave, curr_layer: int = 0, comp_nodes: Array[Cave] = []) -> Array:
	var nodes: Array[Cave] = [cave_node]
	var layers: Array[int] = [curr_layer]
	var comp_nodes_append: Array[Cave] = [cave_node]
	
	for child_index in range(0, cave_node.snap_points.size()):
		var child: Cave = cave_node.snap_points.get_child(child_index)
		if child == null:
			continue
		
		var completed = false
		for comp_node in comp_nodes:
			if child.get_instance_id() == comp_node.get_instance_id():
				completed = true
			
		if !completed:
			var new_completed_arr = comp_nodes
			new_completed_arr.append_array(comp_nodes_append)
			var next_nodes_and_layers = get_nodes_and_layers(child, curr_layer+1, new_completed_arr)
			nodes.append_array(next_nodes_and_layers[0])
			layers.append_array(next_nodes_and_layers[1])
	
	return [nodes, layers]

func delete_node_above_layer(layer: int, cave_node: Cave) -> void:
	var nodes: Array[Cave] = []
	var layers: Array[int] = []
	
	var nodes_and_layers = get_nodes_and_layers(cave_node)
	nodes = nodes_and_layers[0]
	layers = nodes_and_layers[1]
	
	for i in range(0, len(layers)):
		if layers[i] > layer:
			nodes[i].delete()
