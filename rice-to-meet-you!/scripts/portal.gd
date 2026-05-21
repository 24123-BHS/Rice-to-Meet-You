extends Area2D

@onready var nextlevel: AudioStreamPlayer = $nextlevel

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		nextlevel.play()
		print("Next Level!")
		#Load a new level
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
