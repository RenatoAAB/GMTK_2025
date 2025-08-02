extends Node


var textos_explicativos = {
	'controles' : 'You can move with WASD or Arrow Keys. Get through the shining door and escape!',
	'morte': 'Guards will try to kill if they see you. 
		Ghosts can not win but can still move. Restart by pressing 1 (blue) or 2 (red)! The other character remembers...',
	'escapou': 'To win you must escape with both characters! Press 1 to play as your partner. The first character will move just as you did'
}

var mostrou_tutorial = {
	'controles' : false,
	'morte': false,
	'escapou': false
}


signal call_tutorial(text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func tutorial_needed(primeira_vez: String):
	mostrou_tutorial[primeira_vez] = true
	var explicacao = textos_explicativos[primeira_vez]
	emit_signal("call_tutorial", explicacao)
