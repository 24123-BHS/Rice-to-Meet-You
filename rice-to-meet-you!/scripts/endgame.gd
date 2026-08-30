extends Node2D

@onready var press: AudioStreamPlayer = $Button/press

func _on_button_pressed() -> void:
	press.play()
	AudioStreamManager.play("res://New Sounds/kenney_interface-sounds/Audio/back_002.ogg")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
