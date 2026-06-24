extends Control

signal restart_requested
signal hub_requested
signal closed

@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var summary_label: Label = $Panel/Margin/VBox/SummaryLabel
@onready var detail_label: Label = $Panel/Margin/VBox/DetailLabel
@onready var warning_label: Label = $Panel/Margin/VBox/WarningLabel
@onready var restart_button: Button = $Panel/Margin/VBox/ButtonRow/RestartButton
@onready var hub_button: Button = $Panel/Margin/VBox/ButtonRow/HubButton
@onready var close_button: Button = $Panel/Margin/VBox/ButtonRow/CloseButton

var current_summary: Dictionary = {}


func _ready() -> void:
	visible = false
	restart_button.pressed.connect(func() -> void: restart_requested.emit())
	hub_button.pressed.connect(func() -> void: hub_requested.emit())
	close_button.pressed.connect(close)


func show_result(summary: Dictionary) -> void:
	current_summary = summary.duplicate(true)
	var end_reason_label := String(summary.get("end_reason_label", "Sandbox End"))
	var start_time := String(summary.get("start_time", "--:--"))
	var end_time := String(summary.get("end_time", "--:--"))
	var elapsed_minutes := int(summary.get("elapsed_minutes", 0))

	title_label.text = "Sandbox Result"
	summary_label.text = "End reason: %s\nTime: %s -> %s\nElapsed: %d min" % [
		end_reason_label,
		start_time,
		end_time,
		elapsed_minutes,
	]
	detail_label.text = "%s\n%s\n%s\n%s" % [
		String(summary.get("result_note", "Sandbox only.")),
		String(summary.get("phone_note", "Phone state is not wired.")),
		String(summary.get("power_note", "Power result is not wired.")),
		String(summary.get("outlet_note", "Outlet state is not wired.")),
	]
	warning_label.text = "%s\n%s\n\nR: Restart sandbox\nB / Backspace: PrototypeHub" % [
		String(summary.get("reward_note", "Reward / Grid Credit is not wired.")),
		"No DayResultPanel, SurvivalState, reward, save/load, story flag, or Main/DAY1 flow was updated.",
	]
	restart_button.text = "Restart"
	hub_button.text = "Hub"
	close_button.text = "Hide Details"
	visible = true


func close() -> void:
	if not visible:
		return
	visible = false
	closed.emit()


func is_open() -> bool:
	return visible
