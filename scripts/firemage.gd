extends Node2D

@onready var you_shall_not_pass: AudioStreamPlayer2D = $you_shall_not_pass
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var evil_laugh: AudioStreamPlayer2D = $evil_laugh
@onready var hit_sound: AudioStreamPlayer2D = $hit_sound
@onready var win_menu_final: CanvasLayer = $"../WinMenuFinal"

@export var left_pos_marker : Marker2D
@export var right_pos_marker : Marker2D

@export var firewall_left : Node
@export var firewall_right : Node

const SUPER_FIREBALL = preload("res://scenes/interactions/super_fireball.tscn")
const FIREBALL = preload("res://scenes/interactions/fireball.tscn")

var middle_pos
var left_pos
var right_pos
var current_position = "middle"
var current_phase := 1
var current_player_turn := "A"
var is_attacking := false
var camera
var fireball_count

func _ready() -> void:
	self.add_to_group("Mage")
	middle_pos = global_position
	left_pos = left_pos_marker.global_position
	right_pos = right_pos_marker.global_position
	you_shall_not_pass.pitch_scale = 0.9
	you_shall_not_pass.play()
	camera = get_viewport().get_camera_2d()

func _physics_process(delta: float) -> void:
	pass # Optional future logic

func kill():
	# Stop any sounds / animations
	hit_sound.stop()
	hit_sound.pitch_scale = 0.9
	hit_sound.play()

	animated_sprite_2d.speed_scale = 1.0
	animated_sprite_2d.play("dying")
	is_attacking = false

	# Remove all fireballs
	for fireball in get_tree().get_nodes_in_group("Fireballs"):
		if is_instance_valid(fireball):
			fireball.queue_free()
	# Zoom the camera in on this mage
	await get_tree().create_timer(1.0).timeout
	var camera = get_viewport().get_camera_2d()
	camera.make_current()

	# Move the camera smoothly to the mage's position and zoom in
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "global_position", Vector2(global_position.x, global_position.y + 25), 1.0)
	tween.tween_property(camera, "zoom", Vector2(8, 8), 1.0)
	await get_tree().create_timer(2.0).timeout
	LevelManager.level_won()
	win_menu_final.visible = true;
	#await get_tree().create_timer(2.0).timeout

func initiate_teleport():
	animated_sprite_2d.play("teleport")

func _on_you_shall_not_pass_finished() -> void:
	firewall_left.emerge()
	firewall_right.emerge()
	next_attack_phase()

func next_attack_phase():
	if current_phase > 3:
		return # Boss fight complete
	
	match [current_phase, current_player_turn]:
		[1, "A"]:
			fireball_count = 0
			start_phase_1_attack("A")
		[1, "B"]:
			fireball_count = 0
			start_phase_1_attack("B")
		[2, "A"]:
			start_phase_2_attack("A")
		[2, "B"]:
			start_phase_2_attack("B")
		[3, "A"]:
			start_phase_3_attack("A")

func advance_phase():
	if current_player_turn == "A":
		current_player_turn = "B"
	else:
		current_player_turn = "A"
		current_phase += 1
	next_attack_phase()

func start_phase_1_attack(player_id: String):
	is_attacking = true
	initiate_teleport()

func start_phase_2_attack(player_id: String):
	is_attacking = true
	initiate_teleport()

func start_phase_3_attack(player_id: String):
	is_attacking = true
	initiate_teleport()
		# DEBUG: Kill the boss 5 seconds after phase 3 starts
	#await get_tree().create_timer(8.0).timeout
	#kill()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "normal":
		if animated_sprite_2d.frame == 1 and current_phase == 3:
			attack_alternating_players()
		if animated_sprite_2d.frame == 1 and current_phase == 1:
			attack_current_player()
		if animated_sprite_2d.frame == 2 and is_attacking and fireball_count == 5:
			is_attacking = false
			advance_phase()
	elif animated_sprite_2d.animation == "teleport" and animated_sprite_2d.frame == 6:
		teleport()
	elif animated_sprite_2d.animation == "super" and animated_sprite_2d.frame == 14:
		if camera:
			camera_shake(2, 1)
		var super_fireball = SUPER_FIREBALL.instantiate()
		super_fireball.global_position = global_position
		get_parent().add_child(super_fireball)
		await get_tree().create_timer(3.0).timeout
		advance_phase()

func attack_current_player():
	var player = get_player_by_id(current_player_turn)
	if not player:
		return
	var fireball = FIREBALL.instantiate()
	fireball.global_position = global_position
	var direction = (player.global_position - global_position).normalized()
	fireball.rotation = -direction.angle_to(Vector2.DOWN)
	get_parent().add_child(fireball)
	fireball_count += 1

var alternate_flag := true  # Tracks which player to attack next

func attack_alternating_players():
	var target_id
	if alternate_flag:
		target_id = "A"
	else:
		target_id = "B"
	
	var fallback_id
	if alternate_flag: 
		fallback_id = "B" 
	else: 
		fallback_id = "A"

	var player = get_player_by_id(target_id)
	if not player:
		player = get_player_by_id(fallback_id)
		if not player:
			# No players to attack
			return
	
	var fireball = FIREBALL.instantiate()
	fireball.global_position = global_position
	var direction = (player.global_position - global_position).normalized()
	fireball.rotation = -direction.angle_to(Vector2.DOWN)
	get_parent().add_child(fireball)
	fireball.add_to_group("Fireballs")
	alternate_flag = !alternate_flag  # Toggle for next attack


func get_player_by_id(id: String):
	var players = get_tree().get_nodes_in_group("Playable")
	for player in players:
		if player.id == id:
			return player
	return null

func teleport():
	if current_phase == 3:
		current_position = "middle"
		global_position = middle_pos
	else:
		match current_position:
			"middle":
				current_position = "left"
				global_position = left_pos
			"left":
				current_position = "right"
				global_position = right_pos
			"right":
				current_position = "left"
				global_position = left_pos

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "teleport" and current_phase == 2:
		super_attack()
	if animated_sprite_2d.animation == "teleport" and current_phase == 3:
		await get_tree().create_timer(2.0).timeout
		animated_sprite_2d.speed_scale = 4.0
		animated_sprite_2d.play("normal")
	if animated_sprite_2d.animation == "teleport" and current_phase == 1:
		if (current_player_turn == "B"):
			await get_tree().create_timer(1.0).timeout
		animated_sprite_2d.play("normal")

func super_attack():
	evil_laugh.stop()
	animated_sprite_2d.play("super")
	evil_laugh.pitch_scale = 0.9
	evil_laugh.play()

func camera_shake(duration := 0.5, strength := 8.0) -> void:
	LoopManager.disable_loop()
	await get_tree().process_frame
	var original_offset = camera.offset
	var elapsed = 0.0
	while elapsed < duration:
		var shake = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * strength
		camera.offset = original_offset + shake
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	camera.offset = original_offset
	LoopManager.enable_loop()
