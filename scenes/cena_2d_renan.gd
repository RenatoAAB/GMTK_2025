extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var character_body_2d_2: CharacterBody2D = $CharacterBody2D2




func is_in_line_of_sight(player: Node2D, target: Node2D, collision_mask := 1) -> bool:
	var space_state := get_world_2d().direct_space_state
	
	#var queryRayParameters = ({
		#"from": player.global_position,
		#"to": target.global_position,
		#"exclude": [player],
		#"collision_mask": collision_mask
	#})
	
	var query = PhysicsRayQueryParameters2D.create(player.global_position, target.global_position, collision_mask, [player])
	
	#var collision = get_world_2d().direct_space_state.intersect_ray(query)

	
	var result := space_state.intersect_ray(query)

	# If no obstacle is hit or we directly hit the target, line of sight is clear
	return not result or result.get("collider") == target

func _process(delta):
	if is_in_line_of_sight(player, character_body_2d_2):
		character_body_2d_2.visible = true
	else:
		character_body_2d_2.visible = false
