extends Node2D

@onready var survival_state: SurvivalState = $SurvivalState
@onready var apartment: Apartment = $Apartment
@onready var survival_hud: SurvivalHUD = $UI/SurvivalHUD
@onready var phone_ui: PhoneUI = $UI/PhoneUI
@onready var interaction_panel: InteractionPanel = $UI/InteractionPanel
@onready var outlet_mode: OutletMode = $UI/OutletMode
@onready var day_result_panel: DayResultPanel = $UI/DayResultPanel

var pending_interaction_data: Dictionary = {}
var test_mode_enabled: bool = false
var phone_tab_was_pressed: bool = false


func _ready() -> void:
	apartment.nearest_interactable_changed.connect(_on_nearest_interactable_changed)
	apartment.interaction_requested.connect(_on_interaction_requested)
	interaction_panel.confirm_requested.connect(_on_interaction_panel_confirm_requested)
	interaction_panel.cancel_requested.connect(_on_interaction_panel_cancel_requested)
	survival_state.changed.connect(_refresh_survival_ui)
	survival_state.phone_battery_warning.connect(_on_phone_battery_warning)
	survival_state.day1_power_warning.connect(_on_day1_power_warning)
	outlet_mode.closed.connect(_on_outlet_mode_closed)
	outlet_mode.power_changed.connect(_on_outlet_power_changed)
	outlet_mode.powered_devices_changed.connect(_on_powered_devices_changed)
	outlet_mode.connection_state_changed.connect(_on_outlet_connection_state_changed)
	outlet_mode.breaker_tripped.connect(_on_breaker_tripped)
	survival_state.day_ended.connect(_on_day_ended)

	survival_hud.set_interaction_prompt("")
	survival_hud.set_test_mode_enabled(false)
	_refresh_survival_ui()


func _process(_delta: float) -> void:
	var phone_tab_is_pressed: bool = Input.is_key_pressed(KEY_TAB)
	if Input.is_action_just_pressed("open_phone") or (phone_tab_is_pressed and not phone_tab_was_pressed):
		print("phone_input_received: Tab/open_phone")
		_toggle_phone_ui()
	phone_tab_was_pressed = phone_tab_is_pressed

	if test_mode_enabled:
		survival_hud.set_test_debug_text(_build_test_debug_text())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_test_mode"):
		_toggle_test_mode()
		get_viewport().set_input_as_handled()
		return

	if _try_room_object_mouse_interaction(event):
		get_viewport().set_input_as_handled()
		return

	if day_result_panel.visible:
		if event.is_action_pressed("interact") or _is_space_pressed(event):
			_continue_to_next_day()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("cancel_or_menu"):
			get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("cancel_or_menu"):
		_handle_cancel_or_menu()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("interact"):
		if outlet_mode.visible:
			get_viewport().set_input_as_handled()
			return
		if interaction_panel.visible:
			if pending_interaction_data.is_empty():
				_close_interaction_panel()
			else:
				_confirm_pending_interaction()
		else:
			apartment.request_nearest_interaction()

		get_viewport().set_input_as_handled()


func _try_room_object_mouse_interaction(event: InputEvent) -> bool:
	var mouse_button: InputEventMouseButton = event as InputEventMouseButton
	if mouse_button == null or not mouse_button.pressed or mouse_button.button_index != MOUSE_BUTTON_LEFT:
		return false
	if _get_modal_state() != "exploration" or apartment.nearest_interactable == null:
		return false

	# Mouse clicks reuse the same nearest-object range gate and request signal as E.
	var interactable: ApartmentInteractable = apartment.nearest_interactable
	var interaction_rect := Rect2(
		interactable.global_position - interactable.body_size * 0.5,
		interactable.body_size
	)
	if not interaction_rect.has_point(apartment.get_global_mouse_position()):
		return false

	apartment.request_nearest_interaction()
	return true


func _handle_cancel_or_menu() -> void:
	# Result is terminal for the current day; ESC is intentionally consumed there.
	if day_result_panel.visible:
		return
	if outlet_mode.visible:
		outlet_mode.close()
		return
	if interaction_panel.visible:
		_close_interaction_panel()
		return
	if phone_ui.visible:
		phone_ui.set_open(false, survival_state)
		_sync_player_movement_with_modal_state()
		return

	# TODO: Open the pause/menu screen when that system is implemented.


func _toggle_phone_ui() -> void:
	if phone_ui.visible:
		phone_ui.set_open(false, survival_state)
		_sync_player_movement_with_modal_state()
		print("phone_ui_visible=", phone_ui.visible, " modal=", _get_modal_state())
		return

	# Phone is an exploration modal and must not overlap interaction, outlet, or result UI.
	if day_result_panel.visible or outlet_mode.visible or interaction_panel.visible:
		print("phone_ui_toggle_blocked modal=", _get_modal_state())
		return

	phone_ui.set_open(true, survival_state)
	_sync_player_movement_with_modal_state()
	print("phone_ui_visible=", phone_ui.visible, " modal=", _get_modal_state())


