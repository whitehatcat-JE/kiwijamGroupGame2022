extends Node2D

func _on_begin_button_down() -> void:
	get_tree().change_scene("res://PlayerSelect.tscn")
	pass 

var rng = RandomNumberGenerator.new()


func _on_escape_button_down():
	#rng.randomize()
	#var my_random_number = rng.randf_range(0.0, 10.0)
	#if my_random_number = 1:
	
	get_tree().quit()
