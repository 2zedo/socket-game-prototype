extends Control
class_name OutletMode

signal closed
signal power_changed(total_power: int)
signal powered_devices_changed(device_keys: Array[String])
signal connection_state_changed(slot_occupancy: Array)
signal breaker_tripped

const OUTLET_COUNT: int = SurvivalState.DAY1_MAX_OUTLET_SLOTS
const PANEL_MARGIN: float = 46.0
const STRIP_SIZE: Vector2 = Vector2(620.0, 465.0)
const SLOT_HIT_SIZE: Vector2 = Vector2(62.0, 92.0)
const SINGLE_ADAPTER_SIZE: Vector2 = Vector2(66.0, 154.0)
const LAPTOP_ADAPTER_SIZE: Vector2 = Vector2(190.0, 190.0)
const CONNECTED_SINGLE_ADAPTER_WIDTH: float = 46.0
const CONNECTED_LAPTOP_ADAPTER_SIZE: Vector2 = Vector2(132.0, 132.0)
const HOME_GAP: float = 44.0
const DROP_DISTANCE: float = 96.0
const CLICK_DISCONNECT_DISTANCE: float = 5.0
const SLOT_CENTER_RATIOS: Array[Vector2] = [
	Vector2(0.245856, 0.418048),
	Vector2(0.416436, 0.418048),
	Vector2(0.587017, 0.418048),
	Vector2(0.755525, 0.418048),
]
const BUILT_IN_LED_Y_RATIO: float = 0.6372
const BUILT_IN_LED_MASK_SIZE: Vector2 = Vector2(13.0, 10.0)
# Connected-only visual tuning. Adjust these values while reviewing the outlet
# screen; zero offset and unit scale preserve the current adapter placement.
const CONNECTED_ADAPTER_TUNING: Dictionary = {
	"fan": {"offset": Vector2.ZERO, "scale": Vector2.ONE},
	"charger": {"offset": Vector2.ZERO, "scale": Vector2.ONE},
	"communication_device": {"offset": Vector2.ZERO, "scale": Vector2.ONE},
	"light": {"offset": Vector2.ZERO, "scale": Vector2.ONE},
	"laptop": {"offset": Vector2.ZERO, "scale": Vector2.ONE},
}

var survival_state: SurvivalState
var occupied_slots: Array = []
var devices: Array[Dictionary] = []
var dragging_device: Dictionary = {}
var drag_offset: Vector2 = Vector2.ZERO
var drag_start_mouse_position: Vector2 = Vector2.ZERO
var drag_started_connected: bool = false
var status_text: String = "어댑터를 끌어 멀티탭 슬롯에 꽂으세요"
var test_mode_enabled: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_reset_slots()
	_create_devices()
	set_process(false)


func open(state: SurvivalState) -> void:
	survival_state = state
	visible = true
	status_text = "어댑터를 끌어 멀티탭 슬롯에 꽂으세요"
	_sync_devices_from_state()
	set_process(true)
	_emit_connection_state()
	queue_redraw()


func close() -> void:
	if not visible:
		return

	if not dragging_device.is_empty():
		_send_device_home(dragging_device)

	dragging_device = {}
	visible = false
	set_process(false)
	closed.emit()


func _gui_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_button: InputEventMouseButton = event as InputEventMouseButton
		if mouse_button.pressed:
			_start_drag(mouse_button.position)
		else:
			_finish_drag(mouse_button.position)
		accept_event()
	elif event is InputEventMouseMotion and not dragging_device.is_empty():
		var mouse_motion: InputEventMouseMotion = event as InputEventMouseMotion
		dragging_device["position"] = mouse_motion.position + drag_offset
		queue_redraw()
		accept_event()


func _draw() -> void:
	if not visible:
		return

	draw_rect(Rect2(Vector2.ZERO, size), Color(0.018, 0.017, 0.016, 0.86), true)

	_draw_text(Vector2(PANEL_MARGIN, 56.0), "멀티탭 관리", 28, UIStyle.TEXT)
	_draw_text(Vector2(PANEL_MARGIN, 84.0), "ESC: 아파트로 돌아가기", 14, UIStyle.MUTED)
	_draw_connection_summary()
	_draw_power_strip()
	_draw_slot_feedback()
	_draw_devices()
	_draw_text(Vector2(PANEL_MARGIN, size.y - 38.0), status_text, 16, UIStyle.TEXT)
	if test_mode_enabled:
		_draw_test_hitboxes()


