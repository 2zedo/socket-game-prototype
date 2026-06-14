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
	var sprite_rect := Rect2(Vector2(-24.0, -44.0), Vector2(48.0, 64.0))
	draw_texture_rect(AssetPaths.YUI_PLAYER_IDLE_BACK, sprite_rect, false)
