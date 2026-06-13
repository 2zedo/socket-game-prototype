extends Area2D
class_name ApartmentInteractable

@export var object_id: String = ""
@export var display_name: String = "Object"
@export var action_title: String = "상호작용"
@export_multiline var action_body: String = "아직 연결되지 않은 임시 상호작용입니다."
@export var body_size: Vector2 = Vector2(96, 64)
@export var body_color: Color = Color("#b8a889")
@export var power_watts: int = 0
@export var power_units: int = 0
@export var day1_action_key: String = ""
@export var is_interactable: bool = true
@export var label_offset: Vector2 = Vector2.ZERO
@export var outline_color: Color = Color("#f0ddb4")

var is_powered: bool = false
var phase_key: String = "day"

const LABEL_HEIGHT: float = 18.0
const LABEL_FONT_SIZE: int = 12
const STATUS_FONT_SIZE: int = 12


func setup(config: Dictionary) -> void:
	object_id = config.get("id", object_id)
	display_name = config.get("name", display_name)
	action_title = config.get("title", action_title)
	action_body = config.get("body", action_body)
	body_size = config.get("size", body_size)
	body_color = config.get("color", body_color)
	power_watts = config.get("watts", power_watts)
	power_units = config.get("power_units", power_units)
	day1_action_key = config.get("day1_action_key", day1_action_key)
	is_interactable = config.get("interactable", is_interactable)
	label_offset = config.get("label_offset", label_offset)
	outline_color = config.get("outline_color", outline_color)
	_update_collision_shape()
	queue_redraw()


func _ready() -> void:
	if is_interactable:
		add_to_group("interactables")
	_update_collision_shape()


func get_interaction_data() -> Dictionary:
	return {
		"id": object_id,
		"name": display_name,
		"title": action_title,
		"body": action_body,
		"watts": power_watts,
		"power_units": power_units,
		"day1_action_key": day1_action_key,
	}


func set_powered(is_active: bool) -> void:
	if is_powered == is_active:
		return

	is_powered = is_active
	queue_redraw()


func set_phase(next_phase_key: String) -> void:
	if phase_key == next_phase_key:
		return

	phase_key = next_phase_key
	queue_redraw()


func _update_collision_shape() -> void:
	var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null:
		return

	var rectangle: RectangleShape2D = RectangleShape2D.new()
	rectangle.size = body_size
	collision_shape.shape = rectangle


func _draw() -> void:
	var rect: Rect2 = Rect2(-body_size * 0.5, body_size)
	var powered_lighten: float = 0.34 if phase_key == "night" else 0.24
	var inactive_darken: float = 0.24 if phase_key == "night" else 0.14
	var fill_color: Color = body_color.lightened(powered_lighten) if is_powered else body_color.darkened(inactive_darken)
	var active_outline: Color = Color("#ffe066") if is_powered else outline_color
	var normal_outline: Color = Color("#5a3a22") if phase_key == "day" else Color("#8b8fa3")
	var outline: Color = active_outline if is_powered else normal_outline

	# The SpriteAnchor child is intentionally empty for now. Future sprite nodes can
	# replace this rectangle without changing interaction or powered-state logic.
	if is_powered:
		var glow_alpha: float = 0.28 if phase_key == "night" else 0.18
		draw_rect(rect.grow(6.0), Color(1.0, 0.86, 0.22, glow_alpha), true)

	_draw_icon(rect, fill_color, outline)

	var label_width: float = maxf(body_size.x + 56.0, 120.0)
	var label_position: Vector2 = Vector2(-label_width * 0.5, -body_size.y * 0.5 - LABEL_HEIGHT + 2.0) + label_offset
	draw_string(ThemeDB.fallback_font, label_position, display_name, HORIZONTAL_ALIGNMENT_CENTER, label_width, LABEL_FONT_SIZE, Color("#f8ecd2"))

	if power_watts > 0 or power_units > 0:
		var state_text: String = "작동 중" if is_powered else "꺼짐"
		var state_color: Color = Color("#ffe066") if is_powered else Color("#5f4b39")
		var status_position: Vector2 = Vector2(-label_width * 0.5, body_size.y * 0.5 + 16.0)
		draw_string(ThemeDB.fallback_font, status_position, state_text, HORIZONTAL_ALIGNMENT_CENTER, label_width, STATUS_FONT_SIZE, state_color)


