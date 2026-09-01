extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
#will be speed in pixels per second
@export var speed = 100
@export var health: int = 30
@onready var animation: AnimatedSprite2D = $Path2D/PathFollow2D/Area2D/AnimatedSprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	# Move along the path (change '+' to '-' if going backwards)
	if path_follow.progress_ratio >= 0.5:
		animation.flip_h = false
	else:
		animation.flip_h = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.respawn()
		print("Ouch")

#to make their paths unique, you must drag the prefab directly onto the scene.


#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Bullet"):
		#queue_free()
		#print("poof")
		
		
func take_damage(amount: int):
	health -= amount
	print("Enemy took ", amount, " damage! HP left: ", health)
	AudioStreamManager.play("res://New Sounds/kenney_impact-sounds/Audio/impactSoft_heavy_000.ogg", +5)
	if health <= 0:
		AudioStreamManager.play("res://New Sounds/kenney_sci-fi-sounds/Audio/slime_000.ogg")
		die()

func die():
	# Stop movement or logic
	set_process(false)
	set_physics_process(false)
	
	# Play the death animation
	animation.play("die")
	
	# Wait for the animation to finish
	await animation.animation_finished
	
	# Delete the enemy node
	queue_free()
