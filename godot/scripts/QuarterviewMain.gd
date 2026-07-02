extends Node2D

const RESTART_KEY := KEY_R
const CANCEL_KEY := KEY_ESCAPE
const PANEL_VIEWPORT_MARGIN := 18.0
const PANEL_OBJECT_OFFSET := Vector2(34, -118)
const PANEL_FALLBACK_SIZE := Vector2(340, 152)
const STATUS_PANEL_AVOID_RECT := Rect2(Vector2(10, 10), Vector2(334, 160))
const DESK_CLOSEUP_SIZE := Vector2(730, 520)
const DESK_CLOSEUP_POSITION := Vector2(390, 74)
const DESK_CLOSEUP_ENTRY_KEYS := ["desk", "laptop"]
const POWER_CLOSEUP_SIZE := Vector2(690, 500)
const POWER_CLOSEUP_POSITION := Vector2(430, 84)
const POWER_CLOSEUP_ENTRY_KEYS := ["power"]
const PHONE_CLOSEUP_SIZE := Vector2(560, 440)
const PHONE_CLOSEUP_POSITION := Vector2(510, 112)
const PHONE_CLOSEUP_ENTRY_KEYS := ["phone"]
const DESK_CLOSEUP_HOTSPOTS := [
	{
		"key": "laptop",
		"display_name": "Laptop",
		"role": "laptop_job",
		"description": "의뢰, 작업 로그, 해킹 진입 후보를 확인할 중심 장비입니다.",
		"candidate_action": "open_work_noop",
		"rect": Rect2(Vector2(78, 92), Vector2(204, 86)),
	},
	{
		"key": "comm",
		"display_name": "Communication Device",
		"role": "communication",
		"description": "외부 신호와 의뢰 흐름을 받을 후보 장비입니다.",
		"candidate_action": "check_signal_noop",
		"rect": Rect2(Vector2(308, 102), Vector2(162, 76)),
	},
	{
		"key": "node17",
		"display_name": "NODE-17",
		"role": "mystery_device",
		"description": "금지 로그와 미스터리 플래그 후보가 모일 장치입니다.",
		"candidate_action": "inspect_node_noop",
		"rect": Rect2(Vector2(500, 94), Vector2(138, 96)),
	},
	{
		"key": "signal_booster",
		"display_name": "Signal Booster",
		"role": "support_device",
		"description": "신호 품질, 추적률, 미션 조건 개선 후보 장비입니다.",
		"candidate_action": "boost_signal_noop",
		"rect": Rect2(Vector2(96, 224), Vector2(164, 72)),
	},
	{
		"key": "speaker",
		"display_name": "Speaker / Audio Analyzer",
		"role": "audio_hacking_device",
		"description": "해킹모드 소리 정보와 신호음 분석 후보 장비입니다.",
		"candidate_action": "analyze_audio_noop",
		"rect": Rect2(Vector2(300, 220), Vector2(178, 82)),
	},
	{
		"key": "job_memo",
		"display_name": "Small Notes / Job Memo",
		"role": "job_memo",
		"description": "오늘 할 일, 의뢰 단서, 위험 메모를 놓는 후보 영역입니다.",
		"candidate_action": "read_memo_noop",
		"rect": Rect2(Vector2(512, 230), Vector2(136, 68)),
	},
]
const POWER_CLOSEUP_MODULES := [
	{
		"key": "battery_core",
		"display_name": "Battery Core",
		"role": "power_module",
		"description": "남는 전력을 임시 저장하는 후보 모듈입니다. 아직 실제 충전 / 방전 계산은 없습니다.",
		"candidate_action": "inspect_battery_noop",
		"rect": Rect2(Vector2(82, 82), Vector2(132, 70)),
		"color": Color(0.16, 0.38, 0.48, 0.92),
	},
	{
		"key": "socket_rail",
		"display_name": "Socket Rail",
		"role": "power_socket",
		"description": "장치 연결 슬롯을 나타내는 후보 영역입니다. OutletMode와는 아직 연결하지 않았습니다.",
		"candidate_action": "inspect_socket_noop",
		"rect": Rect2(Vector2(246, 82), Vector2(210, 54)),
		"color": Color(0.34, 0.28, 0.16, 0.94),
	},
	{
		"key": "load_limiter",
		"display_name": "Load Limiter",
		"role": "power_safety",
		"description": "과부하 제한 후보 모듈입니다. 실제 경고나 차단 로직은 없습니다.",
		"candidate_action": "inspect_limiter_noop",
		"rect": Rect2(Vector2(484, 80), Vector2(104, 86)),
		"color": Color(0.48, 0.22, 0.14, 0.92),
	},
	{
		"key": "adapter_bridge",
		"display_name": "Adapter Bridge",
		"role": "power_adapter",
		"description": "다른 규격 장치를 임시로 연결하는 후보 부품입니다.",
		"candidate_action": "inspect_adapter_noop",
		"rect": Rect2(Vector2(126, 192), Vector2(94, 108)),
		"color": Color(0.25, 0.24, 0.30, 0.94),
	},
	{
		"key": "priority_bus",
		"display_name": "Priority Bus",
		"role": "power_routing",
		"description": "어떤 장치에 전력을 우선 보낼지 정하는 후보 라인입니다.",
		"candidate_action": "inspect_priority_noop",
		"rect": Rect2(Vector2(260, 204), Vector2(176, 62)),
		"color": Color(0.12, 0.36, 0.25, 0.94),
	},
	{
		"key": "warning_meter",
		"display_name": "Warning Meter",
		"role": "power_warning",
		"description": "소비량과 위험도를 보여줄 후보 계기입니다. 실제 SurvivalState와 연결하지 않았습니다.",
		"candidate_action": "inspect_meter_noop",
		"rect": Rect2(Vector2(474, 214), Vector2(126, 78)),
		"color": Color(0.42, 0.34, 0.12, 0.94),
	},
]
const PHONE_CLOSEUP_ITEMS := [
	{
		"key": "battery",
		"display_name": "Battery",
		"role": "phone_battery",
		"description": "전화기 배터리와 충전 후보 상태를 확인합니다. 실제 Phone battery 값은 아직 읽지 않습니다.",
		"candidate_action": "check_battery_noop",
		"value": "47% 후보",
	},
	{
		"key": "signal",
		"display_name": "Signal",
		"role": "phone_signal",
		"description": "THE GRID 내부망 신호 후보를 확인합니다. 실제 통신 이벤트와 연결하지 않았습니다.",
		"candidate_action": "check_signal_noop",
		"value": "weak / unstable",
	},
	{
		"key": "messages",
		"display_name": "Messages",
		"role": "phone_messages",
		"description": "미확인 연락 후보입니다. 실제 PhoneUI 메시지 목록은 열지 않습니다.",
		"candidate_action": "open_messages_noop",
		"value": "0 new",
	},
	{
		"key": "charge_port",
		"display_name": "Charge Port",
		"role": "phone_charge",
		"description": "충전 포트 후보입니다. SurvivalState 충전 계산과 연결하지 않았습니다.",
		"candidate_action": "charge_noop",
		"value": "not wired",
	},
]

