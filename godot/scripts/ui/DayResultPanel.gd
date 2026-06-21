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
	var day_number: int = int(result.get("day", 1))
	var used_devices: Array = result.get("used_day1_actions", [])
	var flags: Dictionary = result.get("day1_flags", {})
	result_label.text = _build_survival_log(result, day_number, used_devices, flags)
	snapshot_label.text = "DAY %d\n정전 일지" % day_number
	thought_label.text = "유이의 기록\n\n%s" % _build_day_summary(result, used_devices, flags)
	footer_label.text = "[E] 계속"
	visible = true


func close() -> void:
	visible = false


func _strip_prefix(text: String, prefix: String) -> String:
	if text.begins_with(prefix):
		return text.substr(prefix.length()).strip_edges()

	return text


func _build_survival_log(result: Dictionary, day_number: int, used_devices: Array, flags: Dictionary) -> String:
	var lines: Array[String] = [
		"DAY %d 생존 기록" % day_number,
		"",
		"남은 전력",
		"  %s" % _get_result_line_value(result, "오늘 남은 전력: ", "기록 없음"),
		"",
		"사용한 장치",
		"  %s" % _get_used_device_text(used_devices),
		"",
		"확인한 정보",
		"  %s" % _get_information_text(flags),
		"",
		"상태 변화",
		"  %s" % _get_state_change_text(flags),
	]
	return "\n".join(lines)


func _build_day_summary(result: Dictionary, used_devices: Array, flags: Dictionary) -> String:
	var sentences: Array[String] = []
	var remaining_power: float = float(result.get("remaining_power", 0.0))
	if used_devices.is_empty():
		sentences.append("아무것도 켜지 않은 채, 어둠 속에서 시간을 보냈다.")
	elif remaining_power <= 2.0:
		sentences.append("전력은 바닥에 가까워졌다. 내일은 더 신중해야 한다.")
	elif remaining_power >= 7.0:
		sentences.append("오늘은 전력을 아껴 쓰며 조용히 하루를 넘겼다.")
	else:
		sentences.append("필요한 장치를 골라 켜며 오늘 하루를 버텼다.")

	if bool(flags.get("checked_laptop", false)):
		sentences.append("오래된 로그에서 Grid라는 단어가 눈에 띄었다.")
	if bool(flags.get("sent_or_received_signal", false)):
		sentences.append("끊어진 신호 사이로 누군가의 방송이 들려왔다.")
	return "\n".join(sentences)


func _get_used_device_text(used_devices: Array) -> String:
	if used_devices.is_empty():
		return "오늘은 어떤 장치도 켜지 않았다."

	var labels: Array[String] = []
	for raw_key in used_devices:
		var device_data: Dictionary = SurvivalState.get_day1_device_data(str(raw_key))
		labels.append(str(device_data.get("label", "알 수 없는 장치")))
	return ", ".join(labels)


func _get_information_text(flags: Dictionary) -> String:
	var entries: Array[String] = []
	if bool(flags.get("checked_laptop", false)):
		entries.append("노트북의 오래된 로그에서 Grid라는 단어를 확인했다.")
	if bool(flags.get("sent_or_received_signal", false)):
		entries.append("끊어진 신호 사이에서 외부 안내 방송을 들었다.")
	return "새로 확인한 정보는 없다." if entries.is_empty() else " ".join(entries)


func _get_state_change_text(flags: Dictionary) -> String:
	var entries: Array[String] = []
	if bool(flags.get("used_light", false)):
		entries.append("방 안의 어둠을 잠시 밀어냈다.")
	if bool(flags.get("used_fan", false)):
		entries.append("방 안의 더운 공기를 조금 식혔다.")
	if bool(flags.get("charged_device", false)):
		entries.append("휴대폰 배터리를 충전했다.")
	if bool(flags.get("ended_by_rest", false)):
		entries.append("스스로 오늘을 정리하고 잠자리에 들었다.")
	return "눈에 띄는 변화는 없었다." if entries.is_empty() else " ".join(entries)


func _get_result_line_value(result: Dictionary, prefix: String, fallback: String) -> String:
	var result_lines: Array = result.get("lines", [])
	for raw_line in result_lines:
		var line: String = str(raw_line)
		if line.begins_with(prefix):
			return _strip_prefix(line, prefix)
	return fallback
