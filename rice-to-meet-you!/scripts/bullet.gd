extends Node2D

@onready var shadow: Sprite2D = $shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var damage: int = 10

var speed: float = 120.0
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	#global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	#shadow.position = Vector2(-2,2).rotated(-rotation)
	
func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("player") or area.is_in_group("Bullet") == false:
		animation_player.play("remove")
	# Check if the object we hit has a 'take_damage' function
	if area.has_method("take_damage"):
		area.take_damage(damage)

	# Destroy the bullet
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()

func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") == false:
		animation_player.play("remove")
