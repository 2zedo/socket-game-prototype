extends Node2D

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")
const PROTOTYPE_SFX_SCRIPT := preload("res://scripts/prototypes/PrototypeSfx.gd")
const ROOM_STUB_SCENE := preload("res://scenes/prototypes/QuarterviewSandboxRoomStub.tscn")
const INTERACTION_PANEL_SCENE := preload("res://scenes/prototypes/SandboxInteractionPanel.tscn")

var room
var interaction_panel
var sfx
var room_contract_connected := false
var debug_overlay_enabled := false
var last_interaction := "-"
var last_nearest := "-"
var last_object := "-"
var last_role := "-"
var last_action := "-"
var panel_state := "closed"
var player_position := Vector2.ZERO
var event_log: Array[String] = []

@onready var room_host: Node2D = $SandboxRoot/RoomHost
@onready var ui_layer: CanvasLayer = $SandboxRoot/UILayer
@onready var status_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxStatusLabel
@onready var log_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxLogLabel
@onready var help_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxHelpLabel
@onready var prompt_label: Label = $SandboxRoot/UILayer/NearestPromptLabel
@onready var debug_layer: CanvasLayer = $SandboxRoot/DebugLayer
@onready var debug_label: Label = $SandboxRoot/DebugLayer/DebugPanel/Margin/DebugLabel


func _ready() -> void:
	_configure_sfx()
	_configure_help()
	_spawn_interaction_panel()
	_spawn_room_stub()
	_set_debug_overlay_enabled(false)
	_append_log("Sandbox ready. No Main/DAY1 wiring.")
	_update_status()


func _process(_delta: float) -> void:
	_update_debug_label()


func _unhandled_input(event: InputEvent) -> void:
	if PROTOTYPE_UTILS.is_hub_back_event(event):
		_go_to_prototype_hub()
		get_viewport().set_input_as_handled()
		return

	if _is_interaction_panel_open():
		if PROTOTYPE_UTILS.is_cancel_event(event):
			_close_interaction_panel()
			get_viewport().set_input_as_handled()
			return
		if PROTOTYPE_UTILS.is_confirm_event(event):
			_on_panel_primary_pressed()
			get_viewport().set_input_as_handled()
			return
		return

	if PROTOTYPE_UTILS.is_restart_event(event):
		_restart_sandbox()
		get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_debug_toggle_event(event):
		_set_debug_overlay_enabled(not debug_overlay_enabled)
		get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_confirm_event(event):
		if room != null:
			room.request_nearest_interaction("primary")
		get_viewport().set_input_as_handled()


func _configure_sfx() -> void:
	sfx = PROTOTYPE_SFX_SCRIPT.new()
	sfx.name = "PrototypeSfx"
	add_child(sfx)


func _configure_help() -> void:
	help_label.text = "RoomSceneContract signal test\nNot Main / Not final quarterview art\nE: Request interaction\nD: Debug\nR: Restart\nB / Backspace: Prototype Hub"


func _spawn_room_stub() -> void:
	var stub := ROOM_STUB_SCENE.instantiate()
	room = stub
	if room == null or not room.has_signal("interaction_requested"):
		push_warning("QuarterviewGameplaySandbox room stub does not expose RoomSceneContract signals.")
		return

	room.connect("interaction_requested", Callable(self, "_on_room_interaction_requested"))
	room.connect("nearest_interactable_changed", Callable(self, "_on_nearest_interactable_changed"))
	room.connect("debug_overlay_toggled", Callable(self, "_on_room_debug_overlay_toggled"))
	room.connect("player_position_changed", Callable(self, "_on_player_position_changed"))
	room.connect("room_ready", Callable(self, "_on_room_ready"))
	room_host.add_child(room)


func _spawn_interaction_panel() -> void:
	interaction_panel = INTERACTION_PANEL_SCENE.instantiate()
	ui_layer.add_child(interaction_panel)
	interaction_panel.connect("primary_pressed", Callable(self, "_on_panel_primary_pressed"))
	interaction_panel.connect("inspect_pressed", Callable(self, "_on_panel_inspect_pressed"))
	interaction_panel.connect("closed", Callable(self, "_on_panel_closed"))


func _go_to_prototype_hub() -> void:
	sfx.play_cancel()
	print("QuarterviewGameplaySandbox: PrototypeHub로 돌아갑니다.")
	PROTOTYPE_UTILS.go_to_hub(self)


func _restart_sandbox() -> void:
	sfx.play_confirm()
	print("QuarterviewGameplaySandbox: restart")
	PROTOTYPE_UTILS.restart_current_scene(self)


func _set_debug_overlay_enabled(enabled: bool) -> void:
	debug_overlay_enabled = enabled
	debug_layer.visible = debug_overlay_enabled
	if room != null:
		room.set_debug_overlay_enabled(debug_overlay_enabled)
	_update_status()
	_update_debug_label()


