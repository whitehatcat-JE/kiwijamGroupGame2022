extends Spatial

var speed:int = 0.9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $rat_textured/movementCheck.is_colliding():
		$rat_textured.rotate(Vector3.UP, 1.0*delta)
		$rat_textured.translation.z += (speed * delta) * (0.5 - $rat_textured/movementCheck.get_collision_point().distance_to($rat_textured.global_transform.origin))
	$rat_textured.translation.z += (speed * delta)
