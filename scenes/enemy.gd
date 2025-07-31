extends CharacterBody2D

@export var patrol_distance := 10  # How far up/down to patrol
@export var patrol_speed := 10.0
@export var chase_speed := 25.0
@export var is_patrolling := true
@export var is_chasing := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var vision_angle_degrees := 60.0  # total cone angle
@onready var player : CharacterBody2D = $"../CharacterBody2D"
@onready var vision_cone = $VisionCone

var direction := Vector2.DOWN
var start_position := Vector2.ZERO

func _ready():
	start_position = global_position

func _physics_process(delta):
	if is_chasing:
		chase_player(delta)
	if is_patrolling:
		patrol(delta)
		
	# Only rotate if moving
	if velocity.length() > 0.01:
			# Rotate the vision cone to match current direction
		if is_chasing:
			vision_cone.look_at(player.global_position)
			vision_cone.rotate(deg_to_rad(-90))
		else:
			vision_cone.rotation = velocity.angle() - deg_to_rad(90)
		# Align cone to velocity direction
		
	#Flip sprite left/right based on movement
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
		
		
func _process(delta):
	if is_player_visible():
		print("Player spotted!")
		# Trigger desired behavior
		start_chase()
	#else:
		#print("Unspotted")

func patrol(delta):
	velocity = direction * patrol_speed
	move_and_slide()

	var distance_from_start = global_position.y - start_position.y

	# Alternate patrolling
	if direction == Vector2.DOWN and distance_from_start >= patrol_distance:
		direction = Vector2.UP
	elif direction == Vector2.UP and distance_from_start <= -patrol_distance:
		direction = Vector2.DOWN
		

func start_chase():
	is_chasing = true
	is_patrolling = false

func stop_chase():
	is_chasing = false
	is_patrolling = true
		
func chase_player(delta):
	var to_player = (player.global_position - global_position).normalized()
	velocity = to_player * chase_speed
	move_and_slide()
		
func is_player_visible() -> bool:
	var to_player = (player.global_position - global_position)
	var dir_to_player = to_player.normalized()
	var facing_dir = Vector2.DOWN.rotated(vision_cone.rotation)

	# Check if within cone angle
	var angle_diff = rad_to_deg(facing_dir.angle_to(dir_to_player))
	if abs(angle_diff) > vision_angle_degrees / 2.0:
		return false  # Outside vision cone

	# Check if wall is in the way
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, collision_mask, [self])
	
	var result := space_state.intersect_ray(query)

	# If ray hits something and it's not the player, blocked
	if result and result.get("collider") != player:
		return false

	return true
