extends Node2D

signal interaction_requested(object_key: String, action_key: String, payload: Dictionary)
signal nearest_interactable_changed(object_key: String, display_name: String)
signal room_back_requested
signal debug_overlay_toggled(enabled: bool)
signal player_position_changed(position: Vector2)
signal room_ready

const ACTION_PRIMARY := "primary"

const ROOM_OBJECT_PATHS := [
	"res://resources/rooms/quarterview/objects/bed.tres",
	"res://resources/rooms/quarterview/objects/laptop.tres",
	"res://resources/rooms/quarterview/objects/power.tres",
	"res://resources/rooms/quarterview/objects/phone.tres",
	"res://resources/rooms/quarterview/objects/comm.tres",
	"res://resources/rooms/quarterview/objects/node17.tres",
	"res://resources/rooms/quarterview/objects/fridge.tres",
	"res://resources/rooms/quarterview/objects/microwave.tres",
	"res://resources/rooms/quarterview/objects/aircon.tres",
	"res://resources/rooms/quarterview/objects/speaker.tres",
	"res://resources/rooms/quarterview/objects/ups.tres",
	"res://resources/rooms/quarterview/objects/signal_booster.tres",
]

const MOVE_SPEED := 230.0
const PLAYER_BOUNDS := Rect2(Vector2(180, 155), Vector2(870, 470))

var object_definitions: Array = []
var label_nodes: Dictionary = {}
var runtime_visual_states: Dictionary = {}
var connected_device_keys: Array[String] = []
var active_device_keys: Array[String] = []
var player_input_enabled := true
var debug_overlay_enabled := false
var player_position := Vector2(610, 500)
var nearest_key := ""
var nearest_display_name := ""
var room_message := ""


func _ready() -> void:
	object_definitions = _load_object_definitions()
	_build_object_labels()
	room_ready.emit()
	_update_nearest_interactable()
	queue_redraw()


func _process(delta: float) -> void:
	_update_player_movement(delta)
	_update_nearest_interactable()
	queue_redraw()


func _draw() -> void:
	_draw_room_shell()
	for definition in object_definitions:
		_draw_object_definition(definition)
	_draw_player()
	if debug_overlay_enabled:
		_draw_debug_overlay()


func set_player_input_enabled(enabled: bool) -> void:
	player_input_enabled = enabled


func set_debug_overlay_enabled(enabled: bool) -> void:
	if debug_overlay_enabled == enabled:
		return
	debug_overlay_enabled = enabled
	_set_label_visibility(debug_overlay_enabled)
	debug_overlay_toggled.emit(debug_overlay_enabled)
	queue_redraw()


func is_debug_overlay_enabled() -> bool:
	return debug_overlay_enabled


func set_connected_devices(device_keys: Array[String]) -> void:
	connected_device_keys = device_keys.duplicate()
	queue_redraw()


func set_active_devices(device_keys: Array[String]) -> void:
	active_device_keys = device_keys.duplicate()
	queue_redraw()


func set_device_visual_state(object_key: String, visual_state: String) -> void:
	runtime_visual_states[object_key] = visual_state
	queue_redraw()


func set_room_object_definitions(definitions: Array) -> void:
	object_definitions.clear()
	for definition in definitions:
		if definition is Resource and definition.has_method("is_valid_definition"):
			object_definitions.append(definition)
	_build_object_labels()
	_update_nearest_interactable()
	queue_redraw()


func get_nearest_interactable_key() -> String:
	return nearest_key


func request_nearest_interaction(action_key: String = ACTION_PRIMARY) -> void:
	if nearest_key.is_empty():
		show_room_message("No nearby interactable", 1.5)
		return

	var definition = _get_definition(nearest_key)
	if definition == null:
		return

	var payload := _make_interaction_payload(definition.zone, definition.role, definition.future_source, _get_visual_state(definition))
	payload["display_name"] = definition.display_name
	interaction_requested.emit(definition.key, action_key, payload)


func get_player_position() -> Vector2:
	return player_position


func set_player_position(position: Vector2) -> void:
	player_position = position.clamp(PLAYER_BOUNDS.position, PLAYER_BOUNDS.end)
	player_position_changed.emit(player_position)
	_update_nearest_interactable()
	queue_redraw()


func set_time_of_day_label(text: String) -> void:
	room_message = "Time hint: %s" % text
	queue_redraw()


func show_room_message(text: String, duration: float = 2.0) -> void:
	room_message = text
	queue_redraw()


func clear_room_message() -> void:
	room_message = ""
	queue_redraw()


func get_debug_text() -> String:
	return "player=(%.0f, %.0f)\nnearest=%s\nobjects=%d\nconnected=%s\nactive=%s\ndebug=%s" % [
		player_position.x,
		player_position.y,
		nearest_key if not nearest_key.is_empty() else "-",
		object_definitions.size(),
		", ".join(connected_device_keys),
		", ".join(active_device_keys),
		str(debug_overlay_enabled),
	]


func _load_object_definitions() -> Array:
	var loaded_definitions := []
	for path in ROOM_OBJECT_PATHS:
		var definition := load(path)
		if definition == null:
			push_warning("QuarterviewSandboxRoomStub could not load object definition: %s" % path)
			continue
		if not definition.is_valid_definition():
			push_warning("Invalid room object definition skipped: %s" % path)
			continue
		loaded_definitions.append(definition)
	return loaded_definitions


