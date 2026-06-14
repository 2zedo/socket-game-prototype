extends Control
class_name OutletMode

signal closed
signal power_changed(total_power: int)
signal powered_devices_changed(device_keys: Array[String])
signal breaker_tripped

const MAX_POWER_WATTS := SurvivalState.DAY1_MAX_LOAD_WATTS
const OUTLET_COUNT := SurvivalState.DAY1_MAX_OUTLET_SLOTS
const SLOT_SIZE := Vector2(92, 82)
const SLOT_GAP := 18.0
const STRIP_SIZE := Vector2(560, 132)
const DEVICE_HEIGHT := 108.0
const BREAKER_SECONDS := 1.4
const PANEL_SIZE := Vector2(1160, 640)

var survival_state: SurvivalState
var occupied_slots: Array = []
var devices: Array[Dictionary] = []
var dragging_device: Dictionary = {}
var drag_offset := Vector2.ZERO
var breaker_timer := 0.0
var status_text := "기기를 콘센트에 끌어다 놓으면 방 안에서 사용할 수 있습니다"


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_reset_slots()
	_create_devices()
	set_process(false)


func open(state: SurvivalState) -> void:
	survival_state = state
	visible = true
	_layout_device_homes()
	status_text = "기기를 콘센트에 끌어다 놓으면 방 안에서 사용할 수 있습니다"
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

	var panel_rect := _get_panel_rect()

	draw_rect(Rect2(Vector2.ZERO, size), Color(0.01, 0.01, 0.012, 0.78), true)
	draw_rect(panel_rect, UIStyle.PANEL, true)
	draw_rect(panel_rect, UIStyle.LINE_DIM, false, 2.0)

	_draw_text(Vector2(panel_rect.position.x + 32, panel_rect.position.y + 42), "멀티탭 관리", 28, UIStyle.TEXT)
	_draw_text(Vector2(panel_rect.position.x + 32, panel_rect.position.y + 78), "ESC: 아파트로 돌아가기", 15, UIStyle.MUTED)

	_draw_power_overview(Vector2(panel_rect.position.x + 28, panel_rect.position.y + 122))
	_draw_text(Vector2(panel_rect.position.x + 392, panel_rect.position.y + 118), "콘센트", 18, UIStyle.MUTED)
	_draw_text(Vector2(panel_rect.position.x + 360, panel_rect.end.y - 164), "연결 가능한 기기", 18, UIStyle.MUTED)
	_draw_power_strip(_get_strip_center())
	_draw_devices()

	_draw_text(Vector2(panel_rect.position.x + 32, panel_rect.end.y - 38), status_text, 17, UIStyle.TEXT)


func _draw_power_strip(strip_center: Vector2) -> void:
	var strip_rect := Rect2(strip_center - STRIP_SIZE * 0.5, STRIP_SIZE)
	draw_rect(strip_rect, Color("#8d7b59"), true)
	draw_rect(strip_rect, Color("#2a2118"), false, 3.0)

	for index in range(OUTLET_COUNT):
		var slot_rect := _get_slot_rect(index)
		var occupied := occupied_slots[index] != null
		var fill := Color("#d8cfba") if not occupied else Color("#b18a44")
		fill.a = 1.0 if not occupied else 0.72
		draw_rect(slot_rect, fill, true)
		draw_rect(slot_rect, Color("#3b332a"), false, 2.0)
		draw_rect(Rect2(slot_rect.get_center() + Vector2(-16, -18), Vector2(7, 27)), Color("#2d2924"), true)
		draw_rect(Rect2(slot_rect.get_center() + Vector2(10, -18), Vector2(7, 27)), Color("#2d2924"), true)
		draw_circle(slot_rect.get_center() + Vector2(0, 24), 5.0, Color("#2d2924"))


