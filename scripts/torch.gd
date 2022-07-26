extends Spatial

export var stayChance:float = 0.975

func _ready():
	if rand_range(0.0, 1.0) < 0.7:
		$torchLight.visible = false
		$safeArea.set_deferred("monitorable", false)


func _on_decayChance_timeout():
	if rand_range(0.0, 1.0) > stayChance:
		$torchLight.visible = false
		$safeArea.set_deferred("monitorable", false)
	$decayChance.wait_time *= 0.99
