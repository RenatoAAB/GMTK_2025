extends CanvasLayer

@onready var tutorial: CanvasLayer = $"."
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TutorialManager.call_tutorial.connect(_on_tutorial_called)
	if not TutorialManager.mostrou_tutorial['controles']:
		TutorialManager.tutorial_needed('controles')

func _on_tutorial_called(text):
	get_tree().paused = true
	label.text = text
	tutorial.visible = true

func _on_botao_continue_pressed() -> void:
	get_tree().paused = false
	tutorial.visible = false
