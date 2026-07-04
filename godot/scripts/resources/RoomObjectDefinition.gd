extends Resource
class_name RoomObjectDefinition

const ZONE_ENTRANCE := "entrance"
const ZONE_LIVING := "living"
const ZONE_WORK := "work"
const ZONE_KITCHEN := "kitchen"
const ZONE_POWER := "power"
const ZONE_UTILITY := "utility"
const ZONE_BACKGROUND := "background"

const ROLE_MANUAL_END_DAY := "manual_end_day"
const ROLE_LAPTOP_JOB := "laptop_job"
const ROLE_PHONE_STATUS := "phone_status"
const ROLE_PHONE_CHARGE := "phone_charge"
const ROLE_POWER_MANAGEMENT := "power_management"
const ROLE_COMMUNICATION := "communication"
const ROLE_MYSTERY_DEVICE := "mystery_device"
const ROLE_AUDIO_HACKING_DEVICE := "audio_hacking_device"
const ROLE_LIVING_APPLIANCE := "living_appliance"
const ROLE_SUPPORT_DEVICE := "support_device"
const ROLE_BACKGROUND_LIFE_HINT := "background_life_hint"
const ROLE_BACKGROUND_STRUCTURE := "background_structure"

const STATE_IDLE := "idle"
const STATE_OFF := "off"
const STATE_ON := "on"
const STATE_ACTIVE := "active"
const STATE_CHARGING := "charging"
const STATE_SIGNAL := "signal"
const STATE_DISABLED := "disabled"

@export_category("식별")
@export var key: String = ""
@export var display_name: String = ""
@export var zone: String = ""
@export var role: String = ""
@export var future_source: String = ""
@export var visual_state: String = STATE_IDLE

@export_category("배치")
@export var layer: String = "ObjectLayer"
@export var position: Vector2 = Vector2.ZERO
@export var size: Vector2 = Vector2(64, 64)
@export var sort_y: int = 0

@export_category("Blockout 표시")
@export var color: Color = Color(0.35, 0.35, 0.35, 1.0)
@export var thickness: float = 10.0

@export_category("상호작용")
@export var blocks: bool = true
@export var interactable: bool = true
@export var room_interaction_enabled: bool = true
@export var is_portable: bool = false
@export var interaction_position: Vector2 = Vector2.ZERO
@export var interaction_radius: float = 96.0
@export var collision_size: Vector2 = Vector2.ZERO
@export var blocker_rect: Rect2 = Rect2()

@export_category("UI")
@export var primary_action_label: String = ""
@export var inspect_action_label: String = "Inspect"

@export_category("Hover")
@export var hover_label: String = ""
@export var hover_priority: int = 0
@export var base_visual_texture: Texture2D
@export var hover_overlay_texture: Texture2D
@export var hover_overlay_offset: Vector2 = Vector2.ZERO
@export var hover_overlay_scale: Vector2 = Vector2.ONE
@export var hover_overlay_z_index: int = 0
@export var hover_visual_mode: String = "fallback_outline"


func get_collision_size() -> Vector2:
	if collision_size == Vector2.ZERO:
		return size
	return collision_size


func get_interaction_position() -> Vector2:
	if interaction_position == Vector2.ZERO:
		return position
	return interaction_position


func has_blocker_rect() -> bool:
	return blocker_rect.size != Vector2.ZERO


func is_valid_definition() -> bool:
	return not key.is_empty() and not display_name.is_empty() and not zone.is_empty() and not role.is_empty()


func allows_room_interaction() -> bool:
	return interactable and room_interaction_enabled


func get_debug_summary() -> String:
	return "%s / zone=%s / role=%s / future=%s / state=%s / room=%s / portable=%s" % [
		key,
		zone,
		role,
		future_source,
		visual_state,
		str(room_interaction_enabled),
		str(is_portable),
	]


func get_primary_label() -> String:
	if not primary_action_label.is_empty():
		return primary_action_label

	match role:
		ROLE_MANUAL_END_DAY:
			return "Rest / End Day"
		ROLE_LAPTOP_JOB:
			return "Open Work"
		ROLE_POWER_MANAGEMENT:
			return "Open Power"
		ROLE_COMMUNICATION:
			return "Check Signal"
		ROLE_MYSTERY_DEVICE:
			return "Inspect NODE"
		ROLE_PHONE_STATUS:
			return "Open Phone"
		ROLE_PHONE_CHARGE:
			return "Check Charge"
		ROLE_AUDIO_HACKING_DEVICE:
			return "Check Audio"
		ROLE_LIVING_APPLIANCE:
			return "Inspect Appliance"
		ROLE_SUPPORT_DEVICE:
			return "Inspect Device"
		ROLE_BACKGROUND_STRUCTURE, ROLE_BACKGROUND_LIFE_HINT:
			return "Inspect"

	return "Interact"
