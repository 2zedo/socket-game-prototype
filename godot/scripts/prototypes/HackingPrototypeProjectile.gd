extends Area2D

@export var speed := 520.0
@export var lifetime := 0.8
@export var damage := 1

var velocity := Vector2.RIGHT * speed


func setup(direction: Vector2) -> void:
	var shot_direction := direction.normalized()
	if shot_direction.length() <= 0.0:
		shot_direction = Vector2.RIGHT
	velocity = shot_direction * speed
	rotation = shot_direction.angle()


func _ready() -> void:
	collision_layer = 8
	collision_mask = 1 | 2
	body_entered.connect(_on_body_entered)

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 5.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
	queue_redraw()


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 6.0, Color(0.35, 1.0, 0.95, 1.0))
	draw_line(Vector2(-8, 0), Vector2(8, 0), Color(0.85, 1.0, 1.0, 0.9), 2.0)
