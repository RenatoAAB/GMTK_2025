extends InteractionEffect

@onready var effect_area: Area2D = $EffectArea
@onready var interaction_effect_dano: Node2D = $"."
@onready var effect: AnimatedSprite2D = $EffectArea/effect
@onready var som: AudioStreamPlayer2D = $som

@export var key_frame : int;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_effect_dano.visible = false

func activate():
	interaction_effect_dano.visible = true
	activate_sequence()
	
func activate_sequence():
	effect.play("fire_explosion")

func activate_area():
	print("Ativado dano")
	effect_area.monitoring = true
	effect_area.set_deferred("monitorable", true)
	# Wait a frame to allow physics update
	await get_tree().process_frame
	# Manually check for overlaps
	for body in effect_area.get_overlapping_bodies():
		print("killed someone")

func deactivate_area():
	effect_area.monitoring = false
	effect_area.set_deferred("monitorable", false)

func _on_effect_frame_changed() -> void:
	if effect.frame == key_frame:
		activate_area()
		som.play()

func _on_effect_animation_finished() -> void:
	deactivate_area()