@onready var camera: Camera2D = $Camera2D
@onready var quarterview_room: Node2D = $QuarterviewRoom
@onready var status_label: Label = $UILayer/StatusPanel/Margin/VBox/StatusLabel
@onready var log_label: Label = $UILayer/StatusPanel/Margin/VBox/LogLabel

var last_interaction := "-"
var last_interaction_debug := "-"
var room_debug_enabled := false
var background_mode := "unknown"
var focused_object_key := ""
var focused_payload := {}
var room_input_locked := false
var desk_closeup_open := false
var power_closeup_open := false
var phone_closeup_open := false
var selected_desk_hotspot_key := "laptop"
var selected_power_module_key := "battery_core"
var selected_phone_item_key := "battery"
var interaction_panel: PanelContainer
var interaction_title_label: Label
var interaction_detail_label: Label
var desk_closeup_backdrop: ColorRect
var desk_closeup_panel: PanelContainer
var desk_hotspot_buttons := {}
var desk_hotspot_title_label: Label
var desk_hotspot_detail_label: Label
var desk_hotspot_debug_label: Label
var desk_hotspot_guides := {}
var power_closeup_backdrop: ColorRect
var power_closeup_panel: PanelContainer
var power_module_buttons := {}
var power_module_title_label: Label
var power_module_detail_label: Label
var power_module_debug_label: Label
var power_module_guides := {}
var phone_closeup_backdrop: ColorRect
var phone_closeup_panel: PanelContainer
var phone_item_buttons := {}
var phone_item_title_label: Label
var phone_item_detail_label: Label
var phone_item_debug_label: Label


func _ready() -> void:
	if quarterview_room.has_signal("interaction_requested"):
		quarterview_room.connect("interaction_requested", Callable(self, "_on_room_interaction_requested"))
	if quarterview_room.has_signal("nearest_interactable_changed"):
		quarterview_room.connect("nearest_interactable_changed", Callable(self, "_on_nearest_interactable_changed"))
	if quarterview_room.has_signal("debug_overlay_toggled"):
		quarterview_room.connect("debug_overlay_toggled", Callable(self, "_on_room_debug_overlay_toggled"))
	if quarterview_room.has_signal("movement_path_failed"):
		quarterview_room.connect("movement_path_failed", Callable(self, "_on_room_movement_path_failed"))

	if quarterview_room.has_method("get_background_mode"):
		background_mode = quarterview_room.get_background_mode()
	if quarterview_room.has_method("is_debug_overlay_enabled"):
		room_debug_enabled = quarterview_room.is_debug_overlay_enabled()

	_build_interaction_panel()
	_build_desk_closeup_overlay()
	_build_power_closeup_overlay()
	_build_phone_closeup_overlay()
	_update_status("QuarterviewMain candidate ready.")


func _unhandled_input(event: InputEvent) -> void:
	if phone_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_phone_closeup_content_point(event.position):
			_hide_phone_closeup()
		get_viewport().set_input_as_handled()
		return

	if power_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_power_closeup_content_point(event.position):
			_hide_power_closeup()
		get_viewport().set_input_as_handled()
		return

	if desk_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_desk_closeup_content_point(event.position):
			_hide_desk_closeup()
		get_viewport().set_input_as_handled()
		return

	if _is_interaction_panel_open() and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_interaction_panel_content_point(event.position):
			_hide_interaction_panel()
			_update_status("Candidate panel closed.")
		get_viewport().set_input_as_handled()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == RESTART_KEY:
			get_tree().reload_current_scene()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == CANCEL_KEY:
			if phone_closeup_open:
				_hide_phone_closeup()
				get_viewport().set_input_as_handled()
				return
			if power_closeup_open:
				_hide_power_closeup()
				get_viewport().set_input_as_handled()
				return
			if desk_closeup_open:
				_hide_desk_closeup()
				get_viewport().set_input_as_handled()
				return
			if interaction_panel != null and interaction_panel.visible:
				_hide_interaction_panel()
				_update_status("Candidate panel closed.")
				get_viewport().set_input_as_handled()
				return


