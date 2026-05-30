extends Control
class_name OutletMode

signal closed
signal power_changed(total_power: int)
signal powered_devices_changed(device_keys: Array[String])
signal breaker_tripped

const MAX_POWER_WATTS := 3000
const OUTLET_COUNT := 4
const SLOT_SIZE := Vector2(92, 82)
const SLOT_GAP := 18.0
const STRIP_SIZE := Vector2(560, 132)
const DEVICE_HEIGHT := 64.0
const BREAKER_SECONDS := 1.4
const PANEL_SIZE := Vector2(1120, 620)

var survival_state: SurvivalState
var occupied_slots: Array = []
var devices: Array[Dictionary] = []
var dragging_device: Dictionary = {}
var drag_offset := Vector2.ZERO
var breaker_timer := 0.0
var status_text := "기기를 콘센트에 끌어다 놓으세요"


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_reset_slots()
	_create_devices()
	set_process(false)


func open(state: SurvivalState) -> void:
	survival_state = state
	visible = true
	_layout_device_homes()
	status_text = "기기를 콘센트에 끌어다 놓으세요"
	set_process(true)
	power_changed.emit(_get_total_power())
	powered_devices_changed.emit(_get_powered_device_keys())
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


func _process(delta: float) -> void:
	if breaker_timer > 0.0:
		breaker_timer -= delta
		if breaker_timer <= 0.0:
			status_text = "차단기 복구됨. 전력을 줄여보세요."
		queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag(event.position)
		else:
			_finish_drag()
		accept_event()
	elif event is InputEventMouseMotion and not dragging_device.is_empty():
		dragging_device["position"] = event.position + drag_offset
		queue_redraw()
		accept_event()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


func _draw() -> void:
	if not visible:
		return

	var center := size * 0.5
	var panel_rect := _get_panel_rect()

	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.02, 0.025, 0.62), true)
	draw_rect(panel_rect, Color("#2f3440"), true)
	draw_rect(panel_rect, Color("#d8cfba"), false, 3.0)

	_draw_text(Vector2(panel_rect.position.x + 28, panel_rect.position.y + 38), "멀티탭 관리", 28, Color("#f5ead2"))
	_draw_text(Vector2(panel_rect.position.x + 28, panel_rect.position.y + 74), "ESC: 아파트로 돌아가기", 15, Color("#bfb6a0"))

	var total_power := _get_total_power()
	var power_color := Color("#ff6b5f") if total_power > MAX_POWER_WATTS else Color("#f5ead2")
	_draw_text(Vector2(panel_rect.position.x + 350, panel_rect.position.y + 52), "전력 사용량: %dW / %dW" % [total_power, MAX_POWER_WATTS], 24, power_color)

	_draw_survival_stats(Vector2(panel_rect.position.x + 28, panel_rect.position.y + 128))
	_draw_need_warnings(Vector2(panel_rect.position.x + 28, panel_rect.position.y + 300))
	_draw_text(Vector2(panel_rect.position.x + 350, panel_rect.position.y + 116), "콘센트", 18, Color("#cfc2a8"))
	_draw_text(Vector2(panel_rect.position.x + 350, panel_rect.end.y - 128), "사용 가능한 기기", 18, Color("#cfc2a8"))
	_draw_power_strip(_get_strip_center())
	_draw_devices()

	if breaker_timer > 0.0:
		_draw_text(center + Vector2(-160, -20), "과부하 발생!\n차단기가 내려갔습니다", 30, Color("#ff6b5f"))
	else:
		_draw_text(Vector2(panel_rect.position.x + 28, panel_rect.end.y - 38), status_text, 18, Color("#f5ead2"))


func _draw_power_strip(strip_center: Vector2) -> void:
	var strip_rect := Rect2(strip_center - STRIP_SIZE * 0.5, STRIP_SIZE)
	draw_rect(strip_rect, Color("#d6c7a8"), true)
	draw_rect(strip_rect, Color("#3a332c"), false, 3.0)

	for index in range(OUTLET_COUNT):
		var slot_rect := _get_slot_rect(index)
		var occupied := occupied_slots[index] != null
		var fill := Color("#fffaf0") if not occupied else Color("#d59b45")
		fill.a = 1.0 if not occupied else 0.72
		draw_rect(slot_rect, fill, true)
		draw_rect(slot_rect, Color("#665d52"), false, 2.0)
		draw_rect(Rect2(slot_rect.get_center() + Vector2(-16, -18), Vector2(7, 27)), Color("#2d2924"), true)
		draw_rect(Rect2(slot_rect.get_center() + Vector2(10, -18), Vector2(7, 27)), Color("#2d2924"), true)
		draw_circle(slot_rect.get_center() + Vector2(0, 24), 5.0, Color("#2d2924"))


