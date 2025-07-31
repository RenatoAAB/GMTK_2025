extends CharacterBody2D
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var id : String
@export var SPEED := 30.0
@export var ACCEL := 10.0

@export var being_played = true

#Playback variables
var playback_inputs := []
var playback_index := 0
var playback_timer := 0.0
var playback_done := false

func _ready():
	var should_change_character = LoopManager.get_should_change_characters()
	var last_played = LoopManager.get_last_played_character()
	if last_played != null:
		if should_change_character:
			being_played = not last_played == id
		else:
			being_played = last_played == id
	call_deferred("_start_recording")

func _start_recording():
	if (being_played):
		if not LoopManager.is_recording:
			LoopManager.start_recording(id)
	else:
		playback_inputs = LoopManager.get_input_recorded()
		print(id + ": Carregou inputs")

func _physics_process(delta):
	var input_data
	if (being_played):
		input_data = {
			"left": Input.is_action_pressed("left"),
			"right": Input.is_action_pressed("right"),
			"up": Input.is_action_pressed("up"),
			"down": Input.is_action_pressed("down"),
			"interact": Input.is_action_pressed("interagir")
		}
		_move(input_data, delta)
	else:
		if playback_done or playback_inputs.is_empty():
			return
		playback_timer += delta
		# Replay inputs up to current time
		while playback_index < playback_inputs.size() and playback_inputs[playback_index]["time"] <= playback_timer:
			input_data = playback_inputs[playback_index]["input"]
			_move(input_data, delta)
			playback_index += 1
		if playback_index >= playback_inputs.size():
			playback_done = true
			print("✅ Ghost finished playback")
			
func _move(input, delta):
	var direction := Vector2.ZERO
	if input["left"]: direction.x -= 1
	if input["right"]: direction.x += 1
	if input["up"]: direction.y -= 1
	if input["down"]: direction.y += 1
	direction = direction.normalized()
	
	velocity = lerp(velocity, direction * SPEED, delta * ACCEL)
	
	_control_animation(direction)
	
	move_and_slide()
	
func _control_animation(direction):
	if direction.length() > 0:
		player_sprite.play("walking")
	else:
		player_sprite.play("idle")
	
	# flip sprite
	if velocity.x != 0:
		player_sprite.flip_h = velocity.x < 0
