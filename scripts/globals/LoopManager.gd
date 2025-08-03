extends Node

var is_recording := false
var recording_start_time := 0.0
var recording_inputs := []  # Stores input data as { time: float, input: Dictionary }
var recorded_inputs := []
# Keep reference to the current player and ghosts
var current_player = null
var should_change = false
var loop_enabled = true

signal player_set(id)

func enable_loop():
	loop_enabled = true
	
func disable_loop():
	loop_enabled = false

func get_should_change_characters():
	return should_change

func get_last_played_character():
	return current_player;

func get_input_recorded():
	return recorded_inputs.duplicate(true)

func reset_vars_for_level_start():
	current_player = null
	should_change = false
	recorded_inputs = []
	is_recording = false
	recording_start_time = 0.0
	recording_inputs = []

func start_recording(player):
	is_recording = true
	recording_start_time = 0.0
	recording_inputs.clear()
	current_player = player
	emit_signal("player_set", current_player)
	print("🎥 Recording started")

func stop_recording_and_change():
	is_recording = false
	recorded_inputs = recording_inputs.duplicate(true)
	should_change = true
	print("🛑 Recording stopped")

func stop_recording_but_keep_character():
	is_recording = false
	should_change = false
	print("🛑 Recording stopped")

func _input(event):
	if loop_enabled:
		if Input.is_action_pressed("play_first"):
			if (current_player == 'A'):
				stop_recording_but_keep_character()
			else:
				stop_recording_and_change()
			get_tree().reload_current_scene()
		if Input.is_action_just_pressed("play_second"):
			if (current_player == 'B'):
				stop_recording_but_keep_character()
			else:
				stop_recording_and_change()
			get_tree().reload_current_scene()

func record_input(delta):
	if not is_recording:
		return
	
	recording_start_time += delta
	var input_data = {
		"left": Input.is_action_pressed("left"),
		"right": Input.is_action_pressed("right"),
		"up": Input.is_action_pressed("up"),
		"down": Input.is_action_pressed("down"),
		"interact": Input.is_action_pressed("interagir")
	}
	recording_inputs.append({
		"time": recording_start_time,
		"input": input_data
	})

func _physics_process(delta):
	if is_recording:
		record_input(delta)
