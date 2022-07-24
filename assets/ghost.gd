extends Sprite3D

export var despawnDistance:int = 10.0

func _ready():
	visible = false
	if rand_range(0.0, 1.0) > 0.8:
		visible = true

func _process(delta):
	if O.plrPos.distance_to(self.global_transform.origin) < despawnDistance:
		visible = false
