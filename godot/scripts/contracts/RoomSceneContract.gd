extends Node
class_name RoomSceneContract

# Prototype/sandbox-facing room interface skeleton.
# Do not attach this to Main or existing room scenes until a migration task wires it.

signal interaction_requested(object_key: String, action_key: String, payload: Dictionary)
signal nearest_interactable_changed(object_key: String, display_name: String)
signal room_back_requested
signal debug_overlay_toggled(enabled: bool)
signal player_position_changed(position: Vector2)
signal room_ready

const ACTION_PRIMARY := "primary"
const ACTION_INSPECT := "inspect"
const ACTION_CLOSE := "close"
const ACTION_DEBUG := "debug"

const MESSAGE_INFO := "info"
const MESSAGE_WARNING := "warning"
const MESSAGE_ERROR := "error"


static func make_interaction_payload(
	zone: String,
	role: String,
	future_source: String,
	visual_state: String
) -> Dictionary:
	return {
		"zone": zone,
		"role": role,
		"future_source": future_source,
		"visual_state": visual_state,
	}


func set_player_input_enabled(enabled: bool) -> void:
	pass


func set_debug_overlay_enabled(enabled: bool) -> void:
	pass


func is_debug_overlay_enabled() -> bool:
	return false


func set_connected_devices(device_keys: Array[String]) -> void:
	pass


func set_active_devices(device_keys: Array[String]) -> void:
	pass


func set_device_visual_state(object_key: String, visual_state: String) -> void:
	pass


func set_room_object_definitions(definitions: Array) -> void:
	pass


func get_nearest_interactable_key() -> String:
	return ""


func request_nearest_interaction(action_key: String = ACTION_PRIMARY) -> void:
	pass


func get_player_position() -> Vector2:
	return Vector2.ZERO


func set_player_position(position: Vector2) -> void:
	pass


func set_time_of_day_label(text: String) -> void:
	pass


func show_room_message(text: String, duration: float = 2.0) -> void:
	pass


func clear_room_message() -> void:
	pass
