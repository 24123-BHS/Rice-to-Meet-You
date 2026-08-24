extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_level1_pressed() -> void:
	AudioStreamManager.play("res://New Sounds/kenney_interface-sounds/Audio/maximize_006.ogg")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
