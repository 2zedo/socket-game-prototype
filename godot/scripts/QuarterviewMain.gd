extends Node2D

const PhoneScreenCandidateScript := preload("res://scripts/ui/quarterview/PhoneScreenCandidate.gd")
const PowerBoardCandidateScript := preload("res://scripts/ui/quarterview/PowerBoardCandidate.gd")

const RESTART_KEY := KEY_R
const CANCEL_KEY := KEY_ESCAPE
const PANEL_VIEWPORT_MARGIN := 18.0
const PANEL_OBJECT_OFFSET := Vector2(34, -118)
const PANEL_FALLBACK_SIZE := Vector2(340, 152)
const STATUS_PANEL_AVOID_RECT := Rect2(Vector2(10, 10), Vector2(334, 160))
const DESK_CLOSEUP_SIZE := Vector2(730, 520)
const DESK_CLOSEUP_POSITION := Vector2(390, 74)
const DESK_CLOSEUP_ENTRY_KEYS := ["desk", "laptop"]
const POWER_CLOSEUP_SIZE := Vector2(860, 520)
const POWER_CLOSEUP_POSITION := Vector2(340, 74)
const POWER_CLOSEUP_ENTRY_KEYS := ["power"]
const PHONE_CLOSEUP_SIZE := Vector2(690, 520)
const PHONE_CLOSEUP_POSITION := Vector2(430, 84)
const PHONE_CLOSEUP_ENTRY_KEYS := ["phone"]
const BED_CLOSEUP_SIZE := Vector2(590, 430)
const BED_CLOSEUP_POSITION := Vector2(480, 116)
const BED_CLOSEUP_ENTRY_KEYS := ["bed"]
const KITCHEN_CLOSEUP_SIZE := Vector2(620, 456)
const KITCHEN_CLOSEUP_POSITION := Vector2(460, 102)
const KITCHEN_CLOSEUP_ENTRY_KEYS := ["fridge", "microwave"]
const DOOR_CLOSEUP_SIZE := Vector2(560, 408)
const DOOR_CLOSEUP_POSITION := Vector2(500, 126)
const DOOR_CLOSEUP_ENTRY_KEYS := ["door"]
const DAY_RESULT_SIZE := Vector2(620, 430)
const DAY_RESULT_POSITION := Vector2(460, 116)
const PROTOTYPE_HUD_POSITION := Vector2(974, 18)
const PROTOTYPE_HUD_SIZE := Vector2(288, 116)
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
const BED_REST_OPTIONS := [
	{
		"key": "short_rest",
		"display_name": "잠깐 쉰다",
		"role": "rest_candidate",
		"description": "짧게 숨을 고르는 후보 행동입니다. 실제 시간 / 컨디션 변화는 아직 없습니다.",
		"candidate_action": "short_rest_noop",
		"value": "time +0 / condition +0",
	},
	{
		"key": "end_day",
		"display_name": "오늘을 마무리한다",
		"role": "manual_end_day",
		"description": "하루 종료 후보 행동입니다. DayResultPanel과 SurvivalState day advance는 아직 연결하지 않았습니다.",
		"candidate_action": "end_day_candidate_noop",
		"value": "result candidate only",
	},
	{
		"key": "check_condition",
		"display_name": "몸 상태를 확인한다",
		"role": "condition_check",
		"description": "허기 / 컨디션 / 피로 표시 후보입니다. 실제 production 상태값은 읽지 않습니다.",
		"candidate_action": "check_condition_noop",
		"value": "hunger / condition mock",
	},
]
const KITCHEN_CANDIDATE_OPTIONS := [
	{
		"key": "stored_food",
		"sources": ["fridge"],
		"display_name": "보관 식량 확인",
		"role": "food_storage",
		"description": "냉장고 안의 보관 식량 후보를 확인합니다. 실제 inventory나 허기 수치는 읽지 않습니다.",
		"candidate_action": "check_stored_food_noop",
		"value": "inventory not wired",
	},
	{
		"key": "find_quick_food",
		"sources": ["fridge"],
		"display_name": "간단히 먹을 것 찾기",
		"role": "food_search",
		"description": "바로 먹을 수 있는 합성 식품 후보를 찾습니다. 실제 허기 회복은 없습니다.",
		"candidate_action": "find_quick_food_noop",
		"value": "hunger +0",
	},
	{
		"key": "fridge_status",
		"sources": ["fridge"],
		"display_name": "냉장고 상태 확인",
		"role": "appliance_status",
		"description": "냉장고 전원과 보관 상태 후보를 확인합니다. 실제 전력 소비나 식량 리스크는 계산하지 않습니다.",
		"candidate_action": "check_fridge_status_noop",
		"value": "power state mock",
	},
	{
		"key": "heat_synthetic_food",
		"sources": ["microwave"],
		"display_name": "합성 식품 데우기",
		"role": "food_cooking",
		"description": "합성 식품을 데우는 후보 행동입니다. 실제 조리 시간이나 전력 소비는 없습니다.",
		"candidate_action": "heat_synthetic_food_noop",
		"value": "power +0 / hunger +0",
	},
	{
		"key": "cooking_status",
		"sources": ["microwave"],
		"display_name": "조리 상태 확인",
		"role": "appliance_status",
		"description": "전자레인지 상태 후보를 확인합니다. 실제 고장 / 발열 / 전력 계산과 연결하지 않았습니다.",
		"candidate_action": "check_cooking_status_noop",
		"value": "idle mock",
	},
	{
		"key": "think_food_plan",
		"sources": ["microwave"],
		"display_name": "오늘 먹을 것 생각하기",
		"role": "food_plan",
		"description": "오늘 식사 계획 후보입니다. 실제 하루 루프나 결과 기록과 연결하지 않았습니다.",
		"candidate_action": "think_food_plan_noop",
		"value": "plan candidate",
	},
]
const DOOR_CANDIDATE_OPTIONS := [
	{
		"key": "check_hallway",
		"display_name": "문 밖 상황 확인",
		"role": "door_check",
		"description": "복도와 문밖 상황을 살피는 후보 행동입니다. 실제 외출 맵이나 이벤트 체크는 없습니다.",
		"candidate_action": "check_hallway_noop",
		"value": "outside map not wired",
	},
	{
		"key": "listen_corridor",
		"display_name": "복도 소리 듣기",
		"role": "door_listen",
		"description": "복도의 소음과 인기척을 들어보는 후보 행동입니다. 실제 story flag나 위험도 계산은 없습니다.",
		"candidate_action": "listen_corridor_noop",
		"value": "story flag +0",
	},
	{
		"key": "prepare_outing",
		"display_name": "외출 준비 생각하기",
		"role": "outing_plan",
		"description": "나갈지 말지 생각하는 후보 행동입니다. scene transition, save-load, 외부 맵은 아직 연결하지 않았습니다.",
		"candidate_action": "prepare_outing_noop",
		"value": "scene transition disabled",
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
var mock_day := 1
var mock_time := "20:30"
var mock_power_percent := 62
var mock_power_state := "안정"
var mock_hunger := "보통"
var mock_condition := "안정"
var mock_info := "없음"
var mock_status_note := "대기"
var desk_closeup_open := false
var power_closeup_open := false
var phone_closeup_open := false
var bed_closeup_open := false
var kitchen_closeup_open := false
var door_closeup_open := false
var day_result_open := false
var selected_desk_hotspot_key := "laptop"
var selected_power_module_key := "small_core"
var selected_phone_item_key := "battery"
var selected_phone_tab_key := "status"
var selected_bed_option_key := "short_rest"
var selected_kitchen_option_key := "stored_food"
var selected_door_option_key := "check_hallway"
var current_kitchen_source_key := "fridge"
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
var power_closeup_panel
var phone_closeup_backdrop: ColorRect
var phone_closeup_panel
var bed_closeup_backdrop: ColorRect
var bed_closeup_panel: PanelContainer
var bed_option_buttons := {}
var bed_option_title_label: Label
var bed_option_detail_label: Label
var bed_option_debug_label: Label
var kitchen_closeup_backdrop: ColorRect
var kitchen_closeup_panel: PanelContainer
var kitchen_option_buttons := {}
var kitchen_title_label: Label
var kitchen_description_label: Label
var kitchen_option_title_label: Label
var kitchen_option_detail_label: Label
var kitchen_option_debug_label: Label
var door_closeup_backdrop: ColorRect
var door_closeup_panel: PanelContainer
var door_option_buttons := {}
var door_option_title_label: Label
var door_option_detail_label: Label
var door_option_debug_label: Label
var prototype_hud_panel: PanelContainer
var prototype_hud_label: Label
var day_result_backdrop: ColorRect
var day_result_panel: PanelContainer
var day_result_summary_label: Label
var day_result_detail_label: Label


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

	_build_prototype_hud()
	_build_interaction_panel()
	_build_desk_closeup_overlay()
	_build_power_closeup_overlay()
	_build_phone_closeup_overlay()
	_build_bed_closeup_overlay()
	_build_kitchen_closeup_overlay()
	_build_door_closeup_overlay()
	_build_day_result_candidate_overlay()
	_update_status("QuarterviewMain candidate ready.")


func _unhandled_input(event: InputEvent) -> void:
	if day_result_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_day_result_content_point(event.position):
			_hide_day_result_candidate()
		get_viewport().set_input_as_handled()
		return

	if door_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_door_closeup_content_point(event.position):
			_hide_door_closeup()
		get_viewport().set_input_as_handled()
		return

	if kitchen_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_kitchen_closeup_content_point(event.position):
			_hide_kitchen_closeup()
		get_viewport().set_input_as_handled()
		return

	if bed_closeup_open and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_bed_closeup_content_point(event.position):
			_hide_bed_closeup()
		get_viewport().set_input_as_handled()
		return

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
			if day_result_open:
				_hide_day_result_candidate()
				get_viewport().set_input_as_handled()
				return
			if door_closeup_open:
				_hide_door_closeup()
				get_viewport().set_input_as_handled()
				return
			if kitchen_closeup_open:
				_hide_kitchen_closeup()
				get_viewport().set_input_as_handled()
				return
			if bed_closeup_open:
				_hide_bed_closeup()
				get_viewport().set_input_as_handled()
				return
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
	if bed_closeup_open:
		_refresh_bed_option_detail()
	if kitchen_closeup_open:
		_refresh_kitchen_option_detail()
	if door_closeup_open:
		_refresh_door_option_detail()
	if day_result_open:
		_refresh_day_result_candidate()
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


func _build_prototype_hud() -> void:
	prototype_hud_panel = PanelContainer.new()
	prototype_hud_panel.name = "PrototypeHudPanel"
	prototype_hud_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	prototype_hud_panel.position = PROTOTYPE_HUD_POSITION
	prototype_hud_panel.custom_minimum_size = PROTOTYPE_HUD_SIZE
	$UILayer.add_child(prototype_hud_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	prototype_hud_panel.add_child(margin)

	prototype_hud_label = Label.new()
	prototype_hud_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prototype_hud_label.add_theme_color_override("font_color", Color(0.86, 0.84, 0.74, 1.0))
	prototype_hud_label.add_theme_font_size_override("font_size", 13)
	margin.add_child(prototype_hud_label)
	_refresh_prototype_hud()


func _refresh_prototype_hud() -> void:
	if prototype_hud_label == null:
		return
	prototype_hud_label.text = "Quarterview HUD (mock)\nDAY %d | 시간 %s\n전력 %d%% (%s) | 허기 %s\n컨디션 %s | 메모 %s" % [
		mock_day,
		mock_time,
		mock_power_percent,
		mock_power_state,
		mock_hunger,
		mock_condition,
		mock_status_note,
	]


func _refresh_mock_state_views() -> void:
	_refresh_prototype_hud()
	if day_result_open:
		_refresh_day_result_candidate()


func _set_mock_status_note(note: String) -> void:
	mock_status_note = note
	_refresh_mock_state_views()


func _set_mock_power_state(percent: int, state: String, note: String) -> void:
	mock_power_percent = clampi(percent, 0, 100)
	mock_power_state = state
	mock_status_note = note
	_refresh_mock_state_views()


func _set_mock_hunger_state(hunger: String, note: String, power_delta := 0) -> void:
	mock_hunger = hunger
	if power_delta != 0:
		mock_power_percent = clampi(mock_power_percent + power_delta, 0, 100)
	mock_status_note = note
	_refresh_mock_state_views()


func _set_mock_condition_state(condition: String, note: String, time_label := "") -> void:
	mock_condition = condition
	if not time_label.is_empty():
		mock_time = time_label
	mock_status_note = note
	_refresh_mock_state_views()


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
	if _should_open_door_closeup():
		_open_door_closeup(focused_object_key)
		return
	if _should_open_kitchen_closeup():
		_open_kitchen_closeup(focused_object_key)
		return
	if _should_open_bed_closeup():
		_open_bed_closeup(focused_object_key)
		return
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
	return desk_closeup_open or power_closeup_open or phone_closeup_open or bed_closeup_open or kitchen_closeup_open or door_closeup_open or day_result_open


func _get_modal_status_text(default_text: String) -> String:
	if day_result_open:
		return "Day result candidate open / room input locked"
	if door_closeup_open:
		return "Door candidate open / room input locked"
	if kitchen_closeup_open:
		return "Food / kitchen candidate open / room input locked"
	if bed_closeup_open:
		return "Bed rest candidate open / room input locked"
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


func _should_open_bed_closeup() -> bool:
	var role := String(focused_payload.get("role", ""))
	return focused_object_key in BED_CLOSEUP_ENTRY_KEYS or role == "manual_end_day"


func _should_open_kitchen_closeup() -> bool:
	return focused_object_key in KITCHEN_CLOSEUP_ENTRY_KEYS


func _should_open_door_closeup() -> bool:
	return focused_object_key in DOOR_CLOSEUP_ENTRY_KEYS


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

	power_closeup_panel = PowerBoardCandidateScript.new()
	power_closeup_panel.visible = false
	power_closeup_panel.z_index = 111
	power_closeup_panel.position = POWER_CLOSEUP_POSITION
	power_closeup_panel.custom_minimum_size = POWER_CLOSEUP_SIZE
	power_closeup_panel.close_requested.connect(_hide_power_closeup)
	power_closeup_panel.module_action_requested.connect(_on_power_module_action_requested)
	power_closeup_panel.module_dropped.connect(_on_power_module_dropped)
	power_closeup_panel.selection_changed.connect(_on_power_module_selection_changed)
	$UILayer.add_child(power_closeup_panel)


func _open_power_closeup(source_key: String) -> void:
	power_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	power_closeup_backdrop.size = _get_viewport_ui_size()
	power_closeup_backdrop.visible = true
	power_closeup_panel.visible = true
	selected_power_module_key = power_closeup_panel.reset_selection(selected_power_module_key)
	power_closeup_panel.set_debug_enabled(room_debug_enabled)

	last_interaction = "Power equipment / open"
	last_interaction_debug = "%s / role=%s / action=power_closeup" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain power close-up opened from %s / no production wiring" % source_key)
	_update_status("Power equipment close-up candidate opened.")


func _hide_power_closeup() -> void:
	if power_closeup_panel != null:
		power_closeup_panel.clear_drag_state()
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
	var panel_size: Vector2 = power_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = POWER_CLOSEUP_SIZE
	return Rect2(power_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _refresh_power_module_detail() -> void:
	if power_closeup_panel != null:
		power_closeup_panel.set_debug_enabled(room_debug_enabled)


func _on_power_module_selection_changed(module_key: String, _module: Dictionary) -> void:
	selected_power_module_key = module_key


func _on_power_module_action_requested(module_key: String, action_key: String, module: Dictionary) -> void:
	selected_power_module_key = module_key
	if action_key == "invalid_drop":
		_update_status("%s: %s 원래 위치로 돌아갑니다." % [
			String(module.get("display_name", module_key)),
			String(module.get("drop_reason", "invalid drop /")),
		])
		return

	var display_name := String(module.get("display_name", module_key))
	var role := String(module.get("role", "-"))
	var mock_effect := _apply_power_mock_effect(module_key, action_key)
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "power_closeup:%s / role=%s / action=%s / candidate=%s" % [
		module_key,
		role,
		action_key,
		String(module.get("candidate_action", "-")),
	]
	print("QuarterviewMain power close-up: %s / no production wiring" % last_interaction_debug)
	var status_text := "%s: 전력 모듈 후보는 아직 연결되지 않았습니다." % display_name
	if not mock_effect.is_empty():
		status_text = "%s: %s" % [display_name, mock_effect]
	_update_status(status_text)


func _on_power_module_dropped(module_key: String, cell: Vector2i, module: Dictionary) -> void:
	selected_power_module_key = module_key
	last_interaction = "%s / grid snap" % String(module.get("display_name", module_key))
	last_interaction_debug = "power_board:%s / action=drag_snap / cell=%s / no OutletMode" % [module_key, str(cell)]
	print("QuarterviewMain power board drag: %s / no production wiring" % last_interaction_debug)
	_update_status("%s: grid %s에 배치 후보로 snap되었습니다. 실제 전력 계산 없음." % [
		String(module.get("display_name", module_key)),
		str(cell),
	])


func _apply_power_mock_effect(module_key: String, action_key: String) -> String:
	if action_key != "primary":
		return ""

	match module_key:
		"small_core":
			_set_mock_power_state(mock_power_percent + 2, "저장 안정", "배터리 후보 점검")
			return "mock 작은 코어 배치 상태가 안정 쪽으로 표시됩니다."
		"laptop_adapter":
			_set_mock_power_state(mock_power_percent, "배선 확인", "소켓 레일 확인")
			return "mock 노트북 어댑터 배선 상태를 확인했습니다."
		"comm_module":
			_set_mock_power_state(mock_power_percent + 1, "과부하 낮음", "제한기 확인")
			return "mock 통신 모듈 공급 상태가 낮은 위험으로 표시됩니다."
		"odd_efficiency_module":
			_set_mock_power_state(mock_power_percent - 1, "어댑터 후보", "어댑터 점검")
			return "mock 효율 모듈 후보 점검으로 전력이 소폭 변했습니다."
		_:
			_set_mock_power_state(mock_power_percent, "확인됨", "전력 후보 확인")
			return "mock 전력 상태를 확인했습니다."


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

	phone_closeup_panel = PhoneScreenCandidateScript.new()
	phone_closeup_panel.visible = false
	phone_closeup_panel.z_index = 121
	phone_closeup_panel.position = PHONE_CLOSEUP_POSITION
	phone_closeup_panel.custom_minimum_size = PHONE_CLOSEUP_SIZE
	phone_closeup_panel.close_requested.connect(_hide_phone_closeup)
	phone_closeup_panel.item_action_requested.connect(_on_phone_item_action_requested)
	phone_closeup_panel.tab_action_requested.connect(_on_phone_tab_action_requested)
	phone_closeup_panel.selection_changed.connect(_on_phone_selection_changed)
	$UILayer.add_child(phone_closeup_panel)


func _open_phone_closeup(source_key: String) -> void:
	phone_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	phone_closeup_backdrop.size = _get_viewport_ui_size()
	phone_closeup_backdrop.visible = true
	phone_closeup_panel.visible = true
	var selection: Dictionary = phone_closeup_panel.reset_selection(selected_phone_item_key, selected_phone_tab_key)
	selected_phone_item_key = String(selection.get("item_key", "battery"))
	selected_phone_tab_key = String(selection.get("tab_key", "status"))
	phone_closeup_panel.set_debug_enabled(room_debug_enabled)

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
	var panel_size: Vector2 = phone_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = PHONE_CLOSEUP_SIZE
	return Rect2(phone_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _refresh_phone_item_detail() -> void:
	if phone_closeup_panel != null:
		phone_closeup_panel.set_debug_enabled(room_debug_enabled)


func _on_phone_selection_changed(tab_key: String, item_key: String) -> void:
	selected_phone_tab_key = tab_key
	selected_phone_item_key = item_key


func _on_phone_item_action_requested(item_key: String, action_key: String, item: Dictionary) -> void:
	selected_phone_tab_key = "status"
	selected_phone_item_key = item_key
	var display_name := String(item.get("display_name", item_key))
	var role := String(item.get("role", "-"))
	var mock_effect := _apply_phone_mock_effect(item_key, action_key)
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "phone_closeup:%s / role=%s / action=%s / candidate=%s" % [
		item_key,
		role,
		action_key,
		String(item.get("candidate_action", "-")),
	]
	print("QuarterviewMain phone close-up: %s / no production wiring" % last_interaction_debug)
	var status_text := "%s: Phone candidate no-op." % display_name
	if not mock_effect.is_empty():
		status_text = "%s: %s" % [display_name, mock_effect]
	_update_status(status_text)


func _on_phone_tab_action_requested(tab_key: String, action_key: String, tab: Dictionary) -> void:
	selected_phone_tab_key = tab_key
	var display_name := String(tab.get("display_name", tab_key))
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "phone_screen:%s / role=%s / action=%s / candidate=%s" % [
		tab_key,
		String(tab.get("role", "-")),
		action_key,
		String(tab.get("candidate_action", "-")),
	]
	print("QuarterviewMain phone screen candidate: %s / no production wiring" % last_interaction_debug)
	if action_key == "primary":
		match tab_key:
			"message":
				mock_info = "Phone 메시지 후보 확인"
				_set_mock_status_note("메시지 탭 확인")
			"job":
				mock_info = "익명 의뢰 후보 확인"
				_set_mock_status_note("의뢰 탭 확인")
			_:
				_set_mock_status_note("Phone 탭 확인")
	_update_status("%s: Phone screen candidate no-op." % display_name)


func _apply_phone_mock_effect(item_key: String, action_key: String) -> String:
	if action_key == "inspect":
		return ""

	match item_key:
		"battery":
			_set_mock_status_note("Phone battery 후보 확인")
			return "mock HUD 메모에 배터리 확인이 기록됩니다."
		"signal":
			mock_info = "신호 약함"
			_set_mock_status_note("THE GRID 신호 약함")
			return "mock 정보 수집 항목에 약한 신호가 기록됩니다."
		"messages":
			mock_info = "새 메시지 없음"
			_set_mock_status_note("메시지 없음")
			return "mock 정보 수집 항목에 메시지 없음이 기록됩니다."
		"charge_port":
			_set_mock_status_note("충전 포트 확인")
			return "mock HUD 메모에 충전 포트 확인이 기록됩니다."
		_:
			_set_mock_status_note("Phone 후보 확인")
			return "mock HUD 메모가 갱신됩니다."


func _build_bed_closeup_overlay() -> void:
	bed_closeup_backdrop = ColorRect.new()
	bed_closeup_backdrop.name = "BedCloseupBackdrop"
	bed_closeup_backdrop.visible = false
	bed_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.31)
	bed_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	bed_closeup_backdrop.z_index = 130
	bed_closeup_backdrop.position = Vector2.ZERO
	bed_closeup_backdrop.size = _get_viewport_ui_size()
	bed_closeup_backdrop.gui_input.connect(_on_bed_closeup_backdrop_gui_input)
	$UILayer.add_child(bed_closeup_backdrop)

	bed_closeup_panel = PanelContainer.new()
	bed_closeup_panel.name = "BedRestCloseupCandidate"
	bed_closeup_panel.visible = false
	bed_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	bed_closeup_panel.z_index = 131
	bed_closeup_panel.position = BED_CLOSEUP_POSITION
	bed_closeup_panel.custom_minimum_size = BED_CLOSEUP_SIZE
	$UILayer.add_child(bed_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	bed_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Bed Rest Candidate"
	title.add_theme_color_override("font_color", Color(0.94, 0.84, 0.68, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "휴식 / 하루 마무리 후보입니다. DayResultPanel / SurvivalState 연결 없음."
	description.add_theme_color_override("font_color", Color(0.78, 0.82, 0.76, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var option_column := VBoxContainer.new()
	option_column.add_theme_constant_override("separation", 8)
	vbox.add_child(option_column)

	for option in BED_REST_OPTIONS:
		var key := String(option["key"])
		var button := Button.new()
		button.name = "%sBedOptionButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(520, 48)
		button.tooltip_text = String(option["description"])
		button.pressed.connect(_on_bed_option_pressed.bind(key))
		option_column.add_child(button)
		bed_option_buttons[key] = button

	bed_option_title_label = Label.new()
	bed_option_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	bed_option_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(bed_option_title_label)

	bed_option_detail_label = Label.new()
	bed_option_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bed_option_detail_label.add_theme_color_override("font_color", Color(0.76, 0.82, 0.80, 1.0))
	bed_option_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(bed_option_detail_label)

	bed_option_debug_label = Label.new()
	bed_option_debug_label.visible = false
	bed_option_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	bed_option_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(bed_option_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "선택"
	use_button.pressed.connect(_on_bed_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_bed_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_bed_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / 실제 하루 종료와 Result는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_bed_option(selected_bed_option_key)


func _open_bed_closeup(source_key: String) -> void:
	bed_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	bed_closeup_backdrop.size = _get_viewport_ui_size()
	bed_closeup_backdrop.visible = true
	bed_closeup_panel.visible = true

	if _get_bed_option(selected_bed_option_key).is_empty():
		selected_bed_option_key = "short_rest"
	_select_bed_option(selected_bed_option_key)

	last_interaction = "Bed rest candidate / open"
	last_interaction_debug = "%s / role=%s / action=bed_rest_candidate" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain bed rest candidate opened from %s / no production wiring" % source_key)
	_update_status("Bed rest candidate opened.")


func _hide_bed_closeup() -> void:
	if bed_closeup_backdrop != null:
		bed_closeup_backdrop.visible = false
	if bed_closeup_panel != null:
		bed_closeup_panel.visible = false
	bed_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Bed rest candidate closed.")


func _on_bed_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_bed_closeup()
		get_viewport().set_input_as_handled()


func _is_bed_closeup_content_point(viewport_point: Vector2) -> bool:
	if bed_closeup_panel == null or not bed_closeup_panel.visible:
		return false
	var panel_size := bed_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = BED_CLOSEUP_SIZE
	return Rect2(bed_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _on_bed_option_pressed(option_key: String) -> void:
	_select_bed_option(option_key)
	_log_bed_option_action("focus")


func _on_bed_use_pressed() -> void:
	if selected_bed_option_key == "end_day":
		_open_day_result_candidate()
		return
	_log_bed_option_action("primary")


func _on_bed_inspect_pressed() -> void:
	_log_bed_option_action("inspect")


func _select_bed_option(option_key: String) -> void:
	var option := _get_bed_option(option_key)
	if option.is_empty():
		return

	selected_bed_option_key = option_key
	for key in bed_option_buttons.keys():
		var button: Button = bed_option_buttons[key]
		var button_option := _get_bed_option(String(key))
		var prefix := "> " if String(key) == selected_bed_option_key else ""
		button.text = "%s%s  -  %s" % [
			prefix,
			String(button_option.get("display_name", key)),
			String(button_option.get("value", "")),
		]
	_refresh_bed_option_detail()


func _refresh_bed_option_detail() -> void:
	var option := _get_bed_option(selected_bed_option_key)
	if option.is_empty():
		return

	bed_option_title_label.text = String(option["display_name"])
	bed_option_detail_label.text = "%s\n\nBed candidate only. 실제 하루 종료 / 결과 계산은 아직 연결되지 않았습니다." % String(option["description"])

	bed_option_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		bed_option_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nvalue: %s\nno-op status: DayResultPanel / SurvivalState disabled" % [
			String(option["key"]),
			String(option["role"]),
			String(option["candidate_action"]),
			String(option["value"]),
		]


func _log_bed_option_action(action_key: String) -> void:
	var option := _get_bed_option(selected_bed_option_key)
	if option.is_empty():
		return

	var display_name := String(option["display_name"])
	var role := String(option["role"])
	var mock_effect := _apply_bed_mock_effect(selected_bed_option_key, action_key)
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "bed_closeup:%s / role=%s / action=%s / candidate=%s" % [
		selected_bed_option_key,
		role,
		action_key,
		String(option["candidate_action"]),
	]
	print("QuarterviewMain bed rest candidate: %s / no production wiring" % last_interaction_debug)
	var status_text := "%s: Bed rest candidate no-op." % display_name
	if not mock_effect.is_empty():
		status_text = "%s: %s" % [display_name, mock_effect]
	_update_status(status_text)


func _apply_bed_mock_effect(option_key: String, action_key: String) -> String:
	if action_key != "primary":
		return ""

	match option_key:
		"short_rest":
			_set_mock_condition_state("조금 회복", "잠깐 쉼", "21:10")
			return "mock 컨디션이 조금 좋아지고 시간이 21:10으로 표시됩니다."
		"check_condition":
			_set_mock_status_note("컨디션 / 허기 확인")
			return "mock HUD 상태를 확인했습니다."
		_:
			return ""


func _get_bed_option(option_key: String) -> Dictionary:
	for option in BED_REST_OPTIONS:
		if String(option["key"]) == option_key:
			return option
	return {}


func _build_day_result_candidate_overlay() -> void:
	day_result_backdrop = ColorRect.new()
	day_result_backdrop.name = "DayResultCandidateBackdrop"
	day_result_backdrop.visible = false
	day_result_backdrop.color = Color(0.0, 0.0, 0.0, 0.36)
	day_result_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	day_result_backdrop.z_index = 160
	day_result_backdrop.position = Vector2.ZERO
	day_result_backdrop.size = _get_viewport_ui_size()
	day_result_backdrop.gui_input.connect(_on_day_result_backdrop_gui_input)
	$UILayer.add_child(day_result_backdrop)

	day_result_panel = PanelContainer.new()
	day_result_panel.name = "DayResultCandidate"
	day_result_panel.visible = false
	day_result_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	day_result_panel.z_index = 161
	day_result_panel.position = DAY_RESULT_POSITION
	day_result_panel.custom_minimum_size = DAY_RESULT_SIZE
	$UILayer.add_child(day_result_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 18)
	day_result_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "오늘의 결과"
	title.add_theme_color_override("font_color", Color(0.96, 0.86, 0.62, 1.0))
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "QuarterviewMain 전용 mock 결과 화면입니다. DayResultPanel / SurvivalState / save-load 연결 없음."
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_color_override("font_color", Color(0.76, 0.84, 0.80, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	day_result_summary_label = Label.new()
	day_result_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	day_result_summary_label.add_theme_color_override("font_color", Color(0.88, 0.86, 0.76, 1.0))
	day_result_summary_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(day_result_summary_label)

	day_result_detail_label = Label.new()
	day_result_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	day_result_detail_label.add_theme_color_override("font_color", Color(0.64, 0.74, 0.74, 1.0))
	day_result_detail_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(day_result_detail_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var next_day_button := Button.new()
	next_day_button.text = "다음 날 후보"
	next_day_button.pressed.connect(_on_day_result_next_day_pressed)
	button_row.add_child(next_day_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_day_result_candidate)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / 실제 하루 진행, 결과 저장, story flag는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_refresh_day_result_candidate()


func _open_day_result_candidate() -> void:
	if bed_closeup_open:
		_hide_bed_closeup()

	day_result_open = true
	_set_room_input_locked(true)
	day_result_backdrop.size = _get_viewport_ui_size()
	day_result_backdrop.visible = true
	day_result_panel.visible = true
	_refresh_day_result_candidate()

	last_interaction = "오늘의 결과 / open"
	last_interaction_debug = "day_result_candidate:day_%d / role=manual_end_day / action=open_result_candidate" % mock_day
	print("QuarterviewMain day result candidate opened / no production wiring")
	_update_status("Day result candidate opened.")


func _hide_day_result_candidate(message := "Day result candidate closed.") -> void:
	if day_result_backdrop != null:
		day_result_backdrop.visible = false
	if day_result_panel != null:
		day_result_panel.visible = false
	day_result_open = false
	_set_room_input_locked(false)
	_update_status(message)


func _on_day_result_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_day_result_candidate()
		get_viewport().set_input_as_handled()


func _is_day_result_content_point(viewport_point: Vector2) -> bool:
	if day_result_panel == null or not day_result_panel.visible:
		return false
	var panel_size := day_result_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = DAY_RESULT_SIZE
	return Rect2(day_result_panel.global_position, panel_size).has_point(viewport_point)


func _on_day_result_next_day_pressed() -> void:
	mock_day += 1
	mock_time = "20:30"
	mock_power_percent = 62
	mock_power_state = "안정"
	mock_hunger = "보통"
	mock_condition = "안정"
	mock_info = "없음"
	mock_status_note = "새 하루 후보 시작"
	_refresh_mock_state_views()
	last_interaction = "DAY %d / next day candidate" % mock_day
	last_interaction_debug = "day_result_candidate:day_%d / action=next_day_candidate / no SurvivalState" % mock_day
	print("QuarterviewMain next day candidate selected / mock day=%d / no production wiring" % mock_day)
	_hide_day_result_candidate("DAY %d candidate started." % mock_day)


func _refresh_day_result_candidate() -> void:
	if day_result_summary_label == null:
		return
	var risk_label := "낮음" if mock_power_percent >= 40 else "주의"
	day_result_summary_label.text = "DAY %d 결과 후보\n전력 관리: %s (%d%%)\n허기: %s\n컨디션: %s\n정보 수집: %s\n위험도: %s\n메모: %s" % [
		mock_day,
		mock_power_state,
		mock_power_percent,
		mock_hunger,
		mock_condition,
		mock_info,
		risk_label,
		mock_status_note,
	]
	day_result_detail_label.text = "다음 날 후보를 누르면 QuarterviewMain 내부 mock DAY만 증가하고 mock HUD 상태가 기본값으로 일부 리셋됩니다. 실제 DayResultPanel, SurvivalState day advance, save-load, story flag는 호출하지 않습니다."


func _build_kitchen_closeup_overlay() -> void:
	kitchen_closeup_backdrop = ColorRect.new()
	kitchen_closeup_backdrop.name = "KitchenCloseupBackdrop"
	kitchen_closeup_backdrop.visible = false
	kitchen_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.31)
	kitchen_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	kitchen_closeup_backdrop.z_index = 140
	kitchen_closeup_backdrop.position = Vector2.ZERO
	kitchen_closeup_backdrop.size = _get_viewport_ui_size()
	kitchen_closeup_backdrop.gui_input.connect(_on_kitchen_closeup_backdrop_gui_input)
	$UILayer.add_child(kitchen_closeup_backdrop)

	kitchen_closeup_panel = PanelContainer.new()
	kitchen_closeup_panel.name = "FoodKitchenCloseupCandidate"
	kitchen_closeup_panel.visible = false
	kitchen_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	kitchen_closeup_panel.z_index = 141
	kitchen_closeup_panel.position = KITCHEN_CLOSEUP_POSITION
	kitchen_closeup_panel.custom_minimum_size = KITCHEN_CLOSEUP_SIZE
	$UILayer.add_child(kitchen_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	kitchen_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	kitchen_title_label = Label.new()
	kitchen_title_label.add_theme_color_override("font_color", Color(0.93, 0.84, 0.66, 1.0))
	kitchen_title_label.add_theme_font_size_override("font_size", 22)
	vbox.add_child(kitchen_title_label)

	kitchen_description_label = Label.new()
	kitchen_description_label.add_theme_color_override("font_color", Color(0.78, 0.84, 0.78, 1.0))
	kitchen_description_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(kitchen_description_label)

	var option_column := VBoxContainer.new()
	option_column.add_theme_constant_override("separation", 8)
	vbox.add_child(option_column)

	for option in KITCHEN_CANDIDATE_OPTIONS:
		var key := String(option["key"])
		var button := Button.new()
		button.name = "%sKitchenOptionButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(548, 44)
		button.tooltip_text = String(option["description"])
		button.pressed.connect(_on_kitchen_option_pressed.bind(key))
		option_column.add_child(button)
		kitchen_option_buttons[key] = button

	kitchen_option_title_label = Label.new()
	kitchen_option_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	kitchen_option_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(kitchen_option_title_label)

	kitchen_option_detail_label = Label.new()
	kitchen_option_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	kitchen_option_detail_label.add_theme_color_override("font_color", Color(0.76, 0.82, 0.80, 1.0))
	kitchen_option_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(kitchen_option_detail_label)

	kitchen_option_debug_label = Label.new()
	kitchen_option_debug_label.visible = false
	kitchen_option_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	kitchen_option_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(kitchen_option_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "선택"
	use_button.pressed.connect(_on_kitchen_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_kitchen_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_kitchen_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / 허기, inventory, SurvivalState는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_kitchen_option(selected_kitchen_option_key)


func _open_kitchen_closeup(source_key: String) -> void:
	current_kitchen_source_key = source_key if source_key in KITCHEN_CLOSEUP_ENTRY_KEYS else "fridge"
	kitchen_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	kitchen_closeup_backdrop.size = _get_viewport_ui_size()
	kitchen_closeup_backdrop.visible = true
	kitchen_closeup_panel.visible = true

	var default_key := _get_default_kitchen_option_key(current_kitchen_source_key)
	var selected_option := _get_kitchen_option(selected_kitchen_option_key)
	if not _is_kitchen_option_available(selected_option, current_kitchen_source_key):
		selected_kitchen_option_key = default_key
	_refresh_kitchen_option_buttons()
	_select_kitchen_option(selected_kitchen_option_key)

	last_interaction = "%s food candidate / open" % _get_kitchen_source_display_name()
	last_interaction_debug = "%s / role=%s / action=kitchen_candidate" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain kitchen candidate opened from %s / no production wiring" % source_key)
	_update_status("Food / kitchen candidate opened.")


func _hide_kitchen_closeup() -> void:
	if kitchen_closeup_backdrop != null:
		kitchen_closeup_backdrop.visible = false
	if kitchen_closeup_panel != null:
		kitchen_closeup_panel.visible = false
	kitchen_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Food / kitchen candidate closed.")


func _on_kitchen_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_kitchen_closeup()
		get_viewport().set_input_as_handled()


func _is_kitchen_closeup_content_point(viewport_point: Vector2) -> bool:
	if kitchen_closeup_panel == null or not kitchen_closeup_panel.visible:
		return false
	var panel_size := kitchen_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = KITCHEN_CLOSEUP_SIZE
	return Rect2(kitchen_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _on_kitchen_option_pressed(option_key: String) -> void:
	_select_kitchen_option(option_key)
	_log_kitchen_option_action("focus")


func _on_kitchen_use_pressed() -> void:
	_log_kitchen_option_action("primary")


func _on_kitchen_inspect_pressed() -> void:
	_log_kitchen_option_action("inspect")


func _select_kitchen_option(option_key: String) -> void:
	var option := _get_kitchen_option(option_key)
	if not _is_kitchen_option_available(option, current_kitchen_source_key):
		return

	selected_kitchen_option_key = option_key
	_refresh_kitchen_option_buttons()
	_refresh_kitchen_option_detail()


func _refresh_kitchen_option_buttons() -> void:
	for key in kitchen_option_buttons.keys():
		var option := _get_kitchen_option(String(key))
		var button: Button = kitchen_option_buttons[key]
		var available := _is_kitchen_option_available(option, current_kitchen_source_key)
		button.visible = available
		button.disabled = not available
		if available:
			var prefix := "> " if String(key) == selected_kitchen_option_key else ""
			button.text = "%s%s  -  %s" % [
				prefix,
				String(option.get("display_name", key)),
				String(option.get("value", "")),
			]


func _refresh_kitchen_option_detail() -> void:
	var option := _get_kitchen_option(selected_kitchen_option_key)
	if not _is_kitchen_option_available(option, current_kitchen_source_key):
		selected_kitchen_option_key = _get_default_kitchen_option_key(current_kitchen_source_key)
		option = _get_kitchen_option(selected_kitchen_option_key)
	if option.is_empty():
		return

	kitchen_title_label.text = "식량 / 조리 - %s" % _get_kitchen_source_display_name()
	kitchen_description_label.text = "생활 장비 후보입니다. 실제 허기 / inventory / 전력 계산 연결 없음."
	kitchen_option_title_label.text = String(option["display_name"])
	kitchen_option_detail_label.text = "%s\n\nFood / kitchen candidate only. 실제 허기 수치, food inventory, DayResultPanel은 아직 연결되지 않았습니다." % String(option["description"])

	kitchen_option_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		kitchen_option_debug_label.text = "source: %s\nkey: %s\nrole: %s\ncandidate action: %s\nvalue: %s\nno-op status: hunger / inventory / SurvivalState disabled" % [
			current_kitchen_source_key,
			String(option["key"]),
			String(option["role"]),
			String(option["candidate_action"]),
			String(option["value"]),
		]


func _log_kitchen_option_action(action_key: String) -> void:
	var option := _get_kitchen_option(selected_kitchen_option_key)
	if option.is_empty():
		return

	var display_name := String(option["display_name"])
	var role := String(option["role"])
	var mock_effect := _apply_kitchen_mock_effect(selected_kitchen_option_key, action_key)
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "kitchen_closeup:%s:%s / role=%s / action=%s / candidate=%s" % [
		current_kitchen_source_key,
		selected_kitchen_option_key,
		role,
		action_key,
		String(option["candidate_action"]),
	]
	print("QuarterviewMain kitchen candidate: %s / no production wiring" % last_interaction_debug)
	var status_text := "%s: Food / kitchen candidate no-op." % display_name
	if not mock_effect.is_empty():
		status_text = "%s: %s" % [display_name, mock_effect]
	_update_status(status_text)


func _apply_kitchen_mock_effect(option_key: String, action_key: String) -> String:
	if action_key != "primary":
		return ""

	match option_key:
		"find_quick_food":
			_set_mock_hunger_state("괜찮음", "간단한 식사 후보", 0)
			return "mock 허기가 괜찮음으로 표시됩니다."
		"heat_synthetic_food":
			_set_mock_hunger_state("든든함", "합성 식품 데움", -2)
			return "mock 허기가 좋아지고 전력이 2% 낮아집니다."
		"stored_food":
			_set_mock_status_note("보관 식량 확인")
			return "mock HUD 메모에 보관 식량 확인이 기록됩니다."
		"fridge_status":
			_set_mock_power_state(mock_power_percent, "냉장고 확인", "냉장고 전원 확인")
			return "mock 전력 상태에 냉장고 확인이 표시됩니다."
		"cooking_status":
			_set_mock_power_state(mock_power_percent, "전자레인지 대기", "조리 장비 확인")
			return "mock 전력 상태에 조리 장비 확인이 표시됩니다."
		"think_food_plan":
			_set_mock_status_note("식사 계획 후보")
			return "mock HUD 메모에 식사 계획 후보가 기록됩니다."
		_:
			return ""


func _get_default_kitchen_option_key(source_key: String) -> String:
	if source_key == "microwave":
		return "heat_synthetic_food"
	return "stored_food"


func _get_kitchen_source_display_name() -> String:
	if current_kitchen_source_key == "microwave":
		return "Microwave"
	return "Fridge"


func _is_kitchen_option_available(option: Dictionary, source_key: String) -> bool:
	if option.is_empty():
		return false
	var sources = option.get("sources", [])
	return source_key in sources


func _get_kitchen_option(option_key: String) -> Dictionary:
	for option in KITCHEN_CANDIDATE_OPTIONS:
		if String(option["key"]) == option_key:
			return option
	return {}


func _build_door_closeup_overlay() -> void:
	door_closeup_backdrop = ColorRect.new()
	door_closeup_backdrop.name = "DoorCloseupBackdrop"
	door_closeup_backdrop.visible = false
	door_closeup_backdrop.color = Color(0.0, 0.0, 0.0, 0.30)
	door_closeup_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	door_closeup_backdrop.z_index = 150
	door_closeup_backdrop.position = Vector2.ZERO
	door_closeup_backdrop.size = _get_viewport_ui_size()
	door_closeup_backdrop.gui_input.connect(_on_door_closeup_backdrop_gui_input)
	$UILayer.add_child(door_closeup_backdrop)

	door_closeup_panel = PanelContainer.new()
	door_closeup_panel.name = "DoorCloseupCandidate"
	door_closeup_panel.visible = false
	door_closeup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	door_closeup_panel.z_index = 151
	door_closeup_panel.position = DOOR_CLOSEUP_POSITION
	door_closeup_panel.custom_minimum_size = DOOR_CLOSEUP_SIZE
	$UILayer.add_child(door_closeup_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	door_closeup_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "출입문"
	title.add_theme_color_override("font_color", Color(0.92, 0.84, 0.68, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "문밖과 외출 후보를 확인합니다. scene transition / story flag / save-load 연결 없음."
	description.add_theme_color_override("font_color", Color(0.76, 0.82, 0.80, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var option_column := VBoxContainer.new()
	option_column.add_theme_constant_override("separation", 8)
	vbox.add_child(option_column)

	for option in DOOR_CANDIDATE_OPTIONS:
		var key := String(option["key"])
		var button := Button.new()
		button.name = "%sDoorOptionButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(500, 48)
		button.tooltip_text = String(option["description"])
		button.pressed.connect(_on_door_option_pressed.bind(key))
		option_column.add_child(button)
		door_option_buttons[key] = button

	door_option_title_label = Label.new()
	door_option_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	door_option_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(door_option_title_label)

	door_option_detail_label = Label.new()
	door_option_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	door_option_detail_label.add_theme_color_override("font_color", Color(0.76, 0.82, 0.80, 1.0))
	door_option_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(door_option_detail_label)

	door_option_debug_label = Label.new()
	door_option_debug_label.visible = false
	door_option_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	door_option_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(door_option_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var use_button := Button.new()
	use_button.text = "선택"
	use_button.pressed.connect(_on_door_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_door_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(_hide_door_closeup)
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / 외부 맵, story flag, save-load는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_door_option(selected_door_option_key)


func _open_door_closeup(source_key: String) -> void:
	door_closeup_open = true
	_hide_interaction_panel()
	_set_room_input_locked(true)
	door_closeup_backdrop.size = _get_viewport_ui_size()
	door_closeup_backdrop.visible = true
	door_closeup_panel.visible = true

	if _get_door_option(selected_door_option_key).is_empty():
		selected_door_option_key = "check_hallway"
	_select_door_option(selected_door_option_key)

	last_interaction = "Door candidate / open"
	last_interaction_debug = "%s / role=%s / action=door_candidate" % [
		source_key,
		String(focused_payload.get("role", "-")),
	]
	print("QuarterviewMain door candidate opened from %s / no production wiring" % source_key)
	_update_status("Door candidate opened.")


func _hide_door_closeup() -> void:
	if door_closeup_backdrop != null:
		door_closeup_backdrop.visible = false
	if door_closeup_panel != null:
		door_closeup_panel.visible = false
	door_closeup_open = false
	_set_room_input_locked(false)
	_update_status("Door candidate closed.")


func _on_door_closeup_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_hide_door_closeup()
		get_viewport().set_input_as_handled()


func _is_door_closeup_content_point(viewport_point: Vector2) -> bool:
	if door_closeup_panel == null or not door_closeup_panel.visible:
		return false
	var panel_size := door_closeup_panel.size
	if panel_size.x <= 1.0 or panel_size.y <= 1.0:
		panel_size = DOOR_CLOSEUP_SIZE
	return Rect2(door_closeup_panel.global_position, panel_size).has_point(viewport_point)


func _on_door_option_pressed(option_key: String) -> void:
	_select_door_option(option_key)
	_log_door_option_action("focus")


func _on_door_use_pressed() -> void:
	_log_door_option_action("primary")


func _on_door_inspect_pressed() -> void:
	_log_door_option_action("inspect")


func _select_door_option(option_key: String) -> void:
	var option := _get_door_option(option_key)
	if option.is_empty():
		return

	selected_door_option_key = option_key
	for key in door_option_buttons.keys():
		var button: Button = door_option_buttons[key]
		var button_option := _get_door_option(String(key))
		var prefix := "> " if String(key) == selected_door_option_key else ""
		button.text = "%s%s  -  %s" % [
			prefix,
			String(button_option.get("display_name", key)),
			String(button_option.get("value", "")),
		]
	_refresh_door_option_detail()


func _refresh_door_option_detail() -> void:
	var option := _get_door_option(selected_door_option_key)
	if option.is_empty():
		return

	door_option_title_label.text = String(option["display_name"])
	door_option_detail_label.text = "%s\n\nDoor candidate only. 실제 외부 맵, scene transition, story flag, save-load는 아직 연결되지 않았습니다." % String(option["description"])

	door_option_debug_label.visible = room_debug_enabled
	if room_debug_enabled:
		door_option_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nvalue: %s\nno-op status: scene transition / story flag / save-load disabled" % [
			String(option["key"]),
			String(option["role"]),
			String(option["candidate_action"]),
			String(option["value"]),
		]


func _log_door_option_action(action_key: String) -> void:
	var option := _get_door_option(selected_door_option_key)
	if option.is_empty():
		return

	var display_name := String(option["display_name"])
	var role := String(option["role"])
	last_interaction = "%s / %s" % [display_name, _get_action_display_name(action_key)]
	last_interaction_debug = "door_closeup:%s / role=%s / action=%s / candidate=%s" % [
		selected_door_option_key,
		role,
		action_key,
		String(option["candidate_action"]),
	]
	print("QuarterviewMain door candidate: %s / no production wiring" % last_interaction_debug)
	_update_status("%s: Door candidate no-op." % display_name)


func _get_door_option(option_key: String) -> Dictionary:
	for option in DOOR_CANDIDATE_OPTIONS:
		if String(option["key"]) == option_key:
			return option
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
