extends Node2D

@onready var survival_state: SurvivalState = $SurvivalState
@onready var apartment: Apartment = $Apartment
@onready var survival_hud: SurvivalHUD = $UI/SurvivalHUD
@onready var phone_ui: PhoneUI = $UI/PhoneUI
@onready var interaction_panel: InteractionPanel = $UI/InteractionPanel
@onready var outlet_mode: OutletMode = $UI/OutletMode
@onready var day_result_panel: DayResultPanel = $UI/DayResultPanel

var pending_interaction_data: Dictionary = {}


func _ready() -> void:
	apartment.nearest_interactable_changed.connect(_on_nearest_interactable_changed)
	apartment.interaction_requested.connect(_on_interaction_requested)
	survival_state.changed.connect(_refresh_survival_ui)
	outlet_mode.closed.connect(_on_outlet_mode_closed)
	outlet_mode.power_changed.connect(_on_outlet_power_changed)
	outlet_mode.powered_devices_changed.connect(_on_powered_devices_changed)
	outlet_mode.breaker_tripped.connect(_on_breaker_tripped)
	survival_state.day_ended.connect(_on_day_ended)

	survival_hud.set_interaction_prompt("")
	_refresh_survival_ui()


func _unhandled_input(event: InputEvent) -> void:
	if day_result_panel.visible:
		if event.is_action_pressed("interact") or _is_space_pressed(event):
			_continue_to_next_day()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_cancel"):
			get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("phone_toggle"):
		if outlet_mode.visible:
			get_viewport().set_input_as_handled()
			return
		phone_ui.set_open(not phone_ui.visible, survival_state)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		if outlet_mode.visible:
			get_viewport().set_input_as_handled()
			return
		if interaction_panel.visible:
			if pending_interaction_data.is_empty():
				interaction_panel.close()
			else:
				_confirm_pending_day1_action()
		else:
			apartment.request_nearest_interaction()

		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		if outlet_mode.visible:
			outlet_mode.close()
			get_viewport().set_input_as_handled()
		elif phone_ui.visible:
			phone_ui.set_open(false, survival_state)
			get_viewport().set_input_as_handled()
		elif interaction_panel.visible:
			pending_interaction_data = {}
			interaction_panel.close()
			get_viewport().set_input_as_handled()


func _on_nearest_interactable_changed(interactable: ApartmentInteractable) -> void:
	if interactable == null:
		survival_hud.set_interaction_prompt("")
		return

	survival_hud.set_interaction_prompt("[E] 상호작용: %s" % interactable.display_name)


func _on_interaction_requested(interactable: ApartmentInteractable) -> void:
	if interaction_panel.visible:
		interaction_panel.close()
		return

	var data: Dictionary = interactable.get_interaction_data()
	if data.get("id", "") == "power_strip":
		_open_outlet_mode()
		return

	var day1_action_key: String = data.get("day1_action_key", "")
	if day1_action_key != "":
		pending_interaction_data = data
		interaction_panel.open(data.get("title", "상호작용"), _build_interaction_body(data), "E: 사용 / ESC: 취소")
		return

	var watts: int = data.get("watts", 0)
	interaction_panel.open(data.get("title", "상호작용"), _build_interaction_body(data))
	survival_state.preview_power_use(watts)


func _build_interaction_body(data: Dictionary) -> String:
	var body: String = data.get("body", "")
	var watts: int = data.get("watts", 0)

	if watts > 0:
		body += "\n\n예상 전력: %dW" % watts
		body += "\n전력은 늘 부족합니다. 무엇을 켤지 선택해야 합니다."

	var power_units: int = int(data.get("power_units", 0))
	if power_units > 0:
		body += "\n\nDAY 1 전력 비용: %d" % power_units
		body += "\n현재 전력: %d / %d" % [
			survival_state.current_power_units,
			SurvivalState.DAY1_STARTING_POWER_UNITS,
		]
		body += "\n\n사용하려면 E, 취소하려면 ESC를 누르세요."

	return body


func _confirm_pending_day1_action() -> void:
	var action_key: String = pending_interaction_data.get("day1_action_key", "")
	var title: String = pending_interaction_data.get("title", "상호작용")
	var result := survival_state.try_use_day1_action(action_key)
	var prefix := "사용 완료" if bool(result.get("success", false)) else "사용 불가"

	pending_interaction_data = {}
	interaction_panel.open("%s - %s" % [title, prefix], str(result.get("message", "")), "E 또는 ESC: 닫기")


func _refresh_survival_ui() -> void:
	survival_hud.set_warnings(survival_state.get_warning_lines())
	survival_hud.set_stats(survival_state.get_hud_stat_text())
	survival_hud.set_time(survival_state.get_time_text())
	survival_hud.set_phase_effect(survival_state.get_phase_effect_text())
	survival_hud.set_phase_style(survival_state.phase)
	apartment.set_powered_devices(survival_state.powered_devices)
	apartment.set_phase(survival_state.phase)

	if phone_ui.visible:
		phone_ui.refresh(survival_state)

	if outlet_mode.visible:
		outlet_mode.queue_redraw()


func _open_outlet_mode() -> void:
	interaction_panel.close()
	phone_ui.set_open(false, survival_state)
	apartment.set_player_movement_enabled(false)
	outlet_mode.open(survival_state)


func _on_outlet_mode_closed() -> void:
	apartment.set_player_movement_enabled(true)


func _on_outlet_power_changed(total_power: int) -> void:
	survival_state.preview_power_use(total_power)


func _on_powered_devices_changed(device_keys: Array[String]) -> void:
	survival_state.set_powered_devices(device_keys)


func _on_breaker_tripped() -> void:
	survival_state.record_overload()


func _on_day_ended(result: Dictionary) -> void:
	if outlet_mode.visible:
		outlet_mode.close()

	phone_ui.set_open(false, survival_state)
	interaction_panel.close()
	apartment.set_player_movement_enabled(false)
	day_result_panel.open(result)


func _continue_to_next_day() -> void:
	day_result_panel.close()
	survival_state.continue_to_next_day()
	apartment.set_player_movement_enabled(true)


func _is_space_pressed(event: InputEvent) -> bool:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null:
		return false

	return key_event.pressed and not key_event.echo and key_event.keycode == KEY_SPACE
