extends Area2D

@onready var nextlevel: AudioStreamPlayer = $nextlevel

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Levelmanager.current_level += 1
		Levelmanager._unlock_level(Levelmanager.current_level)
		var level_to_load: String = Levelmanager._load_level(Levelmanager.current_level)
		if level_to_load == "":
			return
		get_tree().call_deferred("change_scene_to_file", level_to_load)
		nextlevel.play()
		print("Next Level!")
