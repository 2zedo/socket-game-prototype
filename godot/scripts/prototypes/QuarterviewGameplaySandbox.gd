extends Node2D

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")
const PROTOTYPE_SFX_SCRIPT := preload("res://scripts/prototypes/PrototypeSfx.gd")
const ROOM_STUB_SCENE := preload("res://scenes/prototypes/QuarterviewSandboxRoomStub.tscn")

var room
var sfx
var room_contract_connected := false
var debug_overlay_enabled := false
var last_interaction := "-"
var last_nearest := "-"
var player_position := Vector2.ZERO
var event_log: Array[String] = []

@onready var room_host: Node2D = $SandboxRoot/RoomHost
@onready var status_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxStatusLabel
@onready var log_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxLogLabel
@onready var help_label: Label = $SandboxRoot/UILayer/SandboxStatusPanel/Margin/VBox/SandboxHelpLabel
@onready var prompt_label: Label = $SandboxRoot/UILayer/NearestPromptLabel
@onready var debug_layer: CanvasLayer = $SandboxRoot/DebugLayer
@onready var debug_label: Label = $SandboxRoot/DebugLayer/DebugPanel/Margin/DebugLabel


func _ready() -> void:
	_configure_sfx()
	_configure_help()
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
	var log_text := "interaction_requested: %s / %s / zone=%s / role=%s" % [
		object_key,
		action_key,
		zone,
		role,
	]
	_append_log(log_text)
	print("Sandbox received interaction: %s / %s / future=%s / state=%s / no-op" % [
		object_key,
		action_key,
		future_source,
		visual_state,
	])
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


func _append_log(text: String) -> void:
	event_log.push_front(text)
	while event_log.size() > 6:
		event_log.pop_back()
	log_label.text = "Event Log:\n%s" % "\n".join(event_log)


func _update_status() -> void:
	status_label.text = "Quarterview Gameplay Sandbox\nNot Main\nNo Phone/Outlet/Result wiring yet\nRoom contract connected: %s\nLast interaction: %s\nLast nearest: %s\nDebug: %s" % [
		"yes" if room_contract_connected else "no",
		last_interaction,
		last_nearest,
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
