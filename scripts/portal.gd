extends InteractionEffect

var is_active = false
@onready var portal_1: AnimatedSprite2D = $Area1/portal1
@onready var portal_2: AnimatedSprite2D = $Area2/portal2
@onready var collision_shape_portal_2: CollisionShape2D = $Area2/CollisionShape2D
@onready var collision_shape_portal_1: CollisionShape2D = $Area1/CollisionShape2D
@onready var area_1: Area2D = $Area1
@onready var area_2: Area2D = $Area2
@onready var point_light_2d_2: PointLight2D = $Area1/PointLight2D2
@onready var point_light_2d: PointLight2D = $Area2/PointLight2D
@onready var som_ativo: AudioStreamPlayer2D = $som_ativo
@onready var som_passagem: AudioStreamPlayer2D = $som_passagem

func _ready():
	portal_1.material = portal_1.material.duplicate(true)
	portal_2.material = portal_1.material

# Called when the node enters the scene tree for the first time.
func activate() -> void:
	deactivate_highlight()
	portal_1.play("ligando")
	portal_2.play("ligando")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_highlight():
	portal_1.material.set_shader_parameter("show_outline", true)
	
func deactivate_highlight():
	portal_1.material.set_shader_parameter("show_outline", false)

func _on_portal_2_animation_finished() -> void:
	if portal_2.animation == 'ligando':
		som_ativo.play()
		portal_2.play("rodando")
		is_active = true
		point_light_2d_2.enabled = true

func _on_portal_1_animation_finished() -> void:
	if portal_1.animation == 'ligando':
		portal_1.play("rodando")
		is_active = true
		point_light_2d.enabled = true

func desligar_portais():
	som_passagem.play()
	som_ativo.stop()
	point_light_2d.enabled = false
	point_light_2d_2.enabled = false
	is_active = false
	portal_1.play("desligando")
	portal_2.play("desligando")

func _on_area_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Playable") and is_active:
		desligar_portais()
		body.global_position = area_2.global_position


func _on_area_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Playable") and is_active:
		desligar_portais()
		body.global_position = area_1.global_position
