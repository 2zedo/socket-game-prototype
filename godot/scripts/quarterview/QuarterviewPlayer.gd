extends CharacterBody2D

const MOVE_SPEED := 220.0
const TARGET_REACHED_DISTANCE := 7.0

var keyboard_input_enabled := false
var move_target := Vector2.ZERO
var has_move_target := false


func set_keyboard_input_enabled(enabled: bool) -> void:
	keyboard_input_enabled = enabled
	if enabled:
		has_move_target = false


func set_move_target(target: Vector2) -> void:
	move_target = target
	has_move_target = true


func clear_move_target() -> void:
	has_move_target = false


func has_active_target() -> bool:
	return has_move_target


func is_at_target() -> bool:
	return not has_move_target


func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO

	if keyboard_input_enabled:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			input_vector.x -= 1.0
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			input_vector.x += 1.0
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			input_vector.y -= 1.0
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			input_vector.y += 1.0

	if input_vector != Vector2.ZERO:
		has_move_target = false
		velocity = input_vector.normalized() * MOVE_SPEED
	elif has_move_target:
		var to_target := move_target - global_position
		if to_target.length() <= TARGET_REACHED_DISTANCE:
			global_position = move_target
			has_move_target = false
			velocity = Vector2.ZERO
		else:
			velocity = to_target.normalized() * MOVE_SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	z_index = int(global_position.y)
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(7, 14), 20.0, Color(0.0, 0.0, 0.0, 0.30))
	draw_rect(Rect2(Vector2(-10, -28), Vector2(20, 44)), Color(0.08, 0.10, 0.12, 1.0), true)
	draw_rect(Rect2(Vector2(-8, -36), Vector2(16, 16)), Color(0.12, 0.13, 0.15, 1.0), true)
	draw_line(Vector2(-10, -24), Vector2(10, 16), Color(0.86, 0.74, 0.52, 0.60), 2.0)
