extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
#will be speed in pixels per second
@export var speed = 100
@export var health: int = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow.progress += speed * delta

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
	if health <= 0:
		queue_free() # Enemy is defeated
