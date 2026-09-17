extends CharacterBody2D
enum States {
idle,
walk,
run,
hiden,
jump,
fall,
landing,
death,
reset
}
@export var speed = 300.0
@export var running_speed = 600.0
@export var airborn_speed = 200.0
@export var jump_velocity = -400.0
@export var double_jump_velocity = -300
@export var run_charge_limit: float = .5
@export var landing_charge_limit: float = .6
@export var double_jump_charge_limit: float = .3
@export var respawn_rate: float = 2
@export var respawn_position: Vector2 = global_position

var state = States.idle
var run_charge: float = 0
var landing_charge: float = 0
var respawn_charge: float = 0
var double_jump_charge: float = 0
var can_hide: bool = false
var can_die: bool = false

var direction: float = 0
var jump_pressed: bool = false
var hide_pressed: bool = false
var run_held: bool = false
var run_released: bool = false
var reset_pressed: bool = false

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_label: Label = $StateLabel
@onready var can_hide_label: Label = $CanHideLabel

func _player_input() -> void:
		direction = Input.get_axis("Left", "Right")
		jump_pressed = Input.is_action_just_pressed("Jump")
		hide_pressed = Input.is_action_just_pressed("Hide")
		run_held = Input.is_action_pressed("Run")
		run_released = Input.is_action_just_released("Run")
		reset_pressed = Input.is_action_just_pressed("Quick Reload")
	
func _animation():
	$GPUParticlesRUN.emitting = false
	if can_die:
		$AnimatedSprite2D.play('reset')
		return
	if hide_pressed:
		$AnimatedSprite2D.play('hidden')
		return
	if direction == 0.0 and is_on_floor():
		if landing_charge > landing_charge_limit:
			$GPUParticlesLAND.restart()
			$AnimatedSprite2D.play('land')
			landing_charge = 0
			return
		$AnimatedSprite2D.play('idle')
		return
	if velocity.y < 0 and !is_on_floor():
		$AnimatedSprite2D.flip_h = direction < 0
		$GPUParticlesLAND.restart()
		$AnimatedSprite2D.play('jump')
		return
	if velocity.y > 0 and !is_on_floor():
		$AnimatedSprite2D.flip_h = direction < 0
		$AnimatedSprite2D.play('fall')
		return
	if direction and abs(velocity.x) == speed:
		$AnimatedSprite2D.flip_h = direction < 0
		$GPUParticlesRUN.emitting = true
		$GPUParticlesRUN.scale.x = -1 if direction < 0 else 1
		$AnimatedSprite2D.play('walk')
		return
	if direction and abs(velocity.x) == running_speed:
		$AnimatedSprite2D.flip_h = direction < 0
		$GPUParticlesRUN.emitting = true
		$GPUParticlesRUN.scale.x = -1 if direction < 0 else 1
		$AnimatedSprite2D.play('run')
		return

func _move_to(moving_speed, delta: float = 0.0) -> void:
	if direction == 0.0 and !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, moving_speed * delta)
	else:
		velocity.x = direction * moving_speed
	
func _apply_gravity(delta) -> void:
	velocity += get_gravity() * delta
	
func _state_idle() -> void:
	_move_to(speed)
	if velocity.x != 0.0:
		_change_state(States.walk)
		return
	if not is_on_floor():
		_change_state(States.fall)
		return
	if jump_pressed and is_on_floor():
		_change_state(States.jump)
		return
	if hide_pressed and can_hide:
		_change_state(States.hiden)
		return
	if can_die:
		_change_state(States.death)
		return
	if reset_pressed:
		_change_state(States.reset)
		return
		
func _state_hiden() -> void:
	velocity.x = move_toward(velocity.x, 0, speed)
	if jump_pressed and is_on_floor():
		_change_state(States.jump)
		return
	if hide_pressed:
		_change_state(States.idle)
		return

func _state_walk(delta: float) -> void:
	_move_to(speed)
	if velocity.x == 0.0:
		$FootStepTimer.stop()
		_change_state(States.idle)
		return
	if not is_on_floor():
		_change_state(States.fall)
		$FootStepTimer.stop()
		return
	if jump_pressed and is_on_floor():
		$FootStepTimer.stop()
		_change_state(States.jump)
		return
	if run_held:
		run_charge += delta
		if run_charge >= run_charge_limit:
			$FootStepTimer.stop()
			_change_state(States.run)
			return
	if can_die:
		$FootStepTimer.stop()
		_change_state(States.death)
		return

