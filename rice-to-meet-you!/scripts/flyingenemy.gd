extends Node2D

@export var speed: float = 100.0
@export var slam_speed: float = 400.0
@export var return_speed: float = 200.0
@export var pause_duration: float = 0.5 # Time spent shaking/pausing before drop
@export var activation_radius: float = 1000.0

@export var health: int = 30

@onready var raycast: RayCast2D = $Area2D/RayCast2D
@onready var pause_timer: Timer = $Area2D/PauseTimer
@onready var animated: AnimatedSprite2D = $Area2D/AnimatedSprite2D

enum State { HOVER, PRE_SLAM, SLAMMING, RETURNING }
var current_state: State = State.HOVER

var player: Node2D = null
var start_position: Vector2
var pre_slam_pos: Vector2

func _ready() -> void:
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	
	# Connect the timer timeout via code
	pause_timer.one_shot = true
	pause_timer.timeout.connect(_on_pause_timer_timeout)

func _physics_process(delta: float) -> void:
	if not player:
		return

	match current_state:
		State.HOVER:
			if global_position.distance_to(player.global_position) <= activation_radius:
				# 1. Float horizontally above player
				var target_x = player.global_position.x
				global_position.x = move_toward(global_position.x, target_x, speed * delta)
			
			# 2. Trigger warning phase if lined up
			if abs(global_position.x - player.global_position.x) < 5.0:
				if player.global_position.y > global_position.y:
					trigger_warning()

		State.PRE_SLAM:
			# Add a slight visual screen/sprite shake effect during the pause
			# We shake the sprite directly so the root global_position stays fixed
			$Area2D/AnimatedSprite2D.position.x = randf_range(-2.0, 2.0)

		State.SLAMMING:
			# Move straight down rapidly
			global_position.y += slam_speed * delta
			
			# Check if we hit the floor
			if raycast.is_colliding():
				global_position.y = raycast.get_collision_point().y - 10 
				current_state = State.RETURNING

		State.RETURNING:
			# Float back up to original spawn height
			global_position.y = move_toward(global_position.y, start_position.y, return_speed * delta)
			if abs(global_position.y - start_position.y) < 1.0:
				current_state = State.HOVER

func trigger_warning() -> void:
	current_state = State.PRE_SLAM
	pause_timer.start(pause_duration)
	# Optional: Play warning animation or audio here
	animated.play("pre_smash")

func _on_pause_timer_timeout() -> void:
	# Reset sprite offset from shaking
	$Area2D/AnimatedSprite2D.position = Vector2.ZERO 
	
	animated.play("smash")
	
	# Begin the drop
	current_state = State.SLAMMING
	raycast.force_raycast_update()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.respawn()
		print("Ouch")
		
		
		
func take_damage(amount: int):
	health -= amount
	print("Enemy took ", amount, " damage! HP left: ", health)
	AudioStreamManager.play("res://New Sounds/kenney_impact-sounds/Audio/impactPunch_heavy_004.ogg")
	if health <= 0:
		AudioStreamManager.play("res://New Sounds/kenney_sci-fi-sounds/Audio/explosionCrunch_004.ogg")
		die()

func die():
	# Stop movement or logic
	set_process(false)
	set_physics_process(false)
	
	# Play the death animation
	animated.play("die")
	
	# Wait for the animation to finish
	await animated.animation_finished
	
	# Delete the enemy node
	queue_free()
