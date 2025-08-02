extends CharacterBody2D

@export var patrol_distance := 10  # How far up/down to patrol
@export var patrol_speed := 10
@export var chase_speed := 25.0
@export var is_patrolling := true
@export var is_chasing := false
@export var path_2d_to_follow: PathFollow2D
@export var ignore_path := false
@export var is_path_linear := true
@onready var exclamation_mark: Sprite2D = $ExclamationMark
@export var always_visible := false
@onready var enemy_alerted_sound: AudioStreamPlayer = $enemyAlertedSound
@onready var initial_standing_position
@onready var initial_direction

var path_follow: PathFollow2D
var on_patrolloing_path := true
var hide_timer_running := false

# chase timeout timer
@export var chase_timer := 10.0




@onready var agent: NavigationAgent2D = $NavigationAgent2D

var playerBeingChased = null
var moving_forward = true
@export var vision_angle_degrees := 60.0  # total cone angle

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_cone = $VisionCone

#@onready var player : CharacterBody2D = $"../CharacterBody2D"
var dead = false
var just_seen = false
var just_seen_cooldown = 0.5
var just_seen_cooldown_timer = 0.5

var direction := Vector2.DOWN
var start_position := Vector2.ZERO

func _ready():
	if not ignore_path:
		path_follow = path_2d_to_follow
		start_position = path_follow.global_position
	else:
		initial_direction = vision_cone.rotation
		initial_standing_position = global_position
	add_to_group("Enemies")
	# Set how close we need to get to the target point before requesting a new one
	#agent.target_desired_distance = 4.0
	#agent.path_desired_distance = 4.0

func kill():
	sprite.play("dead")
	vision_cone.visible = false
	dead = true

func _physics_process(delta):
	if dead:
		return
	if is_chasing:
		chase_player(delta)
	if is_patrolling:
		patrol(delta)
		
	# Only rotate if moving
	if velocity.length() > 1:
		
	# Rotate the vision cone to match current direction
		vision_cone.rotation = velocity.angle() - deg_to_rad(90)
		
	#Flip sprite left/right based on movement
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
		
		
func _process(delta):
	if dead:
		return
	var NinjaA = null
	var NinjaB = null
	
	
	

	if has_object_with_id("Playable","A"):
		NinjaA = get_object_with_id("Playable","A")
	
	if has_object_with_id("Playable","B"):
		NinjaB = get_object_with_id("Playable","B")
	
	just_seen_cooldown_timer -= delta
	if just_seen_cooldown_timer < 0:
		just_seen = false
	
	var ta_vendo = is_in_line_of_sight(NinjaA, NinjaB)
	if ta_vendo or just_seen:
		if (ta_vendo):
			just_seen = true
			just_seen_cooldown_timer = just_seen_cooldown
		self.visible = true
	else:
		self.visible = always_visible
	
	
	if is_patrolling:
		
		var visiblePlayer = null
		if(NinjaA):
			if(not NinjaA.dead):
				visiblePlayer = find_visible_player(NinjaA)
		
		if(NinjaB and not visiblePlayer):
			if(not NinjaB.dead):
				visiblePlayer = find_visible_player(NinjaB)
			
		if visiblePlayer:
			print("Player spotted!")
			
			# sets player to be chased
			playerBeingChased = visiblePlayer
			start_chase()

func patrol(delta):
	if not ignore_path:
		# if is already in the path place
		if(on_patrolloing_path):
			
			# Move enemy to path follow position
			var direction = (path_follow.global_position - global_position).normalized()
			velocity = direction * patrol_speed
			move_and_slide()

			if moving_forward:
				path_follow.progress += (patrol_speed) * delta
			else:
				path_follow.progress -= (patrol_speed) * delta
				
			# Optional: Ping-pong movement
			if is_path_linear:
				if path_follow.progress_ratio >= 0.9:
					moving_forward = false
				elif path_follow.progress_ratio <= 0.1:
					moving_forward = true
		else:
			# directs the enemy back to the
			agent.target_position = path_follow.global_position

			var next_path_point = agent.get_next_path_position()
			var direction = (next_path_point - global_position).normalized()
			
			velocity = direction * chase_speed
			move_and_slide()
			
			if is_within_distance(global_position, path_follow.global_position, 30):
				on_patrolloing_path = true
				
			
	else:# if ignore path is true! (no path set to enemy)
		if not is_within_distance(global_position, initial_standing_position, 5):
			agent.target_position = initial_standing_position
			
			var next_path_point = agent.get_next_path_position()
			var direction = (next_path_point - global_position).normalized()
			
			velocity = direction * chase_speed
			move_and_slide()

		else:
			# tá parado
			velocity = Vector2.ZERO
			vision_cone.rotation  = velocity.angle() - initial_direction
			
	
	
	
	#var distance_from_start = global_position.y - start_position.y
