extends Camera3D

const FOLLOW_SPEED := 1.0
const ROTATE_SPEED := 1.0
const RAY_LENGTH = 1000

@export
var target : Node3D = null

@export
var distance : float = 0

@export
var follow_angle : float = 0

@export
var speedCurve : Curve

@export
var rotateSpeed := 1.0

@export_range(0.0, 1.0)
var slerpWeight := 0.0

@export
var withSlerp := false

@onready
var _prev_target : Node3D = target

@onready
var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _ready():
	tween.tween_property($"..", "global_position", target.global_position, 1)

func _physics_process(delta):
	if Input.is_action_just_pressed("Select"):
		var hit := CheckClickRaycast()
		if "collider" in hit:
			if tween:
				tween.kill()
				tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			tween.tween_property($"..", "global_position", hit["collider"].global_position, 1)
	# Check if the user pressed any input.
	if Input.is_action_pressed("left"):
		$"..".rotate($"..".transform.basis.y, -delta * ROTATE_SPEED)
	if Input.is_action_pressed("right"):
		$"..".rotate($"..".transform.basis.y, delta * ROTATE_SPEED)
	# Look at the target.
	look_at($"..".position)
	# Now adjust the camera position according to the distance.
	_adjust_distance_from_target(delta)

func _adjust_distance_from_target(delta):
	var desiredPosition = position.normalized() * distance
	# Interpolate the position of the camera to slowly adjust its position.
	position = position.lerp(desiredPosition, delta * FOLLOW_SPEED)

func CheckClickRaycast() -> Dictionary:
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
		return Dictionary()
	print(result)
	return result

func RotateAround(axis : Vector3, circleNormal : Vector3, angleRadians : float):
	pass