func _on_room_interaction_requested(object_key: String, action_key: String, payload: Dictionary) -> void:
	if _has_closeup_open():
		return
	var role := String(payload.get("role", "-"))
	var display_name := String(payload.get("display_name", object_key))
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "%s / role=%s / action=%s" % [object_key, role, action_key]
	print("QuarterviewMain candidate interaction: %s / display=%s" % [last_interaction_debug, display_name])
	focused_object_key = object_key
	focused_payload = payload.duplicate(true)
	_show_interaction_panel(object_key, payload)
	_update_status("%s selected." % display_name)


func _on_nearest_interactable_changed(object_key: String, display_name: String) -> void:
	if object_key.is_empty():
		_update_status("No nearby object.")
	else:
		_update_status("Nearest: %s (%s)" % [display_name, object_key])


func _on_room_debug_overlay_toggled(enabled: bool) -> void:
	var room_transform := quarterview_room.global_transform
	var camera_transform := camera.global_transform
	var camera_zoom := camera.zoom
	room_debug_enabled = enabled
	_update_status("Debug overlay %s." % ("ON" if enabled else "OFF"))
	if interaction_panel != null and interaction_panel.visible and not focused_payload.is_empty():
		_refresh_interaction_panel_detail(focused_object_key, focused_payload)
	if desk_closeup_open:
		_refresh_desk_hotspot_detail()
	if power_closeup_open:
		_refresh_power_module_detail()
	if phone_closeup_open:
		_refresh_phone_item_detail()
	quarterview_room.global_transform = room_transform
	camera.global_transform = camera_transform
	camera.zoom = camera_zoom


func _on_room_movement_path_failed(reason: String) -> void:
	_update_status(reason)


func _update_status(message: String) -> void:
	var debug_text := "Debug ON: arrow-key move enabled" if room_debug_enabled else "Normal: mouse click movement"
	var modal_text := _get_modal_status_text(debug_text)
	status_label.text = "Candidate only / no production wiring\n%s\n%s" % [message, modal_text]
	if room_debug_enabled:
		var room_debug_summary := _get_room_debug_summary()
		log_label.text = "Last: %s\nD: debug | R: restart | BG: %s\n%s" % [
			last_interaction_debug,
			background_mode,
			room_debug_summary,
		]
	else:
		log_label.text = "Last: %s\nD: debug | R: restart" % [last_interaction]


