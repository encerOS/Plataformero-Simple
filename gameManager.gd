extends Node

var current_level: int = 1
var max_level: int = 6

func _load_level(path: String) -> void:
	current_level = int(path)
	LevelTransition.change_scene_to(str("res://Scenes/Levels/level",path,".tscn"))

func _load_next_level() -> void:
	current_level += 1
	if current_level <= max_level:
		_load_level(str(current_level))
	else:
		LevelTransition.change_scene_to("res://Scenes/Levels/endScreen.tscn")
