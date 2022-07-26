extends Node2D

var initialMinute:int = 0

func _ready():
	initialMinute = OS.get_datetime()["minute"]

func _process(delta):
	if initialMinute != OS.get_datetime()["minute"]:
		O.seedProgress = pow((OS.get_datetime()["minute"] + OS.get_datetime()["hour"] + OS.get_datetime()["day"] + OS.get_datetime()["month"]), 2)
		O.sharedSeed = 123456789
		O.makeMaze()
		if O.isPlr1:
			get_tree().change_scene("res://maze.tscn")
		else:
			get_tree().change_scene("res://map.tscn")
	else:
		$Label.text = str(60-OS.get_datetime()["second"])
