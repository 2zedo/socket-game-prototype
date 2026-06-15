extends RefCounted
class_name AssetPaths

const YUI_PORTRAIT_NEUTRAL := preload("res://assets/art/portraits/yui/yui_portrait_neutral.png")
const APARTMENT_MAP_REFERENCE := preload("res://assets/art/maps/apartment/apartment_map_reference.png")
const YUI_PLAYER_IDLE_BACK := preload("res://assets/art/characters/yui/yui_player_idle_back.png")
const YUI_WALK_4DIR_RGBA := preload("res://assets/art/characters/yui/yui_walk_4dir_rgba.png")
const YUI_IDLE_DOWN_PATH := "res://assets/art/characters/yui/idle/yui_idle_down.png"
const YUI_IDLE_UP_PATH := "res://assets/art/characters/yui/idle/yui_idle_up.png"
const YUI_IDLE_LEFT_PATH := "res://assets/art/characters/yui/idle/yui_idle_left.png"
const YUI_IDLE_RIGHT_PATH := "res://assets/art/characters/yui/idle/yui_idle_right.png"
const YUI_WALK_DOWN_01_PATH := "res://assets/art/characters/yui/walk/yui_walk_down_01.png"
const YUI_WALK_DOWN_02_PATH := "res://assets/art/characters/yui/walk/yui_walk_down_02.png"
const YUI_WALK_UP_01_PATH := "res://assets/art/characters/yui/walk/yui_walk_up_01.png"
const YUI_WALK_UP_02_PATH := "res://assets/art/characters/yui/walk/yui_walk_up_02.png"
const YUI_WALK_LEFT_01_PATH := "res://assets/art/characters/yui/walk/yui_walk_left_01.png"
const YUI_WALK_LEFT_02_PATH := "res://assets/art/characters/yui/walk/yui_walk_left_02.png"
const YUI_WALK_RIGHT_01_PATH := "res://assets/art/characters/yui/walk/yui_walk_right_01.png"
const YUI_WALK_RIGHT_02_PATH := "res://assets/art/characters/yui/walk/yui_walk_right_02.png"

const ROOM_FLOOR_BASE := preload("res://assets/art/environment/room/room_floor_base.png")
const ROOM_WALL_BASE := preload("res://assets/art/environment/room/room_wall_base.png")

const FLUORESCENT_LIGHT_OFF := preload("res://assets/art/objects/light/fluorescent_light_off.png")
const FLUORESCENT_LIGHT_ON := preload("res://assets/art/objects/light/fluorescent_light_on.png")
const FLUORESCENT_GLOW := preload("res://assets/art/overlays/lighting/fluorescent_glow.png")

const LAPTOP_OFF := preload("res://assets/art/objects/laptop/laptop_off.png")
const LAPTOP_ON := preload("res://assets/art/objects/laptop/laptop_on.png")
const FAN_OFF := preload("res://assets/art/objects/fan/fan_off.png")
const FAN_ON := preload("res://assets/art/objects/fan/fan_on.png")
const PHONE_NORMAL := preload("res://assets/art/objects/phone/phone_normal.png")
const PHONE_RECHARGE := preload("res://assets/art/objects/phone/phone_recharge.png")
const PHONE_CHARGING := preload("res://assets/art/objects/phone/phone_charging.png")
const PHONE_CHARGED := preload("res://assets/art/objects/phone/phone_charged.png")
const COMM_DEVICE_OFF := preload("res://assets/art/objects/comm_device/comm_device_off.png")
const COMM_DEVICE_ON := preload("res://assets/art/objects/comm_device/comm_device_on.png")
const POWERSTRIP_EMPTY := preload("res://assets/art/objects/powerstrip/powerstrip_empty.png")
const POWERSTRIP_CONNECTED := preload("res://assets/art/objects/powerstrip/powerstrip_connected.png")

const OUTLET_SLOT_EMPTY := preload("res://assets/art/objects/outlet/outlet_slot_empty.png")
const OUTLET_SLOT_ACTIVE := preload("res://assets/art/objects/outlet/outlet_slot_active.png")
const PLUG_1_SLOT := preload("res://assets/art/objects/outlet/plug_1slot.png")
const PLUG_2_SLOT := preload("res://assets/art/objects/outlet/plug_2slot.png")

const UI_PANEL_DIALOGUE := preload("res://assets/art/ui/panels/ui_panel_dialogue.png")
const UI_PANEL_INTERACTION := preload("res://assets/art/ui/panels/ui_panel_interaction.png")
const ICON_POWER := preload("res://assets/art/ui/icons/icon_power.png")
const ICON_PLUG := preload("res://assets/art/ui/icons/icon_plug.png")
const BADGE_CONNECTED := preload("res://assets/art/ui/badges/badge_connected.png")
const BADGE_DISCONNECTED := preload("res://assets/art/ui/badges/badge_disconnected.png")


static func load_texture_or_fallback(path: String, fallback: Texture2D) -> Texture2D:
	if ResourceLoader.exists(path):
		var texture: Texture2D = load(path) as Texture2D
		if texture != null:
			return texture

	return fallback
