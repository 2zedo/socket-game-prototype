extends CharacterBody2D

signal shot_requested(origin: Vector2, direction: Vector2)
signal health_changed(current_hp: int)

@export var move_speed := 220.0
@export var roll_speed := 420.0
@export var roll_duration := 0.18
@export var roll_cooldown := 0.45
@export var hop_duration := 0.25
@export var max_hp := 3

var hp := max_hp
var facing_direction := Vector2.RIGHT
var roll_timer := 0.0
var roll_cooldown_timer := 0.0
var hop_timer := 0.0
var invulnerable_timer := 0.0
var roll_direction := Vector2.RIGHT
var controls_enabled := true


func _ready() -> void:
	collision_layer = 4
	collision_mask = 1

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 13.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	_tick_timers(delta)

	if not controls_enabled:
		velocity = Vector2.ZERO
		move_and_slide()
		queue_redraw()
		return

	var input_vector := _get_move_input()
	if input_vector.length() > 0.0:
		facing_direction = input_vector.normalized()

	if roll_timer > 0.0:
		velocity = roll_direction * roll_speed
	else:
		velocity = input_vector.normalized() * move_speed

	move_and_slide()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not controls_enabled:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_J:
			_request_shot(facing_direction)
		elif event.keycode == KEY_K or event.keycode == KEY_SHIFT:
			_start_roll()
		elif event.keycode == KEY_SPACE:
			_start_hop()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var direction := global_position.direction_to(get_global_mouse_position())
		if direction.length() <= 0.0:
			direction = facing_direction
		_request_shot(direction)


func take_damage(amount: int) -> bool:
	if invulnerable_timer > 0.0 or roll_timer > 0.0:
		return false

	hp = max(0, hp - amount)
	invulnerable_timer = 0.65
	health_changed.emit(hp)
	queue_redraw()
	return true


func reset_health() -> void:
	hp = max_hp
	health_changed.emit(hp)
	queue_redraw()


func set_controls_enabled(enabled: bool) -> void:
	controls_enabled = enabled
	if not controls_enabled:
		velocity = Vector2.ZERO
		roll_timer = 0.0


func is_hopping() -> bool:
	return hop_timer > 0.0


func is_rolling() -> bool:
	return roll_timer > 0.0


func _get_move_input() -> Vector2:
	var input_vector := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_vector.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_vector.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_vector.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_vector.y += 1.0
	return input_vector


func _tick_timers(delta: float) -> void:
	roll_timer = maxf(0.0, roll_timer - delta)
	roll_cooldown_timer = maxf(0.0, roll_cooldown_timer - delta)
	hop_timer = maxf(0.0, hop_timer - delta)
	invulnerable_timer = maxf(0.0, invulnerable_timer - delta)


func _request_shot(direction: Vector2) -> void:
	var shot_direction := direction.normalized()
	if shot_direction.length() <= 0.0:
		shot_direction = facing_direction
	shot_requested.emit(global_position + shot_direction * 20.0, shot_direction)


func _start_roll() -> void:
	if roll_timer > 0.0 or roll_cooldown_timer > 0.0:
		return

	roll_direction = facing_direction.normalized()
	if roll_direction.length() <= 0.0:
		roll_direction = Vector2.RIGHT
	roll_timer = roll_duration
	roll_cooldown_timer = roll_cooldown


func _start_hop() -> void:
	if hop_timer > 0.0:
		return
	hop_timer = hop_duration


func _draw() -> void:
	var body_color := Color(0.18, 0.95, 0.92, 1.0)
	if invulnerable_timer > 0.0:
		body_color = Color(1.0, 0.82, 0.25, 1.0)
	if is_hopping():
		body_color = Color(0.75, 0.95, 1.0, 1.0)
	if is_rolling():
		body_color = Color(0.95, 0.45, 1.0, 1.0)

	draw_circle(Vector2.ZERO, 14.0, Color(0.02, 0.05, 0.08, 1.0))
	draw_circle(Vector2.ZERO, 10.0, body_color)
	draw_line(Vector2.ZERO, facing_direction.normalized() * 22.0, Color(1.0, 1.0, 1.0, 0.85), 2.0)
