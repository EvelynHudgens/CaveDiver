class_name SnapPoints

var children_nodes: Array[Cave] = []
var children_nodes_sp: Array[Node3D] = []

func check_index(index: int) -> bool:
	return index < len(children_nodes) and index < len(children_nodes_sp) and index >= 0
	
func init_sps(count: int) -> void:
	for i in range(0, count):
		children_nodes.append(null)
		children_nodes_sp.append(null)
		
func set_sp(index: int, node: Cave, sp: Node3D) -> bool:
	if !check_index(index):
		return false
	
	children_nodes[index] = node
	children_nodes_sp[index] = sp
	
	return true
	
func has_empty_children() -> bool:
	for i in range(0, len(children_nodes)):
		if children_nodes[i] == null or children_nodes_sp[i] == null:
			return true
	return false

func is_null(index: int) -> bool:
	if !check_index(index):
		return false
	
	return children_nodes[index] == null or children_nodes_sp[index] == null
	
func size() -> int:
	return len(children_nodes)
	
func get_child(index: int) -> Cave:
	if !check_index(index):
		return null
	return children_nodes[index]

func get_sp(index: int) -> Node3D:
	if !check_index(index):
		return null
	return children_nodes_sp[index]
