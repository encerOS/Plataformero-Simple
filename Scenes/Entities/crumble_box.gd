extends StaticBody2D

@onready var timer : Timer = $CrumbleTimer
@onready var col_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		timer.start()

func _on_crumble_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.4)
	col_shape_2d.position = Vector2(-1000, 2000)
