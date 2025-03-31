extends Node

const WIDTH = 10
const DEPTH = 10
const HEIGHT = 22

var grid_x : Array 
var grid_z : Array 

func _reset_grid() -> void:
	grid_x.clear()
	grid_z.clear()
	_setup_grid_x()
	_setup_grid_z()

func _ready() -> void:
	_setup_grid_x()
	_setup_grid_z()
	Event.reset_game.connect(_reset_grid)

func _setup_grid_x() -> void:
	for x in range(WIDTH):
			var width : Array = []
			for y in range(HEIGHT + 1):
				width.append(null)
			grid_x.append(width)

func _setup_grid_z() -> void:
	for x in range(DEPTH):
			var depth : Array = []
			for y in range(HEIGHT + 1):
				depth.append(null)
			grid_z.append(depth) 

func add_grid_x(x: int, y: int, child: Node3D) -> void:
	if grid_x[x][y] is Block: return
	grid_x[x][y] = child

func add_grid_z(z: int, y: int, child: Node3D) -> void:
	if grid_z[z][y] is Block: return
	grid_z[z][y] = child

# 不等于null返回true，等于null返回false
func check_grid_x(x: int, y: int) -> bool:
	return grid_x[x][y] is Block

func check_grid_z(z: int, y: int) -> bool:
	return grid_z[z][y] is Block

#检查一行是否满
func isRowFull(y: int, grid) -> bool:
	for x in WIDTH:
		if not grid[x][y] is Block:
			return false
			break
	return true

# 清除一行
func destroyRow(y: int, grid) -> void:
	var score : int = 0
	for i in WIDTH:
		if grid[i][y] is Block:
			grid[i][y].queue_free()
			grid[i][y] = null
			score += 1
	Event.add_socre.emit(score)
	Event.particle_emit.emit()

# 检查每一行，从上到下
func checkFullRow() -> void:
	for y in HEIGHT:
		if isRowFull(y, grid_x) or isRowFull(y, grid_z):  
			## 还是会出现下降两次
			# 添加音效
			destroyRow(y, grid_x)
			destroyRow(y, grid_z)
			
			decreaceRow_x(y)
			decreaceRow_z(y)

# 清除一行后，将上面的往下移动一行
func decreaceRow_x(row: int) -> void:
	for y in range(row, HEIGHT):
		for x in WIDTH:
			if grid_x[x][y + 1] is Block: #可能是y - 1
				grid_x[x][y] = grid_x[x][y + 1]
				grid_x[x][y + 1] = null
				grid_x[x][y].global_position.y -= 1
	
				

func decreaceRow_z(row: int) -> void:
	for y in range(row, HEIGHT):
		for x in DEPTH:
			if grid_z[x][y + 1] is Block: #可能是y - 1
				grid_z[x][y] = grid_z[x][y + 1]
				grid_z[x][y + 1] = null
				grid_z[x][y].global_position.y -= 1
				
