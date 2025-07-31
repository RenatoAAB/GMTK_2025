extends CharacterBody2D

@export var SPEED := 300.0
@export var ACCEL := 10.0

func _ready():
	# Ensure this character is known to the LoopManager if needed
	pass

func _input(event):
	if event.is_action_pressed("interagir"):
		if not LoopManager.is_recording:
			LoopManager.start_recording(self)
		else:
			LoopManager.stop_recording()

func _physics_process(delta):
	var input_direction = Vector2.ZERO
	
	# Use ui_ actions here to match the recording setup
	if Input.is_action_pressed("right"):
		input_direction.x += 1
	if Input.is_action_pressed("left"):
		input_direction.x -= 1
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("up"):
		input_direction.y -= 1
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	velocity = lerp(velocity, input_direction * SPEED, delta * ACCEL)
	move_and_slide()