func _draw_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	match object_id:
		"fan":
			_draw_fan_icon(rect, fill_color, outline)
		"charger":
			_draw_charger_icon(rect, fill_color, outline)
		"power_strip":
			_draw_power_strip_icon(rect, fill_color, outline)
		"microwave":
			_draw_microwave_icon(rect, fill_color, outline)
		"laptop":
			_draw_laptop_icon(rect, fill_color, outline)
		_:
			draw_rect(rect, fill_color, true)
			draw_rect(rect, outline, false, 2.0)


func _draw_fan_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var center: Vector2 = rect.get_center()
	var radius: float = minf(rect.size.x, rect.size.y) * 0.34
	draw_circle(center, radius, fill_color)
	draw_arc(center, radius, 0.0, TAU, 40, outline, 2.0, true)
	draw_circle(center, radius * 0.14, outline)
	for index in range(3):
		var angle: float = TAU * float(index) / 3.0
		var blade_end: Vector2 = center + Vector2(cos(angle), sin(angle)) * radius * 0.78
		draw_line(center, blade_end, outline, 5.0, true)
	draw_line(center + Vector2(0.0, radius), center + Vector2(0.0, radius + 16.0), outline, 3.0, true)
	draw_line(center + Vector2(-18.0, radius + 16.0), center + Vector2(18.0, radius + 16.0), outline, 3.0, true)


func _draw_charger_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var block: Rect2 = rect.grow(-12.0)
	block.size.y *= 0.72
	block.position.y += 8.0
	draw_rect(block, fill_color, true)
	draw_rect(block, outline, false, 2.0)
	var prong_y: float = block.position.y - 10.0
	draw_line(Vector2(block.position.x + block.size.x * 0.36, block.position.y), Vector2(block.position.x + block.size.x * 0.36, prong_y), outline, 2.0, true)
	draw_line(Vector2(block.position.x + block.size.x * 0.64, block.position.y), Vector2(block.position.x + block.size.x * 0.64, prong_y), outline, 2.0, true)
	draw_circle(block.get_center(), 5.0, Color("#f4e3c3"))


func _draw_power_strip_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var strip: Rect2 = rect.grow(-8.0)
	draw_rect(strip, fill_color, true)
	draw_rect(strip, outline, false, 2.0)
	for index in range(4):
		var x: float = strip.position.x + strip.size.x * (0.18 + 0.21 * float(index))
		var socket_center: Vector2 = Vector2(x, strip.get_center().y)
		draw_circle(socket_center, 9.0, Color("#f6ead6"))
		draw_circle(socket_center + Vector2(-3.0, 0.0), 1.7, outline)
		draw_circle(socket_center + Vector2(3.0, 0.0), 1.7, outline)


func _draw_microwave_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var body: Rect2 = rect.grow(-8.0)
	draw_rect(body, fill_color, true)
	draw_rect(body, outline, false, 2.0)
	var screen: Rect2 = Rect2(body.position + Vector2(10.0, 12.0), Vector2(body.size.x * 0.55, body.size.y - 24.0))
	draw_rect(screen, Color("#3b3f45"), true)
	draw_rect(screen, outline.darkened(0.2), false, 1.5)
	var button_x: float = body.position.x + body.size.x - 22.0
	for index in range(3):
		draw_circle(Vector2(button_x, body.position.y + 18.0 + float(index) * 13.0), 3.0, Color("#f6e7c7"))


func _draw_laptop_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var screen: Rect2 = Rect2(rect.position + Vector2(14.0, 8.0), Vector2(rect.size.x - 28.0, rect.size.y * 0.58))
	var base: Rect2 = Rect2(rect.position + Vector2(6.0, rect.size.y * 0.72), Vector2(rect.size.x - 12.0, 10.0))
	draw_rect(screen, fill_color, true)
	draw_rect(screen, outline, false, 2.0)
	draw_rect(screen.grow(-8.0), Color("#26343a"), true)
	draw_rect(base, fill_color.darkened(0.12), true)
	draw_rect(base, outline, false, 2.0)
