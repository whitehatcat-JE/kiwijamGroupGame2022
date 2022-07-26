extends Node2D


func _ready():
	pass 
	
	
func _on_wanderBtn_button_down():
	O.isPlr1 = true
	get_tree().change_scene("res://loading.tscn")


func _on_guideBtn_button_down():
	O.isPlr1 = false
	get_tree().change_scene("res://loading.tscn")
