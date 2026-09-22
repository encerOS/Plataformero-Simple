extends Node2D

func _ready() -> void:
	var buttons = $LevelsButtonManager.get_children()
	for i in buttons.size():
		buttons[i].pressed.connect(_on_level_button_pressed.bind(i + 1))

func _on_level_button_pressed(level_number: int) -> void:
	GameManager._load_level(str(level_number))

func _on_return_pressed() -> void:
	LevelTransition.change_scene_to("res://Scenes/Levels/main_menu.tscn")
