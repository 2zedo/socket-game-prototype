extends CharacterBody2D

# Candidate movement tuning. Keep these near the top so GUI feedback can map
# directly to a small number of values.
const MOVE_SPEED := 230.0
const TARGET_REACHED_DISTANCE := 10.0

var keyboard_input_enabled := false
var path_points: PackedVector2Array = PackedVector2Array()
var path_index := 0


func set_keyboard_input_enabled(enabled: bool) -> void:
	keyboard_input_enabled = enabled


func set_move_target(target: Vector2) -> void:
	set_path(PackedVector2Array([target]))


func set_path(points: PackedVector2Array) -> void:
	path_points = points
	path_index = 0

	if path_points.size() > 0 and global_position.distance_to(path_points[0]) <= TARGET_REACHED_DISTANCE:
		path_index = 1

	if path_index >= path_points.size():
		clear_move_target()


func clear_move_target() -> void:
	path_points.clear()
	path_index = 0


func has_active_target() -> bool:
	return path_index < path_points.size()


func is_at_target() -> bool:
	return not has_active_target()


func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO

	if keyboard_input_enabled:
		if Input.is_key_pressed(KEY_LEFT):
			input_vector.x -= 1.0
		if Input.is_key_pressed(KEY_RIGHT):
			input_vector.x += 1.0
		if Input.is_key_pressed(KEY_UP):
			input_vector.y -= 1.0
		if Input.is_key_pressed(KEY_DOWN):
			input_vector.y += 1.0

	if input_vector != Vector2.ZERO:
		clear_move_target()
		velocity = input_vector.normalized() * MOVE_SPEED
	elif has_active_target():
		var current_target := path_points[path_index]
		var to_target := current_target - global_position
		if to_target.length() <= TARGET_REACHED_DISTANCE:
			global_position = current_target
			path_index += 1
			if has_active_target():
				velocity = (path_points[path_index] - global_position).normalized() * MOVE_SPEED
			else:
				velocity = Vector2.ZERO
		else:
			velocity = to_target.normalized() * MOVE_SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	z_index = int(global_position.y)
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(8, 18), 28.0, Color(0.0, 0.0, 0.0, 0.32))
	draw_rect(Rect2(Vector2(-14, -34), Vector2(28, 56)), Color(0.08, 0.10, 0.12, 1.0), true)
	draw_rect(Rect2(Vector2(-11, -46), Vector2(22, 22)), Color(0.12, 0.13, 0.15, 1.0), true)
	draw_line(Vector2(-14, -30), Vector2(14, 18), Color(0.86, 0.74, 0.52, 0.68), 3.0)
