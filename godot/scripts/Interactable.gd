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
@export var interaction_type: String = ""
@export var prompt_text: String = ""
@export var is_interactable: bool = true
@export var label_offset: Vector2 = Vector2.ZERO
@export var outline_color: Color = Color("#f0ddb4")

var is_powered: bool = false
var is_used_today: bool = false
var is_low_power: bool = false
var phase_key: String = "day"

const LABEL_HEIGHT: float = 18.0
const LABEL_FONT_SIZE: int = 11
const STATUS_FONT_SIZE: int = 11
const OBJECT_DISPLAY_RULES := {
	"light": {
		"world_size": Vector2(148, 38),
		"world_offset": Vector2(0, -10),
		"world_modulate": Color(0.82, 0.78, 0.68, 0.82),
		"ui_preview_size": Vector2(260, 92),
		"z_index": 1,
	},
	"laptop": {
		"world_size": Vector2(104, 78),
		"world_offset": Vector2(0, 18),
		"world_modulate": Color(0.82, 0.8, 0.74, 0.88),
		"ui_preview_size": Vector2(300, 220),
		"z_index": 3,
	},
	"fan": {
		"world_size": Vector2(86, 104),
		"world_offset": Vector2(0, 0),
		"world_modulate": Color(0.78, 0.76, 0.68, 0.82),
		"ui_preview_size": Vector2(220, 250),
		"z_index": 3,
	},
	"charger": {
		"world_size": Vector2(48, 48),
		"world_offset": Vector2(-4, 2),
		"world_modulate": Color(0.86, 0.84, 0.78, 0.9),
		"ui_preview_size": Vector2(170, 170),
		"z_index": 3,
	},
	"communication_device": {
		"world_size": Vector2(80, 58),
		"world_offset": Vector2(0, 2),
		"world_modulate": Color(0.78, 0.74, 0.68, 0.78),
		"ui_preview_size": Vector2(250, 190),
		"z_index": 3,
		"use_world_texture": false,
	},
	"power_strip": {
		"world_size": Vector2(118, 58),
		"world_offset": Vector2(0, 0),
		"world_modulate": Color(0.82, 0.78, 0.7, 0.88),
		"ui_preview_size": Vector2(280, 140),
		"z_index": 2,
	},
}


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
	interaction_type = config.get("interaction_type", interaction_type)
	prompt_text = config.get("prompt_text", prompt_text)
	is_interactable = config.get("interactable", is_interactable)
	label_offset = config.get("label_offset", label_offset)
	outline_color = config.get("outline_color", outline_color)
	z_index = int(get_display_rule_for_object(object_id).get("z_index", 1))
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
		"interaction_type": interaction_type,
	}


func get_prompt_text() -> String:
	if prompt_text != "":
		return prompt_text

	if day1_action_key != "":
		return "[E] %s 사용" % display_name

	return "[E] %s" % display_name


func set_powered(is_active: bool) -> void:
	if is_powered == is_active:
		return

	is_powered = is_active
	queue_redraw()


func set_day1_visual_state(used_actions: Array[String], current_power: int) -> void:
	var next_used := day1_action_key != "" and used_actions.has(day1_action_key)
	var next_low_power := current_power <= 2
	if is_used_today == next_used and is_low_power == next_low_power:
		return

	is_used_today = next_used
	is_low_power = next_low_power
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
	var powered_lighten: float = 0.22 if phase_key == "night" else 0.16
	var inactive_darken: float = 0.36 if phase_key == "night" else 0.24
	var fill_color: Color = body_color.lightened(powered_lighten) if is_powered else body_color.darkened(inactive_darken)
	var active_outline: Color = Color("#d6aa4c") if is_powered else outline_color
	var normal_outline: Color = Color("#493724") if phase_key == "day" else Color("#76634b")
	var outline: Color = active_outline if is_powered else normal_outline

	# The SpriteAnchor child is intentionally empty for now. Future sprite nodes can
	# replace this rectangle without changing interaction or powered-state logic.
	if is_powered:
		var glow_alpha: float = 0.18 if phase_key == "night" else 0.12
		draw_rect(rect.grow(8.0), Color(0.95, 0.68, 0.24, glow_alpha), true)

	var texture := _get_object_texture()
	if texture != null:
		_draw_object_texture(rect, texture)
	else:
		_draw_icon(rect, fill_color, outline)

	# Labels and power status are intentionally not drawn during exploration.
	# The single proximity prompt and interaction panel carry that information.


