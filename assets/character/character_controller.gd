extends CharacterBody3D

@onready var cam = get_node("Camera3D")
@onready var forward_node = get_node("Camera3D/forward_node")
@onready var left_node = get_node("Camera3D/left_node")
@onready var right_node = get_node("Camera3D/right_node")
@onready var backward_node = get_node("Camera3D/backward_node")

@onready var char_data = get_node("character_data")

var speed = 1.7
var sprint_speed = 3
var climbing_speed = 0
var jump_height = 20

var stamina = 0
	
func _process(delta: float):
	var vector_x = 0
	var vector_y = 0
	var vector_z = 0
	var new_velocity: Vector3 = Vector3(0, velocity.y, 0)
		
	if Input.is_action_pressed("forward") && !Input.is_action_pressed("backward"):
		new_velocity.x += forward_node.global_position.x - global_position.x
		new_velocity.z += forward_node.global_position.z - global_position.z
	if Input.is_action_pressed("backward") && !Input.is_action_pressed("forward"):
		new_velocity.x += backward_node.global_position.x - global_position.x
		new_velocity.z += backward_node.global_position.z - global_position.z
	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		new_velocity.x += left_node.global_position.x - global_position.x
		new_velocity.z += left_node.global_position.z - global_position.z
	if Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
		new_velocity.x += right_node.global_position.x - global_position.x
		new_velocity.z += right_node.global_position.z - global_position.z
	
	var speed_to_run = speed
	if Input.is_action_pressed("sprint") && stamina > 0:
		speed_to_run = sprint_speed
	velocity = new_velocity.normalized() * speed_to_run
	
	if !is_on_floor():
		velocity.y -= 1
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += jump_height
	move_and_slide()

func _on_character_data_stamina_signal(value: float) -> void:
	stamina = value
