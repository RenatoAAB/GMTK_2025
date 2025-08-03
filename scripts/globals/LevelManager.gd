extends Node

var levels_cleared = []
var level_being_played = ''

func load_level(level_scene, level_number):
	LoopManager.reset_vars_for_level_start()
	MusicManager.start_level_music(level_number)
	level_being_played = level_number
	get_tree().change_scene_to_packed(level_scene)
	
	
func level_won():
	MusicManager.start_win_music()
	levels_cleared.append(level_being_played)
	
func change_to_level_selection():
	MusicManager.start_music_menu()
	get_tree().change_scene_to_file("res://scenes/ui/level_selection.tscn")
	