func set_test_mode_enabled(is_enabled: bool) -> void:
	test_mode_enabled = is_enabled
	queue_redraw()


func _draw_test_hitboxes() -> void:
	for index in range(OUTLET_COUNT):
		var slot_rect: Rect2 = _get_slot_rect(index)
		draw_rect(slot_rect, Color(1.0, 0.52, 0.08, 0.14), true)
		draw_rect(slot_rect, Color(1.0, 0.58, 0.12, 0.95), false, 2.0)

	for device in devices:
		var device_rect: Rect2 = _get_device_rect(device)
		draw_rect(device_rect, Color(1.0, 0.7, 0.2, 0.82), false, 1.5)
		var plug_position: Vector2 = _get_device_plug_position(device)
		draw_circle(plug_position, 4.0, Color(1.0, 0.32, 0.12, 0.95))

	if not dragging_device.is_empty():
		var dragging_rect: Rect2 = _get_device_rect(dragging_device)
		draw_rect(dragging_rect, Color(1.0, 0.9, 0.25, 0.95), false, 2.5)


func _draw_connection_summary() -> void:
	var connected_labels: Array[String] = []
	for device in devices:
		if int(device["connected_start"]) >= 0:
			connected_labels.append(str(device["label"]))

	var connected_text: String = "없음" if connected_labels.is_empty() else ", ".join(connected_labels)
	var summary: String = "사용 슬롯: %d / %d\n연결 기기: %s" % [
		_get_used_slots(),
		OUTLET_COUNT,
		connected_text,
	]
	_draw_text(Vector2(size.x - 360.0, 58.0), summary, 16, UIStyle.TEXT)


func _draw_power_strip() -> void:
	var strip_rect: Rect2 = _get_strip_rect()
	draw_texture_rect(AssetPaths.POWERSTRIP_4SLOT, strip_rect, false, Color.WHITE)

	for index in range(OUTLET_COUNT):
		if occupied_slots[index] != null:
			continue

		# The texture already contains one green LED per slot. Empty slots only mask
		# that exact artwork so occupied slots reveal the original lit LED unchanged.
		var led_center := strip_rect.position + Vector2(
			strip_rect.size.x * SLOT_CENTER_RATIOS[index].x,
			strip_rect.size.y * BUILT_IN_LED_Y_RATIO
		)
		var led_mask := Rect2(led_center - BUILT_IN_LED_MASK_SIZE * 0.5, BUILT_IN_LED_MASK_SIZE)
		draw_rect(led_mask, Color(0.015, 0.018, 0.014, 0.82), true)


func _draw_slot_feedback() -> void:
	if dragging_device.is_empty():
		return

	var target_slot: int = _find_target_slot(dragging_device)
	if target_slot < 0:
		return

	var target_valid: bool = _can_use_slots(dragging_device, target_slot)
	var requested_slots: int = int(dragging_device["slots"])
	var visible_slots: int = mini(requested_slots, OUTLET_COUNT - target_slot)
	var fill_color: Color = Color(0.48, 0.88, 0.38, 0.3) if target_valid else Color(0.9, 0.18, 0.14, 0.34)
	var line_color: Color = Color(0.72, 1.0, 0.52, 1.0) if target_valid else Color(1.0, 0.25, 0.18, 1.0)

	# Draw each occupied slot, then bind multi-slot adapters with one outer frame.
	for slot_offset in range(visible_slots):
		var slot_rect: Rect2 = _get_slot_rect(target_slot + slot_offset).grow(5.0)
		draw_rect(slot_rect, fill_color, true)
		draw_rect(slot_rect, line_color, false, 2.5)

	var target_rect: Rect2 = _get_slot_group_rect(target_slot, maxi(visible_slots, 1)).grow(11.0)
	draw_rect(target_rect, line_color, false, 3.0)


