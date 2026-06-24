extends Resource
class_name HackingMissionDefinition

const TYPE_DATA_EXTRACT := "data_extract"
const TYPE_SIGNAL_TRACE := "signal_trace"
const TYPE_FIREWALL_BYPASS := "firewall_bypass"
const TYPE_SURVEILLANCE_DISABLE := "surveillance_disable"
const TYPE_ARCHIVE_RESTORE := "archive_restore"
const TYPE_FALSE_SIGNAL := "false_signal"

const OBJECTIVE_EXTRACT_DATA := "extract_data"
const OBJECTIVE_REACH_EXIT := "reach_exit"
const OBJECTIVE_DISABLE_NODE := "disable_node"
const OBJECTIVE_SURVIVE_TIMER := "survive_timer"
const OBJECTIVE_TRACE_SIGNAL := "trace_signal"

const DIFFICULTY_MIN := 1
const DIFFICULTY_MAX := 5

@export_category("식별")
@export var mission_key: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

@export_category("미션")
@export var mission_type: String = TYPE_DATA_EXTRACT
@export var difficulty: int = DIFFICULTY_MIN
@export var map_scene_path: String = ""
@export var objective_type: String = OBJECTIVE_EXTRACT_DATA

@export_category("장치 조건")
@export var required_device_keys: Array[String] = []
@export var recommended_device_keys: Array[String] = []

@export_category("스토리 플래그 후보")
@export var unlock_story_flags: Array[String] = []
@export var success_story_flags: Array[String] = []
@export var failure_story_flags: Array[String] = []

@export_category("보상 후보")
@export var reward_grid_credit: int = 0
@export var reward_power_bonus: float = 0.0
@export var reward_info_keys: Array[String] = []

@export_category("위험 / 제한")
@export var trace_risk: int = 0
@export var time_limit_seconds: float = 0.0

@export_category("결과 문구 후보")
@export_multiline var success_result_text: String = ""
@export_multiline var failure_result_text: String = ""


func is_valid_definition() -> bool:
	return (
		not mission_key.is_empty()
		and not display_name.is_empty()
		and not mission_type.is_empty()
		and not objective_type.is_empty()
		and difficulty >= DIFFICULTY_MIN
		and difficulty <= DIFFICULTY_MAX
	)


func get_debug_summary() -> String:
	return "%s / type=%s / objective=%s / difficulty=%d / map=%s" % [
		mission_key,
		mission_type,
		objective_type,
		difficulty,
		map_scene_path,
	]


func get_difficulty_label() -> String:
	match difficulty:
		1:
			return "Easy"
		2:
			return "Normal"
		3:
			return "Risky"
		4:
			return "Hard"
		5:
			return "Critical"

	return "Unknown"


func requires_device(device_key: String) -> bool:
	return required_device_keys.has(device_key)


func recommends_device(device_key: String) -> bool:
	return recommended_device_keys.has(device_key)


func has_any_required_devices() -> bool:
	return not required_device_keys.is_empty()


func get_result_text(success: bool) -> String:
	if success:
		if success_result_text.is_empty():
			return "Mission completed."
		return success_result_text

	if failure_result_text.is_empty():
		return "Mission failed."
	return failure_result_text
