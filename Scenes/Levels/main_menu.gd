extends Node2D

func _on_start_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level.tscn")


func _on_levels_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level_selection.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
