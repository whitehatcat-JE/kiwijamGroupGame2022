extends Spatial

var speed:int = 0.9

var timeOffGround:float = 0.0

var mouseSpeed:float = rand_range(0.9, 1.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$rat_textured.global_transform.origin += $rat_textured.global_transform.basis.z.normalized() * mouseSpeed * delta
	
	if $rat_textured/movementCheck.is_colliding():
		$rat_textured.rotate(Vector3.UP, -10.0*delta*mouseSpeed)
	elif $rat_textured/movementCheck2.is_colliding():
		$rat_textured.rotate(Vector3.UP, 10.0*delta*mouseSpeed)
	
	if !$rat_textured/floorCheck.is_colliding():
		timeOffGround += delta
		if timeOffGround > 1.0:
			$rat_textured.global_transform.origin = self.global_transform.origin
	else:
		timeOffGround = 0.0
