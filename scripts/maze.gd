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

var gates:Array = []
var gateUpdateQueue:Array = []

var lastMinuteUpdated = -1

func _ready():
	lastMinuteUpdated = OS.get_datetime()["minute"]
	O.makeMaze()
	renderMaze()

func _process(delta):
	pass
	#O.changeMaze()
	#updateMaze()
	

func wallType(walls):
	match walls:
		14:
			return [WALL.DEADEND, 0.0, WALL.UP]
		13:
			return [WALL.DEADEND, 270.0, WALL.RIGHT]
		12:
			return [WALL.CORNER, 0.0, WALL.UP, WALL.RIGHT]
		11:
			return [WALL.DEADEND, 180.0, WALL.DOWN]
		10:
			return [WALL.HALLWAY, 0.0, WALL.UP, WALL.DOWN]
		9:
			return [WALL.CORNER, 270.0, WALL.UP, WALL.RIGHT] 
		8:
			return [WALL.TINTERSECTION, 270.0, WALL.DOWN, WALL.UP, WALL.LEFT]
		7:
			return [WALL.DEADEND, 90.0, WALL.LEFT]
		6:
			return [WALL.CORNER, 90.0, WALL.DOWN, WALL.LEFT]
		5:
			return [WALL.HALLWAY, 90.0, WALL.RIGHT, WALL.LEFT]
		4:
			return [WALL.TINTERSECTION, 0.0, WALL.LEFT, WALL.RIGHT, WALL.UP]
		3:
			return [WALL.CORNER, 180.0, WALL.DOWN, WALL.LEFT]
		2:
			return [WALL.TINTERSECTION, 90.0, WALL.UP, WALL.DOWN, WALL.RIGHT]
		1:
			return [WALL.TINTERSECTION, 180.0, WALL.RIGHT, WALL.LEFT, WALL.DOWN]
		_:
			return [WALL.INTERSECTION, 0.0, WALL.UP, WALL.RIGHT, WALL.DOWN, WALL.LEFT]

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
			var childNum:int = 0
			for child in newPiece.get_children():
				if "gate" in child.name:
					childNum += 1
					gates.append([child, Vector2(x, y),  true, wallInfo[1 + childNum]])

func getGate(direction, tile):
	for gate in range(len(gates)):
		if gates[gate][1] == tile and gates[gate][3] == direction:
			return gate
	return 0

func updateMaze():
	for y in range(O.MAZE_SIZE):
		for x in range(O.MAZE_SIZE):
			var originalStops:Array = []
			var newStops:Array = []
			var originalWalls:int = O.originalMaze[y][x]
			var newWalls:int = O.maze[y][x]
			if originalWalls >= 8:
				originalWalls -= 8
				originalStops.append(WALL.LEFT)
			if newWalls >= 8:
				newWalls -= 8
				newStops.append(WALL.LEFT)
			if originalWalls >= 4:
				originalWalls -= 4
				originalStops.append(WALL.DOWN)
			if newWalls >= 4:
				newWalls -= 4
				newStops.append(WALL.DOWN)
			if originalWalls >= 2:
				originalWalls -= 2
				originalStops.append(WALL.RIGHT)
			if newWalls >= 2:
				newWalls -= 2
				newStops.append(WALL.RIGHT)
			if originalWalls >= 1:
				originalWalls -= 1
				originalStops.append(WALL.UP)
			if newWalls >= 1:
				newWalls -= 1
				newStops.append(WALL.UP)
			if (WALL.UP in originalStops) != (WALL.UP in newStops):
				var targetGate:int = getGate(WALL.UP, Vector2(x, y))
				if !(WALL.UP in newStops):
					if !gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("ascend")
						gates[targetGate][2] = true
				elif gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("fall")
						gates[targetGate][2] = false
			if (WALL.RIGHT in originalStops) != (WALL.RIGHT in newStops):
				var targetGate:int = getGate(WALL.RIGHT, Vector2(x, y))
				if !(WALL.RIGHT in newStops):
					if !gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("ascend")
						gates[targetGate][2] = true
				elif gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("fall")
						gates[targetGate][2] = false
			if (WALL.DOWN in originalStops) != (WALL.DOWN in newStops):
				var targetGate:int = getGate(WALL.DOWN, Vector2(x, y))
				if !(WALL.DOWN in newStops):
					if !gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("ascend")
						gates[targetGate][2] = true
				elif gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("fall")
						gates[targetGate][2] = false
			if (WALL.LEFT in originalStops) != (WALL.LEFT in newStops):
				var targetGate:int = getGate(WALL.UP, Vector2(x, y))
				if !(WALL.LEFT in newStops):
					if !gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("ascend")
						gates[targetGate][2] = true
				elif gates[targetGate][2]:
						gates[targetGate][0].get_child(1).play("fall")
						gates[targetGate][2] = false
					
