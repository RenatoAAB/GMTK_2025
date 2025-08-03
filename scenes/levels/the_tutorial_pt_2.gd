extends Node2D
@onready var ninja_a: CharacterBody2D = $NinjaA
@onready var ninja_b: CharacterBody2D = $NinjaB
@onready var tutorial_texts: CanvasLayer = $"Tutorial texts"



func _ready():
	ninja_a.player_died.connect(_on_player1_died)
	ninja_b.player_died.connect(_on_player2_died)

func _on_player1_died():
	tutorial_texts.nextText()
	
func _on_player2_died():
	tutorial_texts.nextText()



		
