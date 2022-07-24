extends Spatial

func _ready():
	if rand_range(0.0, 1.0) < 0.7:
		$torchLight.visible = false
