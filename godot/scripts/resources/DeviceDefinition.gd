extends Resource
class_name DeviceDefinition

@export_category("식별")
@export var device_key: String = ""
@export var display_name: String = ""
@export var result_flag: String = ""

@export_category("전력")
@export var load_watts: int = 0
@export var outlet_slots: int = 1
@export var drain_per_game_hour: float = 0.0
@export var requires_connection: bool = true


func to_action_data() -> Dictionary:
	# 기존 상호작용 코드의 키 형식을 유지하면서 실제 값은 Resource가 소유한다.
	return {
		"label": display_name,
		"drain_per_game_hour": drain_per_game_hour,
		"watt_usage": load_watts,
		"outlet_size": outlet_slots,
		"requires_connection": requires_connection,
		"flag": result_flag,
		"power_key": device_key,
	}
