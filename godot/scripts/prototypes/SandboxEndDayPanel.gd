extends Control

signal confirmed
signal cancelled
signal closed

@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var detail_label: Label = $Panel/Margin/VBox/DetailLabel
@onready var confirm_button: Button = $Panel/Margin/VBox/ButtonRow/ConfirmButton
@onready var cancel_button: Button = $Panel/Margin/VBox/ButtonRow/CancelButton
@onready var close_button: Button = $Panel/Margin/VBox/ButtonRow/CloseButton

var current_object_key := ""
var current_payload: Dictionary = {}


func _ready() -> void:
	visible = false
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	close_button.pressed.connect(close)


func show_confirmation(object_key: String, display_name: String, payload: Dictionary) -> void:
	current_object_key = object_key
	current_payload = payload.duplicate(true)
	var role := String(payload.get("role", "-"))
	var future_source := String(payload.get("future_source", "-"))
	var visual_state := String(payload.get("visual_state", "-"))
	var title_name := display_name if not display_name.is_empty() else object_key

	title_label.text = "End Day? / %s" % title_name
	detail_label.text = "Sandbox End Day confirmation only.\nNo SurvivalState, Result, or Main flow is connected.\n\nkey: %s\nrole: %s\nfuture: %s\nstate: %s" % [
		object_key,
		role,
		future_source,
		visual_state,
	]
	confirm_button.text = "End Day"
	cancel_button.text = "Cancel"
	close_button.text = "Close"
	confirm_button.visible = true
	cancel_button.visible = true
	close_button.visible = true
	visible = true


func show_confirmed() -> void:
	title_label.text = "Sandbox End Day Confirmed"
	detail_label.text = "day_end_confirmed = true\nResult / SurvivalState / Main DAY1 flow is still not connected.\n\nPress R to restart sandbox or B / Backspace to return to PrototypeHub."
	confirm_button.visible = false
	cancel_button.visible = false
	close_button.visible = false
	visible = true


func close() -> void:
	if not visible:
		return
	visible = false
	closed.emit()


func is_open() -> bool:
	return visible


func _on_confirm_pressed() -> void:
	confirmed.emit()


func _on_cancel_pressed() -> void:
	cancelled.emit()
