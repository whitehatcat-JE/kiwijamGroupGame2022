extends Node2D

enum WALL {
	UP = 1,
	RIGHT = 2,
	DOWN = 4,
	LEFT = 8
}

var mazePieceSize:int = 64
var currentPieces:Array = []

var lastMinuteUpdated:int = -1

onready var mazeMapPiece:PackedScene = preload("res://mazeMapPiece.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	renderMaze()

func _process(delta):
	pass


func generateMazePiece(startingPos:Vector2):
	var newMazePiece:Node = mazeMapPiece.instance()
	currentPieces.append(newMazePiece)
	self.add_child(newMazePiece)
	newMazePiece.position = startingPos + Vector2(150, 0)
	return newMazePiece

func renderMaze():
	for piece in currentPieces: piece.queue_free()
	currentPieces.clear()
	for y in range(O.MAZE_SIZE):
		for x in range(O.MAZE_SIZE):
			var walls = O.maze[y][x]
			if walls - 8 >= 0:
				walls -= 8
				var newPiece:Node = generateMazePiece(Vector2(x*mazePieceSize, y*mazePieceSize))
				newPiece.position.x -= mazePieceSize / 2
				newPiece.rotation_degrees = -90
			if walls - 4 >= 0:
				walls -= 4
				var newPiece:Node = generateMazePiece(Vector2(x*mazePieceSize, y*mazePieceSize))
				newPiece.position.y += mazePieceSize / 2
				newPiece.rotation_degrees = 180
			if walls - 2 >= 0:
				walls -= 2
				var newPiece:Node = generateMazePiece(Vector2(x*mazePieceSize, y*mazePieceSize))
				newPiece.position.x += mazePieceSize / 2
				newPiece.rotation_degrees = +90
			if walls - 1 >= 0:
				walls -= 1
				var newPiece:Node = generateMazePiece(Vector2(x*mazePieceSize, y*mazePieceSize))
				newPiece.position.y -= mazePieceSize / 2
	for gate in O.gates:
		var targetGate:int
		if gate[0][4]: targetGate = 0;
		else: targetGate = 1;
		var pieceA:Node = generateMazePiece(gate[targetGate][0] * Vector2(mazePieceSize, mazePieceSize))
		var pieceB:Node = generateMazePiece(gate[targetGate][2] * Vector2(mazePieceSize, mazePieceSize))
		match gate[targetGate][1]:
			WALL.UP:
				pieceA.position.y -= mazePieceSize / 2
				pieceB.position.y += mazePieceSize / 2
				pieceB.rotation_degrees = 180
			WALL.RIGHT:
				pieceA.position.x += mazePieceSize / 2
				pieceA.rotation_degrees = 90
				pieceB.position.x -= mazePieceSize / 2
				pieceB.rotation_degrees = -90
			WALL.DOWN:
				pieceA.position.y += mazePieceSize / 2
				pieceA.rotation_degrees = 180
				pieceB.position.y -= mazePieceSize / 2
			WALL.LEFT:
				pieceA.position.x -= mazePieceSize / 2
				pieceA.rotation_degrees = -90
				pieceB.position.x += mazePieceSize / 2
				pieceB.rotation_degrees = 90

func _on_changeTime_timeout():
	O.changeMaze()
	renderMaze()


func _on_Button_button_down():
	get_tree().change_scene("res://mainMenu.tscn")


func _on_Button2_button_down():
	get_tree().change_scene("res://mainMenu.tscn")
