extends Control

signal toggle_clock_requested
signal add_minutes_requested(minutes: int)
signal jump_time_requested(hour: int, minute: int)
signal trigger_auto_end_requested
signal trigger_manual_result_requested
signal reset_sandbox_requested
signal close_requested

@onready var state_label: Label = $Panel/Margin/VBox/StateLabel
@onready var time_label: Label = $Panel/Margin/VBox/TimeLabel
@onready var toggle_clock_button: Button = $Panel/Margin/VBox/ButtonContainer/ToggleClockButton
@onready var add_30_min_button: Button = $Panel/Margin/VBox/ButtonContainer/Add30MinButton
@onready var add_2_hour_button: Button = $Panel/Margin/VBox/ButtonContainer/Add2HourButton
@onready var jump_0150_button: Button = $Panel/Margin/VBox/ButtonContainer/Jump0150Button
@onready var trigger_auto_end_button: Button = $Panel/Margin/VBox/ButtonContainer/TriggerAutoEndButton
@onready var trigger_manual_result_button: Button = $Panel/Margin/VBox/ButtonContainer/TriggerManualResultButton
@onready var reset_sandbox_button: Button = $Panel/Margin/VBox/ButtonContainer/ResetSandboxButton
@onready var close_button: Button = $Panel/Margin/VBox/ButtonContainer/CloseButton

var current_summary: Dictionary = {}


func _ready() -> void:
	visible = false
	toggle_clock_button.pressed.connect(func() -> void: toggle_clock_requested.emit())
	add_30_min_button.pressed.connect(func() -> void: add_minutes_requested.emit(30))
	add_2_hour_button.pressed.connect(func() -> void: add_minutes_requested.emit(120))
	jump_0150_button.pressed.connect(func() -> void: jump_time_requested.emit(1, 50))
	trigger_auto_end_button.pressed.connect(func() -> void: trigger_auto_end_requested.emit())
	trigger_manual_result_button.pressed.connect(func() -> void: trigger_manual_result_requested.emit())
	reset_sandbox_button.pressed.connect(func() -> void: reset_sandbox_requested.emit())
	close_button.pressed.connect(close)


func show_test_mode(summary: Dictionary) -> void:
	update_summary(summary)
	visible = true


func update_summary(summary: Dictionary) -> void:
	current_summary = summary.duplicate(true)
	var clock_text := String(summary.get("clock_running", "false"))
	var restore_text := String(summary.get("restore_clock_on_close", "false"))
	var auto_end_text := String(summary.get("auto_end_triggered", "false"))
	var result_text := String(summary.get("result_open", "false"))
	var end_reason := String(summary.get("end_reason", "none"))
	var open_modal := String(summary.get("open_modal", "none"))

	time_label.text = "Time: %s\nElapsed: %d min\nClock: %s\nRestore on close: %s" % [
		String(summary.get("time", "--:--")),
		int(summary.get("elapsed_minutes", 0)),
		clock_text,
		restore_text,
	]
	state_label.text = "Auto End: %s\nResult: %s\nEnd reason: %s\nOpen modal: %s\nMain/DAY1: %s" % [
		auto_end_text,
		result_text,
		end_reason,
		open_modal,
		String(summary.get("main_wiring", "not connected")),
	]


func close(emit_request: bool = true) -> void:
	if not visible:
		return
	visible = false
	if emit_request:
		close_requested.emit()


func is_open() -> bool:
	return visible
