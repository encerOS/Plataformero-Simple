extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var speed = 100.0

var player
var facing_right = false

func _apply_gravity(delta) -> void:
	velocity += get_gravity() * delta

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	navigation_agent_2d.target_position = player.global_position
	velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
