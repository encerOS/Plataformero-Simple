extends Node2D

func _on_level_1_pressed() -> void:
	GameManager._load_level(str(1))

func _on_level_2_pressed() -> void:
	GameManager._load_level(str(2))

func _on_level_3_pressed() -> void:
	GameManager._load_level(str(3))

func _on_level_4_pressed() -> void:
	GameManager._load_level(str(4))

func _on_level_5_pressed() -> void:
	GameManager._load_level(str(5))

func _on_return_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/main_menu.tscn")
