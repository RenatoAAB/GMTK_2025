extends InteractionEffect

@onready var sprite: AnimatedSprite2D = $sprite
const FIREBALL = preload("res://scenes/interactions/fireball.tscn")
@onready var som_cast: AudioStreamPlayer2D = $som_cast

func _ready():
	sprite.material = sprite.material.duplicate(true)

func activate() -> void:
	deactivate_highlight()
	sprite.play()

func activate_highlight():
	sprite.material.set_shader_parameter("show_outline", true)
	
func deactivate_highlight():
	sprite.material.set_shader_parameter("show_outline", false)


func _on_sprite_frame_changed() -> void:
	if sprite.frame == 3:
		som_cast.play()
		var fireball = FIREBALL.instantiate()
		add_child(fireball)
