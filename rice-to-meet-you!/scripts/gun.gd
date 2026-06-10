extends Node2D

const bullet_scene = preload("res://prefabs/bullet.tscn")

@onready var rotation_offset: Node2D = $RotationOffset
@onready var shadow: Sprite2D = $RotationOffset/Sprite2D/shadow
@onready var shoot_pos: Marker2D = $RotationOffset/Sprite2D/shoot_pos

var time_between_shot: float = 0.25
var last_shoot_direction = Vector2(1, 0) # Default to aiming right
var can_shoot: bool = true

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation_offset.rotation = lerp_angle(rotation_offset.rotation, ( get_global_mouse_position() - global_position ).angle(), 6.5*delta)
	#shadow.position = Vector2(-2, 2).rotated(-rotation_offset.rotation)
		
# --- AIMING ---
	# Get vector strictly for the arrow keys to prevent aiming from resetting to (0,0)
	var aim_vector = Input.get_vector("left", "right", "up", "down")
	
	if aim_vector != Vector2.ZERO:
		# .normalized().round() snaps diagonal presses exactly to one of the 8 directions
		last_shoot_direction = aim_vector.normalized().round()
		
	if Input.is_action_just_pressed("shoot") and can_shoot:
		_shoot()
		can_shoot = false
		$ShootTimer.start()

		
func _shoot():
	var new_bullet = bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.direction = last_shoot_direction
	new_bullet.global_rotation = shoot_pos.global_rotation
	new_bullet.speed = 120

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