func _state_run() -> void:
	_move_to(running_speed)
	if velocity.x == 0.0:
		$RunStepTimer.stop()
		_change_state(States.idle)
		return
	if not is_on_floor():
		$RunStepTimer.stop()
		_change_state(States.fall)
		return
	if jump_pressed and is_on_floor():
		$RunStepTimer.stop()
		_change_state(States.jump)
		return
	if run_released:
		$RunStepTimer.stop()
		_change_state(States.walk)
		return
	if can_die:
		$RunStepTimer.stop()
		_change_state(States.death)
		return

func _state_jump(delta: float) -> void:
	_apply_gravity(delta)
	_move_to(airborn_speed, delta)
	double_jump_charge += delta
	if double_jump_charge >= double_jump_charge_limit and jump_pressed:
		velocity.y = double_jump_velocity
		return
	if velocity.y > 0:
		_change_state(States.fall)
		return
	if can_die:
		_change_state(States.death)
		return
	if reset_pressed:
		_change_state(States.reset)
		return


func _state_fall(delta: float) -> void:
	_apply_gravity(delta)
	_move_to(airborn_speed, delta)
	landing_charge += delta
	if landing_charge >= landing_charge_limit:
		_change_state(States.landing)
		return
	if is_on_floor():
		_change_state(States.idle)
		return
	if can_die:
		_change_state(States.death)
		return
	if reset_pressed:
		_change_state(States.reset)
		return

func _state_landing(delta: float) -> void:
	_apply_gravity(delta)
	_move_to(airborn_speed, delta)
	if is_on_floor():
		$LandSfx.play()
		_change_state(States.idle)
		return
	if can_die:
		_change_state(States.death)
		return
	if reset_pressed:
		_change_state(States.reset)
		return

func _state_death(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.y = move_toward(velocity.y, 0, speed)
	respawn_charge += delta
	if respawn_charge >= respawn_rate:
		global_position = respawn_position
		can_die = false
		_change_state(States.idle)
		
func _state_reset() -> void:
	global_position = respawn_position
	_change_state(States.idle)

func _change_state(new_state: States) -> void:
	if new_state == state:
		return
	match new_state:
		States.jump:
			double_jump_charge = 0
			$JumpSfx.play()
			velocity.y = jump_velocity
		States.walk:
			$FootStepTimer.start()
			run_charge = 0
		States.run:
			$RunStepTimer.start()
		States.fall:
			landing_charge = 0
		States.death:
			$DeathSfx.play()
			respawn_charge = 0
	state = new_state

func _run_state(delta: float) -> void:
	match state:
		States.idle:
			_state_idle()
		States.walk:
			_state_walk(delta)
		States.run:
			_state_run()
		States.jump:
			_state_jump(delta)
		States.fall:	
			_state_fall(delta)
		States.landing:
			_state_landing(delta)
		States.hiden:
			_state_hiden()
		States.death:
			_state_death(delta)
		States.reset:
			_state_reset()
	state_label.text = States.keys()[state]
	can_hide_label.text = "can hide:" + str(can_hide)

func _physics_process(delta: float) -> void:
	_player_input()
	_run_state(delta)
	_animation()
	move_and_slide()

func _on_hiding_zone_body_entered(_body: Node2D) -> void:
	can_hide = true

func _on_hiding_zone_body_exited(_body: Node2D) -> void:
	can_hide = false

func _on_death_zone_body_entered(_body: Node2D) -> void:
	can_die = true

func _on_check_point_zone_body_entered(_body: Node2D) -> void:
	$GPUParticlesCheckPoint.restart()
	respawn_position = global_position


func _on_timer_timeout() -> void:
	$WalkSfx.play()


func _on_run_step_timer_timeout() -> void:
	$RunSfx.play()


func _on_finish_line_body_entered(_body: Node2D) -> void:
	GameManager._load_next_level()
