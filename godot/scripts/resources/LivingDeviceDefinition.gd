extends Resource
class_name LivingDeviceDefinition

const TYPE_CONTINUOUS := "continuous"
const TYPE_INSTANT := "instant"
const TYPE_STORAGE := "storage"
const TYPE_ENVIRONMENT := "environment"
const TYPE_BACKGROUND_FIXTURE := "background_fixture"
const TYPE_SUPPORT := "support"

const POWER_CONTINUOUS := "continuous"
const POWER_INSTANT := "instant"
const POWER_DEDICATED_CIRCUIT := "dedicated_circuit"
const POWER_PASSIVE := "passive"
const POWER_STORAGE := "storage"
const POWER_NONE := "none"

const EFFECT_COMFORT := "comfort"
const EFFECT_FATIGUE := "fatigue"
const EFFECT_FOCUS := "focus"
const EFFECT_FOOD_PRESERVATION := "food_preservation"

@export_category("식별")
@export var device_key: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

@export_category("Room 연결 후보")
@export var room_object_key: String = ""
@export var device_type: String = TYPE_CONTINUOUS
@export var power_model: String = POWER_CONTINUOUS

@export_category("전력 모델 후보")
@export var required_power_device_key: String = ""
@export var uses_outlet_slot: bool = false
@export var uses_dedicated_circuit: bool = false
@export var drain_per_game_hour: float = 0.0
@export var instant_power_cost: float = 0.0
@export var use_duration_game_minutes: float = 0.0

@export_category("생활 효과 후보")
@export var comfort_delta: float = 0.0
@export var fatigue_delta: float = 0.0
@export var focus_delta: float = 0.0
@export var food_preservation_delta: float = 0.0

@export_category("상태 후보")
@export var can_be_toggled: bool = true
@export var can_fail: bool = false
@export var requires_maintenance: bool = false

@export_category("Result 후보")
@export var result_flag_key: String = ""
@export_multiline var active_result_text: String = ""
@export_multiline var inactive_result_text: String = ""


func is_valid_definition() -> bool:
	if device_key.is_empty() or display_name.is_empty() or room_object_key.is_empty():
		return false
	if device_type.is_empty() or power_model.is_empty():
		return false
	if is_continuous() and drain_per_game_hour < 0.0:
		return false
	if is_instant() and instant_power_cost < 0.0:
		return false
	if power_model == POWER_DEDICATED_CIRCUIT and not uses_dedicated_circuit:
		return false

	return true


func get_debug_summary() -> String:
	return "%s / room=%s / type=%s / power=%s / drain=%.2f / instant=%.2f" % [
		device_key,
		room_object_key,
		device_type,
		power_model,
		drain_per_game_hour,
		instant_power_cost,
	]


func is_continuous() -> bool:
	return device_type == TYPE_CONTINUOUS or power_model == POWER_CONTINUOUS


func is_instant() -> bool:
	return device_type == TYPE_INSTANT or power_model == POWER_INSTANT


func is_storage() -> bool:
	return device_type == TYPE_STORAGE or power_model == POWER_STORAGE


func is_background_fixture() -> bool:
	return device_type == TYPE_BACKGROUND_FIXTURE


func uses_direct_outlet() -> bool:
	return uses_outlet_slot


func uses_room_circuit() -> bool:
	return uses_dedicated_circuit or power_model == POWER_DEDICATED_CIRCUIT


func get_power_cost_for_use() -> float:
	return instant_power_cost


func get_drain_per_game_hour() -> float:
	return drain_per_game_hour


func get_effect_summary() -> Dictionary:
	return {
		EFFECT_COMFORT: comfort_delta,
		EFFECT_FATIGUE: fatigue_delta,
		EFFECT_FOCUS: focus_delta,
		EFFECT_FOOD_PRESERVATION: food_preservation_delta,
	}


func get_result_text(active: bool) -> String:
	if active:
		if active_result_text.is_empty():
			return "Device was active."
		return active_result_text

	if inactive_result_text.is_empty():
		return "Device was inactive."
	return inactive_result_text
