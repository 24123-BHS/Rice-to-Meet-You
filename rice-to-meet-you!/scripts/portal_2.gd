extends Area2D

@onready var victory: AudioStreamPlayer = $victory

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		victory.play()
		print("you won!")
		#Load the final scene
		get_tree().change_scene_to_file("res://scenes/endgame.tscn")
