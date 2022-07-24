extends Node2D

var storedSeed:String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	O.makeMaze()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	O.seedProgress


func _on_LineEdit_text_changed(new_text):
	storedSeed = new_text


func _on_StartButton_button_down():
	O.isPlr1 = false
	get_tree().change_scene("res://Loading.tscn")
	O.seedProgress = int(storedSeed)
	print(O.seedProgress)
	O.makeMaze()
