extends Node2D

@onready var you_shall_not_pass: AudioStreamPlayer2D = $you_shall_not_pass
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var evil_laugh: AudioStreamPlayer2D = $evil_laugh
const SUPER_FIREBALL = preload("res://scenes/interactions/super_fireball.tscn")
const FIREBALL = preload("res://scenes/interactions/fireball.tscn")
@onready var hit_sound: AudioStreamPlayer2D = $hit_sound

@export var left_pos_marker : Marker2D;
@export var right_pos_marker : Marker2D;

var middle_pos;
var left_pos;
var right_pos;
var current_position = 'middle'

const super_cooldown = 17.0
var super_cooldown_timer = 17.0

const teleport_cooldown = 10.0
var teleport_cooldown_timer = 10.0

var life = 3;

var player_index := 0
var camera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("Mage")
	middle_pos = global_position
	left_pos = left_pos_marker.global_position
	right_pos = right_pos_marker.global_position
	you_shall_not_pass.pitch_scale = 0.9
	you_shall_not_pass.play()
	camera = get_viewport().get_camera_2d()

func kill():
	if life == 1:
		pass
	else:
		life -= 1
		hit_sound.stop()
		hit_sound.pitch_scale = 0.9
		hit_sound.play()
		animated_sprite_2d.play("dying")
		await get_tree().create_timer(1.0).timeout
		super_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if animated_sprite_2d.animation == 'normal':
		teleport_cooldown_timer -= delta
		if teleport_cooldown_timer < 0:
			initiate_teleport()

func initiate_teleport():
	animated_sprite_2d.play("teleport")

func _on_you_shall_not_pass_finished() -> void:
	super_attack()

func super_attack():
	evil_laugh.stop()
	animated_sprite_2d.play("super")
	evil_laugh.pitch_scale = 0.9
	evil_laugh.play()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == 'normal' and animated_sprite_2d.frame == 1:
		var players = get_tree().get_nodes_in_group("Playable")
		if players.size() == 0:
			return
		# Encontrar jogador mais próximo
		var closest_player = null
		var closest_distance = INF
		for player in players:
			var distance = global_position.distance_squared_to(player.global_position)
			if player.dead == false:
				if distance < closest_distance:
					closest_distance = distance
					closest_player = player
		if closest_player == null:
			return
		var fireball = FIREBALL.instantiate()
		fireball.global_position = global_position
		var direction = (closest_player.global_position - global_position).normalized()
		fireball.rotation = -direction.angle_to(Vector2.DOWN)
		get_parent().add_child(fireball)
	elif animated_sprite_2d.animation == 'teleport' and animated_sprite_2d.frame == 6:
		teleport()
	elif animated_sprite_2d.animation == 'super' and animated_sprite_2d.frame == 14:
		if camera:
			camera_shake(4, 1)
		var super_fireball = SUPER_FIREBALL.instantiate()
		super_fireball.global_position = global_position
		get_parent().add_child(super_fireball)

func teleport():
	match current_position:
		'middle':
			current_position = 'left'
			global_position = left_pos
		'left':
			current_position = 'right'
			global_position = right_pos
		'right':
			current_position = 'middle'
			global_position = middle_pos

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == 'super':
		await get_tree().create_timer(1.0).timeout
		super_cooldown_timer = super_cooldown
		animated_sprite_2d.play("normal")
	if animated_sprite_2d.animation == 'teleport':
		animated_sprite_2d.play("normal")
		teleport_cooldown_timer = teleport_cooldown
		
func camera_shake(duration := 0.5, strength := 8.0) -> void:
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
