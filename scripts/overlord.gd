extends Node

var maze:Array = []

const N = 1
const E = 2
const S = 4
const W = 8

const MAZE_SIZE:int = 16

var cellWalls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

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
			var next = neighbors[randi() % neighbors.size()]
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
	for y in range(MAZE_SIZE):
		var row = ""
		for x in range(MAZE_SIZE):
			row += str(maze[y][x])
			if len(str(maze[y][x])) == 1:
				row += " "
			row += " "
		print(row)
