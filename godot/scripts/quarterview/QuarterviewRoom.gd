extends Node2D

signal interaction_requested(object_key: String, action_key: String, payload: Dictionary)
signal nearest_interactable_changed(object_key: String, display_name: String)
signal hover_interactable_changed(object_key: String, display_name: String, payload: Dictionary)
signal debug_overlay_toggled(enabled: bool)
signal movement_path_failed(reason: String)

const ACTION_PRIMARY := "primary"
const ACTION_FOCUS := "focus"
const TEMP_BACKGROUND_PATH := "res://assets/art/quarterview/room/temp_qv_room_background.png"
const REFERENCE_BACKGROUND_PATH := "res://assets/art/quarterview/reference/qv_room_concept_reference.png"
const BACKGROUND_TARGET_SIZE := Vector2(1280, 720)
const REFERENCE_OVERLAY_ALPHA := 0.38

# Candidate click/path tuning. Adjust these first when GUI feedback says the
# player sticks to furniture, takes too wide a route, or arrives too early/late.
const WALK_TARGET_BOUNDS := Rect2(Vector2(190, 190), Vector2(900, 438))
const CLICK_OBJECT_PADDING := 28.0
const CLICK_TARGET_CLAMP_MARGIN := 8.0
const PATH_GRID_CELL_SIZE := 24.0
const PATH_BLOCKER_PADDING := 24.0
const PATH_TARGET_REACHED_DISTANCE := 10.0
const OBJECT_APPROACH_INTERACTION_MARGIN := 8.0
const PLAYER_COLLISION_DEBUG_RADIUS := 16.0

# Debug display tuning. Blockout layers stay hidden by default so D toggles only
# measurement overlays and cannot visually shift the room/background.
const DEBUG_SHOW_BLOCKOUT_LAYERS := false
const DEBUG_BLOCKER_LINE_WIDTH := 2.0
const DEBUG_INTERACTION_LINE_WIDTH := 2.0
const DEBUG_APPROACH_MARKER_HALF_SIZE := 6.0
const DEBUG_PATH_LINE_WIDTH := 3.0
const DEBUG_CLICK_TARGET_MARKER_HALF_SIZE := 9.0
const DEBUG_FAILURE_LABEL_POSITION := Vector2(24, 616)
const DEBUG_VISUAL_RECT_COLOR := Color(0.82, 0.82, 0.78, 0.34)
const DEBUG_CLICK_AREA_COLOR := Color(0.35, 0.62, 1.0, 0.62)
const DEBUG_FOOTPRINT_COLOR := Color(1.0, 0.42, 0.18, 0.72)
const HOVER_OUTLINE_COLOR := Color(0.98, 0.82, 0.30, 0.92)
const HOVER_FILL_COLOR := Color(0.98, 0.70, 0.22, 0.10)
const HOVER_PROMPT_OFFSET := Vector2(18, -38)
const HOVER_PROMPT_MARGIN := 18.0
const HOVER_PROMPT_CLAMP_SIZE := Vector2(220, 34)
const TUNING_TOGGLE_KEY := KEY_F3
const TUNING_PRINT_KEY := KEY_C

const INTERACTION_PRIORITY_DEFAULT := 50
const INTERACTION_PRIORITY_BY_KEY := {
	"desk": 10,
	"laptop": 10,
	"power": 10,
	"bed": 20,
	"door": 20,
	"fridge": 20,
	"microwave": 20,
	"comm": 30,
	"phone": 30,
	"speaker": 30,
	"ups": 30,
	"signal_booster": 30,
	"node17": 30,
	"aircon": 40,
	"bathroom_door": 80,
	"shelf": 90,
	"small_table": 90,
}
const CLICK_ONLY_INTERACTABLE_KEYS := ["desk", "door"]
const EXTERNAL_ENVIRONMENT_IDS_BY_LEGACY_KEY := {
	"door": "entrance_door",
	"bed": "bed",
	"fridge": "fridge",
	"microwave": "microwave",
	"comm": "navi_link",
	"power": "power_module_board",
	"node17": "node_17",
}

const OBJECT_RESOURCE_PATHS := [
	"res://resources/rooms/quarterview/objects/door.tres",
	"res://resources/rooms/quarterview/objects/bathroom_door.tres",
	"res://resources/rooms/quarterview/objects/bed.tres",
	"res://resources/rooms/quarterview/objects/desk.tres",
	"res://resources/rooms/quarterview/objects/laptop.tres",
	"res://resources/rooms/quarterview/objects/phone.tres",
	"res://resources/rooms/quarterview/objects/comm.tres",
	"res://resources/rooms/quarterview/objects/node17.tres",
	"res://resources/rooms/quarterview/objects/speaker.tres",
	"res://resources/rooms/quarterview/objects/signal_booster.tres",
	"res://resources/rooms/quarterview/objects/power.tres",
	"res://resources/rooms/quarterview/objects/ups.tres",
	"res://resources/rooms/quarterview/objects/fridge.tres",
	"res://resources/rooms/quarterview/objects/microwave.tres",
	"res://resources/rooms/quarterview/objects/aircon.tres",
	"res://resources/rooms/quarterview/objects/shelf.tres",
	"res://resources/rooms/quarterview/objects/small_table.tres",
]

const WALL_BLOCKERS := [
	{
		"name": "BackWallBlocker",
		"rect": Rect2(Vector2(244, 76), Vector2(774, 74)),
		"blocker_footprint": [Vector2(236, 146), Vector2(1026, 146), Vector2(1042, 184), Vector2(220, 184)],
	},
	{
		"name": "LeftWallBlocker",
		"rect": Rect2(Vector2(132, 170), Vector2(92, 400)),
		"blocker_footprint": [Vector2(142, 184), Vector2(226, 156), Vector2(236, 460), Vector2(170, 586), Vector2(112, 536)],
	},
	{
		"name": "RightWallBlocker",
		"rect": Rect2(Vector2(1082, 184), Vector2(66, 318)),
		"blocker_footprint": [Vector2(1018, 154), Vector2(1114, 184), Vector2(1154, 486), Vector2(1136, 514), Vector2(1084, 400)],
	},
	{
		"name": "FrontLipBlocker",
		"rect": Rect2(Vector2(392, 636), Vector2(592, 40)),
		"blocker_footprint": [Vector2(372, 642), Vector2(992, 622), Vector2(1014, 668), Vector2(354, 688)],
	},
]

