extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@export var ammo : PackedScene

var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
	_aim()
	_check_player_collision()

func _aim():
	ray_cast_2d.target_position = to_local(player.position)

func _check_player_collision():
	if ray_cast_2d.get_collider() == player and timer.is_stopped():
		timer.start()
		return
	if ray_cast_2d.get_collider() != player and not timer.is_stopped():
		timer.stop()
		return

func _on_timer_timeout() -> void:
	_shoot()
	
func _shoot():
	var bullet = ammo.instantiate()
	bullet.position = position
	bullet.direction = (ray_cast_2d.target_position).normalized()
	get_tree().current_scene.add_child(bullet)
