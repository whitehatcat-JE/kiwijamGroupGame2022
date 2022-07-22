extends Node2D

var mazePieceSize:int = 64

onready var mazeMapPiece:PackedScene = preload("res://mazeMapPiece.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	O.makeMaze()
	renderMaze()

func generateMazePiece(startingPos:Vector2):
	var newMazePiece:Node = mazeMapPiece.instance()
	self.add_child(newMazePiece)
	newMazePiece.position = startingPos
	return newMazePiece

func renderMaze():
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
