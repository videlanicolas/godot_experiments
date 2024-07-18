extends Camera3D

const PLACABLE_MASK := 1

const transparent_mesh := preload("res://example_device_transparent.tres")
const opaque_mesh := preload("res://example_device_opaque.tres")

@export
var ray_length := 50.0

@onready
var spawnMap := {
	"res://example_device.tscn": preload("res://example_device.tscn")
}

var _selected_object : PhysicsBody3D = null

func _physics_process(delta):
	if _selected_object == null:
		return
	_selected_object.global_position = GetSelectedPosition()

func _on_ui_button_select(selected_object : String):
	print("Camera3D received signal: ", selected_object)
	var pScene : PackedScene = spawnMap[selected_object]
	if pScene == null:
		return
	var scene := pScene.instantiate()
	scene.get_node("MeshInstance3D").mesh = transparent_mesh
	$"..".add_child(scene)
	_selected_object = scene

func _on_ui_button_done_select():
	_selected_object.collision_layer = 1
	_selected_object.get_node("MeshInstance3D").mesh = opaque_mesh
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
	# This gives us two vectors that we can easily calculate a ray.
	# Create the query.
	var query = PhysicsRayQueryParameters3D.create(origin, end, PLACABLE_MASK)
	# Make the actualy query.
	var result = space_state.intersect_ray(query)
	if !result:
		return end
	return result["collider"].get_node("AbovePlacement").global_position