# `blocker_footprint` is the candidate floor-contact polygon for debug/tuning.
# It only drives path/collision when `footprint_path_enabled` is explicitly true.
# This keeps guessed coordinates visible without treating them as final blockers.
const OBJECT_LAYOUT := {
	"door": {
		"position": Vector2(216, 412),
		"size": Vector2(76, 126),
		"thickness": 12.0,
		"layer": "WallSideLayer",
		"blocker_rect": Rect2(Vector2(166, 344), Vector2(70, 126)),
		"blocker_footprint": [Vector2(168, 438), Vector2(242, 454), Vector2(246, 562), Vector2(184, 572), Vector2(160, 508)],
		"interaction_position": Vector2(272, 482),
		"approach_position": Vector2(286, 522),
		"interaction_radius": 60.0,
		"color": Color(0.21, 0.19, 0.15, 1.0),
	},
	"bathroom_door": {
		"position": Vector2(328, 320),
		"size": Vector2(66, 118),
		"thickness": 10.0,
		"layer": "WallSideLayer",
		"blocker_rect": Rect2(Vector2(290, 256), Vector2(70, 122)),
		"blocker_footprint": [Vector2(292, 356), Vector2(366, 350), Vector2(382, 420), Vector2(298, 432)],
		"interaction_position": Vector2(382, 386),
		"approach_position": Vector2(390, 404),
		"interaction_radius": 56.0,
		"color": Color(0.30, 0.29, 0.25, 1.0),
	},
	"bed": {
		"position": Vector2(460, 348),
		"size": Vector2(254, 120),
		"thickness": 38.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(324, 290), Vector2(282, 132)),
		"blocker_footprint": [Vector2(324, 368), Vector2(602, 356), Vector2(626, 430), Vector2(354, 458)],
		"interaction_position": Vector2(548, 452),
		"approach_position": Vector2(560, 472),
		"interaction_radius": 94.0,
		"color": Color(0.23, 0.34, 0.25, 1.0),
	},
	"desk": {
		"position": Vector2(805, 338),
		"size": Vector2(276, 92),
		"thickness": 42.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(652, 292), Vector2(316, 112)),
		"blocker_footprint": [Vector2(654, 362), Vector2(972, 356), Vector2(956, 430), Vector2(684, 446)],
		"interaction_position": Vector2(790, 428),
		"approach_position": Vector2(788, 456),
		"interaction_radius": 96.0,
		"color": Color(0.35, 0.21, 0.11, 1.0),
	},
	"laptop": {
		"position": Vector2(792, 288),
		"size": Vector2(72, 40),
		"thickness": 10.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(790, 420),
		"approach_position": Vector2(788, 456),
		"interaction_radius": 94.0,
		"color": Color(0.05, 0.11, 0.15, 1.0),
	},
	"phone": {
		"position": Vector2(862, 332),
		"size": Vector2(44, 24),
		"thickness": 6.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(820, 425),
		"approach_position": Vector2(812, 456),
		"interaction_radius": 82.0,
		"color": Color(0.06, 0.18, 0.22, 1.0),
	},
	"comm": {
		"position": Vector2(900, 306),
		"size": Vector2(58, 42),
		"thickness": 18.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(858, 424),
		"approach_position": Vector2(840, 456),
		"interaction_radius": 88.0,
		"color": Color(0.12, 0.17, 0.17, 1.0),
	},
	"node17": {
		"position": Vector2(952, 344),
		"size": Vector2(54, 48),
		"thickness": 22.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(888, 430),
		"approach_position": Vector2(858, 462),
		"interaction_radius": 86.0,
		"color": Color(0.08, 0.09, 0.13, 1.0),
	},
	"speaker": {
		"position": Vector2(972, 296),
		"size": Vector2(34, 54),
		"thickness": 20.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(892, 424),
		"approach_position": Vector2(866, 456),
		"interaction_radius": 84.0,
		"color": Color(0.07, 0.08, 0.08, 1.0),
	},
	"signal_booster": {
		"position": Vector2(924, 382),
		"size": Vector2(44, 34),
		"thickness": 18.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(882, 432),
		"approach_position": Vector2(854, 466),
		"interaction_radius": 84.0,
		"color": Color(0.10, 0.15, 0.17, 1.0),
	},
	"power": {
		"position": Vector2(876, 552),
		"size": Vector2(144, 76),
		"thickness": 54.0,
		"layer": "ForegroundLayer",
		"blocker_rect": Rect2(Vector2(794, 502), Vector2(178, 112)),
		"blocker_footprint": [Vector2(794, 548), Vector2(972, 536), Vector2(1018, 606), Vector2(816, 632)],
		"interaction_position": Vector2(758, 540),
		"approach_position": Vector2(754, 548),
		"interaction_radius": 106.0,
		"color": Color(0.13, 0.15, 0.14, 1.0),
	},
	"ups": {
		"position": Vector2(1012, 542),
		"size": Vector2(86, 62),
		"thickness": 44.0,
		"layer": "ForegroundLayer",
		"blocker_rect": Rect2(Vector2(962, 500), Vector2(108, 92)),
		"blocker_footprint": [Vector2(962, 546), Vector2(1068, 538), Vector2(1088, 604), Vector2(976, 616)],
		"interaction_position": Vector2(934, 544),
		"approach_position": Vector2(932, 556),
		"interaction_radius": 82.0,
		"color": Color(0.11, 0.13, 0.15, 1.0),
	},
	"fridge": {
		"position": Vector2(1040, 340),
		"size": Vector2(86, 158),
		"thickness": 26.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(988, 254), Vector2(110, 178)),
		"blocker_footprint": [Vector2(988, 374), Vector2(1100, 368), Vector2(1110, 438), Vector2(996, 448)],
		"interaction_position": Vector2(958, 374),
		"approach_position": Vector2(952, 410),
		"interaction_radius": 94.0,
		"color": Color(0.42, 0.46, 0.45, 1.0),
	},
	"microwave": {
		"position": Vector2(1010, 244),
		"size": Vector2(92, 44),
		"thickness": 20.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(956, 222), Vector2(118, 58)),
		"blocker_footprint": [Vector2(946, 294), Vector2(1070, 290), Vector2(1068, 330), Vector2(940, 334)],
		"interaction_position": Vector2(940, 310),
		"approach_position": Vector2(934, 324),
		"interaction_radius": 78.0,
		"color": Color(0.34, 0.36, 0.35, 1.0),
	},
	"aircon": {
		"position": Vector2(462, 132),
		"size": Vector2(144, 28),
		"thickness": 10.0,
		"layer": "WallBackLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(460, 220),
		"approach_position": Vector2(460, 236),
		"interaction_radius": 48.0,
		"color": Color(0.48, 0.48, 0.43, 1.0),
	},
	"shelf": {
		"position": Vector2(1002, 190),
		"size": Vector2(120, 28),
		"thickness": 14.0,
		"layer": "WallBackLayer",
		"blocker_rect": Rect2(),
		"interaction_position": Vector2(980, 260),
		"approach_position": Vector2(948, 290),
		"interaction_radius": 50.0,
		"color": Color(0.31, 0.20, 0.11, 1.0),
	},
	"small_table": {
		"position": Vector2(620, 550),
		"size": Vector2(142, 74),
		"thickness": 28.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(Vector2(540, 506), Vector2(170, 92)),
		"blocker_footprint": [Vector2(538, 548), Vector2(714, 540), Vector2(724, 604), Vector2(552, 616)],
		"interaction_position": Vector2(620, 650),
		"interaction_radius": 78.0,
		"color": Color(0.33, 0.20, 0.11, 1.0),
	},
}

const VISUAL_BLOCKS := [
	{
		"name": "EntryMat",
		"position": Vector2(246, 524),
		"size": Vector2(98, 44),
		"thickness": 4.0,
		"layer": "FloorLayer",
		"color": Color(0.14, 0.13, 0.11, 0.92),
	},
	{
		"name": "Rug",
		"position": Vector2(548, 508),
		"size": Vector2(250, 150),
		"thickness": 3.0,
		"layer": "FloorLayer",
		"color": Color(0.17, 0.19, 0.17, 0.92),
	},
	{
		"name": "SinkCounter",
		"position": Vector2(960, 404),
		"size": Vector2(104, 62),
		"thickness": 36.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(902, 366), Vector2(128, 84)),
		"blocker_footprint": [Vector2(904, 424), Vector2(1034, 414), Vector2(1032, 468), Vector2(912, 478)],
		"color": Color(0.25, 0.22, 0.18, 1.0),
	},
	{
		"name": "BathroomTileHint",
		"position": Vector2(330, 394),
		"size": Vector2(82, 48),
		"thickness": 3.0,
		"layer": "FloorLayer",
		"color": Color(0.24, 0.25, 0.23, 0.86),
	},
	{
		"name": "CableBundle",
		"position": Vector2(920, 468),
		"size": Vector2(170, 16),
		"thickness": 6.0,
		"layer": "ObjectLayer",
		"color": Color(0.035, 0.04, 0.04, 1.0),
	},
]

var object_definitions: Array = []
@export_group("External Apartment Environment")
@export var external_environment_mode := false
@export var external_environment_path: NodePath
var external_environment: Node
var nearest_key := ""
var debug_enabled := false
var footprint_tuning_enabled := false
var background_mode := "none"
var pending_focus_key := ""
var blocker_rects: Array[Rect2] = []
var blocker_footprints: Array = []
var path_grid := AStarGrid2D.new()
var path_grid_size := Vector2i.ZERO
var current_debug_path := PackedVector2Array()
var current_click_target := Vector2.ZERO
var has_click_target := false
var path_failure_reason := ""
var selected_key := ""
var hovered_key := ""
var tuning_object_index := 0
var tuning_status_message := ""
var room_input_enabled := true
var hover_affordance_enabled := true
var debug_label_nodes := {}
var debug_radius_nodes := {}
var debug_approach_nodes := {}
var debug_visual_rect_nodes := {}
var debug_click_area_nodes := {}
var debug_footprint_nodes := {}
var debug_blocker_guide_nodes: Array[Line2D] = []
var prompt_label: Label
var hover_prompt_label: Label
var hover_highlight_polygon: Polygon2D
var hover_outline_line: Line2D
var hover_overlay_sprite: Sprite2D
var reference_notice_label: Label
var path_debug_line: Line2D
var click_target_debug_line: Line2D
var walk_bounds_debug_line: Line2D
var player_collision_debug_line: Line2D
var path_failure_label: Label
var tuning_vertex_labels: Array[Label] = []
var floor_points := PackedVector2Array([
	Vector2(244, 150),
	Vector2(1018, 150),
	Vector2(1136, 510),
	Vector2(990, 630),
	Vector2(372, 650),
	Vector2(154, 430),
])

@onready var background_layer: Node2D = $BackgroundLayer
@onready var background_sprite: Sprite2D = $BackgroundLayer/BackgroundSprite
@onready var floor_layer: Node2D = $FloorLayer
@onready var wall_back_layer: Node2D = $WallBackLayer
@onready var wall_side_layer: Node2D = $WallSideLayer
@onready var object_back_layer: Node2D = $ObjectBackLayer
@onready var object_layer: Node2D = $ObjectLayer
@onready var player_layer: Node2D = $PlayerLayer
@onready var foreground_layer: Node2D = $ForegroundLayer
@onready var debug_layer: Node2D = $DebugLayer
@onready var prompt_layer: Node2D = $PromptLayer
@onready var player: CharacterBody2D = $PlayerLayer/Player


func _ready() -> void:
	if external_environment_mode:
		external_environment = get_node_or_null(external_environment_path)
		if external_environment == null:
			push_error("QuarterviewRoom external environment path is missing: %s" % external_environment_path)
	_configure_layers()
	if not external_environment_mode:
		_configure_background_art()
		_build_room_shell()
		_build_visual_details()
	_build_prompt()
	if not external_environment_mode:
		_build_reference_notice()
	_load_object_definitions()
	if not external_environment_mode:
		_build_object_placeholders()
		_build_wall_blockers()
	_rebuild_path_grid()
	if not external_environment_mode:
		_build_object_debug_guides()
		_build_path_debug()
	_set_blockout_layers_visible(false)
	_set_debug_enabled(false)


func _process(_delta: float) -> void:
	if room_input_enabled:
		_update_hover_affordance()
		_update_nearest_interactable()
		_update_pending_focus()
	elif prompt_label != null:
		_clear_hover_target()
		prompt_label.visible = false
	_update_player_collision_debug()
	_update_object_debug_visibility()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_D:
			_set_debug_enabled(not debug_enabled)
			get_viewport().set_input_as_handled()
			return
		if debug_enabled and event.keycode == TUNING_TOGGLE_KEY:
			_set_footprint_tuning_enabled(not footprint_tuning_enabled)
			get_viewport().set_input_as_handled()
			return
		if debug_enabled and footprint_tuning_enabled and event.unicode == 91:
			_select_tuning_object(-1)
			get_viewport().set_input_as_handled()
			return
		if debug_enabled and footprint_tuning_enabled and event.unicode == 93:
			_select_tuning_object(1)
			get_viewport().set_input_as_handled()
			return
		if debug_enabled and footprint_tuning_enabled and event.keycode == TUNING_PRINT_KEY:
			_print_tuning_layout_snippet()
			get_viewport().set_input_as_handled()
			return
		if not room_input_enabled:
			return
		if event.keycode == KEY_E or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_request_nearest_interaction()
			get_viewport().set_input_as_handled()
	elif room_input_enabled and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_left_click(get_global_mouse_position())
		get_viewport().set_input_as_handled()


