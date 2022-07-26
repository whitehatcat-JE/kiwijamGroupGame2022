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

var torchOff:bool = false

var startTime:float = 0.0
var lightsOffActive:bool = false

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
		if torchOff:
			$headAnims.playback_speed = 3.0
		else:
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
	
	if torchOff:
		vel.x *= 1.5
		vel.z *= 1.5
	
	vel.y -= gravity * delta
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)

func _process(delta):
	startTime += delta
	if startTime >= 30 and !lightsOffActive:
		lightsOffActive = true
		$lightOffCheck.start()
	O.plrPos = self.translation
	
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookangle, maxLookangle)
	
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	mouseDelta = Vector2()

func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _on_audioScareCooldown_timeout():
	if rand_range(0.0, 2.0) > 1.5:
		if rand_range(0.0, 1.0) > 0.5:
			$gearsA.play()
		else:
			$gearsB.play()

func goHome():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://mainMenu.tscn")

func _on_lightOffTime_timeout():
	$steps.play()

func _on_steps_finished():
	if torchOff: $Jumpscare.play("scary")

func _on_safeCheck_area_entered(area):
	torchOff = false
	$lightOffTime.stop()
	$steps.stop()
	$safeCheck.set_deferred("monitoring", false)
	$lightOffCheck.start()
	$Camera/torch/RootNode/torch/torch_body/torchLight.visible = true


func _on_lightOffCheck_timeout():
	if rand_range(0.0, 1.0) > 0.75:
		$lightOffTime.start()
		torchOff = true
		$safeCheck.set_deferred("monitoring", true)
		$Camera/torch/RootNode/torch/torch_body/torchLight.visible = false
	else:
		$lightOffCheck.start()


func _on_respawnTimer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://mainMenu.tscn")


func _on_exitCheck_area_entered(area):
	$winScreen/Camera2D.current = true
	$winScreen.visible = true
	$winScreen/respawnTimer.start()
	$exitCheck.set_deferred("monitoring", false)
