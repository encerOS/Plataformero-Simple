extends StaticBody2D

@onready var timer : Timer = $CrumbleTimerOsc
@onready var col_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var regen_timer: Timer = $RegenerateTimer
var respawn_position: Vector2 = Vector2(0,0)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		respawn_position = col_shape_2d.position
		timer.start()

func _on_crumble_timer_osc_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.4)
	col_shape_2d.position = Vector2(-1000, 2000)
	timer.stop()
	regen_timer.start()

func _on_regenerate_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.4)
	col_shape_2d.position = respawn_position
	regen_timer.stop()
