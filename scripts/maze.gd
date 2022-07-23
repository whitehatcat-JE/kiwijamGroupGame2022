extends Spatial

enum WALL {
	TINTERSECTION,
	CORNER,
	HALLWAY,
	DEADEND,
	INTERSECTION,
	UP,
	LEFT,
	DOWN,
	RIGHT
}

var pieceSpacing:float = 9.0

onready var fourWay:PackedScene = preload("res://assets/intersection.tscn")
onready var threeWay:PackedScene = preload("res://assets/tIntersection.tscn")
onready var hallway:PackedScene = preload("res://assets/hallway.tscn")
onready var corner:PackedScene = preload("res://assets/corner.tscn")
onready var deadEnd:PackedScene = preload("res://assets/deadEnd.tscn")


func _ready():
	O.makeMaze()
	renderMaze()

func wallType(walls):
	match walls:
		14:
			return [WALL.DEADEND, 0.0]
		13:
			return [WALL.DEADEND, 270.0]
		12:
			return [WALL.CORNER, 0.0]
		11:
			return [WALL.DEADEND, 180.0]
		10:
			return [WALL.HALLWAY, 0.0]
		9:
			return [WALL.CORNER, 270.0] 
		8:
			return [WALL.TINTERSECTION, 270.0]
		7:
			return [WALL.DEADEND, 90.0]
		6:
			return [WALL.CORNER, 90.0]
		5:
			return [WALL.HALLWAY, 90.0]
		4:
			return [WALL.TINTERSECTION, 0.0]
		3:
			return [WALL.CORNER, 180.0]
		2:
			return [WALL.TINTERSECTION, 90.0] # C
		1:
			return [WALL.TINTERSECTION, 180.0]
		0:
			return [WALL.INTERSECTION, 0.0]

func renderMaze():
	for y in range(O.MAZE_SIZE):
		for x in range(O.MAZE_SIZE):
			var newPiece:Node
			var wallInfo:Array = wallType(O.maze[y][x])
			match wallInfo[0]:
				WALL.DEADEND:
					newPiece = deadEnd.instance()
				WALL.HALLWAY:
					newPiece = hallway.instance()
				WALL.CORNER:
					newPiece = corner.instance()
				WALL.TINTERSECTION:
					newPiece = threeWay.instance()
				WALL.INTERSECTION:
					newPiece = fourWay.instance()
			self.add_child(newPiece)
			newPiece.rotation_degrees.y = wallInfo[1]
			newPiece.translation = Vector3(x*pieceSpacing, 0.0, y*pieceSpacing)
