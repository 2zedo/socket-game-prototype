extends Node2D

const RESTART_KEY := KEY_R
const CANCEL_KEY := KEY_ESCAPE

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
var interaction_panel: PanelContainer
var interaction_title_label: Label
var interaction_detail_label: Label


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
	_update_status("QuarterviewMain candidate ready.")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == RESTART_KEY:
			get_tree().reload_current_scene()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == CANCEL_KEY and interaction_panel != null and interaction_panel.visible:
			_hide_interaction_panel()
			_update_status("Candidate panel closed.")
			get_viewport().set_input_as_handled()


func _on_room_interaction_requested(object_key: String, action_key: String, payload: Dictionary) -> void:
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
	quarterview_room.global_transform = room_transform
	camera.global_transform = camera_transform
	camera.zoom = camera_zoom


func _on_room_movement_path_failed(reason: String) -> void:
	_update_status(reason)


func _update_status(message: String) -> void:
	var debug_text := "Debug ON: arrow-key move enabled" if room_debug_enabled else "Normal: mouse click movement"
	status_label.text = "Candidate only / no production wiring\n%s\n%s" % [message, debug_text]
	if room_debug_enabled:
		log_label.text = "Last: %s\nD: debug | R: restart | BG: %s" % [last_interaction_debug, background_mode]
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


func _refresh_interaction_panel_detail(object_key: String, payload: Dictionary) -> void:
	if room_debug_enabled:
		interaction_detail_label.text = _get_debug_object_detail(object_key, payload)
	else:
		interaction_detail_label.text = _get_normal_object_description(payload)


func _hide_interaction_panel() -> void:
	if interaction_panel != null:
		interaction_panel.visible = false


func _on_use_pressed() -> void:
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
	return "key: %s\nrole: %s\nzone: %s\naction: %s\nfuture: %s\nstate: %s\ncandidate no-op only" % [
		object_key,
		String(payload.get("role", "-")),
		String(payload.get("zone", "-")),
		String(payload.get("action", "-")),
		String(payload.get("future_source", "-")),
		String(payload.get("visual_state", "-")),
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
