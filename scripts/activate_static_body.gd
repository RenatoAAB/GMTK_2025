extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var navigation_obstacle_2d: NavigationObstacle2D = $NavigationObstacle2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_effect_animation_finished() -> void:
	collision_shape_2d.disabled = false
	var navmesh = get_tree().get_nodes_in_group("navigation")[0]
	navmesh.add_child(navigation_obstacle_2d)