func _configure_layers() -> void:
	var ordered_layers := [
		background_layer,
		floor_layer,
		wall_back_layer,
		wall_side_layer,
		object_back_layer,
		object_layer,
		player_layer,
		foreground_layer,
		debug_layer,
		prompt_layer,
	]
	for index in ordered_layers.size():
		var layer: Node2D = ordered_layers[index]
		layer.z_as_relative = false
		layer.z_index = index * 10


func _configure_background_art() -> void:
	var image_path := ""
	var alpha := 1.0

	if FileAccess.file_exists(TEMP_BACKGROUND_PATH):
		image_path = TEMP_BACKGROUND_PATH
		background_mode = "runtime_background"
	elif FileAccess.file_exists(REFERENCE_BACKGROUND_PATH):
		image_path = REFERENCE_BACKGROUND_PATH
		background_mode = "reference_overlay"
		alpha = REFERENCE_OVERLAY_ALPHA
	else:
		background_mode = "missing"
		background_sprite.visible = false
		push_warning("QuarterviewRoom has no temporary background or concept reference image.")
		return

	var texture := load(image_path) as Texture2D
	if texture == null:
		background_mode = "missing"
		background_sprite.visible = false
		push_warning("QuarterviewRoom could not load background image: %s" % image_path)
		return

	background_sprite.texture = texture
	background_sprite.centered = false
	var texture_size := texture.get_size()
	var scale_value: float = min(
		BACKGROUND_TARGET_SIZE.x / texture_size.x,
		BACKGROUND_TARGET_SIZE.y / texture_size.y
	)
	background_sprite.scale = Vector2(scale_value, scale_value)
	background_sprite.position = (BACKGROUND_TARGET_SIZE - texture_size * scale_value) * 0.5
	background_sprite.modulate = Color(1.0, 1.0, 1.0, alpha)
	background_sprite.visible = true


func _build_room_shell() -> void:
	_add_polygon(floor_layer, floor_points, Color(0.14, 0.11, 0.08, 1.0))
	_add_polyline(floor_layer, floor_points, Color(0.75, 0.58, 0.36, 0.52), 3.0)
	_add_floor_boards()

	var back_wall := PackedVector2Array([
		Vector2(244, 66),
		Vector2(1018, 66),
		Vector2(1018, 150),
		Vector2(244, 150),
	])
	_add_polygon(wall_back_layer, back_wall, Color(0.21, 0.20, 0.18, 1.0))
	_add_polyline(wall_back_layer, back_wall, Color(0.66, 0.57, 0.42, 0.44), 2.0)

	var left_wall := PackedVector2Array([
		Vector2(152, 180),
		Vector2(244, 66),
		Vector2(244, 150),
		Vector2(154, 430),
		Vector2(142, 580),
		Vector2(104, 536),
	])
	_add_polygon(wall_side_layer, left_wall, Color(0.12, 0.12, 0.11, 1.0))
	_add_polyline(wall_side_layer, left_wall, Color(0.61, 0.54, 0.40, 0.36), 2.0)

	var right_wall := PackedVector2Array([
		Vector2(1018, 66),
		Vector2(1110, 176),
		Vector2(1154, 486),
		Vector2(1136, 510),
		Vector2(1018, 150),
	])
	_add_polygon(wall_side_layer, right_wall, Color(0.13, 0.14, 0.13, 1.0))
	_add_polyline(wall_side_layer, right_wall, Color(0.61, 0.54, 0.40, 0.36), 2.0)

	_add_window()
	_add_wall_fixture(Vector2(374, 108), Vector2(170, 20), Color(0.98, 0.77, 0.42, 0.80))
	_add_wall_fixture(Vector2(870, 118), Vector2(150, 18), Color(0.98, 0.78, 0.42, 0.72))
	_add_front_lip()


func _add_floor_boards() -> void:
	var board_color := Color(0.60, 0.45, 0.28, 0.16)
	for offset in range(0, 10):
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = board_color
		var y := 196.0 + float(offset) * 42.0
		line.points = PackedVector2Array([
			Vector2(238 + offset * 8, y),
			Vector2(1018 + offset * 10, y + 270),
		])
		floor_layer.add_child(line)

	for guide in [
		PackedVector2Array([Vector2(298, 222), Vector2(1078, 502)]),
		PackedVector2Array([Vector2(412, 636), Vector2(1016, 230)]),
		PackedVector2Array([Vector2(604, 154), Vector2(256, 590)]),
	]:
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = Color(0.72, 0.58, 0.38, 0.12)
		line.points = guide
		floor_layer.add_child(line)


func _add_window() -> void:
	var window := PackedVector2Array([
		Vector2(662, 86),
		Vector2(846, 86),
		Vector2(846, 150),
		Vector2(662, 150),
	])
	_add_polygon(wall_back_layer, window, Color(0.025, 0.12, 0.21, 1.0))
	_add_polyline(wall_back_layer, window, Color(0.26, 0.68, 0.96, 0.68), 2.0)

	for x in [694.0, 728.0, 784.0, 820.0]:
		var city_line := Line2D.new()
		city_line.width = 2.0
		city_line.default_color = Color(0.15, 0.42, 0.65, 0.55)
		city_line.points = PackedVector2Array([Vector2(x, 95), Vector2(x, 144)])
		wall_back_layer.add_child(city_line)


func _add_wall_fixture(center: Vector2, size: Vector2, color: Color) -> void:
	var points := PackedVector2Array([
		center + Vector2(-size.x * 0.5, -size.y * 0.5),
		center + Vector2(size.x * 0.5, -size.y * 0.5),
		center + Vector2(size.x * 0.5, size.y * 0.5),
		center + Vector2(-size.x * 0.5, size.y * 0.5),
	])
	_add_polygon(wall_back_layer, points, color)
	_add_polyline(wall_back_layer, points, Color(1.0, 0.86, 0.55, 0.72), 2.0)


func _add_front_lip() -> void:
	var lip := Line2D.new()
	lip.points = PackedVector2Array([
		Vector2(372, 650),
		Vector2(990, 630),
		Vector2(1136, 510),
	])
	lip.width = 9.0
	lip.default_color = Color(0.06, 0.06, 0.05, 0.78)
	foreground_layer.add_child(lip)


func _build_visual_details() -> void:
	for visual in VISUAL_BLOCKS:
		_add_visual_block(visual)

	_add_cable_line(PackedVector2Array([
		Vector2(750, 405),
		Vector2(820, 478),
		Vector2(878, 520),
		Vector2(1012, 540),
	]))
	_add_cable_line(PackedVector2Array([
		Vector2(930, 378),
		Vector2(986, 426),
		Vector2(1010, 510),
	]))


func _add_visual_block(visual: Dictionary) -> void:
	var parent := _get_layer_by_name(String(visual.get("layer", "ObjectLayer")))
	var node := Node2D.new()
	node.name = String(visual["name"])
	node.position = visual["position"]
	parent.add_child(node)

	var size: Vector2 = visual["size"]
	var color: Color = visual["color"]
	_add_pseudo_block(
		node,
		size,
		float(visual["thickness"]),
		color,
		false
	)

	if visual.has("blocker_rect"):
		_add_blocker(
			"%sBlocker" % node.name,
			visual["blocker_rect"],
			_get_layout_footprint(visual),
			_is_layout_footprint_enabled_for_path(visual)
		)


func _add_cable_line(points: PackedVector2Array) -> void:
	var cable := Line2D.new()
	cable.width = 5.0
	cable.default_color = Color(0.035, 0.035, 0.032, 0.78)
	cable.points = points
	object_layer.add_child(cable)


func _build_prompt() -> void:
	prompt_label = Label.new()
	prompt_label.name = "PromptLabel"
	prompt_label.visible = false
	prompt_label.add_theme_color_override("font_color", Color(0.98, 0.84, 0.48, 1.0))
	prompt_label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
	prompt_label.add_theme_constant_override("outline_size", 4)
	prompt_label.add_theme_font_size_override("font_size", 18)
	prompt_layer.add_child(prompt_label)

	hover_highlight_polygon = Polygon2D.new()
	hover_highlight_polygon.name = "HoverHighlightFill"
	hover_highlight_polygon.visible = false
	hover_highlight_polygon.color = HOVER_FILL_COLOR
	prompt_layer.add_child(hover_highlight_polygon)

	hover_outline_line = Line2D.new()
	hover_outline_line.name = "HoverHighlightOutline"
	hover_outline_line.visible = false
	hover_outline_line.closed = true
	hover_outline_line.width = 3.0
	hover_outline_line.default_color = HOVER_OUTLINE_COLOR
	prompt_layer.add_child(hover_outline_line)

	hover_overlay_sprite = Sprite2D.new()
	hover_overlay_sprite.name = "HoverOverlaySprite"
	hover_overlay_sprite.visible = false
	hover_overlay_sprite.centered = true
	prompt_layer.add_child(hover_overlay_sprite)

	hover_prompt_label = Label.new()
	hover_prompt_label.name = "HoverPromptLabel"
	hover_prompt_label.visible = false
	hover_prompt_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.54, 1.0))
	hover_prompt_label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
	hover_prompt_label.add_theme_constant_override("outline_size", 4)
	hover_prompt_label.add_theme_font_size_override("font_size", 16)
	prompt_layer.add_child(hover_prompt_label)


func _build_reference_notice() -> void:
	if background_mode != "reference_overlay":
		return

	reference_notice_label = Label.new()
	reference_notice_label.name = "ReferenceNoticeLabel"
	reference_notice_label.text = "Reference overlay only"
	reference_notice_label.position = Vector2(22, 660)
	reference_notice_label.add_theme_color_override("font_color", Color(0.95, 0.78, 0.42, 0.82))
	reference_notice_label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
	reference_notice_label.add_theme_constant_override("outline_size", 3)
	reference_notice_label.add_theme_font_size_override("font_size", 14)
	prompt_layer.add_child(reference_notice_label)


