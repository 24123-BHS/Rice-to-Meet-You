extends Node

var current_level: int = 5
var level_unlocked: int = 5
var max_level: int = 5

func _unlock_level(level_to_unlock: int) -> void:
	if level_to_unlock > level_unlocked:
		level_unlocked = level_to_unlock
		
func _load_level(level_to_load: int) -> String:
	if level_to_load > max_level:
		AudioStreamManager.play("res://New Sounds/kenney_music-jingles/Audio/8-Bit jingles/jingles_NES12.ogg")
		return "res://levels/endgame.tscn"
	return str("res://levels/", level_to_load,".tscn")
