extends Node

var is_recording := false
var recording_start_time := 0.0
var recorded_inputs := []  # Stores input data as { time: float, input: Dictionary }

# Keep reference to the current player and ghosts
var current_player: Node = null
var ghost_scene: PackedScene = preload("res://scenes/other.tscn")
var start_pos

func start_recording(player):
	start_pos = player.global_position
	is_recording = true
	recording_start_time = 0.0
	recorded_inputs.clear()
	current_player = player
	print("🎥 Recording started")

func stop_recording():
	is_recording = false
	print("🛑 Recording stopped")
	
	# Instantiate ghost and send it the recorded inputs
	var ghost = ghost_scene.instantiate()
	get_node("/root/Level/Ghost").add_child(ghost)
	ghost.global_position = start_pos
	ghost.playback(recorded_inputs)

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
	recorded_inputs.append({
		"time": recording_start_time,
		"input": input_data
	})

func _process(delta):
	if is_recording:
		record_input(delta)
