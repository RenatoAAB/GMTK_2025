extends InteractionEffect

@onready var effect_area: Area2D = $EffectArea
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var navigation_obstacle_2d: NavigationObstacle2D = $StaticBody2D/NavigationObstacle2D
@onready var navmesh = get_tree().get_nodes_in_group("navmesh")[0]
@export var is_open : bool;


func _ready() -> void:
	sprite.material = sprite.material.duplicate(true)
	if is_open:
		open()
	else:
		close()
		
	# generate mashes according to doors
	await get_tree().create_timer(1.0).timeout
	navmesh.bake_navigation_polygon()
	

func activate_highlight():
	sprite.material.set_shader_parameter("show_outline", true)
	
#
func deactivate_highlight():
	sprite.material.set_shader_parameter("show_outline", false)

func activate():
	deactivate_highlight()
	if is_open:
		close()
	else:
		open()
	

func open():
	print("abre a porta")
	is_open = true
	collision_shape.disabled = true
	sprite.frame = 1
	
	
	navigation_obstacle_2d.affect_navigation_mesh = false
	navigation_obstacle_2d.carve_navigation_mesh = false
	
	navmesh.bake_navigation_polygon()
	
func close():
	is_open = false
	print("fecha a porta")
	collision_shape.disabled = false
	sprite.frame = 0
	
	navigation_obstacle_2d.affect_navigation_mesh = true
	navigation_obstacle_2d.carve_navigation_mesh = true
	
	
	navmesh.bake_navigation_polygon()
	
