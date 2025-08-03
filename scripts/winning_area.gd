extends Area2D

var characters_escaped = 0
@onready var win_menu: CanvasLayer = $"../WinMenu"
@export var is_tutorial := false
@export var is_tutorial_2 := false
@onready var tutorial_texts: CanvasLayer = $"../Tutorial texts"

#var level_1_scene := preload("res://scenes/levels/ThePrison.tscn")
@export var firemage : Node;

func _on_body_entered(character: Node2D) -> void:

	if character.is_in_group("Playable"):
		if not character.dead:
			if is_tutorial:
				tutorial_texts.nextText(character.id)
			if is_tutorial_2:
				tutorial_texts.show_extra()
			print(character.id + ": Saved himself")
			update_characters_escaped()
			character.queue_free()


func update_characters_escaped():
	if not TutorialManager.mostrou_tutorial['escapou']:
		TutorialManager.tutorial_needed('escapou')
	characters_escaped += 1
	if (characters_escaped == 2):
		call_winning_screen()
		
func call_winning_screen():
	if is_tutorial:
		tutorial_texts.visible = false
	print("You won !!")
	if firemage:
		firemage.kill()
	else:
		LevelManager.level_won()
		win_menu.visible = true;
		print("You won !!")
