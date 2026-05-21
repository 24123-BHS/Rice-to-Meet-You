extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer = $jumpsound
@onready var deathsound: AudioStreamPlayer = $deathsound
@onready var dashsound: AudioStreamPlayer = $dashsound

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_position = Vector2(576,184)
#Jump count
var jump_count = 0
var max_jumps = 2

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jump_count = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
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
	var direction := Input.get_axis("ui_left", "ui_right")
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

	if is_on_floor():
		if abs(velocity.x) > 0.1:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		animation.play("jump")
	

	# Handle respawn
	if position.y > 900:
		# Respawn 
		respawn()
		
		
func respawn():
	deathsound.play()
	position = start_position
	

# Make it stop dashing
func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
