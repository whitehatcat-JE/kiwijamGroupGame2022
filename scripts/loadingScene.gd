extends Node2D

var initialMinute:int = 0

func _ready():
	initialMinute = OS.get_datetime()["minute"]

func _process(delta):
	if initialMinute != OS.get_datetime()["minute"]:
		if O.isPlr1:
			get_tree().change_scene("res://maze.tscn")
		else:
			get_tree().change_scene("res://map.tscn")
