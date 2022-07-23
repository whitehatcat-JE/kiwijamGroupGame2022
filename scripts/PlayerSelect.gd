extends Node2D


func _ready():
	pass 
	
	
func _on_wanderBtn_button_down():
	get_tree().change_scene("res://P1Seed.tscn")
	pass # Replace with function body.


func _on_guideBtn_button_down():
	get_tree().change_scene("res://P2SeedInput.tscn")
	pass # Replace with function body.