func _draw_devices() -> void:
	for device in devices:
		var rect := _get_device_rect(device)
		var color: Color = device["color"]
		draw_rect(rect, color, true)
		draw_rect(rect, Color("#1f1d1a"), false, 2.0)
		_draw_text(rect.position + Vector2(10, 24), "%s\n%dW" % [device["label"], device["watts"]], 15, Color("#1f1d1a"))

		var plug_x := rect.get_center().x
		if device["slots"] == 2:
			plug_x = rect.position.x + 22.0 if device["plug_side"] == "left" else rect.end.x - 22.0
		draw_rect(Rect2(Vector2(plug_x - 12.0, rect.end.y - 4.0), Vector2(24.0, 28.0)), Color("#2f2b25"), true)


func _draw_need_warnings(position: Vector2) -> void:
	if survival_state == null:
		return

	_draw_text(position, "경고", 17, Color("#f5ead2"))
	var warnings := survival_state.get_warning_lines()
	if warnings.is_empty():
		_draw_text(position + Vector2(0, 28), "현재 경고 없음", 15, Color("#bfb6a0"))
		return

	var text := " / ".join(warnings)
	_draw_text(position + Vector2(0, 28), text, 16, Color("#ffd166"))


func _draw_survival_stats(position: Vector2) -> void:
	if survival_state == null:
		return

	_draw_text(position, "상태", 17, Color("#f5ead2"))
	var rows := [
		{ "label": "배터리", "value": survival_state.battery, "color": Color("#4f8edb") },
		{ "label": "온도", "value": survival_state.temperature, "color": Color("#d98742") },
		{ "label": "피로", "value": survival_state.fatigue, "color": Color("#8f6bb3") },
		{ "label": "재미", "value": survival_state.fun, "color": Color("#e0b33f") },
	]

	for index in range(rows.size()):
		var row: Dictionary = rows[index]
		var y := position.y + 34.0 + index * 30.0
		var value: float = row["value"]
		var text := "%s %d%%" % [row["label"], roundi(value)]
		_draw_text(Vector2(position.x, y + 14.0), text, 15, Color("#f5ead2"))

		var bar_rect := Rect2(Vector2(position.x + 86.0, y + 4.0), Vector2(140.0, 12.0))
		draw_rect(bar_rect, Color("#1f232c"), true)
		draw_rect(Rect2(bar_rect.position, Vector2(bar_rect.size.x * clampf(value / 100.0, 0.0, 1.0), bar_rect.size.y)), row["color"], true)
		draw_rect(bar_rect, Color("#cfc2a8"), false, 1.0)


func _draw_text(position: Vector2, text: String, font_size: int, color: Color) -> void:
	draw_multiline_string(ThemeDB.fallback_font, position, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, -1, color)


func _start_drag(mouse_position: Vector2) -> void:
	if breaker_timer > 0.0:
		return

	for index in range(devices.size() - 1, -1, -1):
		var device := devices[index]
		if _get_device_rect(device).has_point(mouse_position):
			dragging_device = device
			drag_offset = device["position"] - mouse_position
			_release_device(device)
			devices.remove_at(index)
			devices.append(device)
			status_text = "%s 이동 중" % device["label"]
			queue_redraw()
			return


func _finish_drag() -> void:
	if dragging_device.is_empty():
		return

	var target_slot := _find_best_slot(dragging_device)
	if target_slot >= 0 and _can_use_slots(dragging_device, target_slot):
		_connect_device(dragging_device, target_slot)
	else:
		_send_device_home(dragging_device)
		status_text = "맞는 콘센트 공간이 없습니다"

	dragging_device = {}
	queue_redraw()


func _connect_device(device: Dictionary, start_slot: int) -> void:
	var slots: int = device["slots"]
	for slot in range(start_slot, start_slot + slots):
		occupied_slots[slot] = device["key"]

	device["connected_start"] = start_slot
	device["position"] = _get_snap_position(device, start_slot)
	status_text = "%s 연결됨" % device["label"]
	power_changed.emit(_get_total_power())
	powered_devices_changed.emit(_get_powered_device_keys())

	if _get_total_power() > MAX_POWER_WATTS:
		_trip_breaker()


func _trip_breaker() -> void:
	status_text = "과부하: 차단기 내려감"
	breaker_timer = BREAKER_SECONDS
	_reset_slots()

	for device in devices:
		device["connected_start"] = -1
		_send_device_home(device)

	power_changed.emit(0)
	powered_devices_changed.emit(_get_powered_device_keys())
	breaker_tripped.emit()


func _release_device(device: Dictionary) -> void:
	for index in range(occupied_slots.size()):
		if occupied_slots[index] == device["key"]:
			occupied_slots[index] = null

	device["connected_start"] = -1
	power_changed.emit(_get_total_power())
	powered_devices_changed.emit(_get_powered_device_keys())


func _send_device_home(device: Dictionary) -> void:
	device["position"] = device["home_position"]
	device["connected_start"] = -1


