extends Camera3D

const FOLLOW_SPEED := 1.0

@export
var target : Node3D = null

@export
var distance : float = 0

@export
var speedCurve : Curve

@export
var rotateSpeed := 1.0

func _physics_process(delta):
	# If there is no target, skip doing anything.
	if target == null:
		pass
	var n := target.global_position.normalized()
	# Check if the user pressed any input.
	if Input.is_action_pressed("left"):
		print(n)
		global_rotate(n, delta * rotateSpeed)
	if Input.is_action_pressed("right"):
		global_rotate(target.global_position.normalized(), -delta * rotateSpeed)
	# Look at the target.
	look_at(target.global_position)
	# Now adjust the camera position according to the distance.
	_adjust_distance_from_target(delta)

func _adjust_distance_from_target(delta):
	# First calculate the distance between the camera and the target.
	var desiredPosition := (global_position - target.global_position).normalized() * distance
	global_position = global_position.lerp(desiredPosition, delta * FOLLOW_SPEED)
