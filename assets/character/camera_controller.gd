extends Camera3D

var mouse_sens = 0.2
var camera_anglev=0

var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  		
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		_mouse_position *= mouse_sens
		var yaw = _mouse_position.x
		var pitch = _mouse_position.y
		_mouse_position = Vector2(0, 0)
		
		# Prevents looking up/down too far
		pitch = clamp(pitch, -80 - _total_pitch, 80 - _total_pitch)
		_total_pitch += pitch
	
		rotate_y(deg_to_rad(-yaw))
		rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))
