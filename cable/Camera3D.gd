extends Camera3D

const RAY_LENGTH = 1000

var selectedObject: CollisionObject3D = null
var selectedObjectDistance: float = 0.0

func _physics_process(delta):
	# Handle object selection in world space.
	if Input.is_action_just_pressed("Select"):
		var hitCollider = CheckClickRaycast()
		if hitCollider:
			selectedObject = hitCollider
			var origin = project_ray_origin(get_viewport().get_mouse_position())
			selectedObjectDistance = (hitCollider.global_position - origin).length()
		else:
			selectedObject = null
			selectedObjectDistance = 0
	elif Input.is_action_just_released("Select"):
		selectedObject = null
		selectedObjectDistance = 0
	
	if Input.is_action_pressed("Select"):
		# Handle movement of selected object.
		if !selectedObject:
			return
		var mousepos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mousepos)
		selectedObject.global_position = origin + project_ray_normal(mousepos) * selectedObjectDistance

func CheckClickRaycast() -> CollisionObject3D:
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
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	# Make the actualy query.
	var result = space_state.intersect_ray(query)
	if !result:
		return null
	print(result)
	return result['collider']
