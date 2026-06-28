extends Node2D

signal interaction_requested(object_key: String, action_key: String, payload: Dictionary)
signal nearest_interactable_changed(object_key: String, display_name: String)
signal debug_overlay_toggled(enabled: bool)
signal movement_path_failed(reason: String)

const ACTION_PRIMARY := "primary"
const ACTION_FOCUS := "focus"
const TEMP_BACKGROUND_PATH := "res://assets/art/quarterview/room/temp_qv_room_background.png"
const REFERENCE_BACKGROUND_PATH := "res://assets/art/quarterview/reference/qv_room_concept_reference.png"
const BACKGROUND_TARGET_SIZE := Vector2(1280, 720)
const REFERENCE_OVERLAY_ALPHA := 0.38
const WALK_TARGET_BOUNDS := Rect2(Vector2(190, 190), Vector2(900, 438))
const CLICK_OBJECT_PADDING := 28.0
const PATH_GRID_CELL_SIZE := 24.0
const PATH_BLOCKER_PADDING := 24.0
const PLAYER_COLLISION_DEBUG_RADIUS := 16.0

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
	{"name": "BackWallBlocker", "rect": Rect2(Vector2(244, 76), Vector2(774, 74))},
	{"name": "LeftWallBlocker", "rect": Rect2(Vector2(132, 170), Vector2(92, 400))},
	{"name": "RightWallBlocker", "rect": Rect2(Vector2(1082, 184), Vector2(66, 318))},
	{"name": "FrontLipBlocker", "rect": Rect2(Vector2(392, 636), Vector2(592, 40))},
]

