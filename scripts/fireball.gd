extends Node2D

@onready var sprite: AnimatedSprite2D = $sprite
@export var speed := 80.0  # pixels per second
@onready var som: AudioStreamPlayer2D = $som
@onready var som_explosao: AudioStreamPlayer2D = $som_explosao

var voando = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Criada")
	sprite.play("surgindo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if voando:
		position.y += speed * delta


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "surgindo":
		voando = true
		som.play()
		sprite.play("voando")
	if sprite.animation == "explodindo":
		queue_free()


func _on_kill_area_body_entered(body: Node2D) -> void:
	voando = false
	sprite.play("explodindo")
	som_explosao.play()
	if body.is_in_group("Playable") or body.is_in_group("Enemies"):
		body.kill()
		
		
