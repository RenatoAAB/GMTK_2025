extends Node2D

@export var interactionEffect : Node;

var already_activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func activate():
	if not already_activated:
		already_activated = true
		print("Activated")
		interactionEffect.activate()


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Playable"):
		body.set_possible_interaction(self)


func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Playable"):
		body.set_possible_interaction(null)
