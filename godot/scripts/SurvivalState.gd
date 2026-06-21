extends Node
class_name SurvivalState

signal changed
signal day_ended(result: Dictionary)
signal day_time_limit_reached
signal phone_battery_warning(message: String)
signal day1_power_warning(message: String)

const MIN_STAT: float = 0.0
const MAX_STAT: float = 100.0
const DAY_SECONDS: float = 60.0
const DAY_START_MINUTES: int = 8 * 60
# 다음 날 02:00을 26:00으로 다뤄 자정을 지나는 진행 시간을 단순하게 유지한다.
const DAY_END_MINUTES: int = 26 * 60
const DAY_GAME_HOURS: float = float(DAY_END_MINUTES - DAY_START_MINUTES) / 60.0
const GAME_HOURS_PER_REAL_SECOND: float = DAY_GAME_HOURS / DAY_SECONDS
const DAY1_STARTING_POWER_UNITS: int = 10
const DAY1_MAX_LOAD_WATTS: int = 3000
const DAY1_MAX_OUTLET_SLOTS: int = 4
const PHONE_BATTERY_WARNING_THRESHOLDS: Array[int] = [20, 10, 5, 0]
const PHONE_BATTERY_WARNING_MESSAGES: Dictionary = {
	20: "휴대폰 배터리가 얼마 남지 않았다.",
	10: "배터리가 거의 없다. 필요한 정보는 지금 확인해 두자.",
	5: "곧 꺼질 것 같다.",
	0: "휴대폰이 꺼졌다.",
}

const DAY1_DEVICE_DEFINITIONS: Dictionary = {
	"light": preload("res://resources/devices/light.tres"),
	"laptop": preload("res://resources/devices/laptop.tres"),
	"fan": preload("res://resources/devices/fan.tres"),
	"charger": preload("res://resources/devices/charger.tres"),
	"communication_device": preload("res://resources/devices/communication_device.tres"),
}

const POWERSTRIP_DEVICE_ORDER: Array[String] = [
	"fan",
	"communication_device",
	"laptop",
	"charger",
	"light",
]
var day: int = 1
var current_event: String = "없음"
var phase: String = "day"
var elapsed_seconds: float = 0.0
var remaining_phase_seconds: int = int(DAY_SECONDS)
var total_points: int = 0
var overloads_today: int = 0
var is_time_paused: bool = false
var is_clock_paused_by_modal: bool = false
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
var current_power_units: float = float(DAY1_STARTING_POWER_UNITS)
var powered_devices: Array[String] = []
var active_day1_actions: Array[String] = []
var powerstrip_slot_occupancy: Array = []
var powerstrip_device_slots: Dictionary = {}
var powerstrip_device_connected: Dictionary = {}
var powerstrip_device_slot_counts: Dictionary = {}
var used_day1_actions: Array[String] = []
var day1_flags: Dictionary = {}
var day1_day_ended: bool = false
var day_time_limit_announced: bool = false
var last_day1_message: String = ""
var update_accumulator: float = 0.0


func _ready() -> void:
	_reset_powerstrip_connection_state()
	changed.emit()


func _process(delta: float) -> void:
	if is_time_paused or is_clock_paused_by_modal:
		return

	var active_time_delta: float = minf(delta, maxf(0.0, DAY_SECONDS - elapsed_seconds))
	var reached_time_limit: bool = _update_time(delta)
	_update_active_power(active_time_delta)
	_update_needs(active_time_delta)
	update_accumulator += delta

	if update_accumulator >= 0.2:
		update_accumulator = 0.0
		changed.emit()

	if reached_time_limit:
		changed.emit()
		day_time_limit_reached.emit()


func set_powered_devices(device_keys: Array[String]) -> void:
	_reset_powerstrip_connection_state()
	for raw_key in device_keys:
		var key: String = str(raw_key)
		if get_day1_device_definition(key) == null:
			continue

		var slot_count: int = int(powerstrip_device_slot_counts.get(key, 1))
		var start_slot: int = _find_available_powerstrip_slot(slot_count)
		if start_slot < 0:
			continue

		_place_powerstrip_device(key, start_slot, slot_count)

	_refresh_powered_devices_from_powerstrip_state()
	_recalculate_outlet_state()
	changed.emit()


func set_clock_paused_by_modal(is_paused: bool) -> void:
	is_clock_paused_by_modal = is_paused