const OBJECT_LAYOUT := {
	"door": {
		"position": Vector2(216, 412),
		"size": Vector2(76, 126),
		"thickness": 12.0,
		"layer": "WallSideLayer",
		"blocker_rect": Rect2(Vector2(166, 344), Vector2(70, 126)),
		"interaction_position": Vector2(272, 482),
		"interaction_radius": 60.0,
		"color": Color(0.21, 0.19, 0.15, 1.0),
	},
	"bathroom_door": {
		"position": Vector2(328, 320),
		"size": Vector2(66, 118),
		"thickness": 10.0,
		"layer": "WallSideLayer",
		"blocker_rect": Rect2(Vector2(290, 256), Vector2(70, 122)),
		"interaction_position": Vector2(382, 386),
		"interaction_radius": 56.0,
		"color": Color(0.30, 0.29, 0.25, 1.0),
	},
	"bed": {
		"position": Vector2(460, 348),
		"size": Vector2(254, 120),
		"thickness": 38.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(324, 290), Vector2(282, 132)),
		"interaction_position": Vector2(548, 452),
		"interaction_radius": 94.0,
		"color": Color(0.23, 0.34, 0.25, 1.0),
	},
	"desk": {
		"position": Vector2(805, 338),
		"size": Vector2(276, 92),
		"thickness": 42.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(652, 292), Vector2(316, 112)),
		"interaction_position": Vector2(790, 428),
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
		"interaction_radius": 84.0,
		"color": Color(0.10, 0.15, 0.17, 1.0),
	},
	"power": {
		"position": Vector2(876, 552),
		"size": Vector2(144, 76),
		"thickness": 54.0,
		"layer": "ForegroundLayer",
		"blocker_rect": Rect2(Vector2(794, 502), Vector2(178, 112)),
		"interaction_position": Vector2(758, 540),
		"interaction_radius": 106.0,
		"color": Color(0.13, 0.15, 0.14, 1.0),
	},
	"ups": {
		"position": Vector2(1012, 542),
		"size": Vector2(86, 62),
		"thickness": 44.0,
		"layer": "ForegroundLayer",
		"blocker_rect": Rect2(Vector2(962, 500), Vector2(108, 92)),
		"interaction_position": Vector2(934, 544),
		"interaction_radius": 82.0,
		"color": Color(0.11, 0.13, 0.15, 1.0),
	},
	"fridge": {
		"position": Vector2(1040, 340),
		"size": Vector2(86, 158),
		"thickness": 26.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(988, 254), Vector2(110, 178)),
		"interaction_position": Vector2(958, 374),
		"interaction_radius": 94.0,
		"color": Color(0.42, 0.46, 0.45, 1.0),
	},
	"microwave": {
		"position": Vector2(1010, 244),
		"size": Vector2(92, 44),
		"thickness": 20.0,
		"layer": "ObjectBackLayer",
		"blocker_rect": Rect2(Vector2(956, 222), Vector2(118, 58)),
		"interaction_position": Vector2(940, 310),
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
		"interaction_radius": 50.0,
		"color": Color(0.31, 0.20, 0.11, 1.0),
	},
	"small_table": {
		"position": Vector2(620, 550),
		"size": Vector2(142, 74),
		"thickness": 28.0,
		"layer": "ObjectLayer",
		"blocker_rect": Rect2(Vector2(540, 506), Vector2(170, 92)),
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
var nearest_key := ""
var debug_enabled := false
var background_mode := "none"
var pending_focus_key := ""
var blocker_rects: Array[Rect2] = []
var path_grid := AStarGrid2D.new()
var path_grid_size := Vector2i.ZERO
var current_debug_path := PackedVector2Array()
var current_click_target := Vector2.ZERO
var has_click_target := false
var path_failure_reason := ""
var prompt_label: Label
var reference_notice_label: Label
var path_debug_line: Line2D
var click_target_debug_line: Line2D
var walk_bounds_debug_line: Line2D
var player_collision_debug_line: Line2D
var path_failure_label: Label
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
	_configure_layers()
	_configure_background_art()
	_build_room_shell()
	_build_visual_details()
	_build_prompt()
	_build_reference_notice()
	_load_object_definitions()
	_build_object_placeholders()
	_build_wall_blockers()
	_rebuild_path_grid()
	_build_path_debug()
	_set_debug_enabled(false)


func _process(_delta: float) -> void:
	_update_nearest_interactable()
	_update_pending_focus()
	_update_player_collision_debug()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_D:
			_set_debug_enabled(not debug_enabled)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_E or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_request_nearest_interaction()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
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
		_add_blocker("%sBlocker" % node.name, visual["blocker_rect"])


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
	for path in OBJECT_RESOURCE_PATHS:
		var definition: Resource = load(path)
		if definition == null:
			push_warning("QuarterviewRoom could not load object definition: %s" % path)
			continue
		if not definition.has_method("is_valid_definition") or not definition.is_valid_definition():
			push_warning("QuarterviewRoom skipped invalid object definition: %s" % path)
			continue
		object_definitions.append(definition)


func _build_object_placeholders() -> void:
	for definition in object_definitions:
		_add_object_placeholder(definition)
		if definition.blocks and _get_object_blocker_rect(definition).size != Vector2.ZERO:
			_add_object_blocker(definition)
		_add_debug_for_definition(definition)


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
	var skew := Vector2(18.0, 12.0)
	var shadow_points := PackedVector2Array([
		Vector2(-half.x + 8.0, -half.y + 18.0),
		Vector2(half.x + 20.0, -half.y + 18.0),
		Vector2(half.x + skew.x + 24.0, half.y + skew.y + depth + 18.0),
		Vector2(-half.x + skew.x + 12.0, half.y + skew.y + depth + 18.0),
	])
	_add_local_polygon(parent, shadow_points, Color(0.0, 0.0, 0.0, 0.22))

	var top_points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x + skew.x, half.y + skew.y),
		Vector2(-half.x + skew.x, half.y + skew.y),
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
		_get_object_blocker_rect(definition)
	)


func _build_wall_blockers() -> void:
	for blocker in WALL_BLOCKERS:
		_add_blocker(blocker["name"], blocker["rect"])


func _add_blocker(blocker_name: String, rect: Rect2) -> void:
	blocker_rects.append(rect)

	var body := StaticBody2D.new()
	body.name = blocker_name
	body.position = rect.position + rect.size * 0.5
	add_child(body)

	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)

	var guide := Line2D.new()
	guide.name = "%sGuide" % blocker_name
	guide.closed = true
	guide.width = 2.0
	guide.default_color = Color(1.0, 0.24, 0.18, 0.72)
	guide.points = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y),
	])
	debug_layer.add_child(guide)


