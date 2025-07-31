extends InteractionEffect

@onready var som: AudioStreamPlayer2D = $som

signal distraction(position: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func activate():
	print("Ativado distração")
	emit_signal("distraction", global_position)
