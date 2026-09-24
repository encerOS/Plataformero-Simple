extends CharacterBody2D

@export var player: CharacterBody2D
@export var speed: int = 50
@export var chase_speed: int = 150
@export var acceleration: int = 300
@export var left_view_range: Vector2 = Vector2(-125,0)
@export var right_view_range: Vector2 = Vector2(125,0)


@onready var ray_cast_2d: RayCast2D = $Sprite2D/RayCast2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States{
	Wander,
	Chase
}
var current_state = States.Wander

func _ready() -> void:
	left_bounds = self.position + Vector2(-125, 0)
	right_bounds = self.position + Vector2(125, 0)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement(delta)
	_move_to()
	_look_for_player()
	
func _apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _look_for_player():
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.Chase:
			stop_chase()
	elif current_state == States.Chase:
		stop_chase()
		
func chase_player() -> void:
	timer.stop()
	current_state = States.Chase
	
func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func _handle_movement(delta: float) -> void:
	if current_state == States.Wander:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
	move_and_slide()
	
func _move_to() -> void:
	if current_state == States.Wander:
		if sprite_2d.flip_h:
			#move right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				#flip left
				sprite_2d.flip_h = false
				ray_cast_2d.target_position = left_view_range
		else:
			#move left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				#flip right 
				sprite_2d.flip_h = true
				ray_cast_2d.target_position = right_view_range
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			sprite_2d.flip_h = true
			ray_cast_2d.target_position = right_bounds
		else:
			sprite_2d.flip_h = false
			ray_cast_2d.target_position = left_bounds

func _on_timer_timeout() -> void:
	current_state = States.Wander
