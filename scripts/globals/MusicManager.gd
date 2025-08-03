extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

const musicas = {
	'T1': preload("res://sounds/songs/MenuMusic2.mp3"),
	'T2': preload("res://sounds/songs/song-tutorial.mp3"),
	'1': preload("res://sounds/songs/UnderTension.mp3"),
	'2': preload("res://sounds/songs/ConfusingDoors.mp3"),
	'3': preload("res://sounds/songs/song-tutorial.mp3"),
	'4': preload("res://sounds/songs/MenuMusic2.mp3"),
	'5': preload("res://sounds/songs/ConfusingDoors.mp3"),
	'6': preload("res://sounds/songs/UnderTension.mp3"),
	'7': preload("res://sounds/songs/song-tutorial.mp3"),
	'8': preload("res://sounds/songs/UnderTension.mp3"),
	'9': preload("res://sounds/songs/BossFight.mp3"),
}

const musica_menu = preload("res://sounds/songs/song-tutorial.mp3")
const musica_win = preload("res://sounds/music/vitoria.mp3")
const musica_half_win = preload("res://sounds/half-victory.mp3")

func _ready():
	start_music_menu()

func start_level_music(current_level):
	music_player.stop()
	music_player.stream = musicas[current_level]
	music_player.play()

func start_music_menu():
	music_player.stop()
	music_player.stream = musica_menu
	music_player.play()

func start_win_music():
	music_player.stop()
	music_player.stream = musica_win
	music_player.play()


func fade_out_music(duration: float = 1.5):
	if not music_player.playing:
		return
	
	var initial_volume = music_player.volume_db
	var time_passed := 0.0
	var target_volume := -80.0  # Minimum decibel before silence

	while time_passed < duration:
		await get_tree().process_frame
		time_passed += get_process_delta_time()
		var t := time_passed / duration
		music_player.volume_db = lerp(initial_volume, target_volume, t)
	
	music_player.stop()
	music_player.volume_db = initial_volume  # Reset volume for next song
