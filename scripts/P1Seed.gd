extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$seedText.text = str(O.seedProgress)

func _on_StartButton_button_down():
	get_tree().change_scene("res://Loading.tscn.tscn")
