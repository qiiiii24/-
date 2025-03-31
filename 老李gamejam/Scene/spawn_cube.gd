extends Node3D

@export var blocks : Array[PackedScene]
@export var switch : bool 
var current_blocks : Array[PackedScene] 

func _ready() -> void:
	Event.start_game.connect(spawn_block)
	
	Event.spawn_block.connect(spawn_block)
	current_blocks = blocks.duplicate()
	current_blocks.shuffle()
	if not switch : return
	spawn_block()

func spawn_block() -> void:
	if not switch : return
	if current_blocks.is_empty():
		current_blocks = blocks.duplicate()
		current_blocks.shuffle()
	
	var block = current_blocks[0]
	add_child(block.instantiate())
	current_blocks.erase(block)
