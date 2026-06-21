extends CharacterBody2D

@export var move_speed := 95.0
@export var max_hp := 2

var hp := max_hp
var target: Node2D
var kind := "security_drone"
var contact_cooldown := 0.0


func setup(next_target: Node2D, next_kind: String = "security_drone") -> void:
	target = next_target
	kind = next_kind
	if kind == "firewall_sentry":
		move_speed = 45.0
		max_hp = 3
	hp = max_hp


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 16.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	contact_cooldown = maxf(0.0, contact_cooldown - delta)

	if is_instance_valid(target):
		var direction := global_position.direction_to(target.global_position)
		velocity = direction * move_speed
		move_and_slide()

		if global_position.distance_to(target.global_position) <= 30.0 and contact_cooldown <= 0.0:
			if target.has_method("take_damage"):
				target.take_damage(1)
			contact_cooldown = 0.9

	queue_redraw()


func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()
	else:
		queue_redraw()


func _draw() -> void:
	var color := Color(1.0, 0.16, 0.38, 1.0)
	if kind == "firewall_sentry":
		color = Color(1.0, 0.50, 0.16, 1.0)

	draw_circle(Vector2.ZERO, 18.0, Color(0.04, 0.02, 0.06, 1.0))
	draw_circle(Vector2.ZERO, 13.0, color)
	draw_arc(Vector2.ZERO, 22.0, 0.0, TAU, 32, Color(1.0, 0.16, 0.38, 0.55), 2.0)
	draw_line(Vector2(-8, 0), Vector2(8, 0), Color(0.02, 0.01, 0.02, 1.0), 2.0)