func _load_object_definitions() -> void:
	object_definitions.clear()
	var filter_external_ids := (
		external_environment_mode
		and external_environment != null
		and external_environment.has_method("playable_direct_object_ids")
	)
	var allowed_external_ids: Array[String] = []
	if filter_external_ids:
		var provider_ids: Variant = external_environment.call("playable_direct_object_ids")
		for provider_id: Variant in Array(provider_ids):
			allowed_external_ids.append(String(provider_id))
	for path in OBJECT_RESOURCE_PATHS:
		var definition: Resource = load(path)
		if definition == null:
			push_warning("QuarterviewRoom could not load object definition: %s" % path)
			continue
		if not definition.has_method("is_valid_definition") or not definition.is_valid_definition():
			push_warning("QuarterviewRoom skipped invalid object definition: %s" % path)
			continue
		if external_environment_mode:
			var legacy_key := String(definition.key)
			if not EXTERNAL_ENVIRONMENT_IDS_BY_LEGACY_KEY.has(legacy_key):
				continue
			var external_id := String(EXTERNAL_ENVIRONMENT_IDS_BY_LEGACY_KEY[legacy_key])
			if filter_external_ids and not allowed_external_ids.has(external_id):
				continue
		object_definitions.append(definition)


func _build_object_placeholders() -> void:
	for definition in object_definitions:
		_add_object_placeholder(definition)
		if definition.blocks and (
			_get_object_blocker_rect(definition).size != Vector2.ZERO
			or _get_object_blocker_footprint(definition).size() >= 3
		):
			_add_object_blocker(definition)


func _build_object_debug_guides() -> void:
	for definition in object_definitions:
		_add_debug_for_definition(definition)
	_update_object_debug_visibility()


func _add_object_placeholder(definition: Resource) -> void:
	var parent := _get_layer_for_definition(definition)
	var node := Node2D.new()
	node.name = "%sPlaceholder" % String(definition.key).capitalize().replace("_", "")
	node.position = _get_object_position(definition)
	node.z_as_relative = false
	node.z_index = int(_get_object_sort_y(definition))
	parent.add_child(node)

	_add_pseudo_block(
		node,
		_get_object_size(definition),
		_get_object_thickness(definition),
		_get_object_color(definition),
		true
	)
	_add_device_hint(definition, node)


func _add_pseudo_block(parent: Node, size: Vector2, depth: float, base_color: Color, outlined: bool) -> void:
	var half := size * 0.5
	var projection_skew := Vector2(18.0, 12.0)
	var shadow_points := PackedVector2Array([
		Vector2(-half.x + 8.0, -half.y + 18.0),
		Vector2(half.x + 20.0, -half.y + 18.0),
		Vector2(half.x + projection_skew.x + 24.0, half.y + projection_skew.y + depth + 18.0),
		Vector2(-half.x + projection_skew.x + 12.0, half.y + projection_skew.y + depth + 18.0),
	])
	_add_local_polygon(parent, shadow_points, Color(0.0, 0.0, 0.0, 0.22))

	var top_points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x + projection_skew.x, half.y + projection_skew.y),
		Vector2(-half.x + projection_skew.x, half.y + projection_skew.y),
	])
	var front_points := PackedVector2Array([
		top_points[3],
		top_points[2],
		top_points[2] + Vector2(0, depth),
		top_points[3] + Vector2(0, depth),
	])
	var side_points := PackedVector2Array([
		top_points[1],
		top_points[2],
		top_points[2] + Vector2(0, depth),
		top_points[1] + Vector2(0, depth),
	])

	_add_local_polygon(parent, front_points, base_color.darkened(0.36))
	_add_local_polygon(parent, side_points, base_color.darkened(0.20))
	_add_local_polygon(parent, top_points, base_color)
	if outlined:
		_add_local_polyline(parent, top_points, Color(0.92, 0.72, 0.44, 0.38), 2.0)


func _add_device_hint(definition: Resource, node: Node2D) -> void:
	var key := String(definition.key)
	if not (key in ["laptop", "phone", "comm", "node17", "speaker", "signal_booster", "power", "ups"]):
		return

	var glow := Polygon2D.new()
	glow.color = Color(0.10, 0.62, 0.95, 0.28)
	glow.polygon = PackedVector2Array([
		Vector2(-12, -8),
		Vector2(14, -8),
		Vector2(18, 8),
		Vector2(-8, 8),
	])
	node.add_child(glow)


func _add_object_blocker(definition: Resource) -> void:
	_add_blocker(
		"%sBlocker" % String(definition.key).capitalize().replace("_", ""),
		_get_object_blocker_rect(definition),
		_get_object_blocker_footprint(definition),
		_is_object_footprint_enabled_for_path(definition)
	)


func _build_wall_blockers() -> void:
	for blocker in WALL_BLOCKERS:
		_add_blocker(
			blocker["name"],
			blocker["rect"],
			_get_layout_footprint(blocker),
			_is_layout_footprint_enabled_for_path(blocker)
		)


func _add_blocker(
	blocker_name: String,
	rect: Rect2,
	footprint := PackedVector2Array(),
	use_footprint_for_path := false
) -> void:
	var has_footprint := footprint.size() >= 3
	var body := StaticBody2D.new()
	body.name = blocker_name
	add_child(body)

	if has_footprint and use_footprint_for_path:
		blocker_footprints.append(footprint)

		var polygon_shape := CollisionPolygon2D.new()
		polygon_shape.polygon = footprint
		body.add_child(polygon_shape)
	elif rect.size != Vector2.ZERO:
		blocker_rects.append(rect)
		body.position = rect.position + rect.size * 0.5

		var shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = rect.size
		shape.shape = rectangle
		body.add_child(shape)
	else:
		body.queue_free()
		return

	var guide := Line2D.new()
	guide.name = "%sGuide" % blocker_name
	guide.closed = true
	guide.width = DEBUG_BLOCKER_LINE_WIDTH
	guide.default_color = (
		DEBUG_FOOTPRINT_COLOR
		if has_footprint and use_footprint_for_path
		else Color(1.0, 0.42, 0.18, 0.34)
	)
	guide.points = footprint if has_footprint else _rect_to_points(rect)
	debug_layer.add_child(guide)
	debug_blocker_guide_nodes.append(guide)