func _find_target_slot(device: Dictionary) -> int:
	var probe_position: Vector2 = _get_device_plug_position(device)
	for slot_index in range(OUTLET_COUNT):
		if _get_slot_rect(slot_index).has_point(probe_position):
			return slot_index

	# Preserve the existing nearby-drop affordance outside the exact hit rectangle.
	return _find_best_slot(device)


func _draw_devices() -> void:
	for device in devices:
		if not dragging_device.is_empty() and str(device["key"]) == str(dragging_device["key"]):
			continue
		_draw_device(device, false)

	if not dragging_device.is_empty():
		_draw_device(dragging_device, true)


func _draw_device(device: Dictionary, is_dragging: bool) -> void:
	var rect: Rect2 = _get_device_rect(device)
	var texture: Texture2D = _get_adapter_texture(str(device["key"]))
	if texture == null:
		return

	var is_connected: bool = int(device["connected_start"]) >= 0 and not is_dragging
	var visible_rect: Rect2 = _get_adapter_visible_rect(str(device["key"]), rect)
	if is_connected:
		_draw_adapter_contact_shadow(visible_rect)

	var tint: Color = Color(1.0, 1.0, 1.0, 0.82) if is_dragging else Color.WHITE
	draw_texture_rect(texture, rect, false, tint)

	if is_connected:
		_draw_adapter_insert_cover(device, rect)
	elif is_dragging:
		draw_rect(visible_rect.grow(2.0), Color(0.95, 0.84, 0.48, 0.76), false, 1.4)
	else:
		_draw_centered_text(Vector2(rect.get_center().x, rect.end.y + 20.0), str(device["label"]), 13, UIStyle.TEXT)


func _draw_text(position: Vector2, text: String, font_size: int, color: Color) -> void:
	draw_multiline_string(ThemeDB.fallback_font, position, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, -1, color)


