extends Node2D
class_name InteractionEffect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate():
	print("Effect activated")
	for effect in get_children():
		if effect is InteractionEffect:
			effect.activate()
		
func activate_highlight():
	print("Highlight activated")
	for effect in get_children():
		if effect is InteractionEffect:
			effect.activate_highlight()
		
func deactivate_highlight():
	print("Highlight deactivated")
	for effect in get_children():
		if effect is InteractionEffect:
			effect.deactivate_highlight()
