extends Control
class_name DayResultPanel

@onready var panel: Panel = $Panel
@onready var result_label: Label = $Panel/ResultLabel
@onready var snapshot_panel: Panel = $Panel/SnapshotPanel
@onready var snapshot_label: Label = $Panel/SnapshotPanel/SnapshotLabel
@onready var thought_panel: Panel = $Panel/ThoughtPanel
@onready var thought_label: Label = $Panel/ThoughtPanel/ThoughtLabel
@onready var footer_label: Label = $Panel/FooterLabel


func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(UIStyle.PANEL, UIStyle.LINE_DIM, 1, 2))
	snapshot_panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(Color(0.06, 0.052, 0.044, 0.86), UIStyle.LINE_DIM, 1, 2))
	thought_panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(Color(0.04, 0.037, 0.032, 0.86), UIStyle.LINE_DIM, 1, 2))
	footer_label.add_theme_stylebox_override("normal", UIStyle.make_button_style(false))
	UIStyle.apply_label(result_label, UIStyle.TEXT, 16)
	UIStyle.apply_label(snapshot_label, UIStyle.MUTED, 15)
	UIStyle.apply_label(thought_label, UIStyle.TEXT, 15)
	UIStyle.apply_label(footer_label, UIStyle.MUTED, 15)


func open(result: Dictionary) -> void:
	var lines: Array[String] = []
	var day_number: int = int(result.get("day", 1))
	var score_lines: Array = result.get("lines", [])

	lines.append("DAY %d 기록" % day_number)
	lines.append("")
	lines.append("남은 전력")

	for score_line in score_lines:
		var line := str(score_line)
		if line.begins_with("오늘 남은 전력"):
			lines.append("  %s" % line)
		elif line.begins_with("사용 기록"):
			lines.append("")
			lines.append("사용한 기기")
			lines.append("  %s" % _strip_prefix(line, "사용 기록: "))
		elif line.begins_with("현재 부하") or line.begins_with("콘센트"):
			if not lines.has("현재 연결 상태"):
				lines.append("")
				lines.append("현재 연결 상태")
			lines.append("  %s" % line)
		elif line.begins_with("확인한 정보"):
			lines.append("")
			lines.append("확인한 정보")
			lines.append("  %s" % _strip_prefix(line, "확인한 정보: "))
		elif line.begins_with("상태 변화"):
			lines.append("")
			lines.append("상태 변화")
			lines.append("  %s" % _strip_prefix(line, "상태 변화: "))
		else:
			lines.append("  %s" % line)

	result_label.text = "\n".join(lines)
	thought_label.text = "오늘의 생각\n\n오늘도 간신히 하루를 버텼다.\n남은 전력으로 내일을 준비해야 한다."
	visible = true


func close() -> void:
	visible = false


func _strip_prefix(text: String, prefix: String) -> String:
	if text.begins_with(prefix):
		return text.substr(prefix.length()).strip_edges()

	return text
