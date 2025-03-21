extends Node

signal stamina_signal(value: float)
signal sanity_signal(value: float)

@export var max_stamina = 100

var stamina = 100.0
var sanity = 100.0

@export var sprint_stamina_cost = 0.5
@export var stamina_regain_rate = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		stamina = max(0, stamina - sprint_stamina_cost)
	else:
		stamina = min(max_stamina, stamina + stamina_regain_rate)
	stamina_signal.emit(stamina)
