extends CharacterBody2D
class_name Player

@export var speed: float = 185.0

var can_move: bool = true


func _physics_process(_delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()


func set_movement_enabled(is_enabled: bool) -> void:
	can_move = is_enabled


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("#5aa0ff"))
	draw_circle(Vector2(0, -8), 8.0, Color("#dcecff"))
	draw_line(Vector2.ZERO, Vector2(0, -24), Color("#1f2b3a"), 3.0)
