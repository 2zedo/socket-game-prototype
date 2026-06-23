extends CharacterBody2D

signal contact_damage_requested(amount: int, reason: String)

const SECURITY_DRONE_MOVE_SPEED := 95.0
const SECURITY_DRONE_MAX_HP := 2
const FIREWALL_SENTRY_MOVE_SPEED := 45.0
const FIREWALL_SENTRY_MAX_HP := 3
const ENEMY_COLLISION_RADIUS := 16.0
const ENEMY_CONTACT_RANGE := 30.0
const ENEMY_CONTACT_DAMAGE := 1
const ENEMY_CONTACT_COOLDOWN := 0.9
const ENEMY_OUTER_DRAW_RADIUS := 18.0
const ENEMY_INNER_DRAW_RADIUS := 13.0
const ENEMY_ARC_RADIUS := 22.0
const HIT_FLASH_DURATION := 0.16

@export var move_speed := SECURITY_DRONE_MOVE_SPEED
@export var max_hp := SECURITY_DRONE_MAX_HP

var hp := max_hp
var target: Node2D
var kind := "security_drone"
var contact_cooldown := 0.0
var hit_flash_timer := 0.0


func setup(next_target: Node2D, next_kind: String = "security_drone") -> void:
	target = next_target
	kind = next_kind
	if kind == "firewall_sentry":
		move_speed = FIREWALL_SENTRY_MOVE_SPEED
		max_hp = FIREWALL_SENTRY_MAX_HP
	hp = max_hp


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = ENEMY_COLLISION_RADIUS
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	contact_cooldown = maxf(0.0, contact_cooldown - delta)
	hit_flash_timer = maxf(0.0, hit_flash_timer - delta)

	if is_instance_valid(target):
		var direction := global_position.direction_to(target.global_position)
		velocity = direction * move_speed
		move_and_slide()

		if global_position.distance_to(target.global_position) <= ENEMY_CONTACT_RANGE and contact_cooldown <= 0.0:
			contact_damage_requested.emit(ENEMY_CONTACT_DAMAGE, kind)
			contact_cooldown = ENEMY_CONTACT_COOLDOWN

	queue_redraw()


func take_damage(amount: int) -> void:
	hp -= amount
	hit_flash_timer = HIT_FLASH_DURATION
	if hp <= 0:
		queue_free()
	else:
		queue_redraw()


func _draw() -> void:
	var color := Color(1.0, 0.16, 0.38, 1.0)
	if kind == "firewall_sentry":
		color = Color(1.0, 0.50, 0.16, 1.0)
	if hit_flash_timer > 0.0:
		color = Color(1.0, 1.0, 1.0, 1.0)

	draw_circle(Vector2.ZERO, ENEMY_OUTER_DRAW_RADIUS, Color(0.04, 0.02, 0.06, 1.0))
	draw_circle(Vector2.ZERO, ENEMY_INNER_DRAW_RADIUS, color)
	draw_arc(Vector2.ZERO, ENEMY_ARC_RADIUS, 0.0, TAU, 32, Color(1.0, 0.16, 0.38, 0.55), 2.0)
	draw_line(Vector2(-8, 0), Vector2(8, 0), Color(0.02, 0.01, 0.02, 1.0), 2.0)
