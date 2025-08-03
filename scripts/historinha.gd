extends CanvasLayer

@onready var parte_1: Control = $parte1
@onready var parte_2: Control = $parte2
@onready var parte_3: Control = $parte3
@onready var level_selection: CanvasLayer = $"../LevelSelection"
@onready var historinha: CanvasLayer = $"."

func roda_historinha():
	# Começa a sequência ao iniciar a cena
	await mostrar_em_ordem()

func mostrar_em_ordem() -> void:
	# Garante que tudo começa invisível
	parte_1.visible = false
	parte_2.visible = false
	parte_3.visible = false
	historinha.visible = true

	await get_tree().create_timer(1.0).timeout
	parte_1.visible = true
	
	await get_tree().create_timer(2.0).timeout
	parte_2.visible = true
	
	await get_tree().create_timer(2.0).timeout
	parte_3.visible = true
	
	await get_tree().create_timer(4.0).timeout
	finalizar()
	
func finalizar() -> void:
	print("Final call!")  # Substitua com sua lógica final
	level_selection.visible = true;
