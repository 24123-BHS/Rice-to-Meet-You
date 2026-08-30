extends Node2D

const bullet_scene = preload("uid://bvgk74jo512l6")

@export var pellet_count: int = 5
@export var spread_angle: float = 30.0

@onready var rotation_offset: Node2D = $RotationOffset
@onready var sprite_2d: Sprite2D = $RotationOffset/Sprite2D
@onready var shoot_pos: Marker2D = $RotationOffset/Sprite2D/shoot_pos

var time_between_shot: float = 0.25
var aim_dir = Vector2(1,0) # Default to aiming right
var last_horizontal_dir = Vector2(1, 0)
var can_shoot: bool = true

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot

func _process(_delta: float) -> void:
	#shadow.position = Vector2(-2, 2).rotated(-rotation_offset.rotation)
		
# --- AIMING ---
	# Get vector strictly for the arrow keys to prevent aiming from resetting to (0,0)
	var aim_vec: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if aim_vec != Vector2.ZERO:
		aim_dir = aim_vec.round().normalized()
		#rotation_offset.rotation = aim_dir.angle()
		
# Update the baseline horizontal direction if they are pressing left or right
		if aim_vec.x != 0:
			last_horizontal_dir = Vector2(sign(aim_vec.x), 0)
	else:
		# No keys pressed: default to the last horizontal direction looked at
		aim_dir = last_horizontal_dir
		
		
		# Rotate the gun pivot to look in the aim direction
	rotation_offset.rotation = aim_dir.angle()
		
		# Prevent the gun from looking upside down when aiming left
	if aim_dir.x < 0:
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
			
		
	if Input.is_action_just_pressed("shoot") and can_shoot:
		AudioStreamManager.play("res://New Sounds/kenney_sci-fi-sounds/Audio/laserRetro_003.ogg", -10)
		_shoot()
		print(aim_vec)
		can_shoot = false
		$ShootTimer.start()
		
		
		
func _shoot():
	var spread_rad = deg_to_rad(spread_angle)
	var center_angle = aim_dir.angle()
	
	var start_angle = center_angle - (spread_rad / 2.0)
	var angle_step = spread_rad / (pellet_count - 1) if pellet_count > 1 else 0.0
	
	for i in range(pellet_count):
		var new_bullet = bullet_scene.instantiate()
		get_tree().root.add_child(new_bullet)
		new_bullet.global_position = shoot_pos.global_position
		
		var pellet_rotation = start_angle + (i * angle_step)
		if pellet_count == 1:
			pellet_rotation = center_angle
			
			
			
		# Assign values to the bullet script
		new_bullet.direction = Vector2.RIGHT.rotated(pellet_rotation)
		new_bullet.global_rotation = pellet_rotation
		new_bullet.global_rotation += randf_range(-0.05, 0.05)
		new_bullet.speed = 200
	# Your shooting logic here
	print(aim_dir.angle())

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
