extends InteractionEffect

@onready var firewall_left: Node2D = $"."
@onready var fire_sound: AudioStreamPlayer2D = $fire_sound
@onready var som_cast: AudioStreamPlayer2D = $som_cast

func emerge():
	firewall_left.visible = true
	fire_sound.play()
	som_cast.pitch_scale = 0.8
	som_cast.play()

func activate():
	queue_free()
	
func activate_highlight():
	pass

func deactivate_highlight():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Playable"):
		body.kill()