func debug_shift_game_hours(game_hours: float) -> void:
	if day1_day_ended or is_time_paused or is_zero_approx(game_hours):
		return

	# 앞으로 이동할 때는 같은 시간 동안의 전력 소비와 상태 변화도 함께 적용한다.
	var real_seconds_delta: float = game_hours / GAME_HOURS_PER_REAL_SECOND
	if real_seconds_delta > 0.0:
		var active_time_delta: float = minf(real_seconds_delta, maxf(0.0, DAY_SECONDS - elapsed_seconds))
		var reached_time_limit: bool = _update_time(real_seconds_delta)
		_update_active_power(active_time_delta)
		_update_needs(active_time_delta)
		changed.emit()
		if reached_time_limit:
			day_time_limit_reached.emit()
		return

	elapsed_seconds = clampf(elapsed_seconds + real_seconds_delta, 0.0, DAY_SECONDS)
	remaining_phase_seconds = maxi(0, int(ceil(DAY_SECONDS - elapsed_seconds)))
	if elapsed_seconds < DAY_SECONDS:
		day_time_limit_announced = false
	changed.emit()


func debug_adjust_phone_battery(amount: float) -> void:
	_set_battery(battery + amount)
	changed.emit()


func debug_adjust_current_power(amount: float) -> void:
	_set_debug_current_power(current_power_units + amount)


func debug_restore_current_power() -> void:
	_set_debug_current_power(float(max_power))


func debug_set_time_before_limit(minutes_before_limit: int = 10) -> void:
	if day1_day_ended or is_time_paused:
		return

	# 상태를 대량 시뮬레이션하지 않고 시계만 02:00 직전으로 옮긴다.
	var target_minutes: int = maxi(DAY_START_MINUTES, DAY_END_MINUTES - minutes_before_limit)
	var progress: float = float(target_minutes - DAY_START_MINUTES) / float(DAY_END_MINUTES - DAY_START_MINUTES)
	elapsed_seconds = clampf(progress * DAY_SECONDS, 0.0, DAY_SECONDS)
	remaining_phase_seconds = maxi(0, int(ceil(DAY_SECONDS - elapsed_seconds)))
	day_time_limit_announced = false
	changed.emit()


func debug_set_phone_battery(next_battery: float) -> void:
	# 임계값 바로 위에 배치한 뒤 기존 감소 경로로 crossing 경고를 시험한다.
	battery = clampf(next_battery, MIN_STAT, MAX_STAT)
	changed.emit()


func debug_set_current_power(next_power: float) -> void:
	# 0.5 전력 테스트는 작동 중 장치를 강제로 끄지 않는다.
	current_power_units = clampf(next_power, 0.0, float(max_power))
	current_power = ceili(current_power_units)
	changed.emit()


func debug_deactivate_all_devices() -> void:
	active_day1_actions.clear()
	changed.emit()


func debug_disconnect_all_devices() -> void:
	# 연결 해제는 기존 상태 갱신 경로를 사용해 부하, 슬롯, 전선을 함께 동기화한다.
	set_powered_devices([])


func _set_debug_current_power(next_power: float) -> void:
	var previous_power: float = current_power_units
	current_power_units = clampf(next_power, 0.0, float(max_power))
	current_power = ceili(current_power_units)
	if previous_power > 0.0 and current_power_units <= 0.0:
		active_day1_actions.clear()
		last_day1_message = "오늘 남은 전력이 바닥났다. 켜진 기기가 모두 꺼졌다."
		day1_power_warning.emit(last_day1_message)
	changed.emit()


func set_powerstrip_slot_occupancy(slot_occupancy: Array) -> void:
	_reset_powerstrip_connection_state()
	var slot_limit: int = mini(slot_occupancy.size(), DAY1_MAX_OUTLET_SLOTS)
	for slot in range(slot_limit):
		var raw_key: Variant = slot_occupancy[slot]
		if raw_key == null:
			continue

		var key: String = str(raw_key)
		if get_day1_device_definition(key) == null:
			continue

		powerstrip_slot_occupancy[slot] = key

	_refresh_powerstrip_device_state_from_slots()
	_refresh_powered_devices_from_powerstrip_state()
	_recalculate_outlet_state()
	changed.emit()