func _add_debug_for_definition(definition: Resource) -> void:
	var key := String(definition.key)
	var label := Label.new()
	label.name = "%sDebugLabel" % key.capitalize().replace("_", "")
	label.text = definition.display_name
	label.position = _get_object_position(definition) + Vector2(-44, -_get_object_size(definition).y * 0.5 - 34)
	label.add_theme_color_override("font_color", Color(0.55, 0.93, 0.96, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.01, 0.01, 0.02, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_font_size_override("font_size", 12)
	debug_layer.add_child(label)
	debug_label_nodes[key] = label

	var radius := Line2D.new()
	radius.name = "%sInteractionRadius" % key.capitalize().replace("_", "")
	radius.closed = true
	radius.width = 2.0
	radius.default_color = Color(0.28, 0.88, 0.76, 0.42)
	var points := PackedVector2Array()
	for index in 48:
		var angle := TAU * float(index) / 48.0
		points.append(_get_object_interaction_position(definition) + Vector2(cos(angle), sin(angle)) * _get_object_interaction_radius(definition))
	radius.points = points
	debug_layer.add_child(radius)
	debug_radius_nodes[key] = radius

	var visual_rect := Line2D.new()
	visual_rect.name = "%sVisualRect" % key.capitalize().replace("_", "")
	visual_rect.closed = true
	visual_rect.width = 1.0
	visual_rect.default_color = DEBUG_VISUAL_RECT_COLOR
	visual_rect.points = _rect_to_points(_get_object_visual_rect(definition))
	debug_layer.add_child(visual_rect)
	debug_visual_rect_nodes[key] = visual_rect

	var click_area := Line2D.new()
	click_area.name = "%sClickArea" % key.capitalize().replace("_", "")
	click_area.closed = true
	click_area.width = DEBUG_INTERACTION_LINE_WIDTH
	click_area.default_color = DEBUG_CLICK_AREA_COLOR
	click_area.points = _rect_to_points(_get_object_click_rect(definition))
	debug_layer.add_child(click_area)
	debug_click_area_nodes[key] = click_area

	var footprint_points := _get_object_blocker_footprint(definition)
	if footprint_points.size() >= 3:
		var footprint := Line2D.new()
		footprint.name = "%sFootprint" % key.capitalize().replace("_", "")
		footprint.closed = true
		footprint.width = DEBUG_BLOCKER_LINE_WIDTH
		footprint.default_color = DEBUG_FOOTPRINT_COLOR
		footprint.points = footprint_points
		debug_layer.add_child(footprint)
		debug_footprint_nodes[key] = footprint

	var approach := Line2D.new()
	approach.name = "%sApproachPoint" % key.capitalize().replace("_", "")
	approach.closed = true
	approach.width = DEBUG_INTERACTION_LINE_WIDTH
	approach.default_color = Color(1.0, 0.82, 0.24, 0.82)
	var approach_position := _get_object_approach_position(definition)
	approach.points = PackedVector2Array([
		approach_position + Vector2(-DEBUG_APPROACH_MARKER_HALF_SIZE, -DEBUG_APPROACH_MARKER_HALF_SIZE),
		approach_position + Vector2(DEBUG_APPROACH_MARKER_HALF_SIZE, -DEBUG_APPROACH_MARKER_HALF_SIZE),
		approach_position + Vector2(DEBUG_APPROACH_MARKER_HALF_SIZE, DEBUG_APPROACH_MARKER_HALF_SIZE),
		approach_position + Vector2(-DEBUG_APPROACH_MARKER_HALF_SIZE, DEBUG_APPROACH_MARKER_HALF_SIZE),
	])
	debug_layer.add_child(approach)
	debug_approach_nodes[key] = approach


func _get_layer_for_definition(definition: Resource) -> Node2D:
	return _get_layer_by_name(_get_object_layer(definition))


func _get_layer_by_name(layer_name: String) -> Node2D:
	match layer_name:
		"FloorLayer":
			return floor_layer
		"WallBackLayer":
			return wall_back_layer
		"WallSideLayer":
			return wall_side_layer
		"FurnitureBackLayer", "ObjectBackLayer":
			return object_back_layer
		"FurnitureFrontLayer", "ForegroundLayer":
			return foreground_layer
		_:
			return object_layer


func _update_nearest_interactable() -> void:
	var best_key := ""
	var best_display_name := ""
	var best_distance := INF

	for definition in object_definitions:
		if not _is_normal_interactable(definition):
			continue
		var distance := player.global_position.distance_to(_get_object_interaction_position(definition))
		if distance <= _get_object_interaction_radius(definition) and distance < best_distance:
			best_key = definition.key
			best_display_name = definition.display_name
			best_distance = distance

	if best_key == nearest_key:
		_update_prompt()
		return

	nearest_key = best_key
	var public_key := String(EXTERNAL_ENVIRONMENT_IDS_BY_LEGACY_KEY.get(nearest_key, nearest_key)) if external_environment_mode else nearest_key
	nearest_interactable_changed.emit(public_key, best_display_name)
	_update_prompt()
	_update_object_debug_visibility()


func _update_object_debug_visibility() -> void:
	if not debug_enabled:
		return

	var focus_key := _get_debug_focus_key()
	for key in debug_label_nodes.keys():
		var definition := _get_definition(String(key))
		if definition == null:
			continue

		var priority := _get_object_interaction_priority(definition)
		var is_focus := String(key) == focus_key
		var is_background_hint := priority >= 80

		var label: Label = debug_label_nodes[key]
		label.visible = is_focus if footprint_tuning_enabled else not is_background_hint or is_focus
		label.modulate = Color(1.0, 1.0, 1.0, 1.0 if is_focus else 0.72)

		var radius: Line2D = debug_radius_nodes[key]
		radius.visible = is_focus

		var visual_rect: Line2D = debug_visual_rect_nodes[key]
		visual_rect.visible = is_focus

		var click_area: Line2D = debug_click_area_nodes[key]
		click_area.visible = is_focus

		if debug_footprint_nodes.has(key):
			var footprint: Line2D = debug_footprint_nodes[key]
			footprint.visible = is_focus if footprint_tuning_enabled else not is_background_hint or is_focus
			footprint.modulate = Color(1.0, 1.0, 1.0, 1.0 if is_focus else 0.38)

		var approach: Line2D = debug_approach_nodes[key]
		approach.visible = is_focus if footprint_tuning_enabled else is_focus or priority <= 20

	_update_tuning_vertex_markers()
	_update_debug_blocker_guide_visibility()


func _get_debug_focus_key() -> String:
	if footprint_tuning_enabled:
		return _get_tuning_object_key()
	if not selected_key.is_empty():
		return selected_key
	if not hovered_key.is_empty():
		return hovered_key
	return nearest_key


func _set_footprint_tuning_enabled(enabled: bool) -> void:
	if enabled and object_definitions.is_empty():
		tuning_status_message = "Footprint Tuning Mode unavailable: no objects"
		footprint_tuning_enabled = false
		debug_overlay_toggled.emit(debug_enabled)
		return

	footprint_tuning_enabled = enabled
	if footprint_tuning_enabled:
		var preferred_key := selected_key if not selected_key.is_empty() else nearest_key
		if not preferred_key.is_empty():
			for index in object_definitions.size():
				if String(object_definitions[index].key) == preferred_key:
					tuning_object_index = index
					break
		tuning_object_index = clampi(tuning_object_index, 0, object_definitions.size() - 1)
		selected_key = _get_tuning_object_key()
		tuning_status_message = "Footprint Tuning Mode ON"
	else:
		tuning_status_message = "Footprint Tuning Mode OFF"

	_update_object_debug_visibility()
	_update_tuning_vertex_markers()
	debug_overlay_toggled.emit(debug_enabled)


func _select_tuning_object(direction: int) -> void:
	if object_definitions.is_empty():
		return

	tuning_object_index = wrapi(tuning_object_index + direction, 0, object_definitions.size())
	selected_key = _get_tuning_object_key()
	var definition := _get_tuning_definition()
	if definition != null:
		tuning_status_message = "Tuning selected: %s" % String(definition.key)
	_update_object_debug_visibility()
	debug_overlay_toggled.emit(debug_enabled)


func _get_tuning_object_key() -> String:
	var definition := _get_tuning_definition()
	if definition == null:
		return ""
	return String(definition.key)


func _get_tuning_definition() -> Resource:
	if object_definitions.is_empty():
		return null
	tuning_object_index = clampi(tuning_object_index, 0, object_definitions.size() - 1)
	return object_definitions[tuning_object_index]


func _update_tuning_vertex_markers() -> void:
	var should_show := debug_enabled and footprint_tuning_enabled
	var footprint := PackedVector2Array()
	if should_show:
		var definition := _get_tuning_definition()
		if definition != null:
			footprint = _get_object_blocker_footprint(definition)

	for index in footprint.size():
		if index >= tuning_vertex_labels.size():
			var label := Label.new()
			label.name = "TuningVertex%d" % index
			label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.18, 1.0))
			label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
			label.add_theme_constant_override("outline_size", 3)
			label.add_theme_font_size_override("font_size", 12)
			debug_layer.add_child(label)
			tuning_vertex_labels.append(label)

		var label: Label = tuning_vertex_labels[index]
		label.text = str(index)
		label.position = footprint[index] + Vector2(5, -18)
		label.visible = should_show and footprint.size() >= 3

	for index in range(footprint.size(), tuning_vertex_labels.size()):
		tuning_vertex_labels[index].visible = false


func _update_debug_blocker_guide_visibility() -> void:
	var should_show := debug_enabled and not footprint_tuning_enabled
	for guide in debug_blocker_guide_nodes:
		if is_instance_valid(guide):
			guide.visible = should_show


func _print_tuning_layout_snippet() -> void:
	var definition := _get_tuning_definition()
	if definition == null:
		return

	var snippet := "%s: {\n\t\"approach_position\": %s,\n\t\"click_rect\": %s,\n\t\"blocker_footprint\": %s,\n\t\"footprint_path_enabled\": %s,\n}," % [
		JSON.stringify(String(definition.key)),
		_format_vector_snippet(_get_object_approach_position(definition)),
		_format_rect_snippet(_get_object_click_rect(definition)),
		_format_footprint_snippet(_get_object_blocker_footprint(definition)),
		str(_is_object_footprint_enabled_for_path(definition)).to_lower(),
	]
	print(snippet)
	DisplayServer.clipboard_set(snippet)
	tuning_status_message = "Printed layout snippet for %s" % String(definition.key)
	debug_overlay_toggled.emit(debug_enabled)


func _update_prompt() -> void:
	if not hovered_key.is_empty() and hover_prompt_label != null and hover_prompt_label.visible:
		prompt_label.visible = false
		return

	if nearest_key.is_empty():
		prompt_label.visible = false
		return

	var definition := _get_definition(nearest_key)
	if definition == null:
		prompt_label.visible = false
		return

	prompt_label.text = "[E] %s" % definition.display_name
	prompt_label.position = player.global_position + Vector2(-64, -100)
	prompt_label.visible = true


func _update_hover_affordance() -> void:
	if not hover_affordance_enabled:
		_clear_hover_target()
		return

	var mouse_position := get_global_mouse_position()
	var definition := _get_hover_definition_at_position(mouse_position)
	if definition == null:
		_clear_hover_target()
		return

	var key := String(definition.key)
	if key != hovered_key:
		_set_hover_target(definition)
	else:
		_update_hover_prompt_position(mouse_position)


func _set_hover_target(definition: Resource) -> void:
	hovered_key = String(definition.key)
	_update_hover_visual(definition)
	var public_key := _external_object_id(definition) if external_environment_mode else hovered_key
	hover_interactable_changed.emit(public_key, String(definition.display_name), _make_hover_payload(definition))
	_update_prompt()
	_update_object_debug_visibility()


func _clear_hover_target() -> void:
	if hovered_key.is_empty():
		_hide_hover_visual()
		return

	hovered_key = ""
	_hide_hover_visual()
	hover_interactable_changed.emit("", "", {})
	_update_prompt()
	_update_object_debug_visibility()


func _update_hover_visual(definition: Resource) -> void:
	var hover_texture := _get_hover_overlay_texture(definition)
	var mouse_position := get_global_mouse_position()

	if hover_prompt_label != null:
		hover_prompt_label.text = "[클릭] %s" % _get_object_hover_label(definition)
		hover_prompt_label.visible = true
		_update_hover_prompt_position(mouse_position)

	if hover_texture != null:
		if hover_overlay_sprite != null:
			hover_overlay_sprite.texture = hover_texture
			hover_overlay_sprite.position = _get_object_position(definition) + _get_object_hover_overlay_offset(definition)
			hover_overlay_sprite.scale = _get_object_hover_overlay_scale(definition)
			hover_overlay_sprite.z_index = _get_object_hover_overlay_z_index(definition)
			hover_overlay_sprite.visible = true
		if hover_highlight_polygon != null:
			hover_highlight_polygon.visible = false
		if hover_outline_line != null:
			hover_outline_line.visible = false
		return

	var hover_rect := _get_object_click_rect(definition)
	var hover_points := _rect_to_points(hover_rect)
	if hover_highlight_polygon != null:
		hover_highlight_polygon.polygon = hover_points
		hover_highlight_polygon.visible = true
	if hover_outline_line != null:
		hover_outline_line.points = hover_points
		hover_outline_line.visible = true
	if hover_overlay_sprite != null:
		hover_overlay_sprite.visible = false


func _hide_hover_visual() -> void:
	if hover_prompt_label != null:
		hover_prompt_label.visible = false
	if hover_highlight_polygon != null:
		hover_highlight_polygon.visible = false
	if hover_outline_line != null:
		hover_outline_line.visible = false
	if hover_overlay_sprite != null:
		hover_overlay_sprite.visible = false


