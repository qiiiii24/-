extends Node3D
class_name CubeController

enum State{
	MOVE,
	STOP
}
# 需要通过player进行初始化，player1的方块就rotation.x随机角度，player2的方块就rotation.z随机角度
enum Player{
	Player1,
	Player2
}

const x_edge_left = 0
const x_edge_right = 10
const z_edge_left = 0
const z_edge_right = 10
const WIDTH = 10
const HEIGHT = 25

@onready var timer: Timer = $Timer
@onready var cube: Node3D = $Cube

@export var player : Player

var current_state = State.MOVE

var p1_moveable : bool :
	get:
		for i in cube.get_children():
			var x := roundi(i.global_position.x)
			var y := roundi(i.global_position.y)
			if  x < x_edge_left or x >= x_edge_right or y < 0 or Grid.check_grid_x(x, y):
				return false
		return true

var p2_moveable : bool :
	get:
		for i in cube.get_children():
			var z := roundi(i.global_position.z)
			var y := roundi(i.global_position.y)
			if  z < z_edge_left or z >= z_edge_right or y < 0 or Grid.check_grid_z(9-z, y):
				return false
		return true

func _ready() -> void:
	timer.timeout.connect(_move_down)

func _input(event: InputEvent) -> void:
	if not current_state == State.MOVE: return
	_p1_controller(event)
	_p2_controller(event)

func initalization() -> void:
	if player == Player.Player1:
		rotation.z = deg_to_rad(randi_range(0, 3) * 90)
	if player == Player.Player2:
		rotation.x = deg_to_rad(randi_range(0, 3) * 90)

func _p1_controller(event: InputEvent) -> void:
	if event.is_action_pressed("p1rotate"):
		_p1rotate()
	if event.is_action_pressed("p1move_left"):
		_p1move_left()
	if event.is_action_pressed("p1move_right"):
		_p1move_right()
	if event.is_action("p1move_down"):
		_move_down()

func _p2_controller(event: InputEvent) -> void:
	if event.is_action_pressed("p2rotate"):
		_p2rotate()
	if event.is_action_pressed("p2move_left"):
		_p2move_left()
	if event.is_action_pressed("p2move_right"):
		_p2move_right()
	if event.is_action("p2move_down"):
		_move_down()


# 只有mvoedown的时候 not moveable才能让timer.stop()
func _move_down() -> void:
	position.y -= 1
	if not p1_moveable or not p2_moveable:
		position.y += 1
		timer.stop()
		current_state = State.STOP
		Event.spawn_block.emit()
		land()
		Grid.checkFullRow()
		


func _p1move_left() -> void:
	position.x -= 1
	if not p1_moveable:
		position.x += 1

func _p1move_right() -> void:
	position.x += 1
	if not p1_moveable:
		position.x -= 1

func _p1rotate() -> void:
	rotation.z += deg_to_rad(-90)
	if not p1_moveable:
		rotation.z += deg_to_rad(90)


func _p2move_left() -> void:
	position.z += 1
	if not p2_moveable:
		position.z -= 1

func _p2move_right() -> void:
	position.z -= 1
	if not p2_moveable:
		position.z += 1

func _p2rotate() -> void:
	rotation.x += deg_to_rad(90)
	if not p2_moveable:
		rotation.x += deg_to_rad(-90)

func land() -> void:
	var x_array : Array[Vector2]
	var z_array : Array[Vector2]
	
	for i in cube.get_children():
		var x := roundi(i.global_position.x)
		var y := roundi(i.global_position.y)
		var z := roundi(i.global_position.z)
		var vec_x := Vector2(x, y)
		var vec_z := Vector2(z, y)
		if not vec_x in x_array:
			x_array.append(vec_x)
			
			var child = cube.get_child(0).duplicate()
			cube.add_child(child)
			child.global_position = Vector3(x, y, 10)
			Grid.add_grid_x(x, y, child)
		if not vec_z in z_array:
			z_array.append(vec_z)
			
			var child = cube.get_child(0).duplicate()
			cube.add_child(child)
			child.global_position = Vector3(-1, y, z)
			Grid.add_grid_z(9-z, y, child)
		i.queue_free()
		
		if(y == 19):
			Event.lose_game.emit()
			

func generate_block_x(child, x: int,y: int) -> void:
	var block = child
	cube.add_child(block)
	block.global_position = Vector3(x, y, 9)

func generater_block_z(child, z: int, y: int) -> void:
	var block = child
	cube.add_child(block)
	block.global_position = Vector3(0, y, z)
