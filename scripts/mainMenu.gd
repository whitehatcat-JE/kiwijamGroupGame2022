extends Node2D



func _ready():
	pass 
	
	
func _on_begin_button_down() -> void:
	get_tree().change_scene("res://PlayerSelect.tscn")
	pass 


func _on_escape_button_down():
	get_tree().quit()
	pass # Replace with function body.
