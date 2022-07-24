extends KinematicBody


# physics
var moveSpeed : float = 2.0
var gravity : float = 12

# camera
var minLookangle : float = -90
var maxLookangle : float = 90
var lookSensitivity : float = 120

# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# components
onready var camera : Camera = get_node("Camera")

func _ready():
	pass
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	# movement inputs
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if abs(input.x) + abs(input.y) > 0:
		$headAnims.playback_speed = 2.0
	else:
		$headAnims.playback_speed = 0.5
	
	input = input.normalized()
	
	# get the forward and right directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	# set the velocity
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	vel.y -= gravity * delta
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)

func _process(delta):
	O.plrPos = self.translation
	
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookangle, maxLookangle)
	
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	mouseDelta = Vector2()

func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


