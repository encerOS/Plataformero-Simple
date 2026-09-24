extends CharacterBody2D

@export var speed = -100

func _apply_gravity(delta) -> void:
	velocity += get_gravity() * delta

var facing_right = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		_apply_gravity(delta)

	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
