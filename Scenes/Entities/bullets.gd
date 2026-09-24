extends Area2D

var direction: Vector2 = Vector2.RIGHT
@export var speed : float = 300

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
