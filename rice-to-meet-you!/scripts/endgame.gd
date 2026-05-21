extends Node2D

@onready var press: AudioStreamPlayer = $Button/press

func _on_button_pressed() -> void:
	press.play()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