func _on_room_ready() -> void:
	room_contract_connected = true
	_append_log("Room contract connected.")
	_update_status()


func _on_room_interaction_requested(object_key: String, action_key: String, payload: Dictionary) -> void:
	last_interaction = "%s / %s" % [object_key, action_key]
	var zone := String(payload.get("zone", "-"))
	var role := String(payload.get("role", "-"))
	var future_source := String(payload.get("future_source", "-"))
	var visual_state := String(payload.get("visual_state", "-"))
	var display_name := String(payload.get("display_name", object_key))
	var log_text := "interaction_requested: %s / %s / zone=%s / role=%s" % [
		object_key,
		action_key,
		zone,
		role,
	]
	_append_log(log_text)
	print("Sandbox interaction requested: %s / %s / role=%s" % [object_key, action_key, role])
	print("Showing sandbox interaction panel for %s" % display_name)
	print("Sandbox received interaction: %s / %s / future=%s / state=%s / panel-only" % [
		object_key,
		action_key,
		future_source,
		visual_state,
	])
	last_object = object_key
	last_role = role
	last_action = action_key
	panel_state = "open"
	_set_room_input_enabled(false)
	interaction_panel.show_object_interaction(object_key, display_name, role, future_source, visual_state, payload)
	sfx.play_open()
	_update_status()


func _on_nearest_interactable_changed(object_key: String, display_name: String) -> void:
	if object_key.is_empty():
		last_nearest = "-"
		prompt_label.text = ""
	else:
		last_nearest = object_key
		prompt_label.text = "[E] %s" % display_name
	_update_status()


func _on_room_debug_overlay_toggled(enabled: bool) -> void:
	debug_overlay_enabled = enabled
	debug_layer.visible = debug_overlay_enabled
	_update_status()
	_update_debug_label()


func _on_player_position_changed(position: Vector2) -> void:
	player_position = position


func _on_panel_primary_pressed(object_key: String = "", role: String = "", payload: Dictionary = {}) -> void:
	var target_key := object_key if not object_key.is_empty() else last_object
	var target_role := role if not role.is_empty() else last_role
	last_action = "primary"
	last_interaction = "%s / primary" % target_key
	_append_log("Sandbox primary action requested: %s / %s / no-op" % [target_key, target_role])
	print("TODO future: route %s / %s to real feature. Current sandbox action is no-op." % [target_key, target_role])
	sfx.play_confirm()
	_update_status()


func _on_panel_inspect_pressed(object_key: String, role: String, payload: Dictionary) -> void:
	last_action = "inspect"
	last_interaction = "%s / inspect" % object_key
	_append_log("Sandbox inspect requested: %s / %s / payload=%s" % [object_key, role, str(payload)])
	print("Sandbox inspect requested: %s / future=%s / state=%s / no-op" % [
		object_key,
		String(payload.get("future_source", "-")),
		String(payload.get("visual_state", "-")),
	])
	sfx.play_select()
	_update_status()


func _on_panel_closed() -> void:
	panel_state = "closed"
	last_action = "close"
	_set_room_input_enabled(true)
	_append_log("Sandbox interaction panel closed.")
	sfx.play_cancel()
	_update_status()


func _append_log(text: String) -> void:
	event_log.push_front(text)
	while event_log.size() > 6:
		event_log.pop_back()
	log_label.text = "Event Log:\n%s" % "\n".join(event_log)


func _update_status() -> void:
	status_label.text = "Quarterview Gameplay Sandbox\nNot Main\nNo Phone/Outlet/Result wiring yet\nRoom contract connected: %s\nLast interaction: %s\nLast nearest: %s\nPanel: %s\nLast object: %s\nLast role: %s\nLast action: %s\nReal wiring: none\nDebug: %s" % [
		"yes" if room_contract_connected else "no",
		last_interaction,
		last_nearest,
		panel_state,
		last_object,
		last_role,
		last_action,
		"on" if debug_overlay_enabled else "off",
	]


func _update_debug_label() -> void:
	if not debug_overlay_enabled:
		return

	var room_debug := ""
	if room != null and room.has_method("get_debug_text"):
		room_debug = room.call("get_debug_text")

	debug_label.text = "Sandbox Debug\nplayer=(%.0f, %.0f)\ncontract_connected=%s\nlast_interaction=%s\nlast_nearest=%s\n%s" % [
		player_position.x,
		player_position.y,
		str(room_contract_connected),
		last_interaction,
		last_nearest,
		room_debug,
	]


func _close_interaction_panel() -> void:
	if interaction_panel != null:
		interaction_panel.close()


func _is_interaction_panel_open() -> bool:
	return interaction_panel != null and interaction_panel.has_method("is_open") and interaction_panel.is_open()


func _set_room_input_enabled(enabled: bool) -> void:
	if room != null and room.has_method("set_player_input_enabled"):
		room.set_player_input_enabled(enabled)