func get_powerstrip_connection_state() -> Dictionary:
	_ensure_powerstrip_connection_state()
	return {
		"slots": powerstrip_slot_occupancy.duplicate(),
		"device_slots": powerstrip_device_slots.duplicate(true),
		"device_connected": powerstrip_device_connected.duplicate(),
		"device_slot_counts": powerstrip_device_slot_counts.duplicate(),
	}


func record_overload() -> void:
	overloads_today += 1
	changed.emit()


func continue_to_next_day() -> void:
	day += 1
	elapsed_seconds = 0.0
	phase = "day"
	remaining_phase_seconds = int(DAY_SECONDS)
	overloads_today = 0
	_reset_day1_power_loop()
	is_time_paused = false
	is_clock_paused_by_modal = false
	changed.emit()


func get_phase_label() -> String:
	return get_current_time_period()


func get_time_text() -> String:
	return "DAY %d - %s / %s" % [day, get_current_clock_text(), get_current_time_period()]


func get_current_clock_text() -> String:
	var current_minutes: int = _get_current_day_minutes()
	return "%02d:%02d" % [(current_minutes / 60) % 24, current_minutes % 60]


func get_current_time_period() -> String:
	var current_minutes: int = _get_current_day_minutes()
	if current_minutes < 12 * 60:
		return "아침"
	if current_minutes < 17 * 60:
		return "낮"
	if current_minutes < 21 * 60:
		return "저녁"
	if current_minutes < 24 * 60:
		return "밤"
	return "새벽"


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
	return "오늘 남은 전력\n⚡ %.1f / %d  %s\n현재 소비: -%.1f / h\n\n사용한 기기\n%s" % [
		current_power_units,
		max_power,
		_get_power_bar_text(),
		get_active_power_drain_per_game_hour(),
		get_used_day1_action_summary(),
	]


func get_phone_text() -> String:
	if battery <= MIN_STAT:
		return "배터리가 없습니다.\n충전이 필요합니다."

	var lines: Array[String] = [
		"현재 시간: %s" % get_current_clock_text(),
		"시간대: %s" % get_current_time_period(),
		"",
		"배터리: %d%%" % roundi(battery),
		"",
		"오늘 남은 전력: %.1f / %d" % [current_power_units, max_power],
		"현재 소비: -%.1f / h" % get_active_power_drain_per_game_hour(),
		"작동 중: %s" % get_active_day1_action_summary(),
	]

	return "\n".join(lines)


func _get_power_bar_text() -> String:
	var blocks := PackedStringArray()
	for index in range(max_power):
		blocks.append("■" if index < current_power else "□")

	return "".join(blocks)


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
	return get_day1_device_data(action_key)


static func get_day1_device_definition(action_key: String) -> DeviceDefinition:
	return DAY1_DEVICE_DEFINITIONS.get(action_key) as DeviceDefinition


static func get_day1_device_data(action_key: String) -> Dictionary:
	var definition: DeviceDefinition = get_day1_device_definition(action_key)
	return {} if definition == null else definition.to_action_data()


func is_day1_action_connected(action_key: String) -> bool:
	var action_data := get_day1_action_data(action_key)
	if action_data.is_empty():
		return false

	if not bool(action_data.get("requires_connection", false)):
		return true

	var power_key: String = str(action_data.get("power_key", action_key))
	return powered_devices.has(power_key)


func is_day1_action_active(action_key: String) -> bool:
	return active_day1_actions.has(action_key)


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


func get_active_day1_action_summary() -> String:
	if active_day1_actions.is_empty():
		return "없음"

	var labels: Array[String] = []
	for action_key in active_day1_actions:
		var action_data := get_day1_action_data(action_key)
		labels.append(str(action_data.get("label", action_key)))

	return ", ".join(labels)


func get_active_power_drain_per_game_hour() -> float:
	var drain_rate: float = 0.0
	for action_key in active_day1_actions:
		var action_data := get_day1_action_data(action_key)
		drain_rate += float(action_data.get("drain_per_game_hour", 0.0))
	return drain_rate


