extends Control

@onready var level_selection: CanvasLayer = $LevelSelection
@onready var background: TextureRect = $background
@onready var tower: TextureRect = $tower
@onready var clouds_tower: TextureRect = $"clouds-tower"
@onready var people: TextureRect = $people
@onready var fog_2: TextureRect = $fog2
@onready var fog_1: TextureRect = $fog1
@onready var historinha: CanvasLayer = $Historinha

var move_distance := 50.0  # pixels
var move_distance_y := 15.0 # pixels
var loop_duration := 15.0  # seconds
var time_passed := 0.0

var fog_1_start_position := Vector2.ZERO
var fog_2_start_position := Vector2.ZERO
#var people_start_position := Vector2.ZERO
var clouds_tower_start_position := Vector2.ZERO
#var tower_start_position := Vector2.ZERO
var background_start_position := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fog_1_start_position = fog_1.global_position  # or position if using local space
	fog_2_start_position = fog_2.global_position
	#people_start_position = people.global_position
	clouds_tower_start_position = clouds_tower.global_position
	#tower_start_position = tower.global_position
	background_start_position = background.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta

	# Calculate progress in loop (0 to 1 and back)
	var t: float = sin((time_passed / loop_duration) * PI * 2.0) * 0.5 + 0.5
	fog_1.global_position.x = fog_1_start_position.x + move_distance * (t - 0.5) * 2.0
	fog_2.global_position.x = fog_2_start_position.x - move_distance * (t - 0.5) * 2.0
	#people.global_position.y = people_start_position.y + move_distance_y * (t - 0.5) * 2.0
	clouds_tower.global_position.x = clouds_tower_start_position.x - move_distance * (t - 0.5) * 2.0
	#tower.global_position.y = tower_start_position.y - move_distance_y * (t - 0.5) * 2.0
	background.global_position.x = background_start_position.x + move_distance * (t - 0.5) * 2.0


func _on_botao_play_pressed() -> void:
	print("Apertei o botao")
	historinha.roda_historinha()
	
	
