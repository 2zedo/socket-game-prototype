extends Control
class_name DayResultPanel

@onready var panel: Panel = $Panel
@onready var result_label: Label = $Panel/ResultLabel
@onready var footer_label: Label = $Panel/FooterLabel


func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(UIStyle.PANEL, UIStyle.LINE_DIM, 1, 2))
	UIStyle.apply_label(result_label, UIStyle.TEXT, 17)
	UIStyle.apply_label(footer_label, UIStyle.MUTED, 15)


func open(result: Dictionary) -> void:
	var lines: Array[String] = []
	var day_number: int = int(result.get("day", 1))
	var score_lines: Array = result.get("lines", [])

	lines.append("DAY %d 기록" % day_number)
	lines.append("")

	for score_line in score_lines:
		lines.append(str(score_line))

	lines.append("")
	lines.append("오늘도 간신히 하루를 버텼다.")
	lines.append("남은 전력으로 내일을 준비해야 한다.")

	result_label.text = "\n".join(lines)
	visible = true


func close() -> void:
	visible = false
