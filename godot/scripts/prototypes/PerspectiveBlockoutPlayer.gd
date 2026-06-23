extends CharacterBody2D

const MOVE_SPEED := 220.0


func _draw() -> void:
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-18, 18),
			Vector2(-12, 13),
			Vector2(0, 12),
			Vector2(12, 13),
			Vector2(18, 18),
			Vector2(12, 23),
			Vector2(0, 24),
			Vector2(-12, 23),
		]),
		Color(0.0, 0.0, 0.0, 0.32)
	)
	draw_rect(Rect2(Vector2(-10, -24), Vector2(20, 42)), Color(0.08, 0.10, 0.12, 1.0))
	draw_rect(Rect2(Vector2(-8, -30), Vector2(16, 14)), Color(0.11, 0.12, 0.14, 1.0))
	draw_line(Vector2(-10, -24), Vector2(10, 18), Color(0.82, 0.70, 0.50, 0.55), 2.0)


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
