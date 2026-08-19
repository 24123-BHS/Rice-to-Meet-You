extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer = $jumpsound
@onready var deathsound: AudioStreamPlayer = $deathsound
@onready var dashsound: AudioStreamPlayer = $dashsound
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_position = Vector2(576,184)
#Jump count
var jump_count = 0
var in_air: bool = false
var max_jumps = 2
var rotation_dir = 0

var is_x_locked: bool = false
var locked_x_position: float = 0.0

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true

var step_timer = 0.0
var step_interval = 0.35 # Time in seconds between steps

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	update_animation(input_dir)
	
	 # Check if moving and touching the ground
	if input_dir != Vector2.ZERO and abs(velocity.x) > 0.1 and is_x_locked == false and is_on_floor():
		step_timer += delta
		if step_timer >= step_interval:
			AudioStreamManager.play("res://New Sounds/kenney_impact-sounds/Audio/footstep_grass_000.ogg")
			step_timer = 0.0
	else:
		step_timer = step_interval # Reset so it plays immediately on next move
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

#asked AI
	# Check if the player is holding down the lock key
	if Input.is_action_pressed("lock"):
		if not is_x_locked:
			# Capture the exact X coordinate the moment the key is held
			locked_x_position = global_position.x
			is_x_locked = true
		
		# Hard-lock the X coordinate to prevent any horizontal movement
		global_position.x = locked_x_position
		velocity.x = 0
	else:
		# Reset lock when key is released
		is_x_locked = false
#end of asking AI
	if is_on_floor():
		jump_count = 0
		in_air = false
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps and is_x_locked == false:
		in_air = true
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		jumpsound.play()
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_cooldown_timer.start()
		dashsound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else: 
			velocity.x = direction * SPEED
		# Flip_H if moving left 
		if direction < 0.1:
			animation.flip_h = true
		else: 
			animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()
#
	# Handle respawn
	if position.y > 900:
		# Respawn 
		respawn()

func update_animation(dir: Vector2):
	# If no buttons are pressed, default to a neutral look direction
	if dir == Vector2.ZERO and in_air == false:
		# You can let the last played animation continue or play an idle state
		animation_player.play("Idle_Right")
		
		# Normalize and round the vector to snap to strict 8-way coordinates (-1, 0, or 1)
	var snap_dir = dir.normalized().round()
	
	# Manage horizontal mirroring (Flipping left animations using right sprites)
	if snap_dir.x < 0:
		animation.flip_h = true
	elif snap_dir.x > 0:
		animation.flip_h = false

	# 3. Match the vector to the animation name
	# We use abs() on X because flip_h handles the left side mirrors automatically
	var x_sign = abs(snap_dir.x)
	var y_sign = snap_dir.y


	# Combine X and Y states to find the combination
	if x_sign > 0 and y_sign == 0 and abs(velocity.x) > 0.1 and is_x_locked == false:
		animation_player.play("Run_Right")           # Run Right / Left
		print("run")
	elif x_sign == 0 and y_sign < 0:
		animation_player.play("Idle_Up")             # Straight Up
	elif x_sign == 0 and y_sign > 0:
		animation_player.play("Idle_Down")           # Straight Down
	elif x_sign > 0 and y_sign < 0 and abs(velocity.x) > 0.1 and is_x_locked == false:
		animation_player.play("Run_Up_Right")        # Run Diagonal Up-Right / Up-Left
	elif x_sign > 0 and y_sign > 0 and abs(velocity.x) > 0.1 and is_x_locked == false:
		animation_player.play("Run_Down_Right")      # Run Diagonal Down-Right / Down-Left
	elif x_sign > 0 and y_sign < 0:
		animation_player.play("Idle_Up_Right")       # Diagonal Up-Right / Up-Left
	elif x_sign > 0 and y_sign > 0:
		animation_player.play("Idle_Down_Right")     # Diagonal Down-Right / Down-Left
	elif x_sign > 0 and y_sign == 0 or x_sign == 0 and y_sign == 0:
		animation_player.play("Idle_Right")           # Run Right / Left

		
func respawn():
	deathsound.play()
	position = start_position
	

# Make it stop dashing
func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
