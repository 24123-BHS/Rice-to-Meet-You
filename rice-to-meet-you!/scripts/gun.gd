extends Node2D

const bullet_scene = preload("res://prefabs/bullet.tscn")

@onready var rotation_offset: Node2D = $RotationOffset
@onready var shadow: Sprite2D = $RotationOffset/Sprite2D/shadow
@onready var shoot_pos: Marker2D = $RotationOffset/Sprite2D/shoot_pos
@onready var sprite_2d: Sprite2D = $RotationOffset/Sprite2D

var time_between_shot: float = 0.25
var aim_dir = Vector2(1,0) # Default to aiming right
var can_shoot: bool = true

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#shadow.position = Vector2(-2, 2).rotated(-rotation_offset.rotation)
		
# --- AIMING ---
	# Get vector strictly for the arrow keys to prevent aiming from resetting to (0,0)
		
	var aim_vec: Vector2 = Input.get_vector("left", "right", "up", "down")

	
	if aim_vec != Vector2.ZERO:
		aim_dir = aim_vec.round().normalized()
		rotation_offset.rotation = aim_dir.angle()
	else:
		aim_dir = Vector2(1, 0)
		
		# Rotate the gun pivot to look in the aim direction
		rotation_offset.rotation = aim_dir.angle()
		
		# Prevent the gun from looking upside down when aiming left
		if aim_dir.x < 0:
			sprite_2d.flip_v = true
		else:
			sprite_2d.flip_v = false
			
	if Input.is_action_just_pressed("shoot") and can_shoot:
		_shoot()
		can_shoot = false
		$ShootTimer.start()

		
func _shoot():
	var new_bullet = bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.direction = aim_dir
	new_bullet.global_rotation = shoot_pos.global_rotation
	new_bullet.speed = 200
	print(aim_dir.angle())

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
