extends InteractionEffect

@onready var effect_area: Area2D = $EffectArea
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var is_open : bool;



func activate_highlight():
	sprite.material.set_shader_parameter("show_outline", true)
#
func deactivate_highlight():
	sprite.material.set_shader_parameter("show_outline", false)

func activate():
	deactivate_highlight()
	if is_open:
		close()
	else:
		open()
	

func open():
	print("abre a porta")
	is_open = true
	collision_shape.disabled = true
	sprite.frame = 1
	
func close():
	is_open = false
	print("fecha a porta")
	collision_shape.disabled = false
	sprite.frame = 0
	
