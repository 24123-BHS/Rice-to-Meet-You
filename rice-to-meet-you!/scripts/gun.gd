extends Node2D

@onready var rotation_offset: Node2D = $RotationOffset
@onready var shadow: Sprite2D = $RotationOffset/Sprite2D/shadow
@onready var shoot_pos: Marker2D = $RotationOffset/Sprite2D/shoot_pos

var time_between_shot: float = 0.25
var can_shoot: bool = true

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_offset.rotation = lerp_angle(rotation_offset.rotation, ( get_global_mouse_position() - global_position ).angle(), 6.5*delta)
	shadow.position = Vector2(-2, 2).rotated(-rotation_offset.rotation)
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false
		$ShootTimer.start()
		
func _shoot():
	pass

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
