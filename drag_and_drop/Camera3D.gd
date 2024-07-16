extends Camera3D


@export
var ray_length := 50.0

@onready
var spawnMap := {
	"res://example_device.tscn": preload("res://example_device.tscn")
}

var _selected_object : Node3D = null

func _physics_process(delta):
	if _selected_object == null:
		return
	_selected_object.global_position = GetSelectedPosition()

func _on_ui_button_select(selected_object : String):
	print("Camera3D received signal: ", selected_object)
	var pScene : PackedScene = spawnMap[selected_object]
	if pScene == null:
		return
	print(pScene)
	var scene := pScene.instantiate()
	$"..".add_child(scene)
	_selected_object = scene

func _on_ui_button_done_select():
	_selected_object = null

func GetSelectedPosition() -> Vector3:
	# Get the physics space.
	var space_state = get_world_3d().direct_space_state
	# Get the mouse position.
	var mousepos = get_viewport().get_mouse_position()
	# Get the origin Vector3, this is the mouse position in the camera viewport
	# converted to a Vector3 with origin in the global origin.
	var origin = project_ray_origin(mousepos)
	# The end Vector3 is the origin vector we defined before plus a vector that is
	# the normal of the point in Vector3 coordinates of the mouse position, times the ray length.
	var end = origin + project_ray_normal(mousepos) * ray_length
	return end
