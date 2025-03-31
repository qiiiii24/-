extends Node3D

@onready var score: Label = %Score
@onready var start: Button = $UI/Start
@onready var spawn_cube: Node3D = $SpawnCube
@onready var label: Label = $UI/Label
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var reset: Button = $UI/Gameover/Reset
@onready var gameover: Control = $UI/Gameover

var current_score : int = 0

func _ready() -> void:
	Event.add_socre.connect(add_score)
	start.pressed.connect(_start_game)
	Event.particle_emit.connect(_particle1_emit)
	Event.particle_emit.connect(_particle2_emit)
	Event.lose_game.connect(_game_over)
	reset.pressed.connect(_reset_button)
	
	

func add_score(amount) -> void:
	current_score += amount
	score.text = "分数：" + str(current_score)

func _start_game() -> void:
	spawn_cube.switch = true
	Event.start_game.emit()
	start.visible = false
	label.visible = false

func _particle1_emit() -> void:
	gpu_particles_2d.emitting = true

func _particle2_emit() -> void:
	gpu_particles_2d_2.emitting = true

func _game_over() -> void:
	gameover.visible = true
	spawn_cube.switch = false

func _reset_button() -> void:
	get_tree().reload_current_scene()
	Event.reset_game.emit()
	
