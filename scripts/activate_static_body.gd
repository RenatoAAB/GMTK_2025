extends StaticBody2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var navigation_obstacle_2d: NavigationObstacle2D = $NavigationObstacle2D
@onready var navigation_region_2d: NavigationRegion2D = $"../../../NavigationRegion2D"
signal request_obstacle_move(obstacle)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_effect_animation_finished() -> void:
	print(navigation_region_2d)
	collision_shape_2d.disabled = false
	
	var navmesh = get_tree().get_nodes_in_group("navmesh")[0]
	
	navigation_obstacle_2d.affect_navigation_mesh = true
	navigation_obstacle_2d.carve_navigation_mesh = true
	
	navmesh.bake_navigation_polygon()
	
	#emit_signal("request_obstacle_move", navigation_obstacle_2d)
	
	#var navmesh = navigation_region_2d
	#navmesh.add_child(navigation_obstacle_2d)

	##navmesh.bake_navigation_polygon()
	#var children = navmesh.get_children()
	#print(navmesh)
	#print(children)
	#for child in children:
		#print(child.name)
		#
	#for child in self.get_children():
		#print(child.name)
	#
	#
	#print("bakou")
