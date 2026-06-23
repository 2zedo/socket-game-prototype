extends CharacterBody2D

const MOVE_SPEED := 260.0


func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_vector.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_vector.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_vector.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_vector.y += 1.0

	velocity = input_vector.normalized() * MOVE_SPEED
	move_and_slide()
	z_index = int(global_position.y)


func _draw() -> void:
	draw_set_transform(Vector2(0, 14), 0.0, Vector2(1.35, 0.42))
	draw_circle(Vector2.ZERO, 18.0, Color(0.0, 0.0, 0.0, 0.32))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	draw_polygon(
		PackedVector2Array([
			Vector2(-13, -20),
			Vector2(13, -20),
			Vector2(18, 12),
			Vector2(-18, 12),
		]),
		PackedColorArray([Color(0.10, 0.74, 0.80, 1.0)])
	)
	draw_polygon(
		PackedVector2Array([
			Vector2(-18, 12),
			Vector2(18, 12),
			Vector2(12, 28),
			Vector2(-12, 28),
		]),
		PackedColorArray([Color(0.05, 0.36, 0.44, 1.0)])
	)
	draw_line(Vector2(-13, -20), Vector2(13, -20), Color(0.78, 1.0, 0.96, 0.82), 2.0)
