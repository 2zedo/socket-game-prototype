extends Control
class_name DayResultPanel

@onready var result_label: Label = $Panel/ResultLabel


func open(result: Dictionary) -> void:
	var lines: Array[String] = []
	var day_number: int = int(result.get("day", 1))
	var score_lines: Array = result.get("lines", [])

	lines.append("DAY %d 결과" % day_number)
	lines.append("")

	for score_line in score_lines:
		lines.append(str(score_line))

	result_label.text = "\n".join(lines)
	visible = true


func close() -> void:
	visible = false