func _update_hover_prompt_position(mouse_position: Vector2) -> void:
	if hover_prompt_label == null or not hover_prompt_label.visible:
		return

	var prompt_position := mouse_position + HOVER_PROMPT_OFFSET
	prompt_position.x = clampf(
		prompt_position.x,
		HOVER_PROMPT_MARGIN,
		BACKGROUND_TARGET_SIZE.x - HOVER_PROMPT_MARGIN - HOVER_PROMPT_CLAMP_SIZE.x
	)
	prompt_position.y = clampf(
		prompt_position.y,
		HOVER_PROMPT_MARGIN,
		BACKGROUND_TARGET_SIZE.y - HOVER_PROMPT_MARGIN - HOVER_PROMPT_CLAMP_SIZE.y
	)
	hover_prompt_label.position = prompt_position


func _make_hover_payload(definition: Resource) -> Dictionary:
	return {
		"key": _external_object_id(definition) if external_environment_mode else definition.key,
		"display_name": definition.display_name,
		"hover_label": _get_object_hover_label(definition),
		"role": definition.role,
		"zone": definition.zone,
		"future_source": definition.future_source,
		"visual_state": definition.visual_state,
		"hover_priority": _get_object_hover_priority(definition),
		"click_area": _get_object_click_rect(definition),
		"has_hover_overlay_texture": _get_hover_overlay_texture(definition) != null,
	}


func _request_nearest_interaction() -> void:
	if nearest_key.is_empty():
		return
	var definition := _get_definition(nearest_key)
	if definition == null:
		return

	selected_key = definition.key
	_update_object_debug_visibility()
	_emit_interaction_request(definition, ACTION_PRIMARY)


func _emit_interaction_request(definition: Resource, action_key: String) -> void:
	var public_key := _external_object_id(definition) if external_environment_mode else String(definition.key)
	var payload := {
		"key": public_key,
		"display_name": definition.display_name,
		"role": definition.role,
		"zone": definition.zone,
		"future_source": definition.future_source,
		"visual_state": definition.visual_state,
		"action": action_key,
		"priority": _get_object_interaction_priority(definition),
		"interaction_position": _get_object_interaction_position(definition),
		"approach_position": _get_object_approach_position(definition),
		"click_area": _get_object_click_rect(definition),
	}
	interaction_requested.emit(public_key, action_key, payload)


func _get_definition(object_key: String) -> Resource:
	for definition in object_definitions:
		if definition.key == object_key:
			return definition
	return null


func _set_debug_enabled(enabled: bool) -> void:
	var room_transform := global_transform
	var player_transform := player.global_transform
	debug_enabled = enabled
	if not debug_enabled:
		footprint_tuning_enabled = false
	_set_blockout_layers_visible(DEBUG_SHOW_BLOCKOUT_LAYERS and debug_enabled)
	debug_layer.visible = debug_enabled
	if player.has_method("set_keyboard_input_enabled"):
		player.set_keyboard_input_enabled(debug_enabled)
	_update_object_debug_visibility()
	_update_tuning_vertex_markers()
	_update_debug_blocker_guide_visibility()
	global_transform = room_transform
	player.global_transform = player_transform
	debug_overlay_toggled.emit(debug_enabled)


func _set_blockout_layers_visible(should_show: bool) -> void:
	for layer in [
		floor_layer,
		wall_back_layer,
		wall_side_layer,
		object_back_layer,
		object_layer,
		foreground_layer,
	]:
		layer.visible = should_show


func get_background_mode() -> String:
	return background_mode


func is_debug_overlay_enabled() -> bool:
	return debug_enabled


func set_room_input_enabled(enabled: bool) -> void:
	room_input_enabled = enabled
	if enabled:
		return

	pending_focus_key = ""
	selected_key = ""
	_clear_hover_target()
	if player != null and player.has_method("clear_move_target"):
		player.clear_move_target()
	if prompt_label != null:
		prompt_label.visible = false
	_update_path_debug(PackedVector2Array(), Vector2.ZERO)
	_update_object_debug_visibility()


func is_room_input_enabled() -> bool:
	return room_input_enabled


func set_hover_affordance_enabled(enabled: bool) -> void:
	hover_affordance_enabled = enabled
	if not hover_affordance_enabled:
		_clear_hover_target()


func get_hovered_interactable_key() -> String:
	return hovered_key


func get_debug_focus_summary() -> String:
	var focus_key := _get_debug_focus_key()
	if focus_key.is_empty():
		return "Debug focus: -\nF3: footprint tuning"

	var definition := _get_definition(focus_key)
	if definition == null:
		return "Debug focus: %s / missing definition" % focus_key

	var click_rect := _get_object_click_rect(definition)
	var footprint := _get_object_blocker_footprint(definition)
	var footprint_text := "none" if footprint.size() < 3 else _format_rect(_get_polygon_bounds(footprint))
	var mode_text := "Footprint Tuning: ON" if footprint_tuning_enabled else "Footprint Tuning: OFF"
	var help_text := "F3: tuning | [ / ]: select | C: print layout" if footprint_tuning_enabled else "F3: footprint tuning"
	var status_text := "\n%s" % tuning_status_message if not tuning_status_message.is_empty() else ""
	return "%s\nFocus: %s / priority=%d / role=%s / zone=%s\napproach=%s / click=%s\nfootprint=%s / path=%s\n%s%s" % [
		mode_text,
		focus_key,
		_get_object_interaction_priority(definition),
		String(definition.role),
		String(definition.zone),
		_format_vector(_get_object_approach_position(definition)),
		_format_rect(click_rect),
		footprint_text,
		"enabled" if _is_object_footprint_enabled_for_path(definition) else "debug-only",
		help_text,
		status_text,
	]


func _handle_left_click(click_position: Vector2) -> void:
	var clicked_definition := _get_definition_at_position(click_position)
	if clicked_definition != null and _is_click_candidate(clicked_definition):
		selected_key = clicked_definition.key
		_update_object_debug_visibility()
		if _move_player_to(_get_object_approach_position(clicked_definition)):
			pending_focus_key = clicked_definition.key
		else:
			pending_focus_key = ""
		return

	pending_focus_key = ""
	selected_key = ""
	_update_object_debug_visibility()
	_move_player_to(_clamp_walk_target(click_position))


func _move_player_to(target: Vector2) -> bool:
	var path := _find_path_to_target(target)
	if path.size() == 0:
		if path_failure_reason.is_empty():
			path_failure_reason = "No path: empty path"
		if player.has_method("clear_move_target"):
			player.clear_move_target()
		_update_path_debug(PackedVector2Array(), _clamp_walk_target(target))
		movement_path_failed.emit(path_failure_reason)
		return false

	var final_target := path[path.size() - 1]
	if player.has_method("set_path"):
		player.set_path(path)
	else:
		player.set_move_target(final_target)
	_update_path_debug(path, final_target)
	return true


func _rebuild_path_grid() -> void:
	if external_environment_mode:
		path_grid_size = Vector2i.ZERO
		return
	path_grid_size = Vector2i(
		int(ceil(WALK_TARGET_BOUNDS.size.x / PATH_GRID_CELL_SIZE)),
		int(ceil(WALK_TARGET_BOUNDS.size.y / PATH_GRID_CELL_SIZE))
	)
	path_grid = AStarGrid2D.new()
	path_grid.region = Rect2i(Vector2i.ZERO, path_grid_size)
	path_grid.cell_size = Vector2.ONE
	path_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	path_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	path_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	path_grid.update()

	for y in path_grid_size.y:
		for x in path_grid_size.x:
			var cell_id := Vector2i(x, y)
			if _is_world_point_blocked_for_path(_grid_id_to_world(cell_id)):
				path_grid.set_point_solid(cell_id, true)


func _find_path_to_target(target: Vector2) -> PackedVector2Array:
	# Candidate-only navigation: a coarse grid is enough to test click movement around
	# room blockers before the final room art and tuned navigation data exist.
	path_failure_reason = ""
	if external_environment_mode:
		if external_environment == null or not external_environment.has_method("playable_find_path"):
			path_failure_reason = "No path: external environment provider missing"
			return PackedVector2Array()
		var external_path := PackedVector2Array(external_environment.call("playable_find_path", player.global_position, target))
		if external_path.is_empty():
			path_failure_reason = "No path: external environment rejected target"
		return external_path
	if path_grid_size == Vector2i.ZERO:
		path_failure_reason = "No path: grid not ready"
		return PackedVector2Array()

	var clamped_target := _clamp_walk_target(target)
	var target_is_blocked := _is_world_point_blocked_for_path(clamped_target)
	if player.global_position.distance_to(clamped_target) <= PATH_TARGET_REACHED_DISTANCE and not target_is_blocked:
		return PackedVector2Array([clamped_target])

	var start_id := _find_nearest_walkable_grid_id(player.global_position)
	if start_id == Vector2i(-1, -1):
		path_failure_reason = "No path: player is outside walkable area"
		return PackedVector2Array()

	var target_id := _find_nearest_walkable_grid_id(clamped_target)
	if target_id == Vector2i(-1, -1):
		path_failure_reason = "No path: target blocked"
		return PackedVector2Array()
	var resolved_target := _grid_id_to_world(target_id) if target_is_blocked else clamped_target

	if start_id == target_id:
		return PackedVector2Array([resolved_target])

	var id_path := path_grid.get_id_path(start_id, target_id, false)
	if id_path.size() == 0:
		path_failure_reason = "No path: empty path"
		return PackedVector2Array()

	var path := PackedVector2Array()
	for id in id_path:
		path.append(_grid_id_to_world(id))

	if path.size() == 0:
		path_failure_reason = "No path: empty path"
		return PackedVector2Array()

	path[path.size() - 1] = resolved_target
	return path


func _find_nearest_walkable_grid_id(world_point: Vector2) -> Vector2i:
	var origin := _world_to_grid_id(world_point)
	if _is_grid_id_walkable(origin):
		return origin

	var best_id := Vector2i(-1, -1)
	var best_distance := INF
	var max_radius: int = max(path_grid_size.x, path_grid_size.y)
	for radius in range(1, max_radius + 1):
		for y in range(origin.y - radius, origin.y + radius + 1):
			for x in range(origin.x - radius, origin.x + radius + 1):
				if abs(x - origin.x) != radius and abs(y - origin.y) != radius:
					continue
				var candidate := Vector2i(x, y)
				if not _is_grid_id_walkable(candidate):
					continue
				var distance := _grid_id_to_world(candidate).distance_to(world_point)
				if distance < best_distance:
					best_distance = distance
					best_id = candidate
		if best_id != Vector2i(-1, -1):
			return best_id

	return best_id


