extends Area2D

var characters_escaped = 0
@onready var win_menu: CanvasLayer = $"../WinMenu"
@onready var vitory_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var is_tutorial := false
@onready var tutorial_texts: CanvasLayer = $"../Tutorial texts"

#var level_1_scene := preload("res://scenes/levels/ThePrison.tscn")

func _on_body_entered(character: Node2D) -> void:

	if character.is_in_group("Playable"):
		if not character.dead:
			if is_tutorial:
				tutorial_texts.nextText()
				print("WE are here")
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
	tutorial_texts.visible = false
	vitory_sound.play()
	LevelManager.level_won()
	win_menu.visible = true;
	print("You won !!")