#
	## Alternate patrolling
	#if direction == Vector2.DOWN and distance_from_start >= patrol_distance:
		#direction = Vector2.UP
	#elif direction == Vector2.UP and distance_from_start <= -patrol_distance:
		#direction = Vector2.DOWN
		

func start_chase():
	is_chasing = true
	is_patrolling = false
	on_patrolloing_path = false
	set_exclamation_mark()
	enemy_alerted_sound.play()
	start_chase_timer()

func stop_chase():
	is_chasing = false
	is_patrolling = true
		
func chase_player(delta):
	
	# Set the player as the target
	if(playerBeingChased):
		agent.target_position = playerBeingChased.global_position

		var next_path_point = agent.get_next_path_position()
		var direction = (next_path_point - global_position).normalized()
		
	
		velocity = direction * chase_speed
		move_and_slide()
	else: stop_chase()
	
	
	
	

		
# checks if players are visible, returns null if not visible returns the player node if visible
func find_visible_player(player: Node) -> Node:
	
	var to_player = (player.global_position - global_position)
	var dir_to_player = to_player.normalized()
	var facing_dir = Vector2.DOWN.rotated(vision_cone.rotation)

	# Check if within cone angle
	var angle_diff = rad_to_deg(facing_dir.angle_to(dir_to_player))
	if abs(angle_diff) > vision_angle_degrees / 2.0:
		return null  # Outside vision cone

	# Check if wall is in the way
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, collision_mask, [self])
	
	var result := space_state.intersect_ray(query)

	# If ray hits something and it's not the player, blocked
	if result and result.get("collider") != player:
		return null

	return player
	
	
func is_in_line_of_sight(player1: Node2D, player2: Node2D, collision_mask := 1) -> bool:
	var space_state := get_world_2d().direct_space_state
	
	var player_1_visible = false
	var player_2_visible = false
	if player1:
		var query = PhysicsRayQueryParameters2D.create(player1.global_position, self.global_position, collision_mask, [player1])
		var result1 := space_state.intersect_ray(query)
		player_1_visible = not result1 or result1.get("collider") == self
	
	if player2:
		var query = PhysicsRayQueryParameters2D.create(player2.global_position, self.global_position, collision_mask, [player2])
		var result2 := space_state.intersect_ray(query)
		player_2_visible = not result2 or result2.get("collider") == self
	

	return player_1_visible or player_2_visible

	# If no obstacle is hit or we directly hit the target, line of sight is clear
	
func has_object_with_id(group_name: String, target_id: String) -> bool:
	for node in get_tree().get_nodes_in_group(group_name):
		if node.id == target_id:
			return true
	return false
	
func get_object_with_id(group_name: String, target_id: String) -> Node:
	for node in get_tree().get_nodes_in_group(group_name):
		if node.id == target_id:
			return node
	return null


func _on_kill_area_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Playable"):
		body.kill()
		stop_chase()
		
func is_within_distance(point_a: Vector2, point_b: Vector2, max_distance: float) -> bool:
	return point_a.distance_to(point_b) <= max_distance
	
func set_exclamation_mark():
	exclamation_mark.visible = true
	await get_tree().create_timer(2.0).timeout
	exclamation_mark.visible = false
	
func start_chase_timer():
	await get_tree().create_timer(chase_timer).timeout
	stop_chase()
	