func _build_interaction_panel() -> void:
	interaction_panel = PanelContainer.new()
	interaction_panel.name = "CandidateInteractionPanel"
	interaction_panel.visible = false
	interaction_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	interaction_panel.custom_minimum_size = Vector2(300, 0)
	interaction_panel.position = Vector2(940, 204)
	$UILayer.add_child(interaction_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	interaction_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	interaction_title_label = Label.new()
	interaction_title_label.add_theme_color_override("font_color", Color(0.93, 0.86, 0.72, 1.0))
	interaction_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(interaction_title_label)

	interaction_detail_label = Label.new()
	interaction_detail_label.add_theme_color_override("font_color", Color(0.76, 0.83, 0.82, 1.0))
	interaction_detail_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(interaction_detail_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "사용하기"
	use_button.pressed.connect(_on_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명(살펴보기)"
	inspect_button.pressed.connect(_on_inspect_pressed)
	button_row.add_child(inspect_button)

	var cancel_button := Button.new()
	cancel_button.text = "취소"
	cancel_button.pressed.connect(_on_cancel_pressed)
	button_row.add_child(cancel_button)


func _show_interaction_panel(object_key: String, payload: Dictionary) -> void:
	var display_name := String(payload.get("display_name", object_key))
	interaction_title_label.text = display_name
	_refresh_interaction_panel_detail(object_key, payload)
	interaction_panel.visible = true
	_set_room_input_locked(true)
	_position_interaction_panel(payload)


func _refresh_interaction_panel_detail(object_key: String, payload: Dictionary) -> void:
	if room_debug_enabled:
		interaction_detail_label.text = _get_debug_object_detail(object_key, payload)
	else:
		interaction_detail_label.text = _get_normal_object_description(payload)


func _hide_interaction_panel() -> void:
	if interaction_panel != null:
		interaction_panel.visible = false
	if not _has_closeup_open():
		_set_room_input_locked(false)


func _on_use_pressed() -> void:
	if _should_open_phone_closeup():
		_open_phone_closeup(focused_object_key)
		return
	if _should_open_power_closeup():
		_open_power_closeup(focused_object_key)
		return
	if _should_open_desk_closeup():
		_open_desk_closeup(focused_object_key)
		return
	_log_candidate_panel_action("primary")


func _on_inspect_pressed() -> void:
	_log_candidate_panel_action("inspect")


func _on_cancel_pressed() -> void:
	_log_candidate_panel_action("cancel")
	_hide_interaction_panel()


func _log_candidate_panel_action(action_key: String) -> void:
	var role := String(focused_payload.get("role", "-"))
	var display_name := String(focused_payload.get("display_name", focused_object_key))
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "%s / role=%s / action=%s" % [focused_object_key, role, action_key]
	print("QuarterviewMain candidate panel: %s / display=%s / no production wiring" % [last_interaction_debug, display_name])
	_update_status("%s: %s." % [display_name, _get_action_display_name(action_key)])


func _set_room_input_locked(locked: bool) -> void:
	if room_input_locked == locked:
		return

	room_input_locked = locked
	if quarterview_room.has_method("set_room_input_enabled"):
		quarterview_room.set_room_input_enabled(not room_input_locked)


func _has_closeup_open() -> bool:
	return desk_closeup_open or power_closeup_open or phone_closeup_open


func _get_modal_status_text(default_text: String) -> String:
	if phone_closeup_open:
		return "Phone candidate open / room input locked"
	if power_closeup_open:
		return "Power equipment close-up open / room input locked"
	if desk_closeup_open:
		return "Desk close-up open / room input locked"
	return default_text


func _should_open_desk_closeup() -> bool:
	var role := String(focused_payload.get("role", ""))
	return focused_object_key in DESK_CLOSEUP_ENTRY_KEYS or role == "laptop_job"


func _should_open_power_closeup() -> bool:
	var role := String(focused_payload.get("role", ""))
	return focused_object_key in POWER_CLOSEUP_ENTRY_KEYS or role == "power_management"


func _should_open_phone_closeup() -> bool:
	var role := String(focused_payload.get("role", ""))
	return focused_object_key in PHONE_CLOSEUP_ENTRY_KEYS or role == "phone_status" or role == "phone_charge"


func _build_desk_closeup_overlay() -> void:
	desk_closeup_backdrop = ColorRect.new()
	desk_closeup_backdrop.name = "DeskCloseupBackdrop"
	desk_closeup_backdrop.visible = false
	desk_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.32)
	desk_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	desk_closeup_backdrop.z_index = 100
	desk_closeup_backdrop.position = Vector2.ZERO
	desk_closeup_backdrop.size = _get_viewport_ui_size()
	desk_closeup_backdrop.gui_input.connect(_on_desk_closeup_backdrop_gui_input)
	$UILayer.add_child(desk_closeup_backdrop)

	desk_closeup_panel = PanelContainer.new()
	desk_closeup_panel.name = "DeskCloseupCandidate"
	desk_closeup_panel.visible = false
	desk_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	desk_closeup_panel.z_index = 101
	desk_closeup_panel.position = DESK_CLOSEUP_POSITION
	desk_closeup_panel.custom_minimum_size = DESK_CLOSEUP_SIZE
	$UILayer.add_child(desk_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	desk_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Desk Close-up Candidate"
	title.add_theme_color_override("font_color", Color(0.94, 0.84, 0.62, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "책상 위 장비를 선택합니다. Production wiring 없음."
	description.add_theme_color_override("font_color", Color(0.72, 0.80, 0.80, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var hotspot_surface := Control.new()
	hotspot_surface.name = "DeskHotspotMock"
	hotspot_surface.custom_minimum_size = Vector2(670, 318)
	vbox.add_child(hotspot_surface)

	var surface_background := ColorRect.new()
	surface_background.color = Color(0.06, 0.07, 0.07, 0.94)
	surface_background.position = Vector2.ZERO
	surface_background.size = Vector2(670, 318)
	hotspot_surface.add_child(surface_background)

	var desk_plate := ColorRect.new()
	desk_plate.color = Color(0.28, 0.18, 0.10, 0.88)
	desk_plate.position = Vector2(34, 58)
	desk_plate.size = Vector2(602, 214)
	hotspot_surface.add_child(desk_plate)

	for hotspot in DESK_CLOSEUP_HOTSPOTS:
		var key := String(hotspot["key"])
		var rect: Rect2 = hotspot["rect"]

		var guide := ColorRect.new()
		guide.name = "%sDebugRect" % key.capitalize().replace("_", "")
		guide.color = Color(0.17, 0.82, 0.92, 0.18)
		guide.position = rect.position
		guide.size = rect.size
		guide.visible = room_debug_enabled
		guide.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hotspot_surface.add_child(guide)
		desk_hotspot_guides[key] = guide

		var button := Button.new()
		button.name = "%sHotspotButton" % key.capitalize().replace("_", "")
		button.text = String(hotspot["display_name"])
		button.position = rect.position
		button.size = rect.size
		button.tooltip_text = String(hotspot["description"])
		button.pressed.connect(_on_desk_hotspot_pressed.bind(key))
		hotspot_surface.add_child(button)
		desk_hotspot_buttons[key] = button

	desk_hotspot_title_label = Label.new()
	desk_hotspot_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	desk_hotspot_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(desk_hotspot_title_label)

	desk_hotspot_detail_label = Label.new()
	desk_hotspot_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desk_hotspot_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.82, 1.0))
	desk_hotspot_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(desk_hotspot_detail_label)

	desk_hotspot_debug_label = Label.new()
	desk_hotspot_debug_label.visible = false
	desk_hotspot_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	desk_hotspot_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(desk_hotspot_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "사용하기"
	use_button.pressed.connect(_on_desk_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_desk_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_desk_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_desk_hotspot(selected_desk_hotspot_key)


func _open_desk_closeup(source_key: String) -> void:
	desk_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	desk_closeup_backdrop.size = _get_viewport_ui_size()
	desk_closeup_backdrop.visible = true
	desk_closeup_panel.visible = true

	var initial_key := source_key
	if initial_key == "desk" or _get_desk_hotspot(initial_key).is_empty():
		initial_key = "laptop"
	_select_desk_hotspot(initial_key)

	last_interaction = "Desk close-up / open"
	last_interaction_debug = "%s / role=%s / action=desk_closeup" % [
		focused_object_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain desk close-up opened from %s / no production wiring" % focused_object_key)
	_update_status("Desk close-up candidate opened.")


func _hide_desk_closeup() -> void:
	if desk_closeup_backdrop != null:
		desk_closeup_backdrop.visible = false
	if desk_closeup_panel != null:
		desk_closeup_panel.visible = false
	desk_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Desk close-up closed.")


func _on_desk_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_desk_closeup()
		get_viewport().set_input_as_handled()


func _is_desk_closeup_content_point(viewport_point: Vector2) -> bool:
	if desk_closeup_panel == null or not desk_closeup_panel.visible:
		return false
	var panel_size := desk_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = DESK_CLOSEUP_SIZE
	return Rect2(desk_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _build_power_closeup_overlay() -> void:
	power_closeup_backdrop = ColorRect.new()
	power_closeup_backdrop.name = "PowerCloseupBackdrop"
	power_closeup_backdrop.visible = false
	power_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.34)
	power_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	power_closeup_backdrop.z_index = 110
	power_closeup_backdrop.position = Vector2.ZERO
	power_closeup_backdrop.size = _get_viewport_ui_size()
	power_closeup_backdrop.gui_input.connect(_on_power_closeup_backdrop_gui_input)
	$UILayer.add_child(power_closeup_backdrop)

	power_closeup_panel = PanelContainer.new()
	power_closeup_panel.name = "PowerEquipmentCloseupCandidate"
	power_closeup_panel.visible = false
	power_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	power_closeup_panel.z_index = 111
	power_closeup_panel.position = POWER_CLOSEUP_POSITION
	power_closeup_panel.custom_minimum_size = POWER_CLOSEUP_SIZE
	$UILayer.add_child(power_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	power_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "전력 장비"
	title.add_theme_color_override("font_color", Color(0.96, 0.84, 0.56, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "제한된 전력을 모듈로 재배치하는 장치 후보입니다. OutletMode / SurvivalState 연결 없음."
	description.add_theme_color_override("font_color", Color(0.74, 0.82, 0.78, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var board_surface := Control.new()
	board_surface.name = "PowerBoardMock"
	board_surface.custom_minimum_size = Vector2(632, 316)
	vbox.add_child(board_surface)

	var board_background := ColorRect.new()
	board_background.color = Color(0.045, 0.052, 0.048, 0.96)
	board_background.position = Vector2.ZERO
	board_background.size = Vector2(632, 316)
	board_surface.add_child(board_background)

	_add_power_grid(board_surface, Vector2(42, 38), Vector2i(12, 6), Vector2(43, 36))

	for module in POWER_CLOSEUP_MODULES:
		var key := String(module["key"])
		var rect: Rect2 = module["rect"]

		var guide := ColorRect.new()
		guide.name = "%sDebugRect" % key.capitalize().replace("_", "")
		guide.color = Color(0.17, 0.82, 0.92, 0.18)
		guide.position = rect.position
		guide.size = rect.size
		guide.visible = room_debug_enabled
		guide.mouse_filter = Control.MOUSE_FILTER_IGNORE
		board_surface.add_child(guide)
		power_module_guides[key] = guide

		var button := Button.new()
		button.name = "%sModuleButton" % key.capitalize().replace("_", "")
		button.text = String(module["display_name"])
		button.position = rect.position
		button.size = rect.size
		button.tooltip_text = String(module["description"])
		button.modulate = module["color"]
		button.pressed.connect(_on_power_module_pressed.bind(key))
		board_surface.add_child(button)
		power_module_buttons[key] = button

	power_module_title_label = Label.new()
	power_module_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	power_module_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(power_module_title_label)

	power_module_detail_label = Label.new()
	power_module_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	power_module_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.82, 1.0))
	power_module_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(power_module_detail_label)

	power_module_debug_label = Label.new()
	power_module_debug_label.visible = false
	power_module_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	power_module_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(power_module_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var inspect_button := Button.new()
	inspect_button.text = "모듈 확인"
	inspect_button.pressed.connect(_on_power_inspect_pressed)
	button_row.add_child(inspect_button)

	var explain_button := Button.new()
	explain_button.text = "설명"
	explain_button.pressed.connect(_on_power_explain_pressed)
	button_row.add_child(explain_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_power_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / 전력 계산과 OutletMode는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_power_module(selected_power_module_key)


func _add_power_grid(parent: Control, origin: Vector2, cells: Vector2i, cell_size: Vector2) -> void:
	for y in cells.y:
		for x in cells.x:
			var cell := ColorRect.new()
			cell.name = "PowerGridCell_%d_%d" % [x, y]
			cell.color = Color(0.09, 0.12, 0.11, 0.72) if (x + y) % 2 == 0 else Color(0.07, 0.09, 0.085, 0.72)
			cell.position = origin + Vector2(x * cell_size.x, y * cell_size.y)
			cell.size = cell_size - Vector2(3, 3)
			cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
			parent.add_child(cell)


func _open_power_closeup(source_key: String) -> void:
	power_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	power_closeup_backdrop.size = _get_viewport_ui_size()
	power_closeup_backdrop.visible = true
	power_closeup_panel.visible = true

	if _get_power_module(selected_power_module_key).is_empty():
		selected_power_module_key = "battery_core"
	_select_power_module(selected_power_module_key)

	last_interaction = "Power equipment / open"
	last_interaction_debug = "%s / role=%s / action=power_closeup" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain power close-up opened from %s / no production wiring" % source_key)
	_update_status("Power equipment close-up candidate opened.")


func _hide_power_closeup() -> void:
	if power_closeup_backdrop != null:
		power_closeup_backdrop.visible = false
	if power_closeup_panel != null:
		power_closeup_panel.visible = false
	power_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Power equipment close-up closed.")


func _on_power_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_power_closeup()
		get_viewport().set_input_as_handled()


func _is_power_closeup_content_point(viewport_point: Vector2) -> bool:
	if power_closeup_panel == null or not power_closeup_panel.visible:
		return false
	var panel_size := power_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = POWER_CLOSEUP_SIZE
	return Rect2(power_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _on_power_module_pressed(module_key: String) -> void:
	_select_power_module(module_key)
	_log_power_module_action("focus")


func _on_power_inspect_pressed() -> void:
	_log_power_module_action("primary")


func _on_power_explain_pressed() -> void:
	_log_power_module_action("inspect")


func _select_power_module(module_key: String) -> void:
	var module := _get_power_module(module_key)
	if module.is_empty():
		return

	selected_power_module_key = module_key
	for key in power_module_buttons.keys():
		var button: Button = power_module_buttons[key]
		var button_module := _get_power_module(String(key))
		var prefix := "> " if String(key) == selected_power_module_key else ""
		button.text = "%s%s" % [prefix, String(button_module.get("display_name", key))]
	_refresh_power_module_detail()


func _refresh_power_module_detail() -> void:
	var module := _get_power_module(selected_power_module_key)
	if module.is_empty():
		return

	power_module_title_label.text = String(module["display_name"])
	power_module_detail_label.text = "%s\n\n전력 모듈 후보는 아직 연결되지 않았습니다." % String(module["description"])

	var rect: Rect2 = module["rect"]
	power_module_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		power_module_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nmodule rect: %s\nno-op status: OutletMode / SurvivalState disabled" % [
			String(module["key"]),
			String(module["role"]),
			String(module["candidate_action"]),
			_format_rect(rect),
		]

	for key in power_module_guides.keys():
		var guide: ColorRect = power_module_guides[key]
		guide.visible = room_debug_enabled
		guide.color = Color(1.0, 0.78, 0.20, 0.24) if String(key) == selected_power_module_key else Color(0.17, 0.82, 0.92, 0.18)


func _log_power_module_action(action_key: String) -> void:
	var module := _get_power_module(selected_power_module_key)
	if module.is_empty():
		return

	var display_name := String(module["display_name"])
	var role := String(module["role"])
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "power_closeup:%s / role=%s / action=%s / candidate=%s" % [
		selected_power_module_key,
		role,
		action_key,
		String(module["candidate_action"]),
	]
	print("QuarterviewMain power close-up: %s / no production wiring" % last_interaction_debug)
	_update_status("%s: 전력 모듈 후보는 아직 연결되지 않았습니다." % display_name)


func _get_power_module(module_key: String) -> Dictionary:
	for module in POWER_CLOSEUP_MODULES:
		if String(module["key"]) == module_key:
			return module
	return {}


func _build_phone_closeup_overlay() -> void:
	phone_closeup_backdrop = ColorRect.new()
	phone_closeup_backdrop.name = "PhoneCloseupBackdrop"
	phone_closeup_backdrop.visible = false
	phone_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.30)
	phone_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	phone_closeup_backdrop.z_index = 120
	phone_closeup_backdrop.position = Vector2.ZERO
	phone_closeup_backdrop.size = _get_viewport_ui_size()
	phone_closeup_backdrop.gui_input.connect(_on_phone_closeup_backdrop_gui_input)
	$UILayer.add_child(phone_closeup_backdrop)

	phone_closeup_panel = PanelContainer.new()
	phone_closeup_panel.name = "PhoneStatusCloseupCandidate"
	phone_closeup_panel.visible = false
	phone_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	phone_closeup_panel.z_index = 121
	phone_closeup_panel.position = PHONE_CLOSEUP_POSITION
	phone_closeup_panel.custom_minimum_size = PHONE_CLOSEUP_SIZE
	$UILayer.add_child(phone_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	phone_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Phone Candidate"
	title.add_theme_color_override("font_color", Color(0.78, 0.90, 0.96, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "연락 / 충전 상태 확인 후보입니다. PhoneUI / SurvivalState 연결 없음."
	description.add_theme_color_override("font_color", Color(0.74, 0.82, 0.84, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var item_grid := GridContainer.new()
	item_grid.name = "PhoneStatusGrid"
	item_grid.columns = 2
	item_grid.add_theme_constant_override("h_separation", 8)
	item_grid.add_theme_constant_override("v_separation", 8)
	vbox.add_child(item_grid)

	for item in PHONE_CLOSEUP_ITEMS:
		var key := String(item["key"])
		var button := Button.new()
		button.name = "%sPhoneItemButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(250, 74)
		button.tooltip_text = String(item["description"])
		button.pressed.connect(_on_phone_item_pressed.bind(key))
		item_grid.add_child(button)
		phone_item_buttons[key] = button

	phone_item_title_label = Label.new()
	phone_item_title_label.add_theme_color_override("font_color", Color(0.90, 0.88, 0.74, 1.0))
	phone_item_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(phone_item_title_label)

	phone_item_detail_label = Label.new()
	phone_item_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	phone_item_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.84, 1.0))
	phone_item_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(phone_item_detail_label)

	phone_item_debug_label = Label.new()
	phone_item_debug_label.visible = false
	phone_item_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	phone_item_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(phone_item_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "확인"
	use_button.pressed.connect(_on_phone_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_phone_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_phone_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / PhoneUI와 실제 배터리 상태는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.70, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_phone_item(selected_phone_item_key)


func _open_phone_closeup(source_key: String) -> void:
	phone_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	phone_closeup_backdrop.size = _get_viewport_ui_size()
	phone_closeup_backdrop.visible = true
	phone_closeup_panel.visible = true

	if _get_phone_item(selected_phone_item_key).is_empty():
		selected_phone_item_key = "battery"
	_select_phone_item(selected_phone_item_key)

	last_interaction = "Phone candidate / open"
	last_interaction_debug = "%s / role=%s / action=phone_closeup" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain phone close-up opened from %s / no production wiring" % source_key)
	_update_status("Phone candidate opened.")


func _hide_phone_closeup() -> void:
	if phone_closeup_backdrop != null:
		phone_closeup_backdrop.visible = false
	if phone_closeup_panel != null:
		phone_closeup_panel.visible = false
	phone_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Phone candidate closed.")


func _on_phone_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_phone_closeup()
		get_viewport().set_input_as_handled()


func _is_phone_closeup_content_point(viewport_point: Vector2) -> bool:
	if phone_closeup_panel == null or not phone_closeup_panel.visible:
		return false
	var panel_size := phone_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = PHONE_CLOSEUP_SIZE
	return Rect2(phone_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _on_phone_item_pressed(item_key: String) -> void:
	_select_phone_item(item_key)
	_log_phone_item_action("focus")


func _on_phone_use_pressed() -> void:
	_log_phone_item_action("primary")


func _on_phone_inspect_pressed() -> void:
	_log_phone_item_action("inspect")


func _select_phone_item(item_key: String) -> void:
	var item := _get_phone_item(item_key)
	if item.is_empty():
		return

	selected_phone_item_key = item_key
	for key in phone_item_buttons.keys():
		var button: Button = phone_item_buttons[key]
		var button_item := _get_phone_item(String(key))
		var prefix := "> " if String(key) == selected_phone_item_key else ""
		button.text = "%s%s\n%s" % [
			prefix,
			String(button_item.get("display_name", key)),
			String(button_item.get("value", "")),
		]
	_refresh_phone_item_detail()


func _refresh_phone_item_detail() -> void:
	var item := _get_phone_item(selected_phone_item_key)
	if item.is_empty():
		return

	phone_item_title_label.text = String(item["display_name"])
	phone_item_detail_label.text = "%s\n\nPhone candidate only. 실제 PhoneUI / SurvivalState 값은 아직 연결되지 않았습니다." % String(item["description"])

	phone_item_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		phone_item_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nvalue: %s\nno-op status: PhoneUI / SurvivalState disabled" % [
			String(item["key"]),
			String(item["role"]),
			String(item["candidate_action"]),
			String(item["value"]),
		]


func _log_phone_item_action(action_key: String) -> void:
	var item := _get_phone_item(selected_phone_item_key)
	if item.is_empty():
		return

	var display_name := String(item["display_name"])
	var role := String(item["role"])
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "phone_closeup:%s / role=%s / action=%s / candidate=%s" % [
		selected_phone_item_key,
		role,
		action_key,
		String(item["candidate_action"]),
	]
	print("QuarterviewMain phone close-up: %s / no production wiring" % last_interaction_debug)
	_update_status("%s: Phone candidate no-op." % display_name)


func _get_phone_item(item_key: String) -> Dictionary:
	for item in PHONE_CLOSEUP_ITEMS:
		if String(item["key"]) == item_key:
			return item
	return {}


func _is_interaction_panel_open() -> bool:
	return interaction_panel != null and interaction_panel.visible


func _is_interaction_panel_content_point(viewport_point: Vector2) -> bool:
	if not _is_interaction_panel_open():
		return false
	var panel_size := interaction_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = PANEL_FALLBACK_SIZE
	return Rect2(interaction_panel.global_position, panel_size).has_point(viewport_point)


func _get_viewport_ui_size() -> Vector2:
	var viewport_size := get_viewport().get_visible_rect().size
	return Vector2(max(viewport_size.x, 1280.0), max(viewport_size.y, 720.0))


func _on_desk_hotspot_pressed(hotspot_key: String) -> void:
	_select_desk_hotspot(hotspot_key)
	_log_desk_hotspot_action("focus")


func _on_desk_use_pressed() -> void:
	_log_desk_hotspot_action("primary")


func _on_desk_inspect_pressed() -> void:
	_log_desk_hotspot_action("inspect")


func _select_desk_hotspot(hotspot_key: String) -> void:
	var hotspot := _get_desk_hotspot(hotspot_key)
	if hotspot.is_empty():
		return

	selected_desk_hotspot_key = hotspot_key
	for key in desk_hotspot_buttons.keys():
		var button: Button = desk_hotspot_buttons[key]
		var button_hotspot := _get_desk_hotspot(String(key))
		var prefix := "> " if String(key) == selected_desk_hotspot_key else ""
		button.text = "%s%s" % [prefix, String(button_hotspot.get("display_name", key))]
	_refresh_desk_hotspot_detail()


func _refresh_desk_hotspot_detail() -> void:
	var hotspot := _get_desk_hotspot(selected_desk_hotspot_key)
	if hotspot.is_empty():
		return

	desk_hotspot_title_label.text = String(hotspot["display_name"])
	desk_hotspot_detail_label.text = String(hotspot["description"])

	var rect: Rect2 = hotspot["rect"]
	desk_hotspot_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		desk_hotspot_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nhotspot rect: %s\nno-op status: production wiring disabled" % [
			String(hotspot["key"]),
			String(hotspot["role"]),
			String(hotspot["candidate_action"]),
			_format_rect(rect),
		]

	for key in desk_hotspot_guides.keys():
		var guide: ColorRect = desk_hotspot_guides[key]
		guide.visible = room_debug_enabled
		guide.color = Color(1.0, 0.78, 0.20, 0.24) if String(key) == selected_desk_hotspot_key else Color(0.17, 0.82, 0.92, 0.18)


func _log_desk_hotspot_action(action_key: String) -> void:
	var hotspot := _get_desk_hotspot(selected_desk_hotspot_key)
	if hotspot.is_empty():
		return

	var display_name := String(hotspot["display_name"])
	var role := String(hotspot["role"])
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "desk_closeup:%s / role=%s / action=%s / candidate=%s" % [
		selected_desk_hotspot_key,
		role,
		action_key,
		String(hotspot["candidate_action"]),
	]
	print("QuarterviewMain desk close-up: %s / no production wiring" % last_interaction_debug)
	_update_status("%s: %s candidate no-op." % [display_name, _get_action_display_name(action_key)])


func _get_desk_hotspot(hotspot_key: String) -> Dictionary:
	for hotspot in DESK_CLOSEUP_HOTSPOTS:
		if String(hotspot["key"]) == hotspot_key:
			return hotspot
	return {}


func _get_normal_object_description(payload: Dictionary) -> String:
	match String(payload.get("role", "")):
		"manual_end_day":
			return "잠시 쉬거나 하루를 정리할 수 있을 것 같다."
		"laptop_job":
			return "작업과 의뢰를 확인할 수 있을 것 같다."
		"phone_status", "phone_charge":
			return "연락과 충전 상태를 확인할 수 있을 것 같다."
		"power_management":
			return "방의 전력 장비를 살펴볼 수 있을 것 같다."
		"communication":
			return "외부 신호 상태를 확인할 수 있을 것 같다."
		"mystery_device":
			return "정체를 알 수 없는 장치가 조용히 켜져 있다."
		"audio_hacking_device":
			return "소리와 신호를 분석하는 장비처럼 보인다."
		"living_appliance":
			return "생활에 필요한 작은 장비다."
		_:
			return "가까이에서 살펴볼 수 있다."


func _get_debug_object_detail(object_key: String, payload: Dictionary) -> String:
	return "key: %s\nrole: %s\nzone: %s\naction: %s\npriority: %s\napproach: %s\nclick: %s\ncandidate no-op only" % [
		object_key,
		_get_debug_payload_text(payload, "role"),
		_get_debug_payload_text(payload, "zone"),
		_get_debug_payload_text(payload, "action"),
		_get_debug_payload_text(payload, "priority"),
		_format_vector(_get_payload_vector(payload, "approach_position")),
		_format_rect(_get_payload_rect(payload, "click_area")),
	]


func _get_action_display_name(action_key: String) -> String:
	match action_key:
		"primary":
			return "사용하기"
		"inspect":
			return "설명"
		"cancel":
			return "취소"
		"focus":
			return "선택"
		_:
			return action_key


func _position_interaction_panel(payload: Dictionary) -> void:
	var anchor := _get_payload_vector(payload, "approach_position")
	if anchor == Vector2.ZERO:
		anchor = _get_payload_vector(payload, "interaction_position")
	if anchor == Vector2.ZERO:
		anchor = Vector2(860, 360)

	var viewport_size := get_viewport().get_visible_rect().size
	var panel_size := PANEL_FALLBACK_SIZE
	if interaction_panel.size.x > 1.0 and interaction_panel.size.y > 1.0:
		panel_size = Vector2(
			max(interaction_panel.size.x, PANEL_FALLBACK_SIZE.x),
			max(interaction_panel.size.y, PANEL_FALLBACK_SIZE.y)
		)

	# Prefer the object's right/top side, then flip left when the selected object is
	# near the room's right edge. The final clamp keeps this candidate UI inside the viewport.
	var target_position := anchor + PANEL_OBJECT_OFFSET
	if target_position.x + panel_size.x > viewport_size.x - PANEL_VIEWPORT_MARGIN:
		target_position.x = anchor.x - panel_size.x - PANEL_OBJECT_OFFSET.x
	if target_position.y + panel_size.y > viewport_size.y - PANEL_VIEWPORT_MARGIN:
		target_position.y = viewport_size.y - PANEL_VIEWPORT_MARGIN - panel_size.y

	target_position = _clamp_panel_position(target_position, panel_size, viewport_size)
	var panel_rect := Rect2(target_position, panel_size)
	if panel_rect.intersects(STATUS_PANEL_AVOID_RECT):
		target_position.y = STATUS_PANEL_AVOID_RECT.end.y + PANEL_VIEWPORT_MARGIN
		if target_position.y + panel_size.y > viewport_size.y - PANEL_VIEWPORT_MARGIN:
			target_position = Vector2(STATUS_PANEL_AVOID_RECT.end.x + PANEL_VIEWPORT_MARGIN, PANEL_VIEWPORT_MARGIN)
	target_position = _clamp_panel_position(target_position, panel_size, viewport_size)
	interaction_panel.position = target_position


func _clamp_panel_position(panel_position: Vector2, panel_size: Vector2, viewport_size: Vector2) -> Vector2:
	return Vector2(
		clampf(panel_position.x, PANEL_VIEWPORT_MARGIN, viewport_size.x - PANEL_VIEWPORT_MARGIN - panel_size.x),
		clampf(panel_position.y, PANEL_VIEWPORT_MARGIN, viewport_size.y - PANEL_VIEWPORT_MARGIN - panel_size.y)
	)


func _get_room_debug_summary() -> String:
	if quarterview_room.has_method("get_debug_focus_summary"):
		return String(quarterview_room.get_debug_focus_summary())
	return "Debug focus: unavailable"


func _get_payload_vector(payload: Dictionary, key: String) -> Vector2:
	var value = payload.get(key, Vector2.ZERO)
	if value is Vector2:
		return value
	return Vector2.ZERO


func _get_payload_rect(payload: Dictionary, key: String) -> Rect2:
	var value = payload.get(key, Rect2())
	if value is Rect2:
		return value
	return Rect2()


func _get_debug_payload_text(payload: Dictionary, key: String) -> String:
	return _debug_value_to_text(payload.get(key, null))


func _debug_value_to_text(value: Variant) -> String:
	if value == null:
		return "N/A"
	if value is Vector2:
		return _format_vector(value)
	if value is Rect2:
		return _format_rect(value)
	return str(value)


func _format_vector(value: Vector2) -> String:
	return "(%d, %d)" % [int(round(value.x)), int(round(value.y))]


func _format_rect(rect: Rect2) -> String:
	return "(%d, %d, %d, %d)" % [
		int(round(rect.position.x)),
		int(round(rect.position.y)),
		int(round(rect.size.x)),
		int(round(rect.size.y)),
	]
