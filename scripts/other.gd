extends CharacterBody2D

var playback_inputs := []
var playback_index := 0
var playback_timer := 0.0
var playback_done := false
@export var SPEED := 300.0
@export var ACCEL := 10.0

func playback(inputs):
	playback_inputs = inputs
	playback_index = 0
	playback_timer = 0.0
	playback_done = false

func _process(delta):
	if playback_done or playback_inputs.is_empty():
		return

	playback_timer += delta
	
	# Replay inputs up to current time
	while playback_index < playback_inputs.size() and playback_inputs[playback_index]["time"] <= playback_timer:
		var input = playback_inputs[playback_index]["input"]
		move_ghost(input, delta)
		playback_index += 1
	
	if playback_index >= playback_inputs.size():
		playback_done = true
		print("✅ Ghost finished playback")

func move_ghost(input, delta):
	var direction := Vector2.ZERO
	if input["left"]: direction.x -= 1
	if input["right"]: direction.x += 1
	if input["up"]: direction.y -= 1
	if input["down"]: direction.y += 1
	direction = direction.normalized()
	
	velocity = lerp(velocity, direction * SPEED, delta * ACCEL)
	move_and_slide()