func _find_best_slot(device: Dictionary) -> int:
	var best_slot := -1
	var best_distance := 72.0
	var plug_position := _get_device_plug_position(device)

	for slot in range(OUTLET_COUNT):
		var distance := plug_position.distance_to(_get_slot_rect(slot).get_center())
		if distance < best_distance:
			best_slot = slot
			best_distance = distance

	if best_slot < 0:
		return -1

	if device["slots"] == 2 and device["plug_side"] == "right":
		return best_slot - 1

	return best_slot


func _can_use_slots(device: Dictionary, start_slot: int) -> bool:
	var slots: int = device["slots"]
	if start_slot < 0 or start_slot + slots > OUTLET_COUNT:
		return false

	for slot in range(start_slot, start_slot + slots):
		if occupied_slots[slot] != null:
			return false

	return true


func _get_slot_rect(index: int) -> Rect2:
	var strip_center := _get_strip_center()
	var start_x := strip_center.x - STRIP_SIZE.x * 0.5 + SLOT_GAP
	var x := start_x + index * (SLOT_SIZE.x + SLOT_GAP)
	return Rect2(Vector2(x, strip_center.y - SLOT_SIZE.y * 0.5), SLOT_SIZE)


func _get_panel_rect() -> Rect2:
	return Rect2(size * 0.5 - PANEL_SIZE * 0.5, PANEL_SIZE)


func _get_strip_center() -> Vector2:
	var panel_rect := _get_panel_rect()
	return Vector2(panel_rect.position.x + 700.0, panel_rect.position.y + 250.0)


func _get_device_rect(device: Dictionary) -> Rect2:
	var width: float = device["width"]
	return Rect2(device["position"] - Vector2(width, DEVICE_HEIGHT) * 0.5, Vector2(width, DEVICE_HEIGHT))


func _get_device_plug_position(device: Dictionary) -> Vector2:
	var rect := _get_device_rect(device)
	if device["slots"] == 2:
		var plug_x := rect.position.x + 22.0 if device["plug_side"] == "left" else rect.end.x - 22.0
		return Vector2(plug_x, rect.end.y + 10.0)

	return Vector2(rect.get_center().x, rect.end.y + 10.0)


func _get_snap_position(device: Dictionary, start_slot: int) -> Vector2:
	var plug_slot := start_slot
	if device["slots"] == 2 and device["plug_side"] == "right":
		plug_slot = start_slot + 1

	var outlet_center := _get_slot_rect(plug_slot).get_center()
	var rect := _get_device_rect(device)
	var plug_position := _get_device_plug_position(device)
	return device["position"] + (outlet_center - plug_position)


func _get_total_power() -> int:
	var total := 0
	for device in devices:
		if device["connected_start"] >= 0:
			total += device["watts"]
	return total


func _get_powered_device_keys() -> Array[String]:
	var keys: Array[String] = []

	for device in devices:
		if device["connected_start"] >= 0:
			keys.append(device["key"])

	return keys


func _reset_slots() -> void:
	occupied_slots.clear()
	for _index in range(OUTLET_COUNT):
		occupied_slots.append(null)


func _create_devices() -> void:
	devices = [
		_make_device("phone", "충전기", 20, 1, 96.0, "center", Color("#4f8edb"), Vector2(350, 550)),
		_make_device("fan", "선풍기", 900, 1, 96.0, "center", Color("#52a66f"), Vector2(520, 550)),
		_make_device("laptop", "노트북", 1300, 2, 170.0, "left", Color("#486064"), Vector2(710, 550)),
		_make_device("microwave", "전자레인지", 2100, 2, 170.0, "right", Color("#d98742"), Vector2(920, 550)),
	]
	_layout_device_homes()


func _make_device(key: String, label: String, watts: int, slots: int, width: float, plug_side: String, color: Color, home_position: Vector2) -> Dictionary:
	return {
		"key": key,
		"label": label,
		"watts": watts,
		"slots": slots,
		"width": width,
		"plug_side": plug_side,
		"color": color,
		"home_position": home_position,
		"position": home_position,
		"connected_start": -1,
	}


func _layout_device_homes() -> void:
	if devices.is_empty():
		return

	var panel_rect := _get_panel_rect()
	var bottom_y := panel_rect.end.y - 72.0
	var home_positions := [
		Vector2(panel_rect.position.x + 390.0, bottom_y),
		Vector2(panel_rect.position.x + 560.0, bottom_y),
		Vector2(panel_rect.position.x + 760.0, bottom_y),
		Vector2(panel_rect.position.x + 990.0, bottom_y),
	]

	for index in range(devices.size()):
		var device := devices[index]
		var old_home: Vector2 = device["home_position"]
		var new_home: Vector2 = home_positions[index]
		device["home_position"] = new_home

		if device["connected_start"] < 0 and device["position"] == old_home:
			device["position"] = new_home
