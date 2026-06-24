extends Node2D

const RESTART_KEY := KEY_R

@onready var quarterview_room: Node2D = $QuarterviewRoom
@onready var status_label: Label = $UILayer/StatusPanel/Margin/VBox/StatusLabel
@onready var log_label: Label = $UILayer/StatusPanel/Margin/VBox/LogLabel

var last_interaction := "-"


func _ready() -> void:
	if quarterview_room.has_signal("interaction_requested"):
		quarterview_room.connect("interaction_requested", Callable(self, "_on_room_interaction_requested"))
	if quarterview_room.has_signal("nearest_interactable_changed"):
		quarterview_room.connect("nearest_interactable_changed", Callable(self, "_on_nearest_interactable_changed"))

	_update_status("QuarterviewMain candidate ready.")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == RESTART_KEY:
			get_tree().reload_current_scene()
			get_viewport().set_input_as_handled()


func _on_room_interaction_requested(object_key: String, action_key: String, payload: Dictionary) -> void:
	var role := String(payload.get("role", "-"))
	var display_name := String(payload.get("display_name", object_key))
	last_interaction = "%s / role=%s / action=%s" % [object_key, role, action_key]
	print("QuarterviewMain candidate interaction: %s / display=%s" % [last_interaction, display_name])
	_update_status("Interaction request received.")


func _on_nearest_interactable_changed(object_key: String, display_name: String) -> void:
	if object_key.is_empty():
		_update_status("No nearby object.")
	else:
		_update_status("Nearest: %s (%s)" % [display_name, object_key])


func _update_status(message: String) -> void:
	status_label.text = "Candidate only / not project main\nNo Phone / Outlet / Result wiring\n%s" % message
	log_label.text = "Last: %s\nR: restart" % last_interaction