func toggle_day1_action_active(action_key: String) -> Dictionary:
	var action_data := get_day1_action_data(action_key)
	if action_data.is_empty():
		return {
			"success": false,
			"message": "아직 사용할 수 없는 오브젝트입니다.",
		}

	var label: String = str(action_data.get("label", action_key))
	if is_day1_action_active(action_key):
		active_day1_actions.erase(action_key)
		last_day1_message = "%s을 껐다. 전력 소비가 멈췄다." % label
		changed.emit()
		return {
			"success": true,
			"active": false,
			"message": last_day1_message,
			"remaining_power": current_power,
		}

	if not is_day1_action_connected(action_key):
		return {
			"success": false,
			"message": "전원이 연결되어 있지 않다.\n먼저 멀티탭에서 이 기기를 연결해야 한다.",
		}

	if current_power_units <= 0.0:
		return {
			"success": false,
			"message": "오늘 남은 전력이 부족하다.",
		}

	active_day1_actions.append(action_key)
	var flag_key: String = str(action_data.get("flag", action_key))
	if not used_day1_actions.has(action_key):
		used_day1_actions.append(action_key)
		day1_flags[flag_key] = true
		_apply_day1_action_effect(action_key)

	last_day1_message = "%s을 켰다. 켜져 있는 동안 전력이 계속 줄어든다." % label
	changed.emit()

	return {
		"success": true,
		"active": true,
		"message": "%s\n\n오늘 남은 전력: %.1f / %d" % [
			last_day1_message,
			current_power_units,
			max_power,
		],
		"remaining_power": current_power,
		"flag": flag_key,
	}


func _update_needs(delta: float) -> void:
	var has_phone_charger: bool = active_day1_actions.has("charger")
	var has_fan: bool = active_day1_actions.has("fan")
	var has_laptop: bool = active_day1_actions.has("laptop")
	var has_microwave: bool = active_day1_actions.has("microwave")

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

	_set_battery(battery + battery_delta * delta)
	temperature = clampf(temperature + temperature_delta * delta, MIN_STAT, MAX_STAT)
	fatigue = clampf(fatigue + fatigue_delta * delta, MIN_STAT, MAX_STAT)
	fun = clampf(fun + fun_delta * delta, MIN_STAT, MAX_STAT)


func _update_time(delta: float) -> bool:
	var previous_elapsed_seconds: float = elapsed_seconds
	elapsed_seconds = minf(elapsed_seconds + delta, DAY_SECONDS)
	phase = "day"
	remaining_phase_seconds = maxi(0, int(ceil(DAY_SECONDS - elapsed_seconds)))

	if previous_elapsed_seconds < DAY_SECONDS and elapsed_seconds >= DAY_SECONDS and not day_time_limit_announced:
		day_time_limit_announced = true
		return true
	return false


func _update_active_power(delta: float) -> void:
	if delta <= 0.0 or active_day1_actions.is_empty() or current_power_units <= 0.0:
		return

	var elapsed_game_hours: float = delta * GAME_HOURS_PER_REAL_SECOND
	var consumed_power: float = get_active_power_drain_per_game_hour() * elapsed_game_hours
	current_power_units = maxf(0.0, current_power_units - consumed_power)
	current_power = ceili(current_power_units)
	if current_power_units > 0.0:
		return

	active_day1_actions.clear()
	last_day1_message = "오늘 남은 전력이 바닥났다. 켜진 기기가 모두 꺼졌다."
	changed.emit()
	day1_power_warning.emit(last_day1_message)


func _get_current_day_minutes() -> int:
	var day_progress: float = clampf(elapsed_seconds / DAY_SECONDS, 0.0, 1.0)
	var playable_minutes: int = DAY_END_MINUTES - DAY_START_MINUTES
	return DAY_START_MINUTES + int(floor(day_progress * float(playable_minutes)))


func _end_day() -> void:
	is_time_paused = true
	phase = "day"
	remaining_phase_seconds = 0
	day1_day_ended = true

	var result: Dictionary = _calculate_day_result()
	total_points += int(result.get("total", 0))
	changed.emit()
	day_ended.emit(result)


func _calculate_day_result() -> Dictionary:
	var lines: Array[String] = []
	var total: int = 0

	lines.append("오늘 남은 전력: %.1f / %d" % [current_power_units, max_power])
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
		"remaining_power": current_power,
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
			_set_battery(battery + 12.0)
		"communication_device":
			fun = clampf(fun + 3.0, MIN_STAT, MAX_STAT)


func _ensure_powerstrip_connection_state() -> void:
	if powerstrip_slot_occupancy.size() != DAY1_MAX_OUTLET_SLOTS:
		_reset_powerstrip_connection_state()