func _world_to_grid_id(world_point: Vector2) -> Vector2i:
	var local := (world_point - WALK_TARGET_BOUNDS.position) / PATH_GRID_CELL_SIZE
	return Vector2i(
		clamp(int(floor(local.x)), 0, max(path_grid_size.x - 1, 0)),
		clamp(int(floor(local.y)), 0, max(path_grid_size.y - 1, 0))
	)


func _grid_id_to_world(cell_id: Vector2i) -> Vector2:
	return WALK_TARGET_BOUNDS.position + Vector2(cell_id) * PATH_GRID_CELL_SIZE + Vector2.ONE * PATH_GRID_CELL_SIZE * 0.5


func _is_grid_id_walkable(cell_id: Vector2i) -> bool:
	if cell_id.x < 0 or cell_id.y < 0 or cell_id.x >= path_grid_size.x or cell_id.y >= path_grid_size.y:
		return false
	return not path_grid.is_point_solid(cell_id)


func _is_world_point_blocked_for_path(world_point: Vector2) -> bool:
	if not WALK_TARGET_BOUNDS.has_point(world_point):
		return true
	if not Geometry2D.is_point_in_polygon(world_point, floor_points):
		return true

	for footprint in blocker_footprints:
		if _is_point_blocked_by_footprint(world_point, footprint, PATH_BLOCKER_PADDING):
			return true

	for rect in blocker_rects:
		if rect.grow(PATH_BLOCKER_PADDING).has_point(world_point):
			return true

	return false


func _is_point_blocked_by_footprint(world_point: Vector2, footprint: PackedVector2Array, padding: float) -> bool:
	if footprint.size() < 3:
		return false
	if not _get_polygon_bounds(footprint).grow(padding).has_point(world_point):
		return false
	if Geometry2D.is_point_in_polygon(world_point, footprint):
		return true
	if padding <= 0.0:
		return false

	for index in footprint.size():
		var start := footprint[index]
		var end := footprint[(index + 1) % footprint.size()]
		if _distance_to_segment(world_point, start, end) <= padding:
			return true
	return false


func _get_polygon_bounds(points: PackedVector2Array) -> Rect2:
	if points.size() == 0:
		return Rect2()

	var min_point := points[0]
	var max_point := points[0]
	for point in points:
		min_point.x = min(min_point.x, point.x)
		min_point.y = min(min_point.y, point.y)
		max_point.x = max(max_point.x, point.x)
		max_point.y = max(max_point.y, point.y)
	return Rect2(min_point, max_point - min_point)


func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)

	var projection := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * projection)


func _build_path_debug() -> void:
	walk_bounds_debug_line = Line2D.new()
	walk_bounds_debug_line.name = "WalkableBounds"
	walk_bounds_debug_line.closed = true
	walk_bounds_debug_line.width = DEBUG_BLOCKER_LINE_WIDTH
	walk_bounds_debug_line.default_color = Color(0.35, 0.62, 1.0, 0.62)
	walk_bounds_debug_line.points = PackedVector2Array([
		WALK_TARGET_BOUNDS.position,
		WALK_TARGET_BOUNDS.position + Vector2(WALK_TARGET_BOUNDS.size.x, 0),
		WALK_TARGET_BOUNDS.end,
		WALK_TARGET_BOUNDS.position + Vector2(0, WALK_TARGET_BOUNDS.size.y),
	])
	debug_layer.add_child(walk_bounds_debug_line)

	path_debug_line = Line2D.new()
	path_debug_line.name = "CurrentPath"
	path_debug_line.width = DEBUG_PATH_LINE_WIDTH
	path_debug_line.default_color = Color(0.28, 0.84, 1.0, 0.86)
	debug_layer.add_child(path_debug_line)

	click_target_debug_line = Line2D.new()
	click_target_debug_line.name = "ClickTarget"
	click_target_debug_line.closed = true
	click_target_debug_line.width = DEBUG_BLOCKER_LINE_WIDTH
	click_target_debug_line.default_color = Color(1.0, 0.84, 0.18, 0.92)
	debug_layer.add_child(click_target_debug_line)

	player_collision_debug_line = Line2D.new()
	player_collision_debug_line.name = "PlayerCollisionRadius"
	player_collision_debug_line.closed = true
	player_collision_debug_line.width = DEBUG_INTERACTION_LINE_WIDTH
	player_collision_debug_line.default_color = Color(0.92, 0.92, 1.0, 0.68)
	debug_layer.add_child(player_collision_debug_line)

	path_failure_label = Label.new()
	path_failure_label.name = "PathFailureLabel"
	path_failure_label.position = DEBUG_FAILURE_LABEL_POSITION
	path_failure_label.add_theme_color_override("font_color", Color(1.0, 0.46, 0.32, 0.92))
	path_failure_label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
	path_failure_label.add_theme_constant_override("outline_size", 3)
	path_failure_label.add_theme_font_size_override("font_size", 14)
	debug_layer.add_child(path_failure_label)

	_update_path_debug(PackedVector2Array(), Vector2.ZERO)
	_update_player_collision_debug()


func _update_path_debug(path: PackedVector2Array, target: Vector2) -> void:
	current_debug_path = path
	current_click_target = target
	has_click_target = target != Vector2.ZERO

	if path_debug_line != null:
		path_debug_line.points = current_debug_path

	if click_target_debug_line != null:
		if has_click_target:
			click_target_debug_line.points = PackedVector2Array([
				current_click_target + Vector2(-DEBUG_CLICK_TARGET_MARKER_HALF_SIZE, -DEBUG_CLICK_TARGET_MARKER_HALF_SIZE),
				current_click_target + Vector2(DEBUG_CLICK_TARGET_MARKER_HALF_SIZE, -DEBUG_CLICK_TARGET_MARKER_HALF_SIZE),
				current_click_target + Vector2(DEBUG_CLICK_TARGET_MARKER_HALF_SIZE, DEBUG_CLICK_TARGET_MARKER_HALF_SIZE),
				current_click_target + Vector2(-DEBUG_CLICK_TARGET_MARKER_HALF_SIZE, DEBUG_CLICK_TARGET_MARKER_HALF_SIZE),
			])
		else:
			click_target_debug_line.points = PackedVector2Array()

	if path_failure_label != null:
		path_failure_label.text = path_failure_reason
		path_failure_label.visible = not path_failure_reason.is_empty()


func _update_player_collision_debug() -> void:
	if player_collision_debug_line == null:
		return

	var points := PackedVector2Array()
	for index in 32:
		var angle := TAU * float(index) / 32.0
		points.append(player.global_position + Vector2(cos(angle), sin(angle)) * PLAYER_COLLISION_DEBUG_RADIUS)
	player_collision_debug_line.points = points


func _update_pending_focus() -> void:
	if pending_focus_key.is_empty():
		return
	if player.has_method("has_active_target") and player.has_active_target():
		return

	var definition := _get_definition(pending_focus_key)
	pending_focus_key = ""
	if definition == null:
		return
	if player.global_position.distance_to(_get_object_interaction_position(definition)) > _get_object_interaction_radius(definition) + OBJECT_APPROACH_INTERACTION_MARGIN:
		return

	nearest_key = definition.key
	nearest_interactable_changed.emit(_external_object_id(definition) if external_environment_mode else definition.key, definition.display_name)
	_update_prompt()
	_emit_interaction_request(definition, ACTION_FOCUS)


func _get_definition_at_position(click_position: Vector2) -> Resource:
	var best_definition: Resource = null
	var best_distance := INF
	var best_priority := INF

	for definition in object_definitions:
		if not _is_click_candidate(definition):
			continue
		if external_environment_mode and not _external_selection_contains(definition, click_position):
			continue

		var distance := click_position.distance_to(_get_object_interaction_position(definition))
		var object_rect := _get_object_click_rect(definition)
		if distance > _get_object_interaction_radius(definition) and not object_rect.has_point(click_position):
			continue

		var priority := _get_object_interaction_priority(definition)
		var candidate_distance := distance
		if object_rect.has_point(click_position):
			candidate_distance = min(candidate_distance, click_position.distance_to(_get_object_position(definition)))

		if priority < best_priority or (priority == best_priority and candidate_distance < best_distance):
			best_definition = definition
			best_distance = candidate_distance
			best_priority = priority

	return best_definition


func _get_hover_definition_at_position(mouse_position: Vector2) -> Resource:
	var best_definition: Resource = null
	var best_distance := INF
	var best_priority := -INF

	for definition in object_definitions:
		if not _is_click_candidate(definition):
			continue
		if external_environment_mode and not _external_selection_contains(definition, mouse_position):
			continue

		var distance := mouse_position.distance_to(_get_object_interaction_position(definition))
		var object_rect := _get_object_click_rect(definition)
		if distance > _get_object_interaction_radius(definition) and not object_rect.has_point(mouse_position):
			continue

		var priority := _get_object_hover_priority(definition)
		var candidate_distance := mouse_position.distance_to(_get_object_position(definition))
		if object_rect.has_point(mouse_position):
			candidate_distance = min(candidate_distance, distance)

		if priority > best_priority or (priority == best_priority and candidate_distance < best_distance):
			best_definition = definition
			best_distance = candidate_distance
			best_priority = priority

	return best_definition


func _get_object_approach_position(definition: Resource) -> Vector2:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		var use_points: Array = external_data.get("use_points_world", [])
		if not use_points.is_empty():
			return _resolve_walkable_target(Vector2(use_points[0]))
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("approach_position", _get_object_interaction_position(definition))
	return _resolve_walkable_target(value)


