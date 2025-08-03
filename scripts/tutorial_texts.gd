extends CanvasLayer
@export var textoBase : Node;
@export var textoRed : Node;
@export var textoBlue : Node;
@export var extra : Node;


func nextText(id):
	if id == 'A':
		textoBase.visible = false
		textoRed.visible = false	
		textoBlue.visible = true
	elif id == 'B':
		textoBase.visible = false
		textoRed.visible = true	
		textoBlue.visible = false
		
func show_extra():
	textoBase.visible = false
	textoRed.visible = false	
	textoBlue.visible = false
	extra.visible = true

func _ready() -> void:
	textoBase.visible = true
	textoRed.visible = false	
	textoBlue.visible = false