func _get_object_texture() -> Texture2D:
	if get_display_rule_for_object(object_id).get("use_world_texture", true) == false:
		return null

	match object_id:
		"light":
			return AssetPaths.FLUORESCENT_LIGHT_ON if is_used_today else AssetPaths.FLUORESCENT_LIGHT_OFF
		"laptop":
			return AssetPaths.LAPTOP_ON if is_used_today else AssetPaths.LAPTOP_OFF
		"fan":
			return AssetPaths.FAN_ON if is_used_today else AssetPaths.FAN_OFF
		"charger":
			if is_used_today:
				return AssetPaths.PHONE_CHARGED
			if is_powered:
				return AssetPaths.PHONE_CHARGING
			return AssetPaths.PHONE_RECHARGE if is_low_power else AssetPaths.PHONE_NORMAL
		"communication_device":
			return AssetPaths.COMM_DEVICE_ON if is_used_today else AssetPaths.COMM_DEVICE_OFF
		"power_strip":
			return AssetPaths.POWERSTRIP_CONNECTED if is_powered else AssetPaths.POWERSTRIP_EMPTY

	return null


func _draw_object_texture(rect: Rect2, texture: Texture2D) -> void:
	var rule := get_display_rule_for_object(object_id)
	var texture_size: Vector2 = rule.get("world_size", rect.grow(12.0).size)
	var texture_offset: Vector2 = rule.get("world_offset", Vector2.ZERO)
	var texture_modulate: Color = rule.get("world_modulate", Color.WHITE)
	var texture_rect := Rect2(-texture_size * 0.5 + texture_offset, texture_size)

	draw_texture_rect(texture, texture_rect, false, texture_modulate)


static func get_display_rule_for_object(target_object_id: String) -> Dictionary:
	return OBJECT_DISPLAY_RULES.get(target_object_id, {})


static func get_ui_preview_size_for_object(target_object_id: String) -> Vector2:
	var rule := get_display_rule_for_object(target_object_id)
	return rule.get("ui_preview_size", Vector2(180, 140))


func _draw_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	match object_id:
		"fan":
			_draw_fan_icon(rect, fill_color, outline)
		"charger":
			_draw_charger_icon(rect, fill_color, outline)
		"light":
			_draw_light_icon(rect, fill_color, outline)
		"communication_device":
			_draw_communication_icon(rect, fill_color, outline)
		"bed":
			_draw_bed_icon(rect, fill_color, outline)
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


func _draw_light_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var cord_top := rect.position + Vector2(rect.size.x * 0.5, 0.0)
	var shade_rect := Rect2(rect.position + Vector2(rect.size.x * 0.23, rect.size.y * 0.3), Vector2(rect.size.x * 0.54, rect.size.y * 0.32))
	draw_line(cord_top, shade_rect.position + Vector2(shade_rect.size.x * 0.5, 0), outline, 2.0, true)
	draw_rect(shade_rect, fill_color, true)
	draw_rect(shade_rect, outline, false, 2.0)
	draw_circle(shade_rect.get_center() + Vector2(0, shade_rect.size.y * 0.62), 5.0, Color("#d6aa4c"))


func _draw_communication_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	var body: Rect2 = rect.grow(-10.0)
	draw_rect(body, fill_color, true)
	draw_rect(body, outline, false, 2.0)
	for index in range(3):
		draw_circle(body.position + Vector2(16.0 + float(index) * 16.0, 18.0), 3.0, Color("#d6aa4c"))
	draw_line(body.position + Vector2(body.size.x - 18.0, 12.0), body.position + Vector2(body.size.x - 4.0, -16.0), outline, 2.0, true)
	draw_line(body.position + Vector2(16.0, body.size.y - 16.0), body.position + Vector2(body.size.x - 16.0, body.size.y - 16.0), outline, 2.0, true)


func _draw_bed_icon(rect: Rect2, fill_color: Color, outline: Color) -> void:
	draw_rect(Rect2(rect.position + Vector2(5, 7), rect.size), Color(0.02, 0.018, 0.015, 0.42), true)
	draw_rect(rect, fill_color.darkened(0.2), true)
	draw_rect(rect, outline.darkened(0.12), false, 2.0)
	var mattress := rect.grow(-10.0)
	draw_rect(mattress, Color("#5d554d"), true)
	draw_rect(mattress, Color(0.85, 0.78, 0.66, 0.18), false, 1.0)
	var pillow := Rect2(mattress.position + Vector2(8.0, 8.0), Vector2(mattress.size.x * 0.26, mattress.size.y - 16.0))
	draw_rect(pillow, Color("#756a5f"), true)
	draw_rect(pillow, Color(0.95, 0.88, 0.76, 0.18), false, 1.0)
	var blanket := Rect2(mattress.position + Vector2(mattress.size.x * 0.32, 6.0), Vector2(mattress.size.x * 0.62, mattress.size.y - 12.0))
	draw_rect(blanket, Color("#403a35"), true)
	draw_rect(blanket, Color(0.9, 0.82, 0.68, 0.14), false, 1.0)
	draw_line(blanket.position + Vector2(0, blanket.size.y * 0.42), blanket.position + Vector2(blanket.size.x, blanket.size.y * 0.72), Color(0.9, 0.82, 0.68, 0.16), 1.0)


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
