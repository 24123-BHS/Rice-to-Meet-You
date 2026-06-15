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
	
#func _on_area_entered(area: Node2D) -> void:
	#if area.is_in_group("player") or area.is_in_group("Bullet") == false:
		#animation_player.play("remove")
	## Destroy the bullet
	#queue_free()
	
func _on_area_entered(area: Area2D):
	print("Hit detected on: ", area.name)
	
	# Start looking at the immediate parent
	var current_node = area.get_parent()
	
	# Keep climbing up the scene tree until we find the script or run out of nodes
	while current_node != null:
		if current_node.has_method("take_damage"):
			current_node.take_damage(damage)
			queue_free() # Destroy the bullet
			return # Stop running this function completely
		
		# Move up to the next parent level
		current_node = current_node.get_parent()
		
	# If the loop finishes, it means we checked all parents and found no script
	print("Error: Could not find any parent with a 'take_damage' method!")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()

func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") == false:
		animation_player.play("remove")
