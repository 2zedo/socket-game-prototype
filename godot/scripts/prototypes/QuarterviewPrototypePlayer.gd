extends CharacterBody2D

@export var move_speed := 210.0


func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed
	move_and_slide()
	z_index = int(global_position.y)
	queue_redraw()


func _draw() -> void:
	var shadow_color := Color(0.02, 0.015, 0.01, 0.55)
	var coat_color := Color(0.10, 0.12, 0.14, 1.0)
	var face_color := Color(0.74, 0.60, 0.50, 1.0)
	var hair_color := Color(0.03, 0.035, 0.045, 1.0)
	var accent_color := Color(0.86, 0.68, 0.36, 1.0)

	draw_ellipse(Rect2(Vector2(-18, 6), Vector2(36, 12)), shadow_color)
	draw_rect(Rect2(Vector2(-10, -28), Vector2(20, 34)), coat_color, true)
	draw_rect(Rect2(Vector2(-9, -3), Vector2(6, 26)), Color(0.08, 0.09, 0.10), true)
	draw_rect(Rect2(Vector2(3, -3), Vector2(6, 26)), Color(0.08, 0.09, 0.10), true)
	draw_circle(Vector2(0, -38), 13.0, hair_color)
	draw_circle(Vector2(0, -34), 8.0, face_color)
	draw_arc(Vector2(0, -38), 13.0, 0.1, 3.05, 24, hair_color, 5.0)
	draw_line(Vector2(-13, -8), Vector2(-20, 4), coat_color, 4.0)
	draw_line(Vector2(13, -8), Vector2(20, 4), coat_color, 4.0)
	draw_line(Vector2(-10, -28), Vector2(10, -28), accent_color, 1.5)
	draw_arc(Vector2.ZERO, 15.0, 0.0, TAU, 32, Color(0.35, 0.72, 1.0, 0.9), 2.0)


func draw_ellipse(rect: Rect2, color: Color) -> void:
	var center := rect.position + rect.size * 0.5
	var points := PackedVector2Array()
	for index in range(32):
		var angle := TAU * float(index) / 32.0
		points.append(center + Vector2(cos(angle) * rect.size.x * 0.5, sin(angle) * rect.size.y * 0.5))
	draw_colored_polygon(points, color)
