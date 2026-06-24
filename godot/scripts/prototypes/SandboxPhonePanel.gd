extends Control

signal closed

@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var body_label: Label = $Panel/Margin/VBox/BodyLabel
@onready var close_button: Button = $Panel/Margin/VBox/ButtonRow/CloseButton


func _ready() -> void:
	visible = false
	close_button.pressed.connect(close)


func open_with_text(text: String, source: String = "unknown") -> void:
	title_label.text = "PHONE / SANDBOX STATUS"
	body_label.text = "%s\n\nOpened from: %s\n\nThis panel is sandbox-only.\nMain/DAY1 Phone routing and SurvivalState battery state are not connected." % [
		text,
		source,
	]
	close_button.text = "Close"
	visible = true


func close() -> void:
	if not visible:
		return
	visible = false
	closed.emit()


func is_open() -> bool:
	return visible
