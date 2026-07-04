extends PanelContainer
class_name PhoneScreenCandidate

signal close_requested
signal item_action_requested(item_key: String, action_key: String, item: Dictionary)
signal tab_action_requested(tab_key: String, action_key: String, tab: Dictionary)
signal selection_changed(tab_key: String, item_key: String)
signal job_candidate_accepted(job_key: String, payload: Dictionary)

const PANEL_SIZE := Vector2(690, 520)
const UI_ATLAS_PATH := "res://assets/art/ui/atlases/ui_phone_atlas.png"
const JOB_RESOURCE_PATHS := [
	"res://resources/rooms/quarterview/jobs/maintenance_17_fragment.tres",
]
const ATLAS_REGION_FRAME := Rect2(Vector2(46, 27), Vector2(381, 657))
const ATLAS_REGION_SCREEN := Rect2(Vector2(453, 46), Vector2(336, 622))
const ATLAS_REGION_BATTERY := Rect2(Vector2(849, 103), Vector2(139, 66))
const ATLAS_REGION_SIGNAL := Rect2(Vector2(858, 226), Vector2(109, 136))
const ATLAS_REGION_MESSAGE := Rect2(Vector2(853, 375), Vector2(117, 98))
const ATLAS_REGION_POWER := Rect2(Vector2(848, 523), Vector2(124, 126))

const TABS := [
	{
		"key": "status",
		"display_name": "상태",
		"role": "phone_status_tab",
		"description": "배터리, 신호, 충전 포트 후보 상태를 봅니다.",
		"candidate_action": "view_phone_status_noop",
	},
	{
		"key": "message",
		"display_name": "메시지",
		"role": "phone_message_tab",
		"description": "실제 메시지 목록이 아니라 mock message feed 후보를 봅니다.",
		"candidate_action": "view_phone_messages_noop",
	},
	{
		"key": "job",
		"display_name": "의뢰",
		"role": "phone_job_tab",
		"description": "익명 의뢰 후보를 봅니다. Hacking / reward 연결은 없습니다.",
		"candidate_action": "view_phone_jobs_noop",
	},
]

