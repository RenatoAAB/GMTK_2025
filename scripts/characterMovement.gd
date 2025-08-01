extends CharacterBody2D
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
const DYING_ANIMATION = preload("res://scenes/dying_animation.tscn")
@onready var som_morte: AudioStreamPlayer2D = $som_morte

@export var id : String
@export var SPEED := 30.0
@export var ACCEL := 10.0

@export var being_played = true
@export var dead = false
var dying = false


var possible_interaction = null

#Playback variables
var playback_inputs := []
var playback_index := 0
var playback_timer := 0.0
var playback_done := false

func _ready():
	player_sprite.play("idle_"+id)
	var should_change_character = LoopManager.get_should_change_characters()
	var last_played = LoopManager.get_last_played_character()
	add_to_group("Playable")
	if last_played != null:
		if should_change_character:
			being_played = not last_played == id
		else:
			being_played = last_played == id
	call_deferred("_start_recording")
	
func set_possible_interaction(interaction):
	possible_interaction = interaction

func kill():
	if not dead:
		print(id+": Killed")
		som_morte.pitch_scale = randf_range(0.8, 1.0)
		som_morte.play()
		player_sprite.visible = false
		var dying_animation = DYING_ANIMATION.instantiate()
		dying_animation.play("dying_"+id)
		dying_animation.animation_finished.connect(_on_dying_animation_animation_finished)
		get_tree().current_scene.add_child(dying_animation)
		dying_animation.global_position = global_position
		dying = true
		dead = true

func _start_recording():
	if (being_played):
		if not LoopManager.is_recording:
			LoopManager.start_recording(id)
	else:
		playback_inputs = LoopManager.get_input_recorded()
		print(id + ": Carregou inputs")

func _physics_process(delta):
	if dying:
		return
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
	
	if input["interact"] and possible_interaction != null:
		if dead == false:
			possible_interaction.activate()
		else:
			pass #play sound of fail
		
	velocity = lerp(velocity, direction * SPEED, delta * ACCEL)
	
	_control_animation(direction)
	
	move_and_slide()
	
func _control_animation(direction):
	if not dead:
		if direction.length() > 0:
			player_sprite.play("walking_"+id)
		else:
			player_sprite.play("idle_"+id)
	
	# flip sprite
	if velocity.x != 0:
		player_sprite.flip_h = velocity.x < 0


func _on_dying_animation_animation_finished() -> void:
	dying = false
	player_sprite.visible = true
	player_sprite.play("dead_"+id)
