extends Control
class_name DayResultPanel

@onready var result_label: Label = $Panel/ResultLabel


func open(result: Dictionary) -> void:
	var lines: Array[String] = []
	var day_number: int = int(result.get("day", 1))
	var earned_points: int = int(result.get("total", 0))
	var total_points: int = int(result.get("total_points", 0))
	var score_lines: Array = result.get("lines", [])

	lines.append("DAY %d 결과" % day_number)
	lines.append("")

	for score_line in score_lines:
		lines.append(str(score_line))

	lines.append("")
	lines.append("획득 포인트: %d" % earned_points)
	lines.append("총 포인트: %d" % total_points)

	result_label.text = "\n".join(lines)
	visible = true


func close() -> void:
	visible = false
