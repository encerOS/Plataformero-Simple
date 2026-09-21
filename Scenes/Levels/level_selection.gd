extends Node2D

func _on_level_1_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level.tscn")

func _on_level_2_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level2.tscn")

func _on_level_3_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level3.tscn")

func _on_level_4_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level4.tscn")

func _on_level_5_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/level5.tscn")

func _on_return_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/main_menu.tscn")