func _build_object_labels() -> void:
	for label in label_nodes.values():
		if label is Node:
			label.queue_free()
	label_nodes.clear()

	for definition in object_definitions:
		var label := Label.new()
		label.name = "%sLabel" % definition.key.capitalize().replace("_", "")
		label.text = "%s\n%s / %s" % [definition.display_name, definition.zone, definition.role]
		label.position = definition.position + Vector2(-definition.size.x * 0.5, -definition.size.y * 0.5 - 38.0)
		label.visible = debug_overlay_enabled
		label.add_theme_color_override("font_color", Color(0.93, 0.86, 0.70, 1.0))
		label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.014, 1.0))
		label.add_theme_constant_override("outline_size", 3)
		add_child(label)
		label_nodes[definition.key] = label


func _set_label_visibility(visible: bool) -> void:
	for label in label_nodes.values():
		if label is CanvasItem:
			label.visible = visible


func _update_player_movement(delta: float) -> void:
	if not player_input_enabled:
		return

	var input_vector := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_vector.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_vector.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_vector.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_vector.y += 1.0

	if input_vector == Vector2.ZERO:
		return

	player_position += input_vector.normalized() * MOVE_SPEED * delta
	player_position = player_position.clamp(PLAYER_BOUNDS.position, PLAYER_BOUNDS.end)
	player_position_changed.emit(player_position)


func _update_nearest_interactable() -> void:
	var best_key := ""
	var best_display_name := ""
	var best_distance := INF

	for definition in object_definitions:
		if not definition.interactable:
			continue
		var interaction_position: Vector2 = definition.get_interaction_position()
		var distance := player_position.distance_to(interaction_position)
		if distance <= definition.interaction_radius and distance < best_distance:
			best_key = definition.key
			best_display_name = definition.display_name
			best_distance = distance

	if best_key == nearest_key:
		return

	nearest_key = best_key
	nearest_display_name = best_display_name
	nearest_interactable_changed.emit(nearest_key, nearest_display_name)


func _get_definition(object_key: String):
	for definition in object_definitions:
		if definition.key == object_key:
			return definition
	return null


func _get_visual_state(definition) -> String:
	return String(runtime_visual_states.get(definition.key, definition.visual_state))


func _make_interaction_payload(zone: String, role: String, future_source: String, visual_state: String) -> Dictionary:
	return {
		"zone": zone,
		"role": role,
		"future_source": future_source,
		"visual_state": visual_state,
	}


func _draw_room_shell() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color(0.025, 0.028, 0.036, 1.0))

	draw_polygon(
		PackedVector2Array([
			Vector2(235, 135),
			Vector2(1015, 135),
			Vector2(1115, 570),
			Vector2(330, 640),
			Vector2(170, 370),
		]),
		PackedColorArray([Color(0.13, 0.12, 0.105, 1.0)])
	)
	draw_polygon(
		PackedVector2Array([
			Vector2(235, 75),
			Vector2(1015, 75),
			Vector2(1015, 135),
			Vector2(235, 135),
		]),
		PackedColorArray([Color(0.18, 0.175, 0.16, 1.0)])
	)
	draw_polygon(
		PackedVector2Array([
			Vector2(170, 150),
			Vector2(235, 75),
			Vector2(235, 135),
			Vector2(170, 370),
			Vector2(150, 600),
			Vector2(115, 555),
		]),
		PackedColorArray([Color(0.11, 0.105, 0.1, 1.0)])
	)
	draw_line(Vector2(235, 135), Vector2(1015, 135), Color(0.66, 0.55, 0.38, 0.35), 2.0)


func _draw_object_definition(definition) -> void:
	var size: Vector2 = definition.size
	var half: Vector2 = size * 0.5
	var rect := Rect2(definition.position - half, size)
	var color: Color = definition.color
	var state: String = _get_visual_state(definition)

	if active_device_keys.has(definition.key) or state in ["on", "active", "charging", "signal"]:
		color = color.lightened(0.22)
	elif connected_device_keys.has(definition.key):
		color = color.lightened(0.10)

	draw_rect(Rect2(rect.position + Vector2(7, 10), rect.size), Color(0.0, 0.0, 0.0, 0.24), true)
	draw_rect(rect, color, true)
	draw_rect(rect, Color(0.86, 0.70, 0.42, 0.45), false, 2.0)

	if definition.key == nearest_key:
		draw_rect(rect.grow(4.0), Color(0.96, 0.82, 0.46, 0.85), false, 3.0)


func _draw_player() -> void:
	draw_circle(player_position + Vector2(7, 12), 18.0, Color(0.0, 0.0, 0.0, 0.28))
	draw_circle(player_position, 15.0, Color(0.10, 0.13, 0.16, 1.0))
	draw_rect(Rect2(player_position + Vector2(-7, -24), Vector2(14, 28)), Color(0.16, 0.16, 0.18, 1.0), true)
	draw_line(player_position + Vector2(-12, 2), player_position + Vector2(12, 2), Color(0.88, 0.76, 0.52, 0.65), 2.0)


func _draw_debug_overlay() -> void:
	draw_rect(PLAYER_BOUNDS, Color(0.42, 0.68, 0.96, 0.32), false, 2.0)
	for definition in object_definitions:
		draw_arc(definition.get_interaction_position(), definition.interaction_radius, 0.0, TAU, 48, Color(0.30, 0.84, 0.78, 0.34), 2.0)
		if definition.blocks:
			draw_rect(Rect2(definition.position - definition.get_collision_size() * 0.5, definition.get_collision_size()), Color(0.95, 0.28, 0.28, 0.35), false, 2.0)

	if not room_message.is_empty():
		draw_rect(Rect2(Vector2(470, 620), Vector2(340, 34)), Color(0.03, 0.026, 0.02, 0.74), true)