func _reset_powerstrip_connection_state() -> void:
	powerstrip_slot_occupancy.clear()
	for _slot in range(DAY1_MAX_OUTLET_SLOTS):
		powerstrip_slot_occupancy.append(null)

	powerstrip_device_slots.clear()
	powerstrip_device_connected.clear()
	powerstrip_device_slot_counts.clear()
	for key in POWERSTRIP_DEVICE_ORDER:
		var definition: DeviceDefinition = get_day1_device_definition(key)
		var slot_count: int = 1 if definition == null else definition.outlet_slots
		powerstrip_device_slots[key] = []
		powerstrip_device_connected[key] = false
		powerstrip_device_slot_counts[key] = slot_count


func _place_powerstrip_device(key: String, start_slot: int, slot_count: int) -> void:
	var placed_slots: Array = []
	for slot in range(start_slot, start_slot + slot_count):
		powerstrip_slot_occupancy[slot] = key
		placed_slots.append(slot)

	powerstrip_device_slots[key] = placed_slots
	powerstrip_device_connected[key] = true


func _refresh_powerstrip_device_state_from_slots() -> void:
	for key in POWERSTRIP_DEVICE_ORDER:
		var definition: DeviceDefinition = get_day1_device_definition(key)
		powerstrip_device_slots[key] = []
		powerstrip_device_connected[key] = false
		powerstrip_device_slot_counts[key] = 1 if definition == null else definition.outlet_slots

	for slot in range(powerstrip_slot_occupancy.size()):
		var raw_key: Variant = powerstrip_slot_occupancy[slot]
		if raw_key == null:
			continue

		var key: String = str(raw_key)
		if get_day1_device_definition(key) == null:
			continue

		var slots_for_device: Array = powerstrip_device_slots.get(key, [])
		slots_for_device.append(slot)
		powerstrip_device_slots[key] = slots_for_device
		powerstrip_device_connected[key] = true


func _refresh_powered_devices_from_powerstrip_state() -> void:
	powered_devices.clear()
	for key in POWERSTRIP_DEVICE_ORDER:
		if bool(powerstrip_device_connected.get(key, false)):
			powered_devices.append(key)
	_deactivate_disconnected_day1_actions()


func _deactivate_disconnected_day1_actions() -> void:
	for action_key in active_day1_actions.duplicate():
		if not is_day1_action_connected(action_key):
			active_day1_actions.erase(action_key)


func _find_available_powerstrip_slot(slot_count: int) -> int:
	var last_start: int = DAY1_MAX_OUTLET_SLOTS - slot_count
	for start_slot in range(last_start + 1):
		var is_available: bool = true
		for slot in range(start_slot, start_slot + slot_count):
			if powerstrip_slot_occupancy[slot] != null:
				is_available = false
				break

		if is_available:
			return start_slot

	return -1


func _reset_day1_power_loop() -> void:
	current_power_units = float(DAY1_STARTING_POWER_UNITS)
	current_power = DAY1_STARTING_POWER_UNITS
	used_day1_actions.clear()
	active_day1_actions.clear()
	day1_flags.clear()
	day1_day_ended = false
	day_time_limit_announced = false
	last_day1_message = ""
	_recalculate_outlet_state()


func _set_battery(next_battery: float) -> void:
	var previous_battery: float = battery
	battery = clampf(next_battery, MIN_STAT, MAX_STAT)
	if battery >= previous_battery:
		return
	# Charging suppresses low-battery warnings even if another effect causes a net decrease.
	if active_day1_actions.has("charger"):
		return

	# A threshold warns on each downward crossing; charging above it naturally rearms it.
	for threshold in PHONE_BATTERY_WARNING_THRESHOLDS:
		if previous_battery > threshold and battery <= threshold:
			phone_battery_warning.emit(str(PHONE_BATTERY_WARNING_MESSAGES.get(threshold, "")))


func _recalculate_outlet_state() -> void:
	current_load_watts = 0
	used_outlet_slots = 0

	# The outlet panel owns connection gestures, but SurvivalState is the source
	# of truth for what those connections mean to the DAY 1 power loop.
	for action_key in DAY1_DEVICE_DEFINITIONS.keys():
		var action_data: Dictionary = get_day1_action_data(action_key)
		if not bool(action_data.get("requires_connection", false)):
			continue

		var power_key: String = str(action_data.get("power_key", action_key))
		if not powered_devices.has(power_key):
			continue

		current_load_watts += int(action_data.get("watt_usage", 0))
		used_outlet_slots += int(action_data.get("outlet_size", 0))

	current_power_watts = current_load_watts
