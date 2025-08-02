extends Node2D

@onready var you_shall_not_pass: AudioStreamPlayer2D = $you_shall_not_pass
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var evil_laugh: AudioStreamPlayer2D = $evil_laugh
const SUPER_FIREBALL = preload("res://scenes/interactions/super_fireball.tscn")
const FIREBALL = preload("res://scenes/interactions/fireball.tscn")

const super_cooldown = 10.0
var super_cooldown_timer = 10.0

var player_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	you_shall_not_pass.pitch_scale = 0.9
	you_shall_not_pass.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if animated_sprite_2d.animation == 'normal':
		super_cooldown_timer -= delta
		if super_cooldown_timer < 0:
			super_attack()

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
		var target = players[player_index % players.size()]
		player_index += 1
		var fireball = FIREBALL.instantiate()
		fireball.global_position = global_position
		var direction = (target.global_position - global_position).normalized()
		fireball.rotation = - direction.angle_to(Vector2.DOWN)
		get_parent().add_child(fireball)

	elif animated_sprite_2d.frame == 14:
		var super_fireball = SUPER_FIREBALL.instantiate()
		add_child(super_fireball)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == 'super':
		await get_tree().create_timer(1.0).timeout
		super_cooldown_timer = super_cooldown
		animated_sprite_2d.play("normal")
