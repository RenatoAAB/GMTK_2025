extends Node

@export var level_number : String
@export var level : PackedScene
@onready var number: Label = $BotaoBack/Number
@onready var cleared: Sprite2D = $Cleared

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number.text = level_number
	if level_number in LevelManager.levels_cleared:
		cleared.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_botao_level_pressed() -> void:
	LevelManager.load_level(level, level_number)
