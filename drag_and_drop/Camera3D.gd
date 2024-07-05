extends Camera3D

const RAY_LENGTH = 1000
const DEFAULT_DISTANCE = 10

func _input(event):
	if Input.is_action_just_pressed("Select") and %Selectable.visible:
		%Selectable.visible = false

func _physics_process(delta):
	if not %Selectable.visible:
		return
	var collisionPos := FloorMouseCollision()
	if collisionPos != Vector3.ZERO:
		%Selectable.global_position = collisionPos
		return
	var mousepos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mousepos)
	%Selectable.global_position = origin + project_ray_normal(mousepos) * DEFAULT_DISTANCE
 
func FloorMouseCollision() -> Vector3:
	# Get the physics space.
	var space_state = get_world_3d().direct_space_state
	# Get the mouse position.
	var mousepos = get_viewport().get_mouse_position()
	# Get the origin Vector3, this is the mouse position in the camera viewport
	# converted to a Vector3 with origin in the global origin.
	var origin = project_ray_origin(mousepos)
	# The end Vector3 is the origin vector we defined before plus a vector that is
	# the normal of the point in Vector3 coordinates of the mouse position, times the ray length.
	var end = origin + project_ray_normal(mousepos) * RAY_LENGTH
	# This gives us two vectors that we can easily calculate a ray.
	# Create the query.
	var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
	# Make the actualy query.
	var result = space_state.intersect_ray(query)
	if !result:
		return Vector3.ZERO
	return result['position']
