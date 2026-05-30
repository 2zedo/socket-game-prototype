extends Node
class_name SurvivalState

signal changed
signal day_ended(result: Dictionary)

const MIN_STAT: float = 0.0
const MAX_STAT: float = 100.0
const DAY_SECONDS: float = 60.0
const PHASE_SECONDS: float = 30.0

var day: int = 1
var current_event: String = "없음"
var phase: String = "day"
var elapsed_seconds: float = 0.0
var remaining_phase_seconds: int = 30
var total_points: int = 0
var overloads_today: int = 0
var is_time_paused: bool = false
var battery: float = 68.0
var temperature: float = 52.0
var fatigue: float = 34.0
var fun: float = 42.0
var max_power_watts: int = 3000
var current_power_watts: int = 0
var powered_devices: Array[String] = []
var update_accumulator: float = 0.0


func _ready() -> void:
	changed.emit()


func _process(delta: float) -> void:
	if is_time_paused:
		return

	_update_time(delta)
	_update_needs(delta)
	update_accumulator += delta

	if update_accumulator >= 0.2:
		update_accumulator = 0.0
		changed.emit()


func set_powered_devices(device_keys: Array[String]) -> void:
	powered_devices = device_keys.duplicate()
	changed.emit()


func record_overload() -> void:
	overloads_today += 1
	changed.emit()


func continue_to_next_day() -> void:
	day += 1
	elapsed_seconds = 0.0
	phase = "day"
	remaining_phase_seconds = int(PHASE_SECONDS)
	overloads_today = 0
	is_time_paused = false
	changed.emit()


func get_phase_label() -> String:
	return "낮" if phase == "day" else "밤"


func get_time_text() -> String:
	return "DAY %d\n현재 시간: %s\n남은 시간: %d초\n포인트: %d" % [
		day,
		get_phase_label(),
		remaining_phase_seconds,
		total_points,
	]


func get_phase_effect_text() -> String:
	if phase == "day":
		return "낮 효과\n- 온도 증가 속도 증가\n- 재미 감소 속도 완화"

	return "밤 효과\n- 배터리 감소 속도 증가\n- 선풍기 + 낮은 온도 시 피로 회복"


func get_warning_lines() -> Array[String]:
	var warnings: Array[String] = []

	if battery <= 25.0:
		warnings.append("배터리 부족")
	if temperature >= 75.0:
		warnings.append("너무 더움")
	if fatigue >= 70.0:
		warnings.append("매우 피곤함")
	if fun <= 25.0:
		warnings.append("우울해지는 중")
	if current_power_watts > max_power_watts:
		warnings.append("전력 과부하 위험")

	return warnings


func get_hud_stat_text() -> String:
	return "🔋 배터리 %d%%\n🌡 온도 %d%%\n😫 피로 %d%%\n🙂 재미 %d%%" % [
		roundi(battery),
		roundi(temperature),
		roundi(fatigue),
		roundi(fun),
	]


func get_phone_text() -> String:
	var lines: Array[String] = [
		"DAY %d" % day,
		"현재 이벤트: %s" % current_event,
		"",
		"배터리: %d%%" % roundi(battery),
		"온도: %d%%" % roundi(temperature),
		"피로: %d%%" % roundi(fatigue),
		"재미: %d%%" % roundi(fun),
		"",
		"전력: %dW / %dW" % [current_power_watts, max_power_watts],
	]

	return "\n".join(lines)


func preview_power_use(watts: int) -> void:
	current_power_watts = clampi(watts, 0, 9999)
	changed.emit()


func _update_needs(delta: float) -> void:
	var has_phone_charger: bool = powered_devices.has("phone")
	var has_fan: bool = powered_devices.has("fan")
	var has_laptop: bool = powered_devices.has("laptop")
	var has_microwave: bool = powered_devices.has("microwave")

	var battery_delta: float = -0.45
	var temperature_delta: float = 0.32
	var fatigue_delta: float = 0.22
	var fun_delta: float = -0.35

	if phase == "day":
		temperature_delta += 0.12
		fun_delta += 0.08
	else:
		battery_delta -= 0.16

	if has_phone_charger:
		battery_delta += 1.35

	if has_fan:
		temperature_delta -= 0.95

	if has_laptop:
		fun_delta += 0.95
		battery_delta -= 0.18

	if has_microwave:
		fatigue_delta -= 0.75
		temperature_delta += 0.24

	if phase == "night" and has_fan and temperature < 40.0:
		fatigue_delta -= 0.28

	if phase == "night" and temperature >= 70.0:
		fatigue_delta += 0.22

	if temperature >= 75.0:
		fatigue_delta += 0.28

	if fun <= 25.0:
		fatigue_delta += 0.18

	battery = clampf(battery + battery_delta * delta, MIN_STAT, MAX_STAT)
	temperature = clampf(temperature + temperature_delta * delta, MIN_STAT, MAX_STAT)
	fatigue = clampf(fatigue + fatigue_delta * delta, MIN_STAT, MAX_STAT)
	fun = clampf(fun + fun_delta * delta, MIN_STAT, MAX_STAT)


func _update_time(delta: float) -> void:
	elapsed_seconds += delta

	if elapsed_seconds >= DAY_SECONDS:
		elapsed_seconds = DAY_SECONDS
		_end_day()
		return

	phase = "day" if elapsed_seconds < PHASE_SECONDS else "night"
	var phase_elapsed: float = fmod(elapsed_seconds, PHASE_SECONDS)
	remaining_phase_seconds = maxi(1, int(ceil(PHASE_SECONDS - phase_elapsed)))


func _end_day() -> void:
	is_time_paused = true
	phase = "night"
	remaining_phase_seconds = 0

	var result: Dictionary = _calculate_day_result()
	total_points += int(result.get("total", 0))
	changed.emit()
	day_ended.emit(result)


func _calculate_day_result() -> Dictionary:
	var lines: Array[String] = []
	var total: int = 0

	total += _add_score_line(lines, "생존 보너스", 100)

	if battery >= 50.0:
		total += _add_score_line(lines, "배터리 상태", 10)

	if fatigue <= 55.0:
		total += _add_score_line(lines, "낮은 피로", 10)
	elif fatigue >= 80.0:
		total += _add_score_line(lines, "피로 패널티", -15)

	if temperature >= 85.0:
		total += _add_score_line(lines, "고온 패널티", -15)

	if overloads_today > 0:
		total += _add_score_line(lines, "과부하 패널티", -10 * overloads_today)

	total = maxi(0, total)

	return {
		"day": day,
		"lines": lines,
		"total": total,
		"total_points": total_points + total,
	}


func _add_score_line(lines: Array[String], label: String, amount: int) -> int:
	var sign_text: String = "+" if amount >= 0 else ""
	lines.append("%s %s%d" % [label, sign_text, amount])
	return amount
