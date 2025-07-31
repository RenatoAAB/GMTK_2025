extends CanvasLayer

@onready var botao_back_to_menu: Button = $VBoxContainer/Botao3/BotaoBack/BackToMenu/BotaoBackToMenu
@onready var botao_resume: Button = $VBoxContainer/Botao2/BotaoBack/ResumeText/BotaoResume

@onready var pause_menu: CanvasLayer = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false


func _on_botao_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
