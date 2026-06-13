extends Node
class_name SurvivalState

signal changed
signal day_ended(result: Dictionary)

const MIN_STAT: float = 0.0
const MAX_STAT: float = 100.0
const DAY_SECONDS: float = 60.0
const PHASE_SECONDS: float = 30.0
const DAY1_STARTING_POWER_UNITS: int = 10
const DAY1_MAX_LOAD_WATTS: int = 3000
const DAY1_MAX_OUTLET_SLOTS: int = 4

# DAY 1 object tuning is grouped here so the MVP can move it into a Resource
# or data file later without searching through scene flow code.
const DAY1_ACTIONS: Dictionary = {
	"light": {
		"label": "조명",
		"cost": 1,
		"watt_usage": 60,
		"outlet_size": 1,
		"requires_connection": true,
		"flag": "used_light",
		"power_key": "light",
		"feedback": "약한 조명이 방을 겨우 밝힙니다. 오래 버티지는 못할 빛입니다.",
		"already_used": "조명은 이미 켜져 있습니다. 전력을 더 쓰지는 않습니다.",
	},
	"laptop": {
		"label": "노트북",
		"cost": 3,
		"watt_usage": 1300,
		"outlet_size": 1,
		"requires_connection": true,
		"flag": "checked_laptop",
		"power_key": "laptop",
		"feedback": "낡은 로그가 화면에 떠오릅니다. 몇 줄은 Grid라는 이름을 반복합니다.",
		"already_used": "오늘 확인할 수 있는 로그는 이미 훑었습니다.",
	},
	"fan": {
		"label": "선풍기",
		"cost": 2,
		"watt_usage": 900,
		"outlet_size": 1,
		"requires_connection": true,
		"flag": "used_fan",
		"power_key": "fan",
		"feedback": "선풍기가 느리게 돌기 시작합니다. 공기가 움직이지만 계량기는 내려갑니다.",
		"already_used": "선풍기는 이미 돌아가고 있습니다.",
	},
	"charger": {
		"label": "충전기",
		"cost": 2,
		"watt_usage": 20,
		"outlet_size": 1,
		"requires_connection": true,
		"flag": "charged_device",
		"power_key": "charger",
		"feedback": "배터리가 조금씩 차오릅니다. 시간을 산 느낌입니다.",
		"already_used": "오늘 필요한 만큼은 이미 충전했습니다.",
	},
	"communication_device": {
		"label": "통신 장치",
		"cost": 4,
		"watt_usage": 300,
		"outlet_size": 1,
		"requires_connection": true,
		"flag": "sent_or_received_signal",
		"power_key": "communication_device",
		"feedback": "끊어진 신호 사이로 안내 방송이 섞여 들어옵니다. 아직 바깥에는 누군가 있습니다.",
		"already_used": "잡음만 반복됩니다. 오늘 새 신호는 더 잡히지 않습니다.",
	},
}

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
var max_power: int = DAY1_STARTING_POWER_UNITS
var current_power: int = DAY1_STARTING_POWER_UNITS
var max_load_watts: int = DAY1_MAX_LOAD_WATTS
var current_load_watts: int = 0
var max_outlet_slots: int = DAY1_MAX_OUTLET_SLOTS
var used_outlet_slots: int = 0
var max_power_watts: int = DAY1_MAX_LOAD_WATTS
var current_power_watts: int = 0
var current_power_units: int = DAY1_STARTING_POWER_UNITS
var powered_devices: Array[String] = []
var used_day1_actions: Array[String] = []
var day1_flags: Dictionary = {}
var day1_day_ended: bool = false
var last_day1_message: String = ""
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
	_recalculate_outlet_state()
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
	_reset_day1_power_loop()
	is_time_paused = false
	changed.emit()


func get_phase_label() -> String:
	return "낮" if phase == "day" else "밤"


func get_time_text() -> String:
	return ""


func get_phase_effect_text() -> String:
	if phase == "day":
		return "낮 효과\n- 온도 증가 속도 증가\n- 재미 감소 속도 완화"

	return "밤 효과\n- 배터리 감소 속도 증가\n- 선풍기 + 낮은 온도 시 피로 회복"


