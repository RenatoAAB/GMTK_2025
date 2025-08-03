extends CanvasLayer
@export var texts1 : Array[Label];
@export var texts2 : Array[Label];
@export var texts3 : Array[Label];
var current_text = 1
@onready var ninja_a: CharacterBody2D = $"../NinjaA"
@onready var ninja_b: CharacterBody2D = $"../NinjaB"

func nextText():
	print("executou nextText")

	if current_text == 1 and ( not ninja_a.dead and not ninja_b.dead ):
		for text in texts2:
			text.visible = false
		for text in texts1:
			text.visible = false	
		for text in texts3:
			text.visible = true
		current_text += 1
	elif current_text == 1:
		for text in texts1:
			text.visible = false	
		for text in texts3:
			text.visible = false	
		for text in texts2:
			text.visible = true
		current_text += 1
	elif current_text == 2:
		for text in texts2:
			text.visible = false	
		for text in texts3:
			text.visible = true
		for text in texts1:
			text.visible = false	
		current_text += 1

func _ready() -> void:
	for text in texts1:
		text.visible = true
		
	for text in texts2:
		text.visible = false
		
	for text in texts3:
		text.visible = false
