class_name CaveGenerator

enum CaveTypes {
	HALLWAY,
	ROOM,
	DROP
}

var cave_type: CaveTypes = CaveTypes.HALLWAY
var entrances: Array[CaveGeneratorEntrance] = []
var rocks: Array[Node3D] = []
var base_rock_spacing: float = 0
var extruded_rock_spacing_range_min: float = 0
var extruded_rock_spacing_range_max: float = 0
var room_pillar_min: int = 0
var room_pillar_max: int = 0
var wall_line_max: int = 0

var min_entrances: int = 1
var max_entrances: int = 4
var min_entrance_width: float = 0
var max_entrnace_width: float = 0

func generate_geometry() -> Node3D:
	var base_node: Node3D = Node3D.new()
	
	
	
	return base_node

func generate_walls_collsion_nodes() -> Array[MeshInstance3D]:
	var walls: Array[MeshInstance3D] = []
	
	
	
	return walls
	
func generate_pillar_collision_nodes() -> MeshInstance3D:
	return null
	
func generate_floor_collision_node() -> MeshInstance3D:
	return null
	
func generate_celing_collision_node() -> MeshInstance3D:
	return null
	
func generate_wall_points() -> Array[Vector3]:
	return []
	
func generate_collision_node(vertices: Array[Vector3]) -> MeshInstance3D:
	var meshinstance: MeshInstance3D = MeshInstance3D.new()
	
	var tmp_mesh = Mesh.new()
	var verts = PackedVector3Array()
	
	for v in vertices:
		verts.push_back(v)
		
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for v in verts.size():
		st.add_vertex(verts[v])
	
	st.commit(tmp_mesh)
	
	meshinstance.mesh = tmp_mesh

	meshinstance.create_convex_collision(true, true)
	
	return meshinstance
