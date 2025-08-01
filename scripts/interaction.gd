extends Node2D

@export var interactionEffect : Node;
@export var reactivatable := false;
@export var timerCooldown := 3
var last_run_time := 0.0


@onready var trigger: Sprite2D = $TriggerArea/trigger
@onready var sprite: Sprite2D = $TriggerArea/trigger

enum SpriteType {
	LEVER,
	BOOK
}

@export var interactionSprite: SpriteType = SpriteType.BOOK

var already_activated = false
var effect_once = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger.material = trigger.material.duplicate(true)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func activate():
	

	# _can run checks if cooldown for activation is ok
	# also sets new cooldown at the moment it is called
	if _can_run():
		print("called every frame")
		if not reactivatable:
			if not already_activated:
				trigger.material.set_shader_parameter("show_outline", false)
				already_activated = true
				print("Activated")
				interactionEffect.activate()
				
				if interactionSprite == SpriteType.LEVER:
					sprite.frame = 2
		else:
			if not already_activated:
				already_activated = true
				print("Activated")
				interactionEffect.activate()
			else:
				already_activated = false
				interactionEffect.activate()
				print("Ractivated")
			if interactionSprite == SpriteType.LEVER:
				toggle_lever_sprite()


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if not reactivatable:
		if body.is_in_group("Playable") and not already_activated:
			interactionEffect.activate_highlight()
			trigger.material.set_shader_parameter("show_outline", true)
			body.set_possible_interaction(self)
	elif body.is_in_group("Playable"):
		interactionEffect.activate_highlight()
		trigger.material.set_shader_parameter("show_outline", true)
		body.set_possible_interaction(self)

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if not reactivatable:
		if body.is_in_group("Playable") and not already_activated:
			interactionEffect.deactivate_highlight()
			trigger.material.set_shader_parameter("show_outline", false)
			body.set_possible_interaction(null)
	elif body.is_in_group("Playable"):
		interactionEffect.deactivate_highlight()
		trigger.material.set_shader_parameter("show_outline", false)
		body.set_possible_interaction(null)
		
		
		
func _can_run() -> bool:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_run_time >= timerCooldown:
		last_run_time = current_time
		return true
	return false
	
func toggle_lever_sprite():
	if sprite.frame == 2:
		sprite.frame = 0
	else:
		sprite.frame = 2
