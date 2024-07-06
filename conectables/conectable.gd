extends Node2D

@onready
var done := false

func placed():
	done = true

func _physics_process(delta):
	if done:
		return
	global_position = get_global_mouse_position()

func _on_port_a_input_event(viewport, event : InputEvent, shape_idx):
	pass