func get_warning_lines() -> Array[String]:
	var warnings: Array[String] = []

	if current_power_units <= 2:
		warnings.append("오늘 남은 전력 부족")
	if current_load_watts > max_load_watts:
		warnings.append("현재 부하 초과")

	return warnings


func get_hud_stat_text() -> String:
	return "DAY 1\n오늘 남은 전력: %d / %d\n사용한 기기: %s" % [
		current_power,
		max_power,
		get_used_day1_action_summary(),
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
		"오늘 남은 전력: %d / %d" % [current_power, max_power],
		"사용 기록: %s" % get_used_day1_action_summary(),
		"",
		"현재 부하: %dW / %dW" % [current_load_watts, max_load_watts],
		"콘센트: %d / %d" % [used_outlet_slots, max_outlet_slots],
	]

	return "\n".join(lines)


func preview_power_use(watts: int) -> void:
	current_load_watts = clampi(watts, 0, 9999)
	current_power_watts = current_load_watts
	changed.emit()


func end_current_day() -> void:
	if is_time_paused:
		return

	day1_flags["ended_by_rest"] = true
	_end_day()


func get_day1_action_data(action_key: String) -> Dictionary:
	return DAY1_ACTIONS.get(action_key, {})


func is_day1_action_connected(action_key: String) -> bool:
	var action_data := get_day1_action_data(action_key)
	if action_data.is_empty():
		return false

	if not bool(action_data.get("requires_connection", false)):
		return true

	var power_key: String = str(action_data.get("power_key", action_key))
	return powered_devices.has(power_key)


func get_day1_disconnected_message(action_key: String) -> String:
	var action_data := get_day1_action_data(action_key)
	var label: String = str(action_data.get("label", action_key))
	return "%s\n\n전원이 연결되어 있지 않다.\n먼저 멀티탭에서 이 기기를 연결해야 한다." % label


func get_used_day1_action_summary() -> String:
	if used_day1_actions.is_empty():
		return "없음"

	var labels: Array[String] = []
	for action_key in used_day1_actions:
		var action_data := get_day1_action_data(action_key)
		labels.append(str(action_data.get("label", action_key)))

	return ", ".join(labels)


func try_use_day1_action(action_key: String) -> Dictionary:
	var action_data := get_day1_action_data(action_key)
	if action_data.is_empty():
		return {
			"success": false,
			"message": "아직 사용할 수 없는 오브젝트입니다.",
		}

	var cost: int = int(action_data.get("cost", 0))
	var label: String = str(action_data.get("label", action_key))
	if not is_day1_action_connected(action_key):
		return {
			"success": false,
			"message": "전원이 연결되어 있지 않다.\n먼저 멀티탭에서 이 기기를 연결해야 한다.",
		}

	if used_day1_actions.has(action_key):
		return {
			"success": false,
			"message": "오늘은 이미 사용했다.",
		}

	if current_power_units < cost:
		return {
			"success": false,
			"message": "오늘 남은 전력이 부족하다.",
		}

	current_power_units = maxi(0, current_power_units - cost)
	current_power = current_power_units
	used_day1_actions.append(action_key)
	var flag_key: String = str(action_data.get("flag", action_key))
	day1_flags[flag_key] = true

	_apply_day1_action_effect(action_key)
	last_day1_message = str(action_data.get("feedback", "%s을 사용했습니다." % label))
	changed.emit()

	return {
		"success": true,
		"message": "%s\n\n오늘 남은 전력: %d / %d" % [
			last_day1_message,
			current_power,
			max_power,
		],
		"remaining_power": current_power_units,
		"flag": flag_key,
	}


func _update_needs(delta: float) -> void:
	var has_phone_charger: bool = powered_devices.has("charger") or powered_devices.has("phone")
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
	day1_day_ended = true

	var result: Dictionary = _calculate_day_result()
	total_points += int(result.get("total", 0))
	changed.emit()
	day_ended.emit(result)


