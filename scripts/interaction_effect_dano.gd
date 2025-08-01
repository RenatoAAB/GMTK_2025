extends InteractionEffect

@onready var effect_area: Area2D = $EffectArea
@onready var interaction_effect_dano: Node2D = $"."
@onready var effect: AnimatedSprite2D = $EffectArea/effect
@onready var som: AudioStreamPlayer2D = $som

@export var key_frame : int;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func activate_highlight():
	effect.material.set_shader_parameter("show_outline", true)

func deactivate_highlight():
	effect.material.set_shader_parameter("show_outline", false)

func activate():
	deactivate_highlight()
	activate_sequence()
	
func activate_sequence():
	effect.play("fire_explosion")

func activate_area():
	print("Ativado dano")
	# Manually check for overlaps
	var affected_bodies = effect_area.get_overlapping_bodies()
	for body in affected_bodies:
		if body.is_in_group("Playable") or body.is_in_group("Enemies"):
			body.kill()

func deactivate_area():
	effect_area.monitoring = false
	effect_area.set_deferred("monitorable", false)

func _on_effect_frame_changed() -> void:
	if effect.frame == key_frame:
		activate_area()
		som.play()

func _on_effect_animation_finished() -> void:
	deactivate_area()