func _on_nearest_interactable_changed(interactable: ApartmentInteractable) -> void:
	if test_mode_enabled:
		var nearest_text: String = "none" if interactable == null else "%s (%s)" % [interactable.object_id, interactable.display_name]
		print("nearest_interactable=", nearest_text)

	if interactable == null:
		survival_hud.set_interaction_prompt("")
		return

	survival_hud.set_interaction_prompt(interactable.get_prompt_text(), interactable.global_position)


func _on_interaction_requested(interactable: ApartmentInteractable) -> void:
	if interaction_panel.visible:
		_close_interaction_panel()
		return

	var data: Dictionary = interactable.get_interaction_data()
	if data.get("id", "") == "power_strip":
		_open_outlet_mode()
		return

	if data.get("interaction_type", "") == "end_day":
		pending_interaction_data = data
		_open_interaction_panel(data.get("title", "오늘을 마친다"), _build_interaction_body(data), "E: 하루 종료 / ESC: 취소")
		return

	var day1_action_key: String = data.get("day1_action_key", "")
	if day1_action_key != "":
		if not survival_state.is_day1_action_connected(day1_action_key):
			pending_interaction_data = {}
			_open_interaction_panel(data.get("title", "상호작용"), survival_state.get_day1_disconnected_message(day1_action_key), "ESC: 닫기")
			return

		pending_interaction_data = data
		var action_footer: String = "E: 끄기 / ESC: 취소" if survival_state.is_day1_action_active(day1_action_key) else "E: 켜기 / ESC: 취소"
		_open_interaction_panel(data.get("title", "상호작용"), _build_interaction_body(data), action_footer)
		return

	var watts: int = data.get("watts", 0)
	_open_interaction_panel(data.get("title", "상호작용"), _build_interaction_body(data))
	survival_state.preview_power_use(watts)


func _on_interaction_panel_confirm_requested() -> void:
	if not interaction_panel.visible:
		return
	if pending_interaction_data.is_empty():
		_close_interaction_panel()
		return
	_confirm_pending_interaction()


func _on_interaction_panel_cancel_requested() -> void:
	if interaction_panel.visible:
		_close_interaction_panel()


func _build_interaction_body(data: Dictionary) -> String:
	var body: String = data.get("body", "")
	var watts: int = data.get("watts", 0)
	var action_key: String = data.get("day1_action_key", "")

	if action_key != "":
		var action_data := survival_state.get_day1_action_data(action_key)
		var hourly_drain: float = float(action_data.get("drain_per_game_hour", 0.0))
		var watt_usage: int = int(action_data.get("watt_usage", watts))
		var is_active: bool = survival_state.is_day1_action_active(action_key)
		body += "\n\n현재 상태: %s" % ("켜짐" if is_active else "꺼짐")
		body += "\n소비전력: %dW" % watt_usage
		body += "\n시간당 소비량: %.1f / h" % hourly_drain
		body += "\n현재 남은 전력: %.1f / %d" % [
			survival_state.current_power_units,
			survival_state.max_power,
		]
		body += "\n\n%s" % ("끄면 전력 소비가 멈춥니다." if is_active else "켜져 있는 동안 전력이 계속 줄어듭니다.")
		return body

	if watts > 0:
		body += "\n\n예상 전력: %dW" % watts
		body += "\n전력은 늘 부족합니다. 무엇을 켤지 선택해야 합니다."

	if data.get("interaction_type", "") == "end_day":
		body += "\n\n오늘을 마칠까요?"
		body += "\n오늘 남은 전력: %.1f / %d" % [
			survival_state.current_power_units,
			survival_state.max_power,
		]
		body += "\n사용 기록: %s" % survival_state.get_used_day1_action_summary()
		body += "\n\nE로 결과를 확인하거나 ESC로 취소합니다."

	return body


func _confirm_pending_interaction() -> void:
	if pending_interaction_data.get("interaction_type", "") == "end_day":
		pending_interaction_data = {}
		survival_state.end_current_day()
		return

	var action_key: String = pending_interaction_data.get("day1_action_key", "")
	var title: String = pending_interaction_data.get("title", "상호작용")
	var result := survival_state.toggle_day1_action_active(action_key)
	var prefix := "작동 불가"
	if bool(result.get("success", false)):
		prefix = "켜기 완료" if bool(result.get("active", false)) else "끄기 완료"

	pending_interaction_data = {}
	_open_interaction_panel("%s - %s" % [title, prefix], str(result.get("message", "")), "E 또는 ESC: 닫기")


func _open_interaction_panel(title: String, body: String, footer_text: String = "E 또는 ESC: 닫기") -> void:
	# Exploration is keyboard-driven, so modal interaction text pauses Yui until
	# the player confirms or cancels the nearby object's action.
	phone_ui.set_open(false, survival_state)
	interaction_panel.open(title, body, footer_text)
	_sync_player_movement_with_modal_state()