func _resolve_walkable_target(target: Vector2) -> Vector2:
	if external_environment_mode and external_environment != null and external_environment.has_method("playable_resolve_walk_target"):
		return Vector2(external_environment.call("playable_resolve_walk_target", target))
	var clamped_target := _clamp_walk_target(target)
	if path_grid_size == Vector2i.ZERO or not _is_world_point_blocked_for_path(clamped_target):
		return clamped_target

	var walkable_id := _find_nearest_walkable_grid_id(clamped_target)
	if walkable_id == Vector2i(-1, -1):
		return clamped_target
	return _grid_id_to_world(walkable_id)


func _clamp_walk_target(target: Vector2) -> Vector2:
	if external_environment_mode and external_environment != null and external_environment.has_method("playable_resolve_walk_target"):
		return Vector2(external_environment.call("playable_resolve_walk_target", target))
	return Vector2(
		clampf(
			target.x,
			WALK_TARGET_BOUNDS.position.x + CLICK_TARGET_CLAMP_MARGIN,
			WALK_TARGET_BOUNDS.end.x - CLICK_TARGET_CLAMP_MARGIN
		),
		clampf(
			target.y,
			WALK_TARGET_BOUNDS.position.y + CLICK_TARGET_CLAMP_MARGIN,
			WALK_TARGET_BOUNDS.end.y - CLICK_TARGET_CLAMP_MARGIN
		)
	)


func _is_normal_interactable(definition: Resource) -> bool:
	if definition.has_method("allows_room_interaction"):
		if not definition.allows_room_interaction():
			return false
	elif not definition.interactable:
		return false
	return String(definition.key) != "small_table"


func _is_click_candidate(definition: Resource) -> bool:
	var key := String(definition.key)
	if key in CLICK_ONLY_INTERACTABLE_KEYS:
		return true
	return _is_normal_interactable(definition)


func _get_object_interaction_priority(definition: Resource) -> int:
	return int(INTERACTION_PRIORITY_BY_KEY.get(String(definition.key), INTERACTION_PRIORITY_DEFAULT))


func _get_object_hover_priority(definition: Resource) -> int:
	var explicit_priority := int(definition.get("hover_priority"))
	if explicit_priority != 0:
		return explicit_priority
	return int(round(_get_object_sort_y(definition)))


func _get_object_hover_label(definition: Resource) -> String:
	var label := String(definition.get("hover_label"))
	if not label.is_empty():
		return label
	return String(definition.display_name)


func _get_hover_overlay_texture(definition: Resource) -> Texture2D:
	return definition.get("hover_overlay_texture") as Texture2D


func _get_object_hover_overlay_offset(definition: Resource) -> Vector2:
	var offset: Vector2 = definition.get("hover_overlay_offset")
	return offset


func _get_object_hover_overlay_scale(definition: Resource) -> Vector2:
	var scale: Vector2 = definition.get("hover_overlay_scale")
	if scale == Vector2.ZERO:
		return Vector2.ONE
	return scale


func _get_object_hover_overlay_z_index(definition: Resource) -> int:
	return int(definition.get("hover_overlay_z_index"))


func _get_object_layout(definition: Resource) -> Dictionary:
	return OBJECT_LAYOUT.get(String(definition.key), {})


func _external_object_id(definition: Resource) -> String:
	return String(EXTERNAL_ENVIRONMENT_IDS_BY_LEGACY_KEY.get(String(definition.key), String(definition.key)))


func _external_object_data(definition: Resource) -> Dictionary:
	if not external_environment_mode or external_environment == null or not external_environment.has_method("playable_object_data"):
		return {}
	return external_environment.call("playable_object_data", _external_object_id(definition))


func _external_polygon_bounds(polygons: Array) -> Rect2:
	var bounds := Rect2()
	var has_bounds := false
	for value in polygons:
		var polygon := PackedVector2Array(value)
		if polygon.size() < 3:
			continue
		var polygon_bounds := _get_polygon_bounds(polygon)
		bounds = polygon_bounds if not has_bounds else bounds.merge(polygon_bounds)
		has_bounds = true
	return bounds


func _external_selection_contains(definition: Resource, world_position: Vector2) -> bool:
	var data := _external_object_data(definition)
	for value in data.get("selection_polygons", []):
		var polygon := PackedVector2Array(value)
		if polygon.size() >= 3 and Geometry2D.is_point_in_polygon(world_position, polygon):
			return true
	return false


func _get_object_position(definition: Resource) -> Vector2:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		return Vector2(external_data.get("visual_center_world", Vector2.ZERO))
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("position", definition.position)
	return value


func _get_object_size(definition: Resource) -> Vector2:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		return Vector2(external_data.get("visual_size_px", Vector2.ZERO))
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("size", definition.size)
	return value


func _get_object_thickness(definition: Resource) -> float:
	var layout := _get_object_layout(definition)
	if layout.has("thickness"):
		return max(float(layout["thickness"]), 2.0)
	if definition.get("thickness") != null:
		return max(float(definition.thickness), 2.0)
	return 14.0


func _get_object_color(definition: Resource) -> Color:
	var layout := _get_object_layout(definition)
	if layout.has("color"):
		var layout_color: Color = layout["color"]
		return layout_color
	if definition.get("color") != null:
		return definition.color
	return Color(0.25, 0.20, 0.15, 1.0)


func _get_object_layer(definition: Resource) -> String:
	var layout := _get_object_layout(definition)
	return String(layout.get("layer", definition.layer))


func _get_object_sort_y(definition: Resource) -> float:
	var layout := _get_object_layout(definition)
	if layout.has("sort_y"):
		return float(layout["sort_y"])
	return _get_object_position(definition).y


func _get_object_visual_rect(definition: Resource) -> Rect2:
	return Rect2(
		_get_object_position(definition) - _get_object_size(definition) * 0.5,
		_get_object_size(definition)
	)


func _get_object_blocker_rect(definition: Resource) -> Rect2:
	var layout := _get_object_layout(definition)
	if layout.has("blocker_rect"):
		var rect: Rect2 = layout["blocker_rect"]
		return rect
	if definition.has_method("has_blocker_rect") and definition.has_blocker_rect():
		return definition.blocker_rect
	return Rect2(_get_object_position(definition) - definition.get_collision_size() * 0.5, definition.get_collision_size())


func _get_object_blocker_footprint(definition: Resource) -> PackedVector2Array:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		var polygons: Array = external_data.get("collision_polygons", [])
		return PackedVector2Array(polygons[0]) if not polygons.is_empty() else PackedVector2Array()
	return _get_layout_footprint(_get_object_layout(definition))


func _is_object_footprint_enabled_for_path(definition: Resource) -> bool:
	if not _external_object_data(definition).is_empty():
		return true
	return _is_layout_footprint_enabled_for_path(_get_object_layout(definition))


func _is_layout_footprint_enabled_for_path(layout: Dictionary) -> bool:
	return bool(layout.get("footprint_path_enabled", false))


func _get_layout_footprint(layout: Dictionary) -> PackedVector2Array:
	var value = layout.get("blocker_footprint", PackedVector2Array())
	if value is PackedVector2Array:
		return value
	if value is Array:
		return PackedVector2Array(value)
	return PackedVector2Array()


func _get_object_click_rect(definition: Resource) -> Rect2:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		return _external_polygon_bounds(external_data.get("selection_polygons", []))
	var layout := _get_object_layout(definition)
	if layout.has("click_rect"):
		var click_rect: Rect2 = layout["click_rect"]
		return click_rect
	var padding := float(layout.get("click_padding", CLICK_OBJECT_PADDING))
	return Rect2(
		_get_object_position(definition) - _get_object_size(definition) * 0.5 - Vector2.ONE * padding,
		_get_object_size(definition) + Vector2.ONE * padding * 2.0
	)


func _get_object_interaction_position(definition: Resource) -> Vector2:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		var bounds := _external_polygon_bounds(external_data.get("interaction_polygons", []))
		return bounds.get_center() if bounds.has_area() else _get_object_position(definition)
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("interaction_position", definition.get_interaction_position())
	return value


func _get_object_interaction_radius(definition: Resource) -> float:
	var external_data := _external_object_data(definition)
	if not external_data.is_empty():
		var bounds := _external_polygon_bounds(external_data.get("interaction_polygons", []))
		return maxf(bounds.size.x, bounds.size.y) * 0.5 if bounds.has_area() else 0.0
	var layout := _get_object_layout(definition)
	return float(layout.get("interaction_radius", definition.interaction_radius))


func _rect_to_points(rect: Rect2) -> PackedVector2Array:
	if rect.size == Vector2.ZERO:
		return PackedVector2Array()
	return PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y),
	])


func _format_vector(value: Vector2) -> String:
	return "(%d, %d)" % [int(round(value.x)), int(round(value.y))]


func _format_rect(rect: Rect2) -> String:
	return "(%d, %d, %d, %d)" % [
		int(round(rect.position.x)),
		int(round(rect.position.y)),
		int(round(rect.size.x)),
		int(round(rect.size.y)),
	]


func _format_vector_snippet(value: Vector2) -> String:
	return "Vector2(%d, %d)" % [int(round(value.x)), int(round(value.y))]


func _format_rect_snippet(rect: Rect2) -> String:
	return "Rect2(%s, Vector2(%d, %d))" % [
		_format_vector_snippet(rect.position),
		int(round(rect.size.x)),
		int(round(rect.size.y)),
	]


func _format_footprint_snippet(points: PackedVector2Array) -> String:
	if points.size() == 0:
		return "[]"

	var values := []
	for point in points:
		values.append(_format_vector_snippet(point))
	return "[%s]" % ", ".join(values)


func _add_polygon(parent: Node, points: PackedVector2Array, color: Color) -> void:
	var polygon := Polygon2D.new()
	polygon.polygon = points
	polygon.color = color
	parent.add_child(polygon)


func _add_polyline(parent: Node, points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.closed = true
	line.width = width
	line.default_color = color
	line.points = points
	parent.add_child(line)


func _add_local_polygon(parent: Node, points: PackedVector2Array, color: Color) -> void:
	var polygon := Polygon2D.new()
	polygon.polygon = points
	polygon.color = color
	parent.add_child(polygon)


func _add_local_polyline(parent: Node, points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.closed = true
	line.width = width
	line.default_color = color
	line.points = points
	parent.add_child(line)
