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

var pieceSpacing:float = 6.0

onready var fourWay:PackedScene = preload("res://assets/intersection.tscn")
onready var threeWay:PackedScene = preload("res://assets/tIntersection.tscn")
onready var hallway:PackedScene = preload("res://assets/hallway.tscn")
onready var corner:PackedScene = preload("res://assets/corner.tscn")
onready var deadEnd:PackedScene = preload("res://assets/deadEnd.tscn")

var mazeAssets:Array = []

var lastMinuteUpdated = -1

func _ready():
	lastMinuteUpdated = OS.get_datetime()["minute"]
	renderMaze()

#func _process(delta):
	#if lastMinuteUpdated != OS.get_datetime()["minute"] or true:
	#	updateMaze()

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
		mazeAssets.append([])
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
			mazeAssets[y].append(newPiece)
			newPiece.rotation_degrees.y = wallInfo[1]
			newPiece.translation = Vector3(x*pieceSpacing, 0.0, y*pieceSpacing)

func updateMaze():
	var newMaze = O.changeMaze()
	for y in range(O.MAZE_SIZE):
		for x in range(O.MAZE_SIZE):
			if newMaze[y][x] != O.maze[y][x]:
				mazeAssets[y][x].queue_free()
				
				var newPiece:Node
				var wallInfo:Array = wallType(newMaze[y][x])
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
				mazeAssets[y].append(newPiece)
				newPiece.rotation_degrees.y = wallInfo[1]
				newPiece.translation = Vector3(x*pieceSpacing, 0.0, y*pieceSpacing)
	O.maze = newMaze
