extends Area2D

var characters_escaped = 0
@onready var win_menu: CanvasLayer = $"../WinMenu"

func _on_body_entered(character: Node2D) -> void:
	if character.is_in_group("Playable"):
		if not character.dead:
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
	LevelManager.level_won()
	win_menu.visible = true;
	print("You won !!")
