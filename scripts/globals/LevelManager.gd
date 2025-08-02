extends Node

var levels_cleared = []
var level_being_played = ''

func load_level(level_scene, level_number):
	LoopManager.reset_vars_for_level_start()
	level_being_played = level_number
	get_tree().change_scene_to_packed(level_scene)

	
func level_won():
	levels_cleared.append(level_being_played)
	