const ITEMS := [
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

var selected_item_key := "battery"
var selected_tab_key := "status"
var debug_enabled := false
var item_buttons := {}
var tab_buttons := {}
var job_buttons := {}
var item_grid: GridContainer
var job_list: VBoxContainer
var use_button: Button
var item_title_label: Label
var item_detail_label: Label
var item_debug_label: Label
var atlas_texture: Texture2D
var job_definitions: Array = []
var selected_job_key := ""
var accepted_job_keys := {}


func _init() -> void:
	name = "PhoneStatusCloseupCandidate"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = PANEL_SIZE
	_load_job_definitions()
	_build()


func reset_selection(item_key: String = "battery", tab_key: String = "status", job_key: String = "") -> Dictionary:
	if _get_item(item_key).is_empty():
		item_key = "battery"
	if _get_tab(tab_key).is_empty():
		tab_key = "status"
	if not job_key.is_empty() and _get_job_definition(job_key) != null:
		selected_job_key = job_key
	selected_item_key = item_key
	_select_tab(tab_key, false)
	return {
		"item_key": selected_item_key,
		"tab_key": selected_tab_key,
		"job_key": selected_job_key,
	}


func set_debug_enabled(enabled: bool) -> void:
	debug_enabled = enabled
	_refresh_detail()


func get_selected_item_key() -> String:
	return selected_item_key


func get_selected_tab_key() -> String:
	return selected_tab_key


func get_selected_job_key() -> String:
	return selected_job_key


func set_accepted_job(job_key: String, accepted: bool) -> void:
	if job_key.is_empty():
		return
	if accepted:
		accepted_job_keys[job_key] = true
	else:
		accepted_job_keys.erase(job_key)
	_refresh_job_buttons()
	_refresh_detail()


func get_item_data(item_key: String) -> Dictionary:
	return _get_item(item_key).duplicate(true)


func get_tab_data(tab_key: String) -> Dictionary:
	return _get_tab(tab_key).duplicate(true)


func _build() -> void:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Phone Screen Candidate"
	title.add_theme_color_override("font_color", Color(0.78, 0.90, 0.96, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "전화기 화면을 보는 후보입니다. PhoneUI / SurvivalState 연결 없음."
	description.add_theme_color_override("font_color", Color(0.74, 0.82, 0.84, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	var body_row := HBoxContainer.new()
	body_row.add_theme_constant_override("separation", 12)
	vbox.add_child(body_row)

	_build_atlas_preview(body_row)
	_build_screen_controls(body_row)

	item_title_label = Label.new()
	item_title_label.add_theme_color_override("font_color", Color(0.90, 0.88, 0.74, 1.0))
	item_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(item_title_label)

	item_detail_label = Label.new()
	item_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	item_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.84, 1.0))
	item_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(item_detail_label)

	item_debug_label = Label.new()
	item_debug_label.visible = false
	item_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	item_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(item_debug_label)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	use_button = Button.new()
	use_button.text = "확인"
	use_button.pressed.connect(_on_use_pressed)
	button_row.add_child(use_button)

	var inspect_button := Button.new()
	inspect_button.text = "설명"
	inspect_button.pressed.connect(_on_inspect_pressed)
	button_row.add_child(inspect_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(func() -> void: close_requested.emit())
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / PhoneUI와 실제 배터리 상태는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.70, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_tab(selected_tab_key, false)


func _build_atlas_preview(parent: Control) -> void:
	var atlas_preview_panel := PanelContainer.new()
	atlas_preview_panel.custom_minimum_size = Vector2(178, 286)
	parent.add_child(atlas_preview_panel)

	var atlas_margin := MarginContainer.new()
	atlas_margin.add_theme_constant_override("margin_left", 8)
	atlas_margin.add_theme_constant_override("margin_top", 8)
	atlas_margin.add_theme_constant_override("margin_right", 8)
	atlas_margin.add_theme_constant_override("margin_bottom", 8)
	atlas_preview_panel.add_child(atlas_margin)

	var atlas_box := VBoxContainer.new()
	atlas_box.add_theme_constant_override("separation", 6)
	atlas_margin.add_child(atlas_box)

	atlas_texture = _load_texture_from_png(UI_ATLAS_PATH)
	if atlas_texture != null:
		var phone_visual := Control.new()
		phone_visual.name = "PhoneAtlasCompositedPreview"
		phone_visual.custom_minimum_size = Vector2(156, 236)
		atlas_box.add_child(phone_visual)

		_add_atlas_region(phone_visual, "PhoneScreenRegion", ATLAS_REGION_SCREEN, Vector2(42, 42), Vector2(82, 156))
		_add_atlas_region(phone_visual, "PhoneFrameRegion", ATLAS_REGION_FRAME, Vector2(14, 0), Vector2(132, 228))
		_add_atlas_region(phone_visual, "PhoneBatteryRegion", ATLAS_REGION_BATTERY, Vector2(54, 56), Vector2(42, 20))
		_add_atlas_region(phone_visual, "PhoneSignalRegion", ATLAS_REGION_SIGNAL, Vector2(104, 58), Vector2(30, 38))
		_add_atlas_region(phone_visual, "PhoneMessageRegion", ATLAS_REGION_MESSAGE, Vector2(62, 116), Vector2(36, 30))
		_add_atlas_region(phone_visual, "PhonePowerRegion", ATLAS_REGION_POWER, Vector2(100, 116), Vector2(36, 36))
	else:
		var missing_atlas := ColorRect.new()
		missing_atlas.name = "MissingPhoneAtlasPreview"
		missing_atlas.color = Color(0.08, 0.10, 0.11, 0.94)
		missing_atlas.custom_minimum_size = Vector2(156, 236)
		atlas_box.add_child(missing_atlas)

	var atlas_hint := Label.new()
	atlas_hint.text = "phone atlas regions"
	atlas_hint.add_theme_color_override("font_color", Color(0.54, 0.66, 0.68, 0.92))
	atlas_hint.add_theme_font_size_override("font_size", 11)
	atlas_box.add_child(atlas_hint)


func _build_screen_controls(parent: Control) -> void:
	var screen_box := VBoxContainer.new()
	screen_box.add_theme_constant_override("separation", 8)
	screen_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(screen_box)

	var tab_row := HBoxContainer.new()
	tab_row.add_theme_constant_override("separation", 8)
	screen_box.add_child(tab_row)

	for tab in TABS:
		var key := String(tab["key"])
		var button := Button.new()
		button.name = "%sPhoneTabButton" % key.capitalize().replace("_", "")
		button.text = String(tab["display_name"])
		button.tooltip_text = String(tab["description"])
		button.pressed.connect(_on_tab_pressed.bind(key))
		tab_row.add_child(button)
		tab_buttons[key] = button

	item_grid = GridContainer.new()
	item_grid.name = "PhoneStatusGrid"
	item_grid.columns = 2
	item_grid.add_theme_constant_override("h_separation", 8)
	item_grid.add_theme_constant_override("v_separation", 8)
	screen_box.add_child(item_grid)

	for item in ITEMS:
		var key := String(item["key"])
		var button := Button.new()
		button.name = "%sPhoneItemButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(216, 62)
		button.tooltip_text = String(item["description"])
		button.pressed.connect(_on_item_pressed.bind(key))
		item_grid.add_child(button)
		item_buttons[key] = button

	job_list = VBoxContainer.new()
	job_list.name = "PhoneJobList"
	job_list.add_theme_constant_override("separation", 8)
	job_list.visible = false
	screen_box.add_child(job_list)

	_build_job_buttons()


func _build_job_buttons() -> void:
	if job_list == null:
		return

	for definition in job_definitions:
		var key := String(definition.key)
		var button := Button.new()
		button.name = "%sPhoneJobButton" % key.capitalize().replace("_", "")
		button.custom_minimum_size = Vector2(448, 56)
		button.tooltip_text = String(definition.get_summary_text())
		button.pressed.connect(_on_job_pressed.bind(key))
		job_list.add_child(button)
		job_buttons[key] = button


func _load_texture_from_png(path: String) -> Texture2D:
	var image := Image.new()
	var error := image.load(path)
	if error != OK:
		push_warning("PhoneScreenCandidate could not load optional PNG: %s" % path)
		return null
	return ImageTexture.create_from_image(image)


func _make_atlas_texture(region: Rect2) -> Texture2D:
	if atlas_texture == null:
		return null
	var texture := AtlasTexture.new()
	texture.atlas = atlas_texture
	texture.region = region
	return texture


func _add_atlas_region(parent: Control, node_name: String, region: Rect2, position: Vector2, size: Vector2) -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.name = node_name
	texture_rect.texture = _make_atlas_texture(region)
	texture_rect.position = position
	texture_rect.size = size
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(texture_rect)
	return texture_rect


func _on_item_pressed(item_key: String) -> void:
	_select_tab("status", false)
	_select_item(item_key, false)
	item_action_requested.emit(item_key, "focus", _get_item(item_key).duplicate(true))
	selection_changed.emit(selected_tab_key, selected_item_key)


func _on_job_pressed(job_key: String) -> void:
	_select_tab("job", false)
	_select_job(job_key)
	tab_action_requested.emit("job", "focus", _get_tab("job").duplicate(true))


func _on_use_pressed() -> void:
	if selected_tab_key == "status":
		item_action_requested.emit(selected_item_key, "primary", _get_item(selected_item_key).duplicate(true))
	elif selected_tab_key == "job":
		var payload := _get_job_payload(selected_job_key)
		if payload.is_empty():
			tab_action_requested.emit(selected_tab_key, "primary", _get_tab(selected_tab_key).duplicate(true))
			return
		accepted_job_keys[selected_job_key] = true
		_refresh_job_buttons()
		_refresh_detail()
		job_candidate_accepted.emit(selected_job_key, payload)
	else:
		tab_action_requested.emit(selected_tab_key, "primary", _get_tab(selected_tab_key).duplicate(true))


func _on_inspect_pressed() -> void:
	if selected_tab_key == "status":
		item_action_requested.emit(selected_item_key, "inspect", _get_item(selected_item_key).duplicate(true))
	else:
		tab_action_requested.emit(selected_tab_key, "inspect", _get_tab(selected_tab_key).duplicate(true))


func _on_tab_pressed(tab_key: String) -> void:
	_select_tab(tab_key)
	tab_action_requested.emit(tab_key, "focus", _get_tab(tab_key).duplicate(true))


func _select_tab(tab_key: String, emit_signal := true) -> void:
	var tab := _get_tab(tab_key)
	if tab.is_empty():
		return

	selected_tab_key = tab_key
	_refresh_tab_buttons()
	if item_grid != null:
		item_grid.visible = selected_tab_key == "status"
	if job_list != null:
		job_list.visible = selected_tab_key == "job"
	if selected_tab_key == "status":
		_select_item(selected_item_key, false)
	elif selected_tab_key == "job":
		if selected_job_key.is_empty():
			_select_first_job(false)
		else:
			_select_job(selected_job_key, false)
	else:
		_refresh_detail()
	if use_button != null:
		use_button.text = "수락 후보" if selected_tab_key == "job" else "확인"
	if emit_signal:
		var selection_key := selected_job_key if selected_tab_key == "job" else selected_item_key
		selection_changed.emit(selected_tab_key, selection_key)


func _refresh_tab_buttons() -> void:
	for key in tab_buttons.keys():
		var button: Button = tab_buttons[key]
		var tab := _get_tab(String(key))
		var prefix := "> " if String(key) == selected_tab_key else ""
		button.text = "%s%s" % [prefix, String(tab.get("display_name", key))]


func _select_job(job_key: String, emit_signal := true) -> void:
	if _get_job_definition(job_key) == null:
		return

	selected_job_key = job_key
	_refresh_job_buttons()
	_refresh_detail()
	if emit_signal:
		selection_changed.emit(selected_tab_key, selected_job_key)


func _select_first_job(emit_signal := true) -> void:
	if job_definitions.is_empty():
		_refresh_detail()
		return
	_select_job(String(job_definitions[0].key), emit_signal)


func _refresh_job_buttons() -> void:
	for key in job_buttons.keys():
		var button: Button = job_buttons[key]
		var definition = _get_job_definition(String(key))
		if definition == null:
			continue
		var prefix := "> " if String(key) == selected_job_key else ""
		var status: String = definition.get_status_label(_is_job_accepted(String(key)))
		button.text = "%s%s\n%s / 보수 %s / 위험 %s" % [
			prefix,
			String(definition.title),
			status,
			String(definition.reward_label),
			String(definition.risk_label),
		]


func _select_item(item_key: String, emit_signal := true) -> void:
	var item := _get_item(item_key)
	if item.is_empty():
		return

	selected_item_key = item_key
	for key in item_buttons.keys():
		var button: Button = item_buttons[key]
		var button_item := _get_item(String(key))
		var prefix := "> " if String(key) == selected_item_key else ""
		button.text = "%s%s\n%s" % [
			prefix,
			String(button_item.get("display_name", key)),
			String(button_item.get("value", "")),
		]
	_refresh_detail()
	if emit_signal:
		selection_changed.emit(selected_tab_key, selected_item_key)


func _refresh_detail() -> void:
	if selected_tab_key != "status":
		var tab := _get_tab(selected_tab_key)
		if tab.is_empty():
			return
		item_title_label.text = String(tab["display_name"])
		match selected_tab_key:
			"message":
				item_detail_label.text = "새 메시지는 아직 없습니다.\n\nMock feed:\n- GRID 내부망 알림 후보: 신호가 약합니다.\n- 익명 연락 후보: 아직 읽을 수 없습니다.\n\n실제 PhoneUI 메시지 목록은 열지 않습니다."
			"job":
				_refresh_job_detail(tab)
				return
			_:
				item_detail_label.text = "%s\n\nPhone screen candidate only." % String(tab["description"])
		item_debug_label.visible = debug_enabled
		if debug_enabled:
			item_debug_label.text = "tab: %s\nrole: %s\ncandidate action: %s\nno-op status: PhoneUI / Hacking / reward disabled" % [
				String(tab["key"]),
				String(tab["role"]),
				String(tab["candidate_action"]),
			]
		return

	var item := _get_item(selected_item_key)
	if item.is_empty():
		return

	item_title_label.text = String(item["display_name"])
	item_detail_label.text = "%s\n\nPhone candidate only. 실제 PhoneUI / SurvivalState 값은 아직 연결되지 않았습니다." % String(item["description"])

	item_debug_label.visible = debug_enabled
	if debug_enabled:
		item_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nvalue: %s\nno-op status: PhoneUI / SurvivalState disabled" % [
			String(item["key"]),
			String(item["role"]),
			String(item["candidate_action"]),
			String(item["value"]),
		]


func _refresh_job_detail(tab: Dictionary) -> void:
	var definition = _get_job_definition(selected_job_key)
	if definition == null:
		item_detail_label.text = "표시할 의뢰 후보가 없습니다.\n\nHacking / reward / story flag는 아직 연결하지 않습니다."
		item_debug_label.visible = debug_enabled
		if debug_enabled:
			item_debug_label.text = "tab: %s\nrole: %s\nno job resources loaded" % [
				String(tab["key"]),
				String(tab["role"]),
			]
		return

	var status: String = definition.get_status_label(_is_job_accepted(selected_job_key))
	item_title_label.text = String(definition.title)
	item_detail_label.text = "%s\n%s\n\n%s\n\n보수: %s / 위험도: %s / 상태: %s\n관련 장비: %s\n\n수락 후보를 눌러도 Hacking, Grid Credit, save-load, story flag는 연결하지 않습니다." % [
		String(definition.sender_label),
		String(definition.get_summary_text()),
		String(definition.detail_text),
		String(definition.reward_label),
		String(definition.risk_label),
		status,
		String(definition.related_object_key),
	]

	item_debug_label.visible = debug_enabled
	if debug_enabled:
		item_debug_label.text = "job key: %s\n%s\ncandidate action: accept_job_candidate_noop\nno-op status: Hacking / reward / story flag disabled" % [
			String(definition.key),
			String(definition.get_debug_summary()),
		]


func _get_item(item_key: String) -> Dictionary:
	for item in ITEMS:
		if String(item["key"]) == item_key:
			return item
	return {}


func _get_tab(tab_key: String) -> Dictionary:
	for tab in TABS:
		if String(tab["key"]) == tab_key:
			return tab
	return {}


func _load_job_definitions() -> void:
	job_definitions.clear()
	for path in JOB_RESOURCE_PATHS:
		var definition = load(path)
		if definition == null:
			push_warning("PhoneScreenCandidate could not load job Resource: %s" % path)
			continue
		if definition.has_method("is_valid_definition") and not definition.is_valid_definition():
			push_warning("PhoneScreenCandidate ignored invalid job Resource: %s" % path)
			continue
		job_definitions.append(definition)

	if not job_definitions.is_empty():
		selected_job_key = String(job_definitions[0].key)


func _get_job_definition(job_key: String):
	for definition in job_definitions:
		if String(definition.key) == job_key:
			return definition
	return null


func _get_job_payload(job_key: String) -> Dictionary:
	var definition = _get_job_definition(job_key)
	if definition == null:
		return {}
	if definition.has_method("to_candidate_payload"):
		return definition.to_candidate_payload(true)
	return {
		"key": String(definition.key),
		"title": String(definition.title),
		"sender_label": String(definition.sender_label),
		"summary": String(definition.summary),
		"detail_text": String(definition.detail_text),
		"reward_label": String(definition.reward_label),
		"risk_label": String(definition.risk_label),
		"status_label": "수락됨" if _is_job_accepted(job_key) else String(definition.status_label),
		"related_object_key": String(definition.related_object_key),
		"is_prototype": bool(definition.is_prototype),
	}


func _is_job_accepted(job_key: String) -> bool:
	return accepted_job_keys.has(job_key)
