extends Node

var current_level: int = 0
var levels: Array[String] = [
	"res://Scenes/Levels/level.tscn",
	"res://Scenes/Levels/level2.tscn",
	"res://Scenes/endScreen.tscn",
]

func _load_level(path: String) -> void:
	get_tree().change_scene_to_file.call_deferred(path)

func _load_next_level() -> void:
	current_level += 1
	if current_level <= levels.size():
		_load_level(levels[current_level])
	else:
		pass
