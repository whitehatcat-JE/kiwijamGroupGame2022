extends Node

var maze:Array = []

const N = 1
const E = 2
const S = 4
const W = 8

const MAZE_SIZE:int = 16

var seedProgress:int = 999999
var sharedSeed:int = 123456789

var cellWalls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

func seedRand(lower, upper):
	if upper - lower == 0: return 0;
	seedProgress += 1 
	while seedProgress > 1000000:
		seedProgress -= 1000000
	var newSeed:String = str(pow(sharedSeed, 2) + seedProgress)
	while len(newSeed) < 11: newSeed = "0" + newSeed + "0"
	if len(newSeed) % 2 == 1:
		var center:int = int(float(len(newSeed)) / 2.0) + 1
		newSeed = newSeed[center-4] + newSeed[center-3] + newSeed[center-2] + newSeed[center-1] + newSeed[center+1] + newSeed[center+2] + newSeed[center+3] + newSeed[center+4]
	else:
		var center:int = len(newSeed) / 2
		newSeed = newSeed[center-4] + newSeed[center-3] + newSeed[center-2] + newSeed[center-1] + newSeed[center+2] + newSeed[center+3] + newSeed[center+4] + newSeed[center+5]
	sharedSeed = int(newSeed)
	return (sharedSeed % (upper - lower)) + lower

func checkNeighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cellWalls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func makeMaze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	maze.clear()
	for y in range(MAZE_SIZE):
		maze.append([])
		for x in range(MAZE_SIZE):
			unvisited.append(Vector2(x, y))
			maze[y].append(N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = checkNeighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[seedRand(0, len(neighbors))]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var currentWalls = maze[current.y][current.x] - cellWalls[dir]
			var nextWalls = maze[next.y][next.x]  - cellWalls[-dir]
			maze[current.y][current.x] = currentWalls
			maze[next.y][next.x] = nextWalls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()

func changeMaze(changedMaze:Array = maze.duplicate(true)):
	var targetCell:Vector2 = Vector2(seedRand(0, MAZE_SIZE - 2), seedRand(0, MAZE_SIZE - 2))
	var changeDirection = seedRand(0, 3)
	if changeDirection == 0 and targetCell.y == 0:
		changeMaze(changedMaze)
		return changedMaze
	elif changeDirection == 1 and targetCell.x == MAZE_SIZE - 1:
		changeMaze(changedMaze)
		return changedMaze
	elif changeDirection == 2 and targetCell.y == MAZE_SIZE - 1:
		changeMaze(changedMaze)
		return changedMaze
	elif changeDirection == 3 and targetCell.y == 0:
		changeMaze(changedMaze)
		return changedMaze
	var neighbouringCell:Vector2 = targetCell + [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)][changeDirection]
	var targetDirec:int = [1, 2, 4, 8][changeDirection]
	var neighbouringDirec:int = [4, 8, 1, 2][changeDirection]
	if checkIfWall(changedMaze[targetCell.y][targetCell.x], targetDirec):
		if changedMaze[targetCell.y][targetCell.x] in [1, 2, 4, 8]:
			changeMaze(changedMaze)
			return changedMaze
		changedMaze[targetCell.y][targetCell.x] -= targetDirec
		changedMaze[neighbouringCell.y][neighbouringCell.x] -= neighbouringDirec
	else:
		changedMaze[targetCell.y][targetCell.x] += targetDirec
		changedMaze[neighbouringCell.y][neighbouringCell.x] += neighbouringDirec
	if !confirmSolvability(changedMaze, targetCell) or !confirmSolvability(changedMaze, neighbouringCell):
		changeMaze(changedMaze)
		return changedMaze
	return changedMaze

func confirmSolvability(newMaze:Array, startingPos:Vector2):
	var goal:Vector2 = Vector2(MAZE_SIZE - 1, MAZE_SIZE - 1)
	var visitedCells:Array = [startingPos]
	var cellQueue:Array = [startingPos]
	while len(cellQueue) > 0:
		var currentCell:Vector2 = cellQueue.pop_front()
		if currentCell.x > 0:
			if !(checkIfWall(newMaze[currentCell.y][currentCell.x], W) or currentCell - Vector2(1, 0) in visitedCells):
				cellQueue.append(currentCell - Vector2(1, 0))
		if currentCell.x < MAZE_SIZE - 1:
			if !(checkIfWall(newMaze[currentCell.y][currentCell.x], E) or currentCell + Vector2(1, 0) in visitedCells):
				cellQueue.append(currentCell + Vector2(1, 0))
		if currentCell.y > 0:
			if !(checkIfWall(newMaze[currentCell.y][currentCell.x], N) or currentCell - Vector2(0, 1) in visitedCells):
				cellQueue.append(currentCell - Vector2(0, 1))
		if currentCell.y < MAZE_SIZE - 1:
			if !(checkIfWall(newMaze[currentCell.y][currentCell.x], S) or currentCell + Vector2(0, 1) in visitedCells):
				cellQueue.append(currentCell + Vector2(0, 1))
		visitedCells.append(currentCell)
		if currentCell == goal: return true;
	return false

func checkIfWall(walls, direction):
	if walls >= W:
		walls -= W
		if direction == W:
			return true
	if walls >= S:
		walls -= S
		if direction == S:
			return true
	if walls >= E:
		walls -= E
		if direction == E:
			return true
	if walls >= N:
		walls -= N
		if direction == N:
			return true
	return false