func _add_debug_for_definition(definition: Resource) -> void:
	var label := Label.new()
	label.name = "%sDebugLabel" % String(definition.key).capitalize().replace("_", "")
	label.text = "%s\n%s" % [definition.display_name, definition.role]
	label.position = _get_object_position(definition) + Vector2(-44, -_get_object_size(definition).y * 0.5 - 34)
	label.add_theme_color_override("font_color", Color(0.55, 0.93, 0.96, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.01, 0.01, 0.02, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	debug_layer.add_child(label)

	var radius := Line2D.new()
	radius.name = "%sInteractionRadius" % String(definition.key).capitalize().replace("_", "")
	radius.closed = true
	radius.width = 2.0
	radius.default_color = Color(0.28, 0.88, 0.76, 0.34)
	var points := PackedVector2Array()
	for index in 48:
		var angle := TAU * float(index) / 48.0
		points.append(_get_object_interaction_position(definition) + Vector2(cos(angle), sin(angle)) * _get_object_interaction_radius(definition))
	radius.points = points
	debug_layer.add_child(radius)

	var approach := Line2D.new()
	approach.name = "%sApproachPoint" % String(definition.key).capitalize().replace("_", "")
	approach.closed = true
	approach.width = 2.0
	approach.default_color = Color(1.0, 0.82, 0.24, 0.82)
	var approach_position := _get_object_approach_position(definition)
	approach.points = PackedVector2Array([
		approach_position + Vector2(-6, -6),
		approach_position + Vector2(6, -6),
		approach_position + Vector2(6, 6),
		approach_position + Vector2(-6, 6),
	])
	debug_layer.add_child(approach)


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
	nearest_interactable_changed.emit(nearest_key, best_display_name)
	_update_prompt()


func _update_prompt() -> void:
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


func _request_nearest_interaction() -> void:
	if nearest_key.is_empty():
		return
	var definition := _get_definition(nearest_key)
	if definition == null:
		return

	_emit_interaction_request(definition, ACTION_PRIMARY)


func _emit_interaction_request(definition: Resource, action_key: String) -> void:
	var payload := {
		"key": definition.key,
		"display_name": definition.display_name,
		"role": definition.role,
		"zone": definition.zone,
		"future_source": definition.future_source,
		"visual_state": definition.visual_state,
		"action": action_key,
	}
	interaction_requested.emit(definition.key, action_key, payload)


func _get_definition(object_key: String) -> Resource:
	for definition in object_definitions:
		if definition.key == object_key:
			return definition
	return null


func _set_debug_enabled(enabled: bool) -> void:
	debug_enabled = enabled
	for layer in [
		floor_layer,
		wall_back_layer,
		wall_side_layer,
		object_back_layer,
		object_layer,
		foreground_layer,
	]:
		layer.visible = debug_enabled
	debug_layer.visible = debug_enabled
	if player.has_method("set_keyboard_input_enabled"):
		player.set_keyboard_input_enabled(debug_enabled)
	debug_overlay_toggled.emit(debug_enabled)


func get_background_mode() -> String:
	return background_mode


func is_debug_overlay_enabled() -> bool:
	return debug_enabled


func _handle_left_click(click_position: Vector2) -> void:
	var clicked_definition := _get_definition_at_position(click_position)
	if clicked_definition != null and _is_normal_interactable(clicked_definition):
		if _move_player_to(_get_object_approach_position(clicked_definition)):
			pending_focus_key = clicked_definition.key
		else:
			pending_focus_key = ""
		return

	pending_focus_key = ""
	_move_player_to(_clamp_walk_target(click_position))


func _move_player_to(target: Vector2) -> bool:
	var path := _find_path_to_target(target)
	if path.size() == 0:
		if player.has_method("clear_move_target"):
			player.clear_move_target()
		_update_path_debug(PackedVector2Array(), _clamp_walk_target(target))
		movement_path_failed.emit(path_failure_reason)
		return false

	if player.has_method("set_path"):
		player.set_path(path)
	else:
		player.set_move_target(path[path.size() - 1])
	_update_path_debug(path, path[path.size() - 1])
	return true


func _rebuild_path_grid() -> void:
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
	var start_id := _find_nearest_walkable_grid_id(player.global_position)
	if start_id == Vector2i(-1, -1):
		path_failure_reason = "No path: player is outside walkable area"
		return PackedVector2Array()

	var clamped_target := _clamp_walk_target(target)
	var target_id := _find_nearest_walkable_grid_id(clamped_target)
	if target_id == Vector2i(-1, -1):
		path_failure_reason = "No path: target is outside walkable area"
		return PackedVector2Array()

	var id_path := path_grid.get_id_path(start_id, target_id, false)
	if id_path.size() == 0:
		path_failure_reason = "No path: blocked by room objects"
		return PackedVector2Array()

	var path := PackedVector2Array()
	for id in id_path:
		path.append(_grid_id_to_world(id))

	if path.size() > 0:
		path[path.size() - 1] = _grid_id_to_world(target_id)
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

	for rect in blocker_rects:
		if rect.grow(PATH_BLOCKER_PADDING).has_point(world_point):
			return true

	return false


func _build_path_debug() -> void:
	walk_bounds_debug_line = Line2D.new()
	walk_bounds_debug_line.name = "WalkableBounds"
	walk_bounds_debug_line.closed = true
	walk_bounds_debug_line.width = 2.0
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
	path_debug_line.width = 4.0
	path_debug_line.default_color = Color(0.28, 0.84, 1.0, 0.86)
	debug_layer.add_child(path_debug_line)

	click_target_debug_line = Line2D.new()
	click_target_debug_line.name = "ClickTarget"
	click_target_debug_line.closed = true
	click_target_debug_line.width = 3.0
	click_target_debug_line.default_color = Color(1.0, 0.84, 0.18, 0.92)
	debug_layer.add_child(click_target_debug_line)

	player_collision_debug_line = Line2D.new()
	player_collision_debug_line.name = "PlayerCollisionRadius"
	player_collision_debug_line.closed = true
	player_collision_debug_line.width = 2.0
	player_collision_debug_line.default_color = Color(0.92, 0.92, 1.0, 0.68)
	debug_layer.add_child(player_collision_debug_line)

	path_failure_label = Label.new()
	path_failure_label.name = "PathFailureLabel"
	path_failure_label.position = Vector2(24, 616)
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
				current_click_target + Vector2(-9, -9),
				current_click_target + Vector2(9, -9),
				current_click_target + Vector2(9, 9),
				current_click_target + Vector2(-9, 9),
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
	if player.global_position.distance_to(_get_object_interaction_position(definition)) > _get_object_interaction_radius(definition):
		return

	nearest_key = definition.key
	nearest_interactable_changed.emit(definition.key, definition.display_name)
	_update_prompt()
	_emit_interaction_request(definition, ACTION_FOCUS)


func _get_definition_at_position(click_position: Vector2) -> Resource:
	var best_definition: Resource = null
	var best_distance := INF

	for definition in object_definitions:
		if not _is_normal_interactable(definition):
			continue

		var distance := click_position.distance_to(_get_object_interaction_position(definition))
		if distance <= _get_object_interaction_radius(definition) and distance < best_distance:
			best_definition = definition
			best_distance = distance
			continue

		var object_rect := Rect2(
			_get_object_position(definition) - _get_object_size(definition) * 0.5 - Vector2.ONE * CLICK_OBJECT_PADDING,
			_get_object_size(definition) + Vector2.ONE * CLICK_OBJECT_PADDING * 2.0
		)
		if object_rect.has_point(click_position):
			var rect_distance := click_position.distance_to(_get_object_position(definition))
			if rect_distance < best_distance:
				best_definition = definition
				best_distance = rect_distance

	return best_definition


func _get_object_approach_position(definition: Resource) -> Vector2:
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("approach_position", _get_object_interaction_position(definition))
	return _clamp_walk_target(value)


func _clamp_walk_target(target: Vector2) -> Vector2:
	return Vector2(
		clampf(target.x, WALK_TARGET_BOUNDS.position.x, WALK_TARGET_BOUNDS.end.x),
		clampf(target.y, WALK_TARGET_BOUNDS.position.y, WALK_TARGET_BOUNDS.end.y)
	)


func _is_normal_interactable(definition: Resource) -> bool:
	if not definition.interactable:
		return false
	return String(definition.key) != "small_table"


func _get_object_layout(definition: Resource) -> Dictionary:
	return OBJECT_LAYOUT.get(String(definition.key), {})


func _get_object_position(definition: Resource) -> Vector2:
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("position", definition.position)
	return value


func _get_object_size(definition: Resource) -> Vector2:
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


func _get_object_blocker_rect(definition: Resource) -> Rect2:
	var layout := _get_object_layout(definition)
	if layout.has("blocker_rect"):
		var rect: Rect2 = layout["blocker_rect"]
		return rect
	if definition.has_method("has_blocker_rect") and definition.has_blocker_rect():
		return definition.blocker_rect
	return Rect2(_get_object_position(definition) - definition.get_collision_size() * 0.5, definition.get_collision_size())


func _get_object_interaction_position(definition: Resource) -> Vector2:
	var layout := _get_object_layout(definition)
	var value: Vector2 = layout.get("interaction_position", definition.get_interaction_position())
	return value


func _get_object_interaction_radius(definition: Resource) -> float:
	var layout := _get_object_layout(definition)
	return float(layout.get("interaction_radius", definition.interaction_radius))


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
