extends Node2D

@onready var sprite: AnimatedSprite2D = $sprite
@export var speed := 30.0  # pixels per second
@onready var som: AudioStreamPlayer2D = $som

var voando = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Criada")
	sprite.play("surgindo")
	som.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += speed * delta


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "surgindo":
		voando = true
		som.play()
		sprite.play("voando")


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Playable") or body.is_in_group("Enemies"):
		body.kill()
		
		

func _on_som_finished() -> void:
	queue_free()
