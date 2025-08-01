extends Node

@export var level_number : String
@export var level : PackedScene
@export var level_name : String
@onready var number: Label = $BotaoBack/Number
@onready var cleared: Sprite2D = $Cleared
@onready var animation_player: AnimationPlayer = $"../TitleScreen/AnimationPlayer"
@onready var level_name_label: Label = $"../TitleScreen/LevelName"
@onready var levelname_front: Label = $"../TitleScreen/LevelName/LevelnameFront"
@onready var title_screen: CanvasLayer = $"../TitleScreen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number.text = level_number
	if level_number in LevelManager.levels_cleared:
		cleared.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_botao_level_pressed() -> void:
	animation_player.play("transition_to_title")
	title_screen.visible = true
	level_name_label.text = level_name
	levelname_front.text = level_name
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	level_name_label.visible = true;
	await get_tree().create_timer(1.0).timeout
	LevelManager.load_level(level, level_number)