func _close_interaction_panel() -> void:
	pending_interaction_data = {}
	interaction_panel.close()
	_sync_player_movement_with_modal_state()


func _refresh_survival_ui() -> void:
	survival_hud.set_stats(survival_state.get_hud_stat_text())
	survival_hud.set_time("")
	survival_hud.set_phase_effect(survival_state.get_phase_effect_text())
	survival_hud.set_phase_style(survival_state.phase)
	apartment.set_powered_devices(survival_state.powered_devices)
	apartment.set_day1_visual_state(survival_state.active_day1_actions, survival_state.current_power)
	apartment.set_phase(survival_state.phase)

	if phone_ui.visible:
		phone_ui.refresh(survival_state)

	if outlet_mode.visible:
		outlet_mode.queue_redraw()


func _on_phone_battery_warning(message: String) -> void:
	survival_hud.show_temporary_warning(message)


func _on_day1_power_warning(message: String) -> void:
	survival_hud.show_temporary_warning(message)


func _open_outlet_mode() -> void:
	_close_interaction_panel()
	phone_ui.set_open(false, survival_state)
	outlet_mode.open(survival_state)
	outlet_mode.set_test_mode_enabled(test_mode_enabled)
	_sync_player_movement_with_modal_state()


func _on_outlet_mode_closed() -> void:
	_sync_player_movement_with_modal_state()


func _on_outlet_power_changed(total_power: int) -> void:
	survival_state.preview_power_use(total_power)


func _on_powered_devices_changed(device_keys: Array[String]) -> void:
	survival_state.set_powered_devices(device_keys)


func _on_outlet_connection_state_changed(slot_occupancy: Array) -> void:
	survival_state.set_powerstrip_slot_occupancy(slot_occupancy)


func _on_breaker_tripped() -> void:
	survival_state.record_overload()


func _on_day_ended(result: Dictionary) -> void:
	if outlet_mode.visible:
		outlet_mode.close()

	phone_ui.set_open(false, survival_state)
	_close_interaction_panel()
	day_result_panel.open(result)
	_sync_player_movement_with_modal_state()


func _continue_to_next_day() -> void:
	day_result_panel.close()
	survival_state.continue_to_next_day()
	_sync_player_movement_with_modal_state()


func _toggle_test_mode() -> void:
	test_mode_enabled = not test_mode_enabled
	apartment.set_test_mode_enabled(test_mode_enabled)
	outlet_mode.set_test_mode_enabled(test_mode_enabled)
	survival_hud.set_test_mode_enabled(test_mode_enabled)
	if test_mode_enabled:
		survival_hud.set_test_debug_text(_build_test_debug_text())
		if apartment.player != null:
			print("player_pos=", apartment.player.global_position)
	print("test_mode=", "ON" if test_mode_enabled else "OFF")


func _build_test_debug_text() -> String:
	var player_position: Vector2 = Vector2.ZERO
	var player_velocity: Vector2 = Vector2.ZERO
	if apartment.player != null:
		player_position = apartment.player.global_position
		player_velocity = apartment.player.velocity

	var nearest_text: String = "none"
	if apartment.nearest_interactable != null:
		nearest_text = "%s / %s" % [
			apartment.nearest_interactable.object_id,
			apartment.nearest_interactable.display_name,
		]

	return "Player pos: (%.1f, %.1f)\nVelocity: (%.1f, %.1f)\nDay: %d\nPower: %.1f / %d\nDrain: %.1f / h\nLoad: %dW / %dW\nSlots: %d / %d\nNearest: %s\nModal: %s" % [
		player_position.x,
		player_position.y,
		player_velocity.x,
		player_velocity.y,
		survival_state.day,
		survival_state.current_power_units,
		survival_state.max_power,
		survival_state.get_active_power_drain_per_game_hour(),
		survival_state.current_load_watts,
		survival_state.max_load_watts,
		survival_state.used_outlet_slots,
		survival_state.max_outlet_slots,
		nearest_text,
		_get_modal_state(),
	]


func _get_modal_state() -> String:
	if day_result_panel.visible:
		return "result_screen"
	if outlet_mode.visible:
		return "outlet_mode"
	if interaction_panel.visible and pending_interaction_data.get("interaction_type", "") == "end_day":
		return "end_day_confirm"
	if interaction_panel.visible:
		return "interaction_panel"
	if phone_ui.visible:
		return "phone"
	return "exploration"


func _sync_player_movement_with_modal_state() -> void:
	var modal_open: bool = (
		day_result_panel.visible
		or outlet_mode.visible
		or interaction_panel.visible
		or phone_ui.visible
	)
	apartment.set_player_movement_enabled(not modal_open)
	survival_state.set_clock_paused_by_modal(modal_open)


func _is_space_pressed(event: InputEvent) -> bool:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null:
		return false

	return key_event.pressed and not key_event.echo and key_event.keycode == KEY_SPACE