func _calculate_day_result() -> Dictionary:
	var lines: Array[String] = []
	var total: int = 0

	lines.append("오늘 남은 전력: %d / %d" % [current_power, max_power])
	lines.append("사용 기록: %s" % get_used_day1_action_summary())
	lines.append("현재 부하: %dW / %dW" % [current_load_watts, max_load_watts])
	lines.append("콘센트: %d / %d" % [used_outlet_slots, max_outlet_slots])
	lines.append("확인한 정보: %s" % _get_day1_info_summary())
	lines.append("상태 변화: %s" % _get_day1_state_change_summary())

	if battery >= 50.0:
		total += 10

	if fatigue <= 55.0:
		total += 10
	elif fatigue >= 80.0:
		total -= 15

	if temperature >= 85.0:
		total -= 15

	if overloads_today > 0:
		total -= 10 * overloads_today

	total = maxi(0, total)

	return {
		"day": day,
		"lines": lines,
		"total": total,
		"total_points": total_points + total,
		"remaining_power": current_power_units,
		"used_day1_actions": used_day1_actions.duplicate(),
		"day1_flags": day1_flags.duplicate(),
	}


func _add_score_line(lines: Array[String], label: String, amount: int) -> int:
	var sign_text: String = "+" if amount >= 0 else ""
	lines.append("%s %s%d" % [label, sign_text, amount])
	return amount


func _get_day1_info_summary() -> String:
	var info_lines: Array[String] = []
	if day1_flags.get("checked_laptop", false):
		info_lines.append("Grid 로그")
	if day1_flags.get("sent_or_received_signal", false):
		info_lines.append("외부 안내 신호")

	if info_lines.is_empty():
		return "없음"

	return ", ".join(info_lines)


func _get_day1_state_change_summary() -> String:
	var changes: Array[String] = []
	if day1_flags.get("used_light", false):
		changes.append("방 안 시야 확보")
	if day1_flags.get("charged_device", false):
		changes.append("배터리 회복")
	if day1_flags.get("used_fan", false):
		changes.append("온도 완화")
	if day1_flags.get("ended_by_rest", false):
		changes.append("직접 하루 종료")

	if changes.is_empty():
		return "특이 변화 없음"

	return ", ".join(changes)


func _apply_day1_action_effect(action_key: String) -> void:
	# These small stat nudges make the MVP feedback visible while keeping the
	# real balance pass separate from this first power-loop implementation.
	match action_key:
		"light":
			fatigue = clampf(fatigue - 2.0, MIN_STAT, MAX_STAT)
		"laptop":
			fun = clampf(fun + 8.0, MIN_STAT, MAX_STAT)
		"fan":
			temperature = clampf(temperature - 6.0, MIN_STAT, MAX_STAT)
		"charger":
			battery = clampf(battery + 12.0, MIN_STAT, MAX_STAT)
		"communication_device":
			fun = clampf(fun + 3.0, MIN_STAT, MAX_STAT)


func _reset_day1_power_loop() -> void:
	current_power_units = DAY1_STARTING_POWER_UNITS
	current_power = current_power_units
	current_load_watts = 0
	current_power_watts = 0
	used_outlet_slots = 0
	powered_devices.clear()
	used_day1_actions.clear()
	day1_flags.clear()
	day1_day_ended = false
	last_day1_message = ""


func _recalculate_outlet_state() -> void:
	current_load_watts = 0
	used_outlet_slots = 0

	# The outlet panel owns connection gestures, but SurvivalState is the source
	# of truth for what those connections mean to the DAY 1 power loop.
	for action_key in DAY1_ACTIONS.keys():
		var action_data: Dictionary = DAY1_ACTIONS[action_key]
		var power_key: String = str(action_data.get("power_key", action_key))
		if not powered_devices.has(power_key):
			continue

		current_load_watts += int(action_data.get("watt_usage", 0))
		used_outlet_slots += int(action_data.get("outlet_size", 0))

	current_power_watts = current_load_watts
