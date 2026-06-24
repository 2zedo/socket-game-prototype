extends Control

signal primary_pressed(object_key: String, role: String, payload: Dictionary)
signal inspect_pressed(object_key: String, role: String, payload: Dictionary)
signal closed

@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var detail_label: Label = $Panel/Margin/VBox/DetailLabel
@onready var primary_button: Button = $Panel/Margin/VBox/ButtonRow/PrimaryButton
@onready var inspect_button: Button = $Panel/Margin/VBox/ButtonRow/InspectButton
@onready var close_button: Button = $Panel/Margin/VBox/ButtonRow/CloseButton

var current_object_key := ""
var current_role := ""
var current_payload: Dictionary = {}


func _ready() -> void:
	visible = false
	primary_button.pressed.connect(_on_primary_pressed)
	inspect_button.pressed.connect(_on_inspect_pressed)
	close_button.pressed.connect(close)


func show_object_interaction(
	object_key: String,
	display_name: String,
	role: String,
	future_source: String,
	visual_state: String,
	payload: Dictionary
) -> void:
	current_object_key = object_key
	current_role = role
	current_payload = payload.duplicate(true)

	var zone := String(payload.get("zone", "-"))
	title_label.text = display_name if not display_name.is_empty() else object_key
	detail_label.text = "key: %s\nrole: %s\nzone: %s\nfuture: %s\nstate: %s\n\nSandbox only.\nNo real Main/DAY1 action is connected yet." % [
		object_key,
		role,
		zone,
		future_source,
		visual_state,
	]
	primary_button.text = _get_primary_label(role)
	inspect_button.text = "Inspect"
	close_button.text = "Close"
	visible = true


func close() -> void:
	if not visible:
		return
	visible = false
	closed.emit()


func is_open() -> bool:
	return visible


func _on_primary_pressed() -> void:
	primary_pressed.emit(current_object_key, current_role, current_payload)


func _on_inspect_pressed() -> void:
	inspect_pressed.emit(current_object_key, current_role, current_payload)


func _get_primary_label(role: String) -> String:
	match role:
		"manual_end_day":
			return "Rest / End Day"
		"laptop_job":
			return "Open Work"
		"power_management":
			return "Open Power"
		"communication":
			return "Check Signal"
		"mystery_device":
			return "Inspect NODE"
		"phone_status":
			return "Open Phone"
		"phone_charge":
			return "Check Charge"
		"audio_hacking_device":
			return "Check Audio"
		"living_appliance":
			return "Inspect Appliance"
		"support_device":
			return "Inspect Device"
		"background_structure":
			return "Inspect"
	return "Interact"