func _draw_devices() -> void:
	for device in devices:
		var rect := _get_device_rect(device)
		var connected := int(device["connected_start"]) >= 0
		var used := survival_state != null and survival_state.used_day1_actions.has(str(device["key"]))
		var color: Color = Color(0.12, 0.105, 0.09, 0.95)
		var border: Color = UIStyle.ELECTRIC if connected else UIStyle.LINE_DIM
		draw_rect(rect, color, true)
		draw_rect(rect, border, false, 2.0)
		var badge_text := "사용 완료" if used else ("연결됨" if connected else "연결 안 됨")
		var badge_color := UIStyle.SUCCESS if used else (UIStyle.ELECTRIC if connected else UIStyle.MUTED)
		draw_rect(Rect2(rect.position + Vector2(10, 8), Vector2(72, 20)), Color(0.03, 0.03, 0.026, 0.82), true)
		_draw_text(rect.position + Vector2(16, 23), badge_text, 11, badge_color)
		var device_text := "%s\n상태: %s\n소비전력: %dW\n사용 비용: %d\n콘센트: %d칸" % [
			device["label"],
			badge_text,
			int(device["watts"]),
			int(device["power_cost"]),
			int(device["slots"]),
		]
		_draw_text(rect.position + Vector2(10, 46), device_text, 12, UIStyle.TEXT)

		var plug_x := rect.get_center().x
		if device["slots"] == 2:
			plug_x = rect.position.x + 22.0 if device["plug_side"] == "left" else rect.end.x - 22.0
		draw_rect(Rect2(Vector2(plug_x - 10.0, rect.end.y - 3.0), Vector2(20.0, 28.0)), Color("#1c1814"), true)


func _draw_power_overview(position: Vector2) -> void:
	if survival_state == null:
		return

	var overview := [
		"오늘 남은 전력: %d / %d" % [survival_state.current_power, survival_state.max_power],
		"현재 부하: %dW / %dW" % [_get_total_power(), MAX_POWER_WATTS],
		"콘센트: %d / %d" % [_get_used_slots(), OUTLET_COUNT],
		"",
		"연결은 전력을 소모하지 않습니다.",
		"방 안에서 기기를 사용할 때만 오늘 전력이 줄어듭니다.",
	]
	_draw_text(position, "\n".join(overview), 18, UIStyle.TEXT)


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
	var projected_power := _get_total_power() + int(device["watts"])
	if projected_power > MAX_POWER_WATTS:
		_send_device_home(device)
		status_text = "%s은 현재 부하 한도를 넘어서 연결할 수 없습니다" % device["label"]
		power_changed.emit(_get_total_power())
		powered_devices_changed.emit(_get_powered_device_keys())
		return

	for slot in range(start_slot, start_slot + slots):
		occupied_slots[slot] = device["key"]

	device["connected_start"] = start_slot
	device["position"] = _get_snap_position(device, start_slot)
	status_text = "%s 연결됨" % device["label"]
	power_changed.emit(_get_total_power())
	powered_devices_changed.emit(_get_powered_device_keys())


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
	_release_device(device)
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


func _get_used_slots() -> int:
	var used_slots := 0
	for slot_key in occupied_slots:
		if slot_key != null:
			used_slots += 1

	return used_slots


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
		_make_device("light", "조명", 60, 1, 1, 126.0, "center", Color("#d2a85f"), Vector2(350, 550)),
		_make_device("laptop", "노트북", 1300, 3, 1, 142.0, "center", Color("#486064"), Vector2(520, 550)),
		_make_device("fan", "선풍기", 900, 2, 1, 126.0, "center", Color("#52a66f"), Vector2(710, 550)),
		_make_device("charger", "충전기", 20, 2, 1, 126.0, "center", Color("#4f8edb"), Vector2(890, 550)),
		_make_device("communication_device", "통신 장치", 300, 4, 1, 158.0, "center", Color("#8f6bb3"), Vector2(1050, 550)),
	]
	_layout_device_homes()


func _make_device(key: String, label: String, watts: int, power_cost: int, slots: int, width: float, plug_side: String, color: Color, home_position: Vector2) -> Dictionary:
	return {
		"key": key,
		"label": label,
		"watts": watts,
		"power_cost": power_cost,
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
	var bottom_y := panel_rect.end.y - 92.0
	var home_positions := [
		Vector2(panel_rect.position.x + 390.0, bottom_y),
		Vector2(panel_rect.position.x + 535.0, bottom_y),
		Vector2(panel_rect.position.x + 680.0, bottom_y),
		Vector2(panel_rect.position.x + 825.0, bottom_y),
		Vector2(panel_rect.position.x + 990.0, bottom_y),
	]

	for index in range(devices.size()):
		var device := devices[index]
		var old_home: Vector2 = device["home_position"]
		var new_home: Vector2 = home_positions[index]
		device["home_position"] = new_home

		if device["connected_start"] < 0 and device["position"] == old_home:
			device["position"] = new_home