func _draw_centered_text(position: Vector2, text: String, font_size: int, color: Color) -> void:
	var text_size: Vector2 = ThemeDB.fallback_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	draw_string(ThemeDB.fallback_font, position - Vector2(text_size.x * 0.5, 0.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, color)


func _draw_adapter_contact_shadow(rect: Rect2) -> void:
	var shadow_rect: Rect2 = Rect2(
		rect.position + Vector2(2.0, 4.0),
		rect.size
	).grow(1.5)
	draw_rect(shadow_rect, Color(0.0, 0.0, 0.0, 0.18), true)


func _draw_adapter_insert_cover(device: Dictionary, rect: Rect2) -> void:
	var insert_position: Vector2 = _get_device_plug_position(device)
	var cover_size: Vector2 = Vector2(22.0, 14.0) if str(device["key"]) != "laptop" else Vector2(16.0, 10.0)
	var cover_rect: Rect2 = Rect2(insert_position - cover_size * 0.5 + Vector2(0.0, 3.0), cover_size)
	draw_rect(cover_rect, Color(0.035, 0.03, 0.026, 0.46), true)


func _get_adapter_visible_rect(key: String, rect: Rect2) -> Rect2:
	var ratios: Rect2
	match key:
		"fan":
			ratios = Rect2(0.1406, 0.0627, 0.7282, 0.9373)
		"communication_device":
			ratios = Rect2(0.1308, 0.0946, 0.7704, 0.9054)
		"laptop":
			ratios = Rect2(0.0930, 0.2270, 0.9070, 0.5200)
		"charger":
			ratios = Rect2(0.1536, 0.0456, 0.7048, 0.9544)
		"light":
			ratios = Rect2(0.1149, 0.0757, 0.7547, 0.9243)
		_:
			ratios = Rect2(0.0, 0.0, 1.0, 1.0)

	return Rect2(
		rect.position + Vector2(rect.size.x * ratios.position.x, rect.size.y * ratios.position.y),
		Vector2(rect.size.x * ratios.size.x, rect.size.y * ratios.size.y)
	)


func _start_drag(mouse_position: Vector2) -> void:
	for index in range(devices.size() - 1, -1, -1):
		var device: Dictionary = devices[index]
		var rect: Rect2 = _get_device_rect(device)
		if not rect.has_point(mouse_position):
			continue

		dragging_device = device
		drag_start_mouse_position = mouse_position
		drag_started_connected = int(device["connected_start"]) >= 0
		device["drag_size"] = rect.size
		device["position"] = rect.get_center()
		drag_offset = device["position"] - mouse_position
		_disconnect_device(device)
		devices.remove_at(index)
		devices.append(device)
		status_text = "%s 이동 중" % device["label"]
		_emit_connection_state()
		queue_redraw()
		return


func _finish_drag(mouse_position: Vector2) -> void:
	if dragging_device.is_empty():
		return

	var moved_distance: float = mouse_position.distance_to(drag_start_mouse_position)
	if drag_started_connected and moved_distance <= CLICK_DISCONNECT_DISTANCE:
		_send_device_home(dragging_device)
		status_text = "%s 연결 해제" % dragging_device["label"]
		dragging_device = {}
		_emit_connection_state()
		queue_redraw()
		return

	# Preview and drop must resolve the same start slot, especially for 2-slot devices.
	var target_slot: int = _find_target_slot(dragging_device)
	if target_slot >= 0 and _can_use_slots(dragging_device, target_slot):
		_connect_device(dragging_device, target_slot)
	else:
		_send_device_home(dragging_device)
		status_text = "놓을 수 없는 슬롯입니다"
		_emit_connection_state()

	dragging_device = {}
	queue_redraw()


func _connect_device(device: Dictionary, start_slot: int) -> void:
	for slot in range(start_slot, start_slot + int(device["slots"])):
		occupied_slots[slot] = device["key"]

	device["connected_start"] = start_slot
	device.erase("drag_size")
	device["position"] = _get_connected_device_rect(device).get_center()
	status_text = "%s 연결됨" % device["label"]
	_layout_device_homes()
	_emit_connection_state()


func _disconnect_device(device: Dictionary) -> void:
	for index in range(occupied_slots.size()):
		if occupied_slots[index] == device["key"]:
			occupied_slots[index] = null

	device["connected_start"] = -1


func _send_device_home(device: Dictionary) -> void:
	_disconnect_device(device)
	device.erase("drag_size")
	_layout_device_homes()


func _find_best_slot(device: Dictionary) -> int:
	var best_slot: int = -1
	var best_distance: float = DROP_DISTANCE
	var slots: int = int(device["slots"])
	var probe_position: Vector2 = _get_device_plug_position(device)

	for start_slot in range(OUTLET_COUNT):
		if start_slot + slots > OUTLET_COUNT:
			continue

		var target_center: Vector2 = _get_slot_group_rect(start_slot, slots).get_center()
		var distance: float = probe_position.distance_to(target_center)
		if distance < best_distance:
			best_slot = start_slot
			best_distance = distance

	return best_slot


func _can_use_slots(device: Dictionary, start_slot: int) -> bool:
	var slots: int = int(device["slots"])
	if start_slot < 0 or start_slot + slots > OUTLET_COUNT:
		return false

	for slot in range(start_slot, start_slot + slots):
		if occupied_slots[slot] != null:
			return false

	return true


func _get_strip_rect() -> Rect2:
	return Rect2(Vector2(size.x * 0.5, 270.0) - STRIP_SIZE * 0.5, STRIP_SIZE)


func _get_slot_rect(index: int) -> Rect2:
	var strip_rect: Rect2 = _get_strip_rect()
	var ratio: Vector2 = SLOT_CENTER_RATIOS[index]
	var center: Vector2 = strip_rect.position + Vector2(strip_rect.size.x * ratio.x, strip_rect.size.y * ratio.y)
	return Rect2(center - SLOT_HIT_SIZE * 0.5, SLOT_HIT_SIZE)


func _get_slot_group_rect(start_slot: int, slots: int) -> Rect2:
	var first_rect: Rect2 = _get_slot_rect(start_slot)
	var last_rect: Rect2 = _get_slot_rect(start_slot + slots - 1)
	return Rect2(first_rect.position, Vector2(last_rect.end.x - first_rect.position.x, first_rect.size.y))


func _get_device_rect(device: Dictionary) -> Rect2:
	if device.has("drag_size"):
		var drag_size: Vector2 = device["drag_size"]
		return Rect2(Vector2(device["position"]) - drag_size * 0.5, drag_size)

	if int(device["connected_start"]) >= 0:
		return _get_connected_device_rect(device)

	var home_size: Vector2 = _get_home_device_size(str(device["key"]))
	return Rect2(Vector2(device["position"]) - home_size * 0.5, home_size)


func _get_connected_device_rect(device: Dictionary) -> Rect2:
	var start_slot: int = int(device["connected_start"])
	var key: String = str(device["key"])
	var tuning: Dictionary = CONNECTED_ADAPTER_TUNING.get(key, {})
	var connected_scale: Vector2 = tuning.get("scale", Vector2.ONE)
	var connected_offset: Vector2 = tuning.get("offset", Vector2.ZERO)
	var device_size: Vector2 = _get_connected_device_size(key) * connected_scale
	var insert_position: Vector2 = _get_slot_insert_position(start_slot) + connected_offset
	var anchor_ratio: Vector2 = _get_insert_anchor_ratio(key)
	return Rect2(insert_position - Vector2(device_size.x * anchor_ratio.x, device_size.y * anchor_ratio.y), device_size)


func _get_device_plug_position(device: Dictionary) -> Vector2:
	var rect: Rect2 = _get_device_rect(device)
	var anchor_ratio: Vector2 = _get_insert_anchor_ratio(str(device["key"]))
	return rect.position + Vector2(rect.size.x * anchor_ratio.x, rect.size.y * anchor_ratio.y)


func _get_total_power() -> int:
	var total: int = 0
	for device in devices:
		if int(device["connected_start"]) >= 0:
			total += int(device["watts"])
	return total


func _get_used_slots() -> int:
	var used_slots: int = 0
	for slot_key in occupied_slots:
		if slot_key != null:
			used_slots += 1
	return used_slots


func _get_powered_device_keys() -> Array[String]:
	var keys: Array[String] = []
	for device in devices:
		if int(device["connected_start"]) >= 0:
			keys.append(str(device["key"]))
	return keys


func _emit_connection_state() -> void:
	power_changed.emit(_get_total_power())
	powered_devices_changed.emit(_get_powered_device_keys())
	connection_state_changed.emit(occupied_slots.duplicate())


func _reset_slots() -> void:
	occupied_slots.clear()
	for _index in range(OUTLET_COUNT):
		occupied_slots.append(null)


func _create_devices() -> void:
	devices = [
		_make_day1_device("fan"),
		_make_day1_device("communication_device"),
		_make_day1_device("laptop"),
		_make_day1_device("charger"),
		_make_day1_device("light"),
	]
	_layout_device_homes()


func _make_day1_device(key: String) -> Dictionary:
	var action_data: Dictionary = SurvivalState.get_day1_device_data(key)
	return {
		"key": key,
		"label": _get_display_label(key, str(action_data.get("label", key))),
		"watts": int(action_data.get("watt_usage", 0)),
		"slots": int(action_data.get("outlet_size", 1)),
		"home_position": Vector2.ZERO,
		"position": Vector2.ZERO,
		"connected_start": -1,
	}


func _layout_device_homes() -> void:
	if devices.is_empty():
		return

	var total_width: float = -HOME_GAP
	for device in devices:
		total_width += _get_home_device_size(str(device["key"])).x + HOME_GAP

	var cursor_x: float = size.x * 0.5 - total_width * 0.5
	var home_center_y: float = size.y - 104.0
	for device in devices:
		var device_size: Vector2 = _get_home_device_size(str(device["key"]))
		var home_position: Vector2 = Vector2(cursor_x + device_size.x * 0.5, home_center_y)
		device["home_position"] = home_position
		if int(device["connected_start"]) < 0 and (dragging_device.is_empty() or str(device["key"]) != str(dragging_device.get("key", ""))):
			device["position"] = home_position
		cursor_x += device_size.x + HOME_GAP


func _sync_devices_from_state() -> void:
	_reset_slots()
	for device in devices:
		device["connected_start"] = -1
		device.erase("drag_size")

	if survival_state != null and survival_state.powerstrip_slot_occupancy.size() == OUTLET_COUNT:
		var connected_starts: Dictionary = {}
		for slot in range(OUTLET_COUNT):
			var raw_key: Variant = survival_state.powerstrip_slot_occupancy[slot]
			if raw_key == null:
				continue

			var key: String = str(raw_key)
			var device: Dictionary = _get_device_by_key(key)
			if device.is_empty():
				continue

			occupied_slots[slot] = key
			if not connected_starts.has(key):
				connected_starts[key] = slot

		for key in connected_starts.keys():
			var device: Dictionary = _get_device_by_key(str(key))
			if not device.is_empty():
				device["connected_start"] = int(connected_starts[key])
				device["position"] = _get_connected_device_rect(device).get_center()
	elif survival_state != null:
		for key in survival_state.powered_devices:
			var device: Dictionary = _get_device_by_key(str(key))
			if device.is_empty():
				continue

			var start_slot: int = _find_first_available_slot(device)
			if start_slot < 0:
				continue

			for slot in range(start_slot, start_slot + int(device["slots"])):
				occupied_slots[slot] = device["key"]
			device["connected_start"] = start_slot

	_layout_device_homes()


func _get_device_by_key(key: String) -> Dictionary:
	for device in devices:
		if str(device["key"]) == key:
			return device
	return {}


func _find_first_available_slot(device: Dictionary) -> int:
	for slot in range(OUTLET_COUNT):
		if _can_use_slots(device, slot):
			return slot
	return -1


func _get_adapter_texture(key: String) -> Texture2D:
	match key:
		"fan":
			return AssetPaths.ADAPTER_FAN
		"communication_device":
			return AssetPaths.ADAPTER_COMMUNICATION
		"laptop":
			return AssetPaths.ADAPTER_LAPTOP
		"charger":
			return AssetPaths.ADAPTER_CHARGER
		"light":
			return AssetPaths.ADAPTER_LAMP
		_:
			return null


func _get_home_device_size(key: String) -> Vector2:
	if key == "laptop":
		return LAPTOP_ADAPTER_SIZE
	var texture: Texture2D = _get_adapter_texture(key)
	if texture == null:
		return SINGLE_ADAPTER_SIZE

	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return SINGLE_ADAPTER_SIZE

	return Vector2(SINGLE_ADAPTER_SIZE.y * texture_size.x / texture_size.y, SINGLE_ADAPTER_SIZE.y)


func _get_connected_device_size(key: String) -> Vector2:
	if key == "laptop":
		return CONNECTED_LAPTOP_ADAPTER_SIZE

	var texture: Texture2D = _get_adapter_texture(key)
	if texture == null:
		return Vector2(CONNECTED_SINGLE_ADAPTER_WIDTH, CONNECTED_SINGLE_ADAPTER_WIDTH * 2.2)

	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return Vector2(CONNECTED_SINGLE_ADAPTER_WIDTH, CONNECTED_SINGLE_ADAPTER_WIDTH * 2.2)

	return Vector2(CONNECTED_SINGLE_ADAPTER_WIDTH, CONNECTED_SINGLE_ADAPTER_WIDTH * texture_size.y / texture_size.x)


func _get_slot_insert_position(index: int) -> Vector2:
	return _get_slot_rect(index).get_center()


func _get_insert_anchor_ratio(key: String) -> Vector2:
	if key == "laptop":
		return Vector2(0.18, 0.42)
	return Vector2(0.5, 0.7)


func _get_display_label(key: String, fallback: String) -> String:
	match key:
		"fan":
			return "선풍기"
		"communication_device":
			return "통신장치"
		"laptop":
			return "노트북"
		"charger":
			return "충전기"
		"light":
			return "램프"
		_:
			return fallback
