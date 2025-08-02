extends CanvasLayer

@onready var marker: Panel = $marker
@onready var marker_2: Panel = $marker2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoopManager.player_set.connect(_on_player_set)
	
func _on_player_set(id):
	if (id == 'B'):
		return
	else:
		troca_marker()

func troca_marker():
	marker.visible = true;
	marker_2.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
