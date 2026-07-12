extends Node2D

const ApartmentWallSegmentConfigScript := preload("res://scripts/quarterview/ApartmentWallSegmentConfig.gd")
const ApartmentObjectFootprintConfigScript := preload("res://scripts/quarterview/ApartmentObjectFootprintConfig.gd")
const ApartmentObjectFootprintSetConfigScript := preload("res://scripts/quarterview/ApartmentObjectFootprintSetConfig.gd")

enum ViewOrientation {
	FRONT_RIGHT,
	FRONT_LEFT,
	BACK_RIGHT,
	BACK_LEFT,
}

enum MapRotation {
	ROTATE_0,
	ROTATE_90,
	ROTATE_180,
	ROTATE_270,
}

enum DebugMode {
	NONE,
	ROOM_MEASUREMENT,
	OBJECT_PLACEMENT,
	NAVIGATION,
}

enum WallAxis {
	AXIS_A,
	AXIS_B,
}

enum WallType {
	NORMAL,
	DOORWAY_EMPTY,
	DOORWAY_FRAME,
	CUTAWAY_STUB,
	END,
	CORNER,
}

enum WallRenderMode {
	FULL,
	CUTAWAY_STUB,
	HIDDEN_STUB,
	LOGICAL_ONLY,
	REVEALABLE,
}

const DEFAULT_TILE_WIDTH := 128.0
const DEFAULT_TILE_HEIGHT := 64.0
const DEFAULT_WALL_HEIGHT := 176.0
const DEFAULT_WALL_CAP_HEIGHT := 16.0
const DEFAULT_BASEBOARD_HEIGHT := 18.0
const DEFAULT_CUTAWAY_FRONT_STUB_HEIGHT := 42.0
const DEFAULT_MAP_ORIGIN := Vector2(420.0, 270.0)
const DEFAULT_MAP_ROTATION_PIVOT := Vector2(5.5, 5.0)

const DEFAULT_WORK_ROOM_ORIGIN := Vector2i(1, 0)
const DEFAULT_WORK_ROOM_SIZE := Vector2i(8, 4)
const DEFAULT_LIVING_ROOM_ORIGIN := Vector2i(0, 4)
const DEFAULT_LIVING_ROOM_SIZE := Vector2i(11, 6)
const DEFAULT_BATHROOM_ROOM_ORIGIN := Vector2i(0, 4)
const DEFAULT_BATHROOM_ROOM_SIZE := Vector2i(2, 3)
const DEFAULT_ENTRANCE_ROOM_ORIGIN := Vector2i(0, 7)
const DEFAULT_ENTRANCE_ROOM_SIZE := Vector2i(2, 3)
const DEFAULT_SERVICE_ROOM_ORIGIN := Vector2i(0, 9)
const DEFAULT_SERVICE_ROOM_SIZE := Vector2i(2, 1)
const DEFAULT_NO_LARGE_OBJECT_ZONE_ORIGIN := Vector2i(2, 8)
const DEFAULT_NO_LARGE_OBJECT_ZONE_SIZE := Vector2i(8, 2)

const DEFAULT_CONNECTION_DOOR_OFFSET := 6
const DEFAULT_CONNECTION_DOOR_WIDTH := 1
const DEFAULT_ENTRANCE_DOOR_OFFSET := 4
const DEFAULT_ENTRANCE_DOOR_WIDTH := 1
const DEFAULT_BATHROOM_DOOR_OFFSET := 0
const DEFAULT_BATHROOM_DOOR_WIDTH := 1
const DEFAULT_SERVICE_DOOR_OFFSET := 0
const DEFAULT_SERVICE_DOOR_WIDTH := 1
const DEFAULT_LIVING_WINDOW_AXIS_A := 11.0
const DEFAULT_LIVING_WINDOW_B_START := 5.2
const DEFAULT_LIVING_WINDOW_WIDTH := 1.65

const DEFAULT_FULL_MAP_CAMERA_CENTER_OFFSET := Vector2(-24.0, 72.0)
const DEFAULT_FULL_MAP_CAMERA_ZOOM := Vector2(0.58, 0.58)
const DEFAULT_LIVING_CAMERA_CENTER_OFFSET := Vector2(70.0, -16.0)
const DEFAULT_LIVING_CAMERA_ZOOM := Vector2(0.92, 0.92)
const DEFAULT_WORK_CAMERA_CENTER_OFFSET := Vector2(28.0, -78.0)
const DEFAULT_WORK_CAMERA_ZOOM := Vector2(1.0, 1.0)

# Axis A runs screen lower-left <-> upper-right. Axis B runs screen upper-left <-> lower-right.
# That note describes the default FRONT_RIGHT projection; other orientations swap the basis vectors.
const COLOR_BACKGROUND := Color(0.018, 0.02, 0.026, 1.0)
const COLOR_FLOOR := Color(0.67, 0.67, 0.62, 1.0)
const COLOR_FLOOR_ALT := Color(0.72, 0.71, 0.66, 1.0)
const COLOR_FLOOR_WORK := Color(0.62, 0.65, 0.66, 1.0)
const COLOR_FLOOR_BATH := Color(0.58, 0.61, 0.62, 1.0)
const COLOR_FLOOR_LINE := Color(0.33, 0.34, 0.33, 0.68)
const COLOR_FLOOR_EDGE := Color(0.30, 0.31, 0.31, 1.0)
const COLOR_FRONT_STUB := Color(0.25, 0.26, 0.25, 1.0)
const COLOR_WALL := Color(0.72, 0.68, 0.60, 1.0)
const COLOR_WALL_SIDE := Color(0.62, 0.60, 0.55, 1.0)
const COLOR_WALL_CAP := Color(0.42, 0.43, 0.42, 1.0)
const COLOR_BASEBOARD := Color(0.36, 0.37, 0.36, 1.0)
const COLOR_INNER_DOOR := Color(0.28, 0.47, 0.49, 1.0)
const COLOR_ENTRANCE_DOOR := Color(0.18, 0.17, 0.15, 1.0)
const COLOR_SERVICE_DOOR := Color(0.46, 0.50, 0.50, 1.0)
const COLOR_WINDOW := Color(0.42, 0.72, 0.92, 0.9)
const COLOR_NO_OBJECT_ZONE := Color(1.0, 0.66, 0.20, 0.22)
const COLOR_LABEL := Color(0.96, 0.91, 0.75, 1.0)
const COLOR_LABEL_SHADOW := Color(0.01, 0.012, 0.016, 0.88)
const COLOR_WALL_START_MARKER := Color(0.18, 0.95, 0.68, 0.95)
const COLOR_WALL_END_MARKER := Color(1.0, 0.42, 0.32, 0.95)
const COLOR_WALL_ID_BACKGROUND := Color(0.02, 0.025, 0.03, 0.82)
const COLOR_GRID_COORD := Color(0.82, 0.93, 1.0, 0.96)
const COLOR_GRID_LABEL_BACKGROUND := Color(0.02, 0.34, 0.30, 0.76)
const COLOR_GRID_LABEL_TEXT := Color(0.76, 1.0, 0.90, 1.0)
const COLOR_GRID_ORIGIN := Color(1.0, 0.92, 0.22, 1.0)
const COLOR_GRID_AXIS_X := Color(0.35, 0.78, 1.0, 0.95)
const COLOR_GRID_AXIS_Y := Color(0.50, 1.0, 0.60, 0.95)
const COLOR_WALL_EDGE_COORD := Color(1.0, 0.84, 0.46, 0.98)
const COLOR_WALL_EDGE_LABEL_BACKGROUND := Color(0.36, 0.18, 0.02, 0.78)
const COLOR_WALL_EDGE_MARKER := Color(1.0, 0.54, 0.18, 0.92)
const COLOR_WALL_EDGE_HOVER := Color(1.0, 0.74, 0.14, 1.0)
const COLOR_NAV_WALKABLE := Color(0.22, 0.92, 0.66, 0.24)
const COLOR_NAV_WALKABLE_MARKER := Color(0.44, 1.0, 0.78, 0.72)
const COLOR_NAV_BLOCKED_EDGE := Color(1.0, 0.30, 0.18, 0.92)
const COLOR_NAV_OCCLUSION_EDGE := Color(1.0, 0.56, 0.18, 0.95)
const COLOR_NAV_PASSABLE_EDGE := Color(0.22, 0.86, 1.0, 0.96)
const COLOR_NAV_PLAYER := Color(1.0, 0.92, 0.24, 0.96)
const COLOR_NAV_LABEL_BACKGROUND := Color(0.02, 0.18, 0.13, 0.78)
const COLOR_OBJECT_LABEL_BACKGROUND := Color(0.10, 0.08, 0.04, 0.80)
const COLOR_OCCLUSION_LABEL_BACKGROUND := Color(0.28, 0.15, 0.02, 0.82)
const COLOR_OCCLUSION_STUB_BODY := Color(0.20, 0.22, 0.22, 0.58)
const COLOR_OCCLUSION_STUB_CAP := Color(0.58, 0.61, 0.58, 0.90)
const COLOR_OCCLUSION_STUB_SHADOW := Color(0.03, 0.035, 0.04, 0.58)
const COLOR_OCCLUSION_STUB_DEBUG := Color(1.0, 0.62, 0.16, 0.95)
const COLOR_OBJECT_INTERACTION := Color(1.0, 0.58, 0.16, 0.96)
const COLOR_OBJECT_INTERACTION_AREA := Color(1.0, 0.50, 0.10, 0.94)
const COLOR_OBJECT_SELECTION_AREA := Color(0.18, 0.92, 0.92, 0.96)
const COLOR_OBJECT_BASE_POINT := Color(0.28, 1.0, 0.46, 0.98)
const COLOR_OBJECT_TOP_POINT := Color(1.0, 0.88, 0.24, 0.98)
const COLOR_OBJECT_BLOCKED_CELL := Color(1.0, 0.28, 0.20, 0.92)
const COLOR_OBJECT_VISUAL_BOUNDS := Color(0.82, 0.95, 1.0, 0.88)
const COLOR_OBJECT_OCCUPANCY := Color(0.38, 0.36, 1.0, 0.26)
const COLOR_OBJECT_OCCUPANCY_OUTLINE := Color(0.56, 0.58, 1.0, 0.92)
const COLOR_OBJECT_ATTACHMENT := Color(0.92, 0.42, 1.0, 0.96)
const COLOR_OBJECT_LEGEND_BACKGROUND := Color(0.055, 0.035, 0.10, 0.92)
const DIRECT_INTERACTION_OBJECT_IDS := [
	"entrance_door", "bed", "fridge", "microwave", "navi_link",
	"power_module_board", "node_17",
]
const EDITABLE_NODE_OBJECT_IDS := ["fridge", "navi_link", "power_module_board", "microwave"]
const EDITABLE_OBJECT_NODES_PATH := ^"EditableObjectNodes"
const OBJECT_ANCHOR_HIT_RADIUS := 18.0
const OBJECT_CLICK_CYCLE_RADIUS := 3.0
const WALL_INSPECTION_ALPHA := 0.18
const COLOR_DEBUG_PANEL := Color(0.025, 0.03, 0.038, 0.92)
const COLOR_DEBUG_PANEL_ALT := Color(0.045, 0.055, 0.068, 0.94)
const COLOR_DEBUG_PANEL_BORDER := Color(0.46, 0.66, 0.70, 0.70)
const COLOR_DEBUG_PANEL_BACKDROP := Color(0.0, 0.0, 0.0, 0.48)
const COLOR_DEBUG_TEXT := Color(0.92, 0.94, 0.90, 1.0)
const COLOR_DEBUG_MUTED_TEXT := Color(0.68, 0.76, 0.78, 1.0)
const COLOR_MEASUREMENT_ENTRANCE := Color(0.96, 0.72, 0.26, 0.18)
const COLOR_MEASUREMENT_BATHROOM := Color(0.32, 0.72, 0.96, 0.18)
const COLOR_MEASUREMENT_LIVING := Color(0.34, 0.88, 0.58, 0.13)
const COLOR_MEASUREMENT_WORK := Color(0.48, 0.54, 1.0, 0.16)
const COLOR_MEASUREMENT_WALKABLE := Color(0.30, 1.0, 0.72, 0.72)
const COLOR_MEASUREMENT_PLACEMENT := Color(0.36, 0.78, 1.0, 0.34)
const COLOR_MEASUREMENT_DOOR_CLEARANCE := Color(1.0, 0.82, 0.24, 0.46)
const COLOR_MEASUREMENT_MAIN_PATH := Color(0.94, 0.48, 1.0, 0.34)
const COLOR_MEASUREMENT_WALL_AVAILABLE := Color(0.28, 1.0, 0.56, 0.96)
const COLOR_MEASUREMENT_WALL_UNAVAILABLE := Color(1.0, 0.32, 0.26, 0.90)
const COLOR_MEASUREMENT_WALL_LOGICAL := Color(0.30, 0.90, 1.0, 0.96)
const COLOR_MEASUREMENT_LABEL_BACKGROUND := Color(0.018, 0.035, 0.04, 0.90)

@export_group("View Orientation")
# view_orientation controls the isometric projection basis / mirroring only.
@export var view_orientation: ViewOrientation = ViewOrientation.FRONT_RIGHT
@export var map_origin := DEFAULT_MAP_ORIGIN

@export_group("Map Rotation")
# Compatibility setting: this pass is authored and manually reviewed at the current ROTATE_90
# reference view. Other rotations remain available but are not a visual target for this pass.
@export var map_rotation: MapRotation = MapRotation.ROTATE_90
@export var map_rotation_pivot := DEFAULT_MAP_ROTATION_PIVOT

@export_group("Shell Dimensions")
@export var tile_width := DEFAULT_TILE_WIDTH
@export var tile_height := DEFAULT_TILE_HEIGHT
@export var wall_height := DEFAULT_WALL_HEIGHT
@export var wall_cap_height := DEFAULT_WALL_CAP_HEIGHT
@export var baseboard_height := DEFAULT_BASEBOARD_HEIGHT
@export var cutaway_front_stub_height := DEFAULT_CUTAWAY_FRONT_STUB_HEIGHT

@export_group("Shell Colors")
@export var wall_color := COLOR_WALL
@export var wall_side_color := COLOR_WALL_SIDE
@export var wall_cap_color := COLOR_WALL_CAP
@export var baseboard_color := COLOR_BASEBOARD
@export var cutaway_stub_color := COLOR_FRONT_STUB
@export var doorway_debug_color := COLOR_INNER_DOOR
@export var inner_door_color := COLOR_INNER_DOOR
@export var entrance_door_color := COLOR_ENTRANCE_DOOR
@export var service_door_color := COLOR_SERVICE_DOOR

@export_group("Layout Rects")
@export var work_room_origin := DEFAULT_WORK_ROOM_ORIGIN
@export var work_room_size := DEFAULT_WORK_ROOM_SIZE
@export var living_room_origin := DEFAULT_LIVING_ROOM_ORIGIN
@export var living_room_size := DEFAULT_LIVING_ROOM_SIZE
@export var bathroom_room_origin := DEFAULT_BATHROOM_ROOM_ORIGIN
@export var bathroom_room_size := DEFAULT_BATHROOM_ROOM_SIZE
@export var entrance_room_origin := DEFAULT_ENTRANCE_ROOM_ORIGIN
@export var entrance_room_size := DEFAULT_ENTRANCE_ROOM_SIZE
@export var service_room_origin := DEFAULT_SERVICE_ROOM_ORIGIN
@export var service_room_size := DEFAULT_SERVICE_ROOM_SIZE
@export var no_large_object_zone_origin := DEFAULT_NO_LARGE_OBJECT_ZONE_ORIGIN
@export var no_large_object_zone_size := DEFAULT_NO_LARGE_OBJECT_ZONE_SIZE

@export_group("Wall Segment Editing")
# Leave this empty to use the named default shell walls below. Add Resource items here to test
# wall movement, deletion, or extra walls without touching the renderer.
@export var custom_wall_segments: Array[Resource] = []

@export_group("Object Footprint Editing")
# Fridge, NAVI LINK, Power Board, and Microwave use EditableObjectNodes as the exact ROTATE_90
# pixel-geometry authority. This Resource set remains logical/grid data for the other objects.
@export var object_footprint_set: ApartmentObjectFootprintSetConfig
# Custom entries are additive shell tests. Keep ids unique unless you intentionally want overlap
# warnings while comparing a custom footprint against the Resource-backed baseline.
@export var custom_object_footprints: Array[Resource] = []

@export_group("Window Layout")
@export var living_window_axis_a := DEFAULT_LIVING_WINDOW_AXIS_A
@export var living_window_axis_b_start := DEFAULT_LIVING_WINDOW_B_START
@export var living_window_width := DEFAULT_LIVING_WINDOW_WIDTH

@export_group("Camera Presets")
@export var full_map_camera_center_offset := DEFAULT_FULL_MAP_CAMERA_CENTER_OFFSET
@export var full_map_camera_zoom := DEFAULT_FULL_MAP_CAMERA_ZOOM
@export var living_camera_center_offset := DEFAULT_LIVING_CAMERA_CENTER_OFFSET
@export var living_camera_zoom := DEFAULT_LIVING_CAMERA_ZOOM
@export var work_camera_center_offset := DEFAULT_WORK_CAMERA_CENTER_OFFSET
@export var work_camera_zoom := DEFAULT_WORK_CAMERA_ZOOM
@export_enum("full_map", "living_area", "work_power_area") var camera_preset: String = "full_map"

@export_group("Debug")
@export var active_debug_mode: DebugMode = DebugMode.NONE
@export var allow_combined_debug_overlays := false
@export var show_debug_labels := true
@export var show_wall_ids := false
@export var show_floor_grid_coords := false
# Shows wall grid-line vertices / edges. Wall segments use these coordinates, not floor centers.
@export var show_wall_edge_coords := false
# Shows walkable cells, logical blocked edges, passable doorway edges, and the shell-only marker.
@export var show_navigation_debug := false
# Shows coordinate-based furniture / device footprint placeholders. These are shell-only guides.
@export var show_object_placeholders := false
@export var show_object_labels := true
@export var show_object_interaction_cells := true
@export var show_blocking_object_cells := true
@export var show_nonblocking_object_cells := true
@export_group("Object Placement Debug")
@export var show_object_names := true
@export var show_object_floor_footprints := true
@export var show_object_collision_shapes := true
@export var show_object_interaction_areas := true
@export var show_object_visual_bounds := false
@export var show_object_parent_links := true
@export_group("Debug")
# Highlights logical occlusion walls that are rendered as low stubs in the current shell view.
@export var show_occlusion_wall_debug := false
# Visual-only inspection aid. It lowers every candidate wall/door/window visual layer opacity
# without changing wall data, navigation edges, reveal state, or collision ownership.
@export var wall_inspection_transparency := false
# Shows room dimensions, placement reference cells, doorway clearance, and wall-mount spans.
@export var show_room_measurements := false
@export_range(0, 3, 1) var doorway_clearance_cells := 1
@export_range(0, 3, 1) var main_path_clearance_cells := 1
# Preview helper only: draw REVEALABLE walls at full height without adding character/area logic.
@export var preview_revealed_walls := false
# Shell-only reveal test. When true, REVEALABLE walls can become full walls for the active room area.
@export var debug_auto_reveal_walls := false
@export var debug_focus_wall_id := ""
@export var debug_focus_object_id := ""
@export var player_debug_cell := Vector2i(1, 8)

@onready var camera_2d: Camera2D = $Camera2D

var _background_layer: Node2D
var _floor_layer: Node2D
var _zone_layer: Node2D
var _edge_layer: Node2D
var _occlusion_stub_layer: Node2D
var _wall_layer: Node2D
var _door_layer: Node2D
var _label_layer: Node2D
var _object_layer: Node2D
var _debug_selection_layer: Node2D
var _navigation_layer: Node2D
var _grid_coord_layer: Node2D
var _wall_edge_coord_layer: Node2D
var _hover_edge_highlight_layer: Node2D
var _wall_id_layer: Node2D
var _occlusion_debug_layer: Node2D
var _room_measurement_layer: Node2D
var _debug_overlay_layer: CanvasLayer
var _debug_detail_panel: PanelContainer
var _debug_detail_label: Label
var _debug_help_panel: PanelContainer
var _compact_help_label: Label
var _hover_coord_label: Label
var _hover_coord_background: ColorRect
var _hover_edge_label: Label
var _hover_edge_background: ColorRect
var _active_room_label: Label
var _active_room_background: ColorRect
var _measurement_legend_label: Label
var _measurement_legend_background: ColorRect
var _object_legend_label: Label
var _object_legend_background: ColorRect
var _measurement_summary_label: Label
var _measurement_summary_background: ColorRect
var _player_debug_marker: Polygon2D
var _player_debug_label: Label
var _interaction_menu_panel: PanelContainer
var _interaction_object_list: VBoxContainer
var _interaction_panel: PanelContainer
var _interaction_title_label: Label
var _interaction_body_label: Label
var _interaction_result_label: Label
var _interaction_active_object_id := ""
var _phone_overlay_root: Control
var _phone_content_label: Label
var _last_active_room_area := ""
var _hovered_object_id := ""
var _hovered_object_candidates: Array[Dictionary] = []
var _selected_object_id := ""
var _selected_candidate_ids: Array[String] = []
var _selected_candidate_index := -1
var _selected_hit_kind := ""
var _last_selection_signature := ""
var _last_selection_world_position := Vector2(INF, INF)


func _ready() -> void:
	_initialize_debug_mode_from_legacy_flags()
	_create_layers()
	_build_shell()
	_apply_wall_inspection_transparency()
	_validate_object_footprints()
	_apply_camera_preset(camera_preset)
	_update_label_visibility()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if _close_top_debug_overlay():
				get_viewport().set_input_as_handled()
				return
			if _has_primary_debug_mode():
				_set_primary_debug_mode(DebugMode.NONE)
				get_viewport().set_input_as_handled()
				return
		if event.keycode == KEY_F1:
			_toggle_full_debug_help()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_L:
			show_debug_labels = not show_debug_labels
			_update_label_visibility()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_W:
			show_wall_ids = not show_wall_ids
			_update_label_visibility()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_G:
			show_floor_grid_coords = not show_floor_grid_coords
			_update_label_visibility()
			_update_hover_cell()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_E:
			show_wall_edge_coords = not show_wall_edge_coords
			_update_label_visibility()
			_update_hover_cell()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_N:
			_toggle_primary_debug_mode(DebugMode.NAVIGATION, event.shift_pressed)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_P:
			_toggle_primary_debug_mode(DebugMode.OBJECT_PLACEMENT, event.shift_pressed)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_O:
			show_occlusion_wall_debug = not show_occlusion_wall_debug
			_update_label_visibility()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_V:
			wall_inspection_transparency = not wall_inspection_transparency
			_apply_wall_inspection_transparency()
			_update_compact_debug_help()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_M:
			_toggle_primary_debug_mode(DebugMode.ROOM_MEASUREMENT, event.shift_pressed)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_J:
			_toggle_interaction_debug_menu()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_H:
			_toggle_phone_overlay()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_I:
			print_wall_segment_inventory()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_1:
			set_camera_preset("full_map")
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_2:
			set_camera_preset("living_area")
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_3:
			set_camera_preset("work_power_area")
			get_viewport().set_input_as_handled()
			return
		if show_navigation_debug and _try_move_player_debug_marker(event.keycode):
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseMotion:
		_update_hover_cell()
		_update_object_hover_at(_mouse_event_world_position(event))
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if show_object_placeholders:
			var click_world_position := _mouse_event_world_position(event)
			_update_object_hover_at(click_world_position)
			if _select_hovered_object(click_world_position):
				get_viewport().set_input_as_handled()
				return
		var hover_cell: Variant = _hover_floor_cell()
		var printed_click := false
		if show_floor_grid_coords and hover_cell != null:
			var clicked_cell: Vector2i = hover_cell
			_print_clicked_cell_edges(clicked_cell)
			printed_click = true
		if show_wall_edge_coords:
			var edge_info := _hover_wall_edge()
			if not edge_info.is_empty():
				_print_clicked_wall_edge(edge_info)
				printed_click = true
		if show_navigation_debug and hover_cell != null:
			_print_clicked_cell_navigation(hover_cell)
			printed_click = true
		if printed_click:
			get_viewport().set_input_as_handled()


func set_camera_preset(preset: String) -> void:
	camera_preset = preset
	_apply_camera_preset(camera_preset)


func _apply_wall_inspection_transparency() -> void:
	var alpha := WALL_INSPECTION_ALPHA if wall_inspection_transparency else 1.0
	for layer in [_occlusion_stub_layer, _wall_layer, _door_layer]:
		if layer != null:
			layer.modulate.a = alpha


func _initialize_debug_mode_from_legacy_flags() -> void:
	if active_debug_mode != DebugMode.NONE and not allow_combined_debug_overlays:
		_set_primary_debug_flags(active_debug_mode)
		return
	if allow_combined_debug_overlays:
		active_debug_mode = _most_recent_enabled_debug_mode()
		return
	if show_navigation_debug:
		_set_primary_debug_flags(DebugMode.NAVIGATION)
	elif show_object_placeholders:
		_set_primary_debug_flags(DebugMode.OBJECT_PLACEMENT)
	elif show_room_measurements:
		_set_primary_debug_flags(DebugMode.ROOM_MEASUREMENT)
	else:
		_set_primary_debug_flags(DebugMode.NONE)


func _toggle_primary_debug_mode(mode: DebugMode, combine := false) -> void:
	if allow_combined_debug_overlays or combine:
		match mode:
			DebugMode.ROOM_MEASUREMENT:
				show_room_measurements = not show_room_measurements
			DebugMode.OBJECT_PLACEMENT:
				show_object_placeholders = not show_object_placeholders
			DebugMode.NAVIGATION:
				show_navigation_debug = not show_navigation_debug
		active_debug_mode = mode if _debug_mode_is_enabled(mode) else _most_recent_enabled_debug_mode()
		_update_label_visibility()
		return
	_set_primary_debug_mode(DebugMode.NONE if active_debug_mode == mode else mode)


func _set_primary_debug_mode(mode: DebugMode) -> void:
	active_debug_mode = mode
	_set_primary_debug_flags(mode)
	_update_label_visibility()


func _set_primary_debug_flags(mode: DebugMode) -> void:
	show_room_measurements = mode == DebugMode.ROOM_MEASUREMENT
	show_object_placeholders = mode == DebugMode.OBJECT_PLACEMENT
	show_navigation_debug = mode == DebugMode.NAVIGATION


func _debug_mode_is_enabled(mode: DebugMode) -> bool:
	match mode:
		DebugMode.ROOM_MEASUREMENT:
			return show_room_measurements
		DebugMode.OBJECT_PLACEMENT:
			return show_object_placeholders
		DebugMode.NAVIGATION:
			return show_navigation_debug
	return not _has_primary_debug_mode()


func _most_recent_enabled_debug_mode() -> DebugMode:
	if show_navigation_debug:
		return DebugMode.NAVIGATION
	if show_object_placeholders:
		return DebugMode.OBJECT_PLACEMENT
	if show_room_measurements:
		return DebugMode.ROOM_MEASUREMENT
	return DebugMode.NONE


func _has_primary_debug_mode() -> bool:
	return show_room_measurements or show_object_placeholders or show_navigation_debug


func _debug_mode_display_name() -> String:
	var names: Array[String] = []
	if show_room_measurements:
		names.append("방 측량")
	if show_object_placeholders:
		names.append("오브젝트 배치")
	if show_navigation_debug:
		names.append("이동·충돌")
	return "없음" if names.is_empty() else " + ".join(names)


func _create_layers() -> void:
	_background_layer = _add_layer("BackgroundLayer", -30)
	_floor_layer = _add_layer("FloorTileLayer", -20)
	_zone_layer = _add_layer("DebugZoneLayer", -15)
	_edge_layer = _add_layer("FloorEdgeLayer", -10)
	_occlusion_stub_layer = _add_layer("OcclusionStubLayer", -4)
	_wall_layer = _add_layer("WallLayer", 0)
	_door_layer = _add_layer("DoorAndWindowLayer", 10)
	_label_layer = _add_layer("DebugLabelLayer", 40)
	_object_layer = _add_layer("ObjectPlacementDebugLayer", 65)
	_debug_selection_layer = _add_layer("DebugSelectionLayer", 68)
	_navigation_layer = _add_layer("NavigationDebugLayer", 70)
	_grid_coord_layer = _add_layer("GridCoordinateLayer", 85)
	_wall_edge_coord_layer = _add_layer("WallEdgeCoordinateLayer", 88)
	_hover_edge_highlight_layer = _add_layer("WallEdgeHoverHighlightLayer", 89)
	_wall_id_layer = _add_layer("WallIdLayer", 90)
	_occlusion_debug_layer = _add_layer("OcclusionWallDebugLayer", 95)
	_room_measurement_layer = _add_layer("RoomMeasurementDebugLayer", 98)
	_debug_overlay_layer = CanvasLayer.new()
	_debug_overlay_layer.name = "DebugOverlayLayer"
	add_child(_debug_overlay_layer)


func _build_shell() -> void:
	_draw_background()
	_draw_floor_tiles(_living_room_rect(), COLOR_FLOOR, "living")
	_draw_floor_tiles(_work_room_rect(), COLOR_FLOOR_WORK, "work_power")
	_draw_floor_tiles(_bathroom_room_rect(), COLOR_FLOOR_BATH, "bathroom")
	_draw_no_large_object_zone()
	_draw_floor_edges()
	_draw_walls()
	_draw_doors_and_window_placeholders()
	_draw_debug_labels()
	_draw_object_placeholders()
	_draw_navigation_overlay()
	_draw_floor_grid_overlay()
	_draw_wall_edge_overlay()
	_draw_room_measurement_overlay()
	_draw_control_hint()


func _draw_background() -> void:
	var bg := Polygon2D.new()
	bg.name = "DarkValidationBackdrop"
	bg.polygon = PackedVector2Array([
		Vector2(-1200, -900),
		Vector2(2600, -900),
		Vector2(2600, 1600),
		Vector2(-1200, 1600),
	])
	bg.color = COLOR_BACKGROUND
	_background_layer.add_child(bg)


func _draw_floor_tiles(room: Rect2i, tint: Color, prefix: String) -> void:
	for a in range(room.position.x, room.position.x + room.size.x):
		for b in range(room.position.y, room.position.y + room.size.y):
			var tile_color := tint if (a + b) % 2 == 0 else tint.lerp(COLOR_FLOOR_ALT, 0.22)
			_draw_floor_tile(a, b, tile_color, "%s_tile_%d_%d" % [prefix, a, b])


func _draw_floor_tile(a: int, b: int, tile_color: Color, tile_name: String) -> void:
	var points := _tile_points(float(a), float(b))
	_add_polygon(_floor_layer, tile_name, points, tile_color)
	_add_line(_floor_layer, "%s_outline" % tile_name, points + [points[0]], COLOR_FLOOR_LINE, 1.5)


func _draw_no_large_object_zone() -> void:
	var points := _rect_points(_no_large_object_zone_rect())
	_add_polygon(_zone_layer, "CameraForegroundNoLargeObjectZone", points, COLOR_NO_OBJECT_ZONE)
	_add_line(_zone_layer, "CameraForegroundNoLargeObjectZoneOutline", points + [points[0]], Color(1.0, 0.72, 0.22, 0.75), 3.0)


func _draw_floor_edges() -> void:
	var living_room := _living_room_rect()
	var work_room := _work_room_rect()
	_draw_room_outline(living_room, "LivingOuterFloorEdge", COLOR_FLOOR_EDGE)
	_draw_room_outline(work_room, "WorkPowerOuterFloorEdge", COLOR_FLOOR_EDGE)
	_draw_front_stub_axis_a(float(living_room.position.x), float(living_room.position.y + living_room.size.y), float(living_room.size.x), "LivingCutawayFrontEdge")
	_draw_front_stub_axis_a(float(work_room.position.x), float(work_room.position.y + work_room.size.y), float(work_room.size.x), "SharedWallFloorJoin")
	_draw_front_stub_axis_b(float(living_room.position.x), float(living_room.position.y), float(living_room.size.y), "LivingLeftFloorEdge")


func _draw_walls() -> void:
	for segment in _wall_segments():
		_draw_wall_segment_data(segment)


# Wall segment data keeps shell structure edits near the layout settings instead of hiding them
# inside drawing calls. start_cell and doorway_offset are in grid coordinates before map rotation.
func _wall_segments() -> Array[Dictionary]:
	var segments: Array[Dictionary] = []
	for entry in _active_wall_segment_config_entries():
		var config: Resource = entry.get("config")
		if config == null:
			continue
		segments.append(_wall_segment_from_config(config, String(entry.get("source", "default"))))
	return segments


func _active_wall_segment_configs() -> Array[Resource]:
	if not custom_wall_segments.is_empty():
		return custom_wall_segments
	return _default_wall_segment_configs()


func _active_wall_segment_config_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var source := "default"
	var configs := _default_wall_segment_configs()
	if not custom_wall_segments.is_empty():
		source = "custom_wall_segments"
		configs = custom_wall_segments

	for config in configs:
		entries.append({
			"source": source,
			"config": config,
		})
	return entries


# Edit these default entries to move, hide, add, or delete shell walls in code. For Inspector tests,
# copy this shape into custom_wall_segments; when that array is non-empty, it overrides this list.
func _default_wall_segment_configs() -> Array[Resource]:
	var living_room := _living_room_rect()
	var work_room := _work_room_rect()
	var bathroom_room := _bathroom_room_rect()
	var service_room := _service_room_rect()
	var living_left := living_room.position.x
	var living_right := living_room.position.x + living_room.size.x
	var living_bottom := living_room.position.y + living_room.size.y
	var work_right := work_room.position.x + work_room.size.x
	var work_bottom := work_room.position.y + work_room.size.y

	return [
		# Work room outer walls.
		_make_wall_segment_config(&"work_back_wall", ApartmentWallSegmentConfigScript.Axis.AXIS_A, work_room.position, work_room.size.x),
		_make_wall_segment_config(&"work_left_wall", ApartmentWallSegmentConfigScript.Axis.AXIS_B, work_room.position, work_room.size.y),
		_make_wall_segment_config(&"work_right_wall", ApartmentWallSegmentConfigScript.Axis.AXIS_B, Vector2i(work_right, work_room.position.y), work_room.size.y),

		# Living room outer walls. The left wall has an entrance-door opening.
		_make_wall_segment_config(
			&"entrance_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			living_room.position,
			living_room.size.y,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			DEFAULT_ENTRANCE_DOOR_OFFSET,
			DEFAULT_ENTRANCE_DOOR_WIDTH,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			true,
			entrance_door_color
		),
		_make_wall_segment_config(
			&"entrance_inner_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(2, 7),
			3,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			1,
			1,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			true,
			inner_door_color
		),
		_make_wall_segment_config(
			&"living_right_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(living_right, living_room.position.y),
			living_room.size.y,
			ApartmentWallSegmentConfigScript.WallType.NORMAL,
			-1,
			0,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			true,
			Color.TRANSPARENT,
			ApartmentWallSegmentConfigScript.RenderMode.REVEALABLE,
			&"living_area",
			true
		),
		_make_wall_segment_config(
			&"living_front_cutaway",
			ApartmentWallSegmentConfigScript.Axis.AXIS_A,
			Vector2i(living_left, living_bottom),
			living_room.size.x,
			ApartmentWallSegmentConfigScript.WallType.CUTAWAY_STUB,
			-1.0,
			0,
			ApartmentWallSegmentConfigScript.HeightMode.CUTAWAY,
			-1.0,
			true,
			Color.TRANSPARENT,
			ApartmentWallSegmentConfigScript.RenderMode.CUTAWAY_STUB
		),
		# Legacy wrong-cell-coordinate occlusion walls are kept disabled for inventory reference.
		_make_wall_segment_config(
			&"living_occlusion_right_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(10, 4),
			5,
			ApartmentWallSegmentConfigScript.WallType.NORMAL,
			-1,
			0,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			false,
			Color.TRANSPARENT,
			ApartmentWallSegmentConfigScript.RenderMode.REVEALABLE,
			&"living_area",
			true
		),
		_make_wall_segment_config(
			&"living_occlusion_front_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_A,
			Vector2i(0, 9),
			10,
			ApartmentWallSegmentConfigScript.WallType.NORMAL,
			-1,
			0,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			false,
			Color.TRANSPARENT,
			ApartmentWallSegmentConfigScript.RenderMode.REVEALABLE,
			&"living_area",
			true
		),

		# Shared wall between the two rooms. Change doorway_offset / doorway_width here to move it.
		_make_wall_segment_config(
			&"work_front_shared_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_A,
			Vector2i(living_left, work_bottom),
			living_right - living_left,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			DEFAULT_CONNECTION_DOOR_OFFSET,
			DEFAULT_CONNECTION_DOOR_WIDTH,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			true,
			inner_door_color
		),

		# Bathroom partitions represent the merged bathroom / former service footprint.
		_make_wall_segment_config(
			&"bathroom_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_A,
			Vector2i(0, 7),
			2,
		),
		_make_wall_segment_config(
			&"bathroom_left_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(0, 7),
			3,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			1,
			DEFAULT_BATHROOM_DOOR_WIDTH,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			false,
			service_door_color
		),
		_make_wall_segment_config(
			&"bathroom_right_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(2, 4),
			3,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			2,
			DEFAULT_BATHROOM_DOOR_WIDTH,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			true,
			service_door_color
		),

		# Legacy service segments stay disabled so inventory can show they are intentionally retired.
		_make_wall_segment_config(
			&"service_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_A,
			service_room.position,
			service_room.size.x,
			ApartmentWallSegmentConfigScript.WallType.DOORWAY_FRAME,
			DEFAULT_SERVICE_DOOR_OFFSET,
			DEFAULT_SERVICE_DOOR_WIDTH,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			false,
			service_door_color.darkened(0.08)
		),
		_make_wall_segment_config(
			&"service_right_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			Vector2i(service_room.position.x + service_room.size.x, service_room.position.y - bathroom_room.size.y + service_room.size.y),
			service_room.size.y + bathroom_room.size.y - 1,
			ApartmentWallSegmentConfigScript.WallType.NORMAL,
			-1,
			0,
			ApartmentWallSegmentConfigScript.HeightMode.DEFAULT,
			-1.0,
			false
		),
	]


func _wall_segment_from_config(config: Resource, source: String = "default") -> Dictionary:
	return {
		"id": String(config.id),
		"enabled": config.enabled,
		"source": source,
		"axis": config.axis,
		"start_cell": config.start_cell,
		"length": config.length,
		"wall_type": config.wall_type,
		"doorway_offset": config.doorway_offset,
		"doorway_width": config.doorway_width,
		"height_mode": config.height_mode,
		"render_mode": config.render_mode,
		"reveal_area_id": String(config.reveal_area_id),
		"reveal_when_area_active": config.reveal_when_area_active,
		"height": _wall_height_from_config(config),
		"doorway_color": doorway_debug_color if config.doorway_color == Color.TRANSPARENT else config.doorway_color,
	}


func _make_wall_segment_config(
	segment_id: StringName,
	segment_axis: int,
	segment_start_cell: Vector2i,
	segment_length: int,
	segment_type: int = 0,
	segment_doorway_offset := -1,
	segment_doorway_width := 0,
	segment_height_mode: int = 0,
	segment_custom_height := -1.0,
	segment_enabled := true,
	segment_doorway_color := Color.TRANSPARENT,
	segment_render_mode: int = 0,
	segment_reveal_area_id: StringName = &"",
	segment_reveal_when_area_active := false
) -> Resource:
	var config: Resource = ApartmentWallSegmentConfigScript.new()
	config.id = segment_id
	config.enabled = segment_enabled
	config.axis = segment_axis
	config.start_cell = segment_start_cell
	config.length = segment_length
	config.wall_type = segment_type
	config.doorway_offset = segment_doorway_offset
	config.doorway_width = segment_doorway_width
	config.height_mode = segment_height_mode
	config.custom_height = segment_custom_height
	config.doorway_color = segment_doorway_color
	config.render_mode = segment_render_mode
	config.reveal_area_id = String(segment_reveal_area_id)
	config.reveal_when_area_active = segment_reveal_when_area_active
	return config


func _wall_height_from_config(config: Resource) -> float:
	match config.height_mode:
		ApartmentWallSegmentConfigScript.HeightMode.CUSTOM:
			return config.custom_height
		ApartmentWallSegmentConfigScript.HeightMode.CUTAWAY:
			return cutaway_front_stub_height
		_:
			return -1.0


# Four ROTATE_90 objects use Scene nodes as their exact pixel-geometry authority. The remaining
# candidate objects keep the Resource footprint path until a later migration pass.
func _object_footprints() -> Array[Dictionary]:
	var footprints: Array[Dictionary] = []
	for entry in _active_object_footprint_config_entries():
		var config: Resource = entry.get("config")
		if config == null:
			continue
		var source := String(entry.get("source", "default"))
		var object_data := _object_footprint_from_config(config, source)
		if source != "custom" and _editable_object_node_authority_active():
			object_data = _object_footprint_with_node_authority(object_data)
		footprints.append(object_data)
	return footprints


func _editable_object_node_authority_active() -> bool:
	return map_rotation == MapRotation.ROTATE_90


func _editable_object_node_by_id(object_id: String) -> Node2D:
	if not EDITABLE_NODE_OBJECT_IDS.has(object_id):
		return null
	var nodes_root := get_node_or_null(EDITABLE_OBJECT_NODES_PATH)
	if nodes_root == null:
		return null
	for candidate in nodes_root.find_children("*", "", true, false):
		if candidate is Node2D and candidate.has_method("body_world_polygon") and String(candidate.get("object_id")) == object_id:
			return candidate as Node2D
	return null


func _object_footprint_with_node_authority(resource_data: Dictionary) -> Dictionary:
	var object_id := String(resource_data.get("id", ""))
	var object_node := _editable_object_node_by_id(object_id)
	if object_node == null:
		return resource_data
	if not object_node.has_method("body_world_polygon") or not object_node.has_method("selection_world_polygon") or not object_node.has_method("interaction_world_polygon"):
		return resource_data

	var object_data := resource_data.duplicate(true)
	var body_polygon: PackedVector2Array = object_node.call("body_world_polygon")
	var selection_polygon: PackedVector2Array = object_node.call("selection_world_polygon")
	var interaction_polygon: PackedVector2Array = object_node.call("interaction_world_polygon")
	var placement_polygon: PackedVector2Array = object_node.call("placement_footprint_world_polygon")
	var occupancy_polygon: PackedVector2Array = object_node.call("floor_occupancy_world_polygon")
	var visual_polygon: PackedVector2Array = object_node.call("visual_world_polygon")
	var collision_polygons: Array[PackedVector2Array] = []
	var selection_polygons: Array[PackedVector2Array] = []
	var interaction_polygons: Array[PackedVector2Array] = []
	var floor_polygons: Array[PackedVector2Array] = []
	if body_polygon.size() >= 3:
		collision_polygons.append(body_polygon)
	if selection_polygon.size() >= 3:
		selection_polygons.append(selection_polygon)
	if interaction_polygon.size() >= 3:
		interaction_polygons.append(interaction_polygon)
	if occupancy_polygon.size() >= 3 and bool(object_data.get("uses_floor_occupancy", true)):
		floor_polygons.append(occupancy_polygon)
	var visual_center: Vector2 = object_node.call("visual_center_world")
	var visual_bounds: Rect2 = object_node.call("visual_bounds_world")
	var root_position: Vector2 = object_node.global_position
	var attachment_anchor: Vector2 = object_node.call("attachment_anchor_world")
	var base_point: Vector2 = object_node.call("base_point_world")
	var top_point: Vector2 = object_node.call("top_point_world")
	var use_point: Vector2 = object_node.call("use_point_world")
	var collision_bounds := _polygons_bounds(collision_polygons)
	var selection_bounds := _polygons_bounds(selection_polygons)
	var interaction_bounds := _polygons_bounds(interaction_polygons)
	var anchor_type := int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR))
	var anchor_world := base_point
	var occupied_cells: Array[Vector2i] = []
	if not floor_polygons.is_empty():
		occupied_cells = _cells_overlapped_by_polygons(floor_polygons)
	var use_cell := Vector2i(floori(_screen_to_grid_point(use_point).x), floori(_screen_to_grid_point(use_point).y))
	var root_grid := _screen_to_grid_point(base_point)
	var anchor_cell := Vector2i(floori(root_grid.x), floori(root_grid.y))
	var footprint_size := _cells_bounds_size(occupied_cells)

	object_data["source"] = "scene_node"
	object_data["resource_source"] = resource_data.get("source", "resource")
	object_data["node_backed"] = true
	object_data["node_path"] = String(object_node.get_path())
	object_data["object_node"] = object_node
	object_data["object_root_world"] = root_position
	object_data["attachment_anchor_world"] = attachment_anchor
	object_data["anchor_world_position"] = anchor_world
	object_data["base_point_world"] = base_point
	object_data["top_point_world"] = top_point
	object_data["height_vector"] = top_point - base_point
	object_data["height_px"] = base_point.distance_to(top_point)
	object_data["socket_world_position"] = object_node.call("attachment_socket_world")
	object_data["anchor_cell"] = anchor_cell
	object_data["size_cells"] = footprint_size
	object_data["position_offset_px"] = visual_center - anchor_world
	object_data["visual_center_world"] = visual_center
	object_data["visual_polygons"] = [visual_polygon] if visual_polygon.size() >= 3 else []
	object_data["visual_size_px"] = visual_bounds.size
	object_data["visual_source"] = String(object_node.call("visual_source"))
	object_data["collision_polygons"] = collision_polygons
	object_data["collision_size_px"] = collision_bounds.size
	object_data["collision_offset_px"] = collision_bounds.get_center() - visual_center if collision_bounds.has_area() else Vector2.ZERO
	object_data["selection_polygons"] = selection_polygons
	object_data["selection_size_px"] = selection_bounds.size
	object_data["selection_offset_px"] = selection_bounds.get_center() - base_point if selection_bounds.has_area() else Vector2.ZERO
	object_data["selection_source"] = "SELECTION_POLYGON"
	object_data["interaction_polygons"] = interaction_polygons
	object_data["interaction_size_px"] = interaction_bounds.size
	object_data["interaction_offset_px"] = interaction_bounds.get_center() - use_point if interaction_bounds.has_area() else Vector2.ZERO
	object_data["use_points_world"] = [use_point]
	object_data["interaction_cells"] = [use_cell]
	object_data["floor_polygons"] = floor_polygons
	object_data["placement_polygons"] = [placement_polygon] if placement_polygon.size() >= 3 else []
	object_data["floor_occupancy_source"] = "PLACEMENT_FOOTPRINT" if placement_polygon.size() >= 3 else ("BODY_POLYGON" if body_polygon.size() >= 3 else "NONE")
	object_data["occupied_cells"] = occupied_cells
	return object_data


func _polygons_bounds(polygons: Array[PackedVector2Array]) -> Rect2:
	var has_point := false
	var bounds := Rect2()
	for polygon in polygons:
		for point in polygon:
			if not has_point:
				bounds = Rect2(point, Vector2.ZERO)
				has_point = true
			else:
				bounds = bounds.expand(point)
	return bounds


func _cells_overlapped_by_polygons(polygons: Array[PackedVector2Array]) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in _base_walkable_floor_cells():
		for polygon in polygons:
			if Geometry2D.is_point_in_polygon(_cell_center(cell), polygon):
				cells.append(cell)
				break
	return cells


func _cells_bounds_size(cells: Array[Vector2i]) -> Vector2i:
	if cells.is_empty():
		return Vector2i.ZERO
	var minimum := cells[0]
	var maximum := cells[0]
	for cell in cells.slice(1):
		minimum = Vector2i(mini(minimum.x, cell.x), mini(minimum.y, cell.y))
		maximum = Vector2i(maxi(maximum.x, cell.x), maxi(maximum.y, cell.y))
	return maximum - minimum + Vector2i.ONE


func _cells_minimum(cells: Array[Vector2i]) -> Vector2i:
	if cells.is_empty():
		return Vector2i.ZERO
	var minimum := cells[0]
	for cell in cells.slice(1):
		minimum = Vector2i(mini(minimum.x, cell.x), mini(minimum.y, cell.y))
	return minimum


func _active_object_footprint_config_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var base_source := "fallback"
	var configs: Array[Resource] = []
	if object_footprint_set != null and not object_footprint_set.objects.is_empty():
		base_source = "resource"
		for config in object_footprint_set.objects:
			configs.append(config)
	else:
		configs = _default_object_footprint_configs()

	for config in configs:
		entries.append({
			"source": base_source,
			"config": config,
		})
	for config in custom_object_footprints:
		entries.append({
			"source": "custom",
			"config": config,
		})
	return entries


# Edit these defaults to rough in furniture/device footprints. Coordinates are floor cells,
# unlike wall segments, whose from/to values are wall edge grid-line coordinates.
func _default_object_footprint_configs() -> Array[Resource]:
	var configs: Array[Resource] = []
	for spec in _candidate_object_footprint_specs():
		var config: Resource = ApartmentObjectFootprintConfigScript.new()
		for property_name in spec:
			config.set(StringName(property_name), spec[property_name])
		configs.append(config)
	return configs


func _candidate_object_footprint_specs() -> Array[Dictionary]:
	return [
		_object_spec("entrance_door", "현관문", "entrance_area", "interaction", Vector2i(0, 8), Vector2(150, 220), true, [Vector2i(0, 8)], ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE, "entrance_wall", "", Vector2(0, -6), Vector2.ZERO, Vector2(96, 56), Vector2(50, 0), "entrance_door_dl_closed.png", "objects/apartment/EntranceDoor.tscn", "audio_entrance_door", "문 안쪽 면이 생활공간 중앙을 향함", false, Vector2i.ONE, 0.75),
		_object_spec("bed", "침대", "living_area", "interaction", Vector2i(9, 6), Vector2(260, 180), true, [Vector2i(8, 7)], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2(10, -6), Vector2(180, 90), Vector2(120, 64), Vector2.ZERO, "bed_dl_base.png", "objects/apartment/Bed.tscn", "", "침대 옆면과 머리맡이 보이고 왼쪽에서 접근", true, Vector2i(2, 1)),
		_object_spec("fridge", "냉장고", "living_area", "interaction", Vector2i.ZERO, Vector2.ZERO, true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "fridge_dl_closed.png", "objects/apartment/Fridge.tscn", "audio_fridge", "문 앞면이 생활공간 중앙을 향함", true, Vector2i.ZERO),
		_object_spec("microwave", "전자레인지", "living_area", "interaction", Vector2i.ZERO, Vector2.ZERO, false, [], ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT, "", "sink_counter", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "microwave_dl_base.png", "objects/apartment/Microwave.tscn", "audio_microwave", "조작면이 주방 통로를 향함", false, Vector2i.ZERO),
		_object_spec("navi_link", "NAVI LINK", "work_power_area", "interaction", Vector2i.ZERO, Vector2.ZERO, true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "navi_link_dl_idle_base.png", "objects/apartment/NaviLink.tscn", "audio_navi_link", "좌석 입구와 조작부가 작업공간 통로를 향함", true, Vector2i.ZERO),
		_object_spec("power_module_board", "전력 모듈 보드", "work_power_area", "interaction", Vector2i.ZERO, Vector2.ZERO, false, [], ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE, "work_back_wall", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "power_module_board_dl_base.png", "objects/apartment/PowerModuleBoard.tscn", "audio_power_board", "화면과 슬롯이 작업공간 안쪽을 향함", false, Vector2i.ZERO),
		_object_spec("node_17", "NODE-17", "work_power_area", "interaction", Vector2i(1, 2), Vector2(150, 140), true, [Vector2i(2, 2)], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2(0, -8), Vector2(90, 60), Vector2(96, 64), Vector2.ZERO, "node_17_dl_base.png", "objects/apartment/Node17.tscn", "audio_node_17", "표시 화면과 신호등이 작업공간 중앙을 향함"),
		_object_spec("sink_counter", "싱크대·주방 카운터", "living_area", "environment", Vector2i(3, 4), Vector2(220, 150), true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2(160, 70), Vector2.ZERO, Vector2.ZERO, "sink_counter_dl_base.png", "objects/apartment/sink_counter.tres", "", "상판 정면이 주방 통로를 향함", true, Vector2i(2, 1)),
		_object_spec("dining_table", "작은 식탁", "living_area", "environment", Vector2i(4, 7), Vector2(170, 120), true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2(130, 70), Vector2.ZERO, Vector2.ZERO, "dining_table_dl_base.png", "objects/apartment/dining_table.tres", "", "의자 접근면이 생활공간 통로를 향함"),
		_object_spec("signal_booster", "신호 증폭기", "work_power_area", "environment", Vector2i(1, 2), Vector2(112, 96), false, [], ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT, "", "node_17", Vector2(-68, -58), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "signal_booster_dl_base.png", "objects/apartment/signal_booster.tres", "audio_signal_booster", "표시등이 작업공간 중앙을 향함", false),
		_object_spec("ups_unit", "UPS·보조전원", "work_power_area", "environment", Vector2i(8, 2), Vector2(140, 110), true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2(100, 60), Vector2.ZERO, Vector2.ZERO, "ups_unit_dl_base.png", "objects/apartment/ups_unit.tres", "audio_ups_unit", "전면 패널이 작업공간 통로를 향함"),
		_object_spec("bathroom_fixture", "욕실 통합 설비", "bathroom", "environment", Vector2i(0, 4), Vector2(200, 140), true, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2(150, 80), Vector2.ZERO, Vector2.ZERO, "bathroom_fixture_dl_base.png", "objects/apartment/bathroom_fixture.tres", "", "욕실문에서 내부를 볼 때 정면이 보임"),
		_object_spec("sea_horizon_poster", "바다·수평선 포스터", "living_area", "decoration", Vector2i(11, 7), Vector2(160, 80), false, [], ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE, "living_right_wall", "", Vector2(0, -20), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "sea_horizon_poster_wall.png", "objects/apartment/sea_horizon_poster.tres", "", "포스터 그림이 침대와 방 안쪽을 향함", false, Vector2i.ONE, 0.58),
		_object_spec("fluorescent_light", "형광등", "living_area", "environment", Vector2i(6, 6), Vector2(240, 40), false, [], ApartmentObjectFootprintConfigScript.AnchorType.CEILING, "", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "fluorescent_light_base.png", "objects/apartment/fluorescent_light.tres", "audio_fluorescent_light", "천장에서 생활공간 전체를 비춤", false),
		_object_spec("shoes_slippers", "신발·슬리퍼", "entrance_area", "decoration", Vector2i(1, 9), Vector2(100, 60), false, [], ApartmentObjectFootprintConfigScript.AnchorType.FLOOR, "", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "shoes_slippers_dl_base.png", "objects/apartment/shoes_slippers.tres", "", "신발 앞코가 현관 통로를 향함", false),
		_object_spec("cable_bundle", "케이블 묶음", "work_power_area", "decoration", Vector2i(2, 2), Vector2(80, 40), false, [], ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT, "", "node_17", Vector2(36, 42), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "cable_bundle_var01.png", "objects/apartment/cable_bundle.tres", "", "NODE-17에서 전력 장비 방향으로 정리됨", false),
		_object_spec("wall_conduit", "벽면 전선관", "work_power_area", "decoration", Vector2i(3, 0), Vector2(128, 64), false, [], ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE, "work_back_wall", "", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "wall_conduit_axis_a_1x.png", "objects/apartment/wall_conduit.tres", "", "작업공간 뒤쪽 벽 방향을 따라 이어짐", false, Vector2i.ONE, 0.31),
		_object_spec("power_housing", "전력 장비 외장 프레임", "work_power_area", "decoration", Vector2i(6, 0), Vector2(240, 210), false, [], ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT, "work_back_wall", "power_module_board", Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, "power_housing_dl_base.png", "objects/apartment/power_housing.tres", "", "전력 모듈 보드와 같은 방향", false, Vector2i.ONE, 0.68),
	]


func _object_spec(
	id: String, name_ko: String, room_id: String, category: String, anchor: Vector2i,
	visual_size: Vector2, blocks: bool, interactions: Array[Vector2i], anchor_type: int,
	wall_id: String, parent_id: String, position_offset: Vector2, collision_size: Vector2,
	interaction_size: Vector2, interaction_offset: Vector2, image_file: String,
	scene_file: String, audio_id: String, facing_ko: String, uses_floor := true,
	size_cells := Vector2i.ONE, wall_ratio := 0.5
) -> Dictionary:
	var collision_offset := Vector2.ZERO
	if collision_size != Vector2.ZERO:
		match id:
			"bed": collision_offset = Vector2(0, 30)
			"fridge": collision_offset = Vector2(0, 38)
			"navi_link": collision_offset = Vector2(0, 45)
			"node_17", "bathroom_fixture": collision_offset = Vector2(0, 28)
			"sink_counter": collision_offset = Vector2(0, 32)
			"dining_table": collision_offset = Vector2(0, 24)
			"ups_unit": collision_offset = Vector2(0, 22)
	return {
		"id": StringName(id), "enabled": true, "room_area_id": StringName(room_id),
		"category": StringName(category), "anchor_cell": anchor, "size_cells": size_cells,
		"position_offset_px": position_offset, "visual_size_px": visual_size,
		"collision_shape_type": 1 if collision_size != Vector2.ZERO else 0,
		"collision_size_px": collision_size, "collision_offset_px": collision_offset,
		"interaction_size_px": interaction_size,
		"interaction_offset_px": interaction_offset, "blocks_movement": blocks,
		"uses_floor_occupancy": uses_floor, "interaction_cells": interactions,
		"anchor_type": anchor_type, "parent_object_id": StringName(parent_id),
		"wall_segment_id": StringName(wall_id), "wall_position_ratio": wall_ratio,
		"facing_description_ko": facing_ko, "display_name_ko": name_ko,
		"expected_image_file": image_file, "expected_scene_file": scene_file,
		"expected_audio_set_id": audio_id,
		"debug_color": _object_debug_color(id),
	}


func _object_debug_color(id: String) -> Color:
	match id:
		"entrance_door": return Color(0.42, 0.32, 0.22, 0.4)
		"bed": return Color(0.45, 0.62, 0.95, 0.36)
		"fridge": return Color(0.82, 0.82, 0.72, 0.36)
		"microwave": return Color(0.7, 0.7, 0.66, 0.3)
		"navi_link": return Color(0.55, 0.48, 0.92, 0.34)
		"power_module_board": return Color(0.18, 0.76, 0.98, 0.32)
		"node_17": return Color(0.38, 0.7, 1.0, 0.3)
		"sink_counter": return Color(0.42, 0.6, 0.62, 0.36)
		"dining_table": return Color(0.72, 0.5, 0.28, 0.34)
		"signal_booster": return Color(0.3, 0.75, 1.0, 0.28)
		"ups_unit": return Color(0.28, 0.68, 0.86, 0.32)
		"bathroom_fixture": return Color(0.42, 0.82, 0.92, 0.34)
		"sea_horizon_poster": return Color(0.28, 0.62, 0.86, 0.28)
		"fluorescent_light": return Color(0.95, 0.9, 0.5, 0.26)
		"shoes_slippers": return Color(0.9, 0.76, 0.36, 0.3)
		"cable_bundle": return Color(0.42, 0.46, 0.5, 0.26)
		"wall_conduit": return Color(0.36, 0.55, 0.66, 0.24)
		"power_housing": return Color(0.2, 0.58, 0.72, 0.24)
		_: return Color(0.55, 0.74, 1.0, 0.38)


func _object_footprint_from_config(config: Resource, source: String = "default") -> Dictionary:
	return {
		"id": String(config.id),
		"enabled": config.enabled,
		"source": source,
		"room_area_id": String(config.room_area_id),
		"category": String(config.category),
		"anchor_cell": config.anchor_cell,
		"size_cells": config.size_cells,
		"position_offset_px": config.position_offset_px,
		"visual_size_px": config.visual_size_px,
		"collision_shape_type": config.collision_shape_type,
		"collision_size_px": config.collision_size_px,
		"collision_offset_px": config.collision_offset_px,
		"interaction_size_px": config.interaction_size_px,
		"interaction_offset_px": config.interaction_offset_px,
		"blocks_movement": config.blocks_movement,
		"uses_floor_occupancy": config.uses_floor_occupancy,
		"interaction_cells": _object_config_interaction_cells(config),
		"anchor_type": config.anchor_type,
		"parent_object_id": String(config.parent_object_id),
		"wall_segment_id": String(config.wall_segment_id),
		"wall_position_ratio": config.wall_position_ratio,
		"wall_offset_px": config.wall_offset_px,
		"facing_description_ko": config.facing_description_ko,
		"display_name_ko": config.display_name_ko,
		"expected_image_file": config.expected_image_file,
		"expected_scene_file": config.expected_scene_file,
		"expected_audio_set_id": config.expected_audio_set_id,
		"debug_color": config.debug_color,
		"display_name": config.display_name,
		"note": config.note,
	}


func _object_config_interaction_cells(config: Resource) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	if config.interaction_cell != Vector2i(-1, -1):
		cells.append(config.interaction_cell)
	for cell in config.interaction_cells:
		var cell_i: Vector2i = cell
		if not cells.has(cell_i):
			cells.append(cell_i)
	return cells


func _validate_object_footprints() -> void:
	for warning in _object_placement_warnings():
		push_warning(warning)
	for warning in _room_measurement_object_warnings():
		push_warning(warning)


func _object_placement_warnings() -> Array[String]:
	var warnings: Array[String] = _editable_object_node_warnings()
	var occupied_by_cell: Dictionary = {}
	var passable_edges: Dictionary = _navigation_edge_sets()["passable"]
	var objects_by_id: Dictionary = {}
	for object_data in _object_footprints():
		objects_by_id[String(object_data.get("id", ""))] = object_data

	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var object_id := String(object_data.get("id", ""))
		if EDITABLE_NODE_OBJECT_IDS.has(object_id) and not _editable_object_node_authority_active():
			continue
		var blocks_movement := bool(object_data.get("blocks_movement", true))
		var uses_floor := _object_uses_floor_occupancy(object_data)
		var category := String(object_data.get("category", ""))
		var contract_interaction := DIRECT_INTERACTION_OBJECT_IDS.has(object_id)
		var raw_interaction_cells := _object_raw_interaction_cells(object_data)
		var interaction_size: Vector2 = object_data.get("interaction_size_px", Vector2.ZERO)
		if contract_interaction and category != "interaction":
			warnings.append("object %s must use interaction category" % object_id)
		elif not contract_interaction and category == "interaction":
			warnings.append("object %s is not one of the seven direct interaction objects" % object_id)
		if contract_interaction and not _object_has_valid_interaction_area(object_data):
			warnings.append("object %s requires a non-zero interaction area and access cell" % object_id)
		elif not contract_interaction and (not raw_interaction_cells.is_empty() or interaction_size != Vector2.ZERO):
			warnings.append("object %s must not define gameplay interaction geometry" % object_id)
		var occupied_cells: Array[Vector2i] = []
		if uses_floor:
			occupied_cells = _object_occupied_cells(object_data)
		if uses_floor and occupied_cells.is_empty():
			warnings.append("object %s has no occupied cells; check size_cells" % object_id)

		for cell in occupied_cells:
			if not _is_base_walkable_cell(cell):
				warnings.append("object %s occupies non-walkable or out-of-room floor cell %s" % [object_id, _format_cell(cell)])
			var cell_key := _cell_key(cell)
			if occupied_by_cell.has(cell_key):
				warnings.append("object %s overlaps %s at floor cell %s" % [object_id, String(occupied_by_cell[cell_key]), _format_cell(cell)])
			else:
				occupied_by_cell[cell_key] = object_id

			if blocks_movement:
				for edge_name in ["top", "right", "bottom", "left"]:
					var edge_info := _wall_edge_info_for_cell(cell, edge_name)
					if edge_info.is_empty():
						continue
					var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
					var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
					var edge_key := _edge_key(from_cell, to_cell)
					if passable_edges.has(edge_key):
						warnings.append("object %s blocks doorway edge %s->%s at floor cell %s" % [
							object_id,
							_format_cell(from_cell),
							_format_cell(to_cell),
							_format_cell(cell),
						])

		for interaction_cell in _object_interaction_cells(object_data):
			if not _is_base_walkable_cell(interaction_cell):
				warnings.append("object %s interaction cell %s is outside base walkable floor" % [object_id, _format_cell(interaction_cell)])
				continue
			var blockers := _object_blocker_ids_for_cell(interaction_cell)
			if not blockers.is_empty():
				warnings.append("object %s interaction cell %s is occupied by blocking object(s): %s" % [
					object_id,
					_format_cell(interaction_cell),
					", ".join(blockers),
				])

		var parent_id := String(object_data.get("parent_object_id", ""))
		if not parent_id.is_empty() and not objects_by_id.has(parent_id):
			warnings.append("object %s references missing parent %s" % [object_id, parent_id])
		var anchor_type := int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR))
		if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT and parent_id.is_empty():
			warnings.append("object %s uses PARENT_OBJECT without parent_object_id" % object_id)
		if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE and uses_floor:
			warnings.append("object %s uses WALL_EDGE but still occupies floor cells" % object_id)
		if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.CEILING and uses_floor:
			warnings.append("object %s uses CEILING but still occupies floor cells" % object_id)
		var wall_id := String(object_data.get("wall_segment_id", ""))
		if _object_requires_wall(object_data):
			var wall := _wall_segment_by_id(wall_id)
			if wall_id.is_empty() or wall.is_empty() or not bool(wall.get("enabled", true)):
				warnings.append("object %s references unavailable wall %s" % [object_id, wall_id])
			elif object_id == "entrance_door" and not _object_wall_attachment_is_doorway(object_data, wall):
				warnings.append("object %s must target the doorway unit on %s" % [object_id, wall_id])
			elif object_id != "entrance_door" and not _object_wall_attachment_is_available(object_data, wall):
				warnings.append("object %s targets an unavailable wall unit on %s" % [object_id, wall_id])
		elif not wall_id.is_empty() and _wall_segment_by_id(wall_id).is_empty():
			warnings.append("object %s references unknown related wall %s" % [object_id, wall_id])

	for object_id in objects_by_id:
		var seen: Dictionary = {}
		var cursor := String(object_id)
		while not cursor.is_empty() and objects_by_id.has(cursor):
			if seen.has(cursor):
				warnings.append("object %s has a parent cycle through %s" % [object_id, cursor])
				break
			seen[cursor] = true
			cursor = String(objects_by_id[cursor].get("parent_object_id", ""))

	var blocking_colliders: Array[Dictionary] = []
	for object_data in objects_by_id.values():
		if bool(object_data.get("blocks_movement", false)) and _object_uses_floor_occupancy(object_data) and Vector2(object_data.get("collision_size_px", Vector2.ZERO)) != Vector2.ZERO:
			blocking_colliders.append(object_data)
	for first_index in range(blocking_colliders.size()):
		for second_index in range(first_index + 1, blocking_colliders.size()):
			var first := blocking_colliders[first_index]
			var second := blocking_colliders[second_index]
			if _object_collision_grid_rect(first).intersects(_object_collision_grid_rect(second)):
				warnings.append("blocking collision overlap between %s and %s" % [first.get("id", ""), second.get("id", "")])
	return warnings


func _editable_object_node_warnings() -> Array[String]:
	var warnings: Array[String] = []
	if not _editable_object_node_authority_active():
		return warnings
	var seen_ids: Dictionary = {}
	var nodes_root := get_node_or_null(EDITABLE_OBJECT_NODES_PATH)
	if nodes_root == null:
		return ["EditableObjectNodes is missing"]
	for candidate in nodes_root.find_children("*", "", true, false):
		if not (candidate is Node2D) or not candidate.has_method("body_world_polygon"):
			continue
		var object_id := String(candidate.get("object_id"))
		if seen_ids.has(object_id):
			warnings.append("duplicate editable object node id %s" % object_id)
		seen_ids[object_id] = true
		for node_warning in candidate.call("geometry_warnings"):
			warnings.append("editable object %s: %s" % [object_id, String(node_warning)])
	for object_id in EDITABLE_NODE_OBJECT_IDS:
		if not seen_ids.has(object_id):
			warnings.append("editable object node %s is missing" % object_id)
	return warnings


func _object_requires_wall(object_data: Dictionary) -> bool:
	return int(object_data.get("anchor_type", 0)) == ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE


func _object_uses_floor_occupancy(object_data: Dictionary) -> bool:
	return bool(object_data.get("uses_floor_occupancy", true))


func _object_wall_attachment_is_available(object_data: Dictionary, wall: Dictionary) -> bool:
	var unit := _object_wall_attachment_unit(object_data, wall)
	return not unit.is_empty() and bool(unit.get("available", false))


func _object_wall_attachment_is_doorway(object_data: Dictionary, wall: Dictionary) -> bool:
	var unit := _object_wall_attachment_unit(object_data, wall)
	return not unit.is_empty() and bool(Dictionary(unit.get("edge", {})).get("doorway", false))


func _object_wall_attachment_unit(object_data: Dictionary, wall: Dictionary) -> Dictionary:
	var units := _measurement_wall_unit_data(wall)
	if units.is_empty():
		return {}
	if bool(object_data.get("node_backed", false)):
		var anchor_position := _object_anchor_world_position(object_data)
		var nearest_unit: Dictionary = units[0]
		var nearest_distance := INF
		for unit in units:
			var edge: Dictionary = unit.get("edge", {})
			if edge.is_empty():
				continue
			var from_cell: Vector2i = edge.get("from_cell", Vector2i.ZERO)
			var to_cell: Vector2i = edge.get("to_cell", Vector2i.ZERO)
			var midpoint := (_iso(from_cell.x, from_cell.y) + _iso(to_cell.x, to_cell.y)) * 0.5
			var distance := midpoint.distance_squared_to(anchor_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_unit = unit
		return nearest_unit
	var ratio := clampf(float(object_data.get("wall_position_ratio", 0.5)), 0.0, 0.9999)
	var unit_index := mini(floori(ratio * units.size()), units.size() - 1)
	return units[unit_index]


# Prints an editor-friendly inventory so the user can identify which wall segment to edit.
func print_wall_segment_inventory() -> void:
	var rows := _wall_segment_inventory_rows()
	print("")
	print("=== Apartment Wall Segment Inventory ===")
	print("from_cell / to_cell are wall grid-line coordinates, not floor cell centers. Use E wall edge overlay to pick exact edge coordinates.")
	print("To place a wall around floor cell (x,y), use that cell's printed edge coordinates from G or E.")
	print("id | name_ko | enabled | source | axis | edge_from_cell | edge_to_cell | length | wall_type | render_mode | current_state | state_ko | doorway | doorway_ko | reveal | logical | height_mode | edit_hint")
	print("--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---")
	for row in rows:
		print("%s | %s | %s | %s | %s | %s | %s | %d | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s" % [
			row["id"],
			row["name_ko"],
			str(row["enabled"]),
			row["source"],
			row["axis"],
			row["from_cell"],
			row["to_cell"],
			row["length"],
			row["wall_type"],
			row["render_mode"],
			row["current_state"],
			row["state_ko"],
			row["doorway"],
			row["doorway_ko"],
			row["reveal"],
			row["logical"],
			row["height_mode"],
			row["edit_hint"],
		])
	print("=== End Wall Segment Inventory ===")
	_print_navigation_summary()
	_print_object_footprint_summary()
	_print_room_measurement_summary()


func _wall_segment_inventory_rows() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for segment in _wall_segments():
		var axis: WallAxis = segment["axis"]
		var start_cell_i: Vector2i = segment.get("start_cell", Vector2i.ZERO)
		var end_cell_i := _segment_end_cell_i(segment)
		rows.append({
			"id": String(segment["id"]),
			"name_ko": _wall_display_name_ko(String(segment["id"])),
			"enabled": bool(segment.get("enabled", true)),
			"source": String(segment.get("source", "default")),
			"axis": _wall_axis_name(axis),
			"from_cell": _format_cell(start_cell_i),
			"to_cell": _format_cell(end_cell_i),
			"length": int(segment.get("length", 0)),
			"wall_type": _wall_type_name(segment.get("wall_type", WallType.NORMAL)),
			"render_mode": _render_mode_name(segment.get("render_mode", WallRenderMode.FULL)),
			"current_state": _wall_render_state(segment),
			"state_ko": _wall_render_state_ko(segment),
			"doorway": _wall_doorway_text(segment),
			"doorway_ko": _wall_doorway_text_ko(segment),
			"reveal": _wall_reveal_text(segment),
			"logical": str(_is_logical_wall(segment)),
			"height_mode": _height_mode_name(segment.get("height_mode", ApartmentWallSegmentConfigScript.HeightMode.DEFAULT)),
			"edit_hint": _wall_edit_hint(segment),
		})
	return rows


func _print_navigation_summary() -> void:
	var edge_sets := _navigation_edge_sets()
	var area_text := ""
	for area_id in _navigation_area_ids():
		if not area_text.is_empty():
			area_text += ", "
		area_text += "%s(%s)" % [area_id, _room_area_label(area_id)]
	print("=== Apartment Navigation Debug Summary ===")
	print("walkable_cells=%d" % _walkable_floor_cells().size())
	print("blocked_edges=%d" % edge_sets["blocked"].size())
	print("passable_edges=%d" % edge_sets["passable"].size())
	print("room_areas=%s" % area_text)
	print("player_debug_cell=%s active_room_area=%s(%s)" % [_format_cell(player_debug_cell), _active_room_area(), _room_area_label(_active_room_area())])
	print("debug_auto_reveal_walls=%s preview_revealed_walls=%s" % [str(debug_auto_reveal_walls), str(preview_revealed_walls)])
	for segment in _wall_segments():
		if int(segment.get("render_mode", WallRenderMode.FULL)) != WallRenderMode.REVEALABLE:
			continue
		print("revealable id=%s name_ko=%s reveal_area_id=%s(%s) reveal_when_area_active=%s current_state=%s state_ko=%s" % [
			String(segment.get("id", "")),
			_wall_display_name_ko(String(segment.get("id", ""))),
			String(segment.get("reveal_area_id", "")),
			_room_area_label(String(segment.get("reveal_area_id", ""))),
			str(bool(segment.get("reveal_when_area_active", false))),
			_wall_render_state(segment),
			_wall_render_state_ko(segment),
		])
	print("=== End Navigation Debug Summary ===")


func _print_object_footprint_summary() -> void:
	var rows := _object_footprint_inventory_rows()
	print("=== Apartment Object Footprint Summary ===")
	print("FLOOR/CEILING anchors and occupied/interactions use floor cells; WALL_EDGE/PARENT_OBJECT anchors resolve from their references. Visual/collision/interaction sizes and offsets use screen pixels.")
	print("id | name_ko | category | source | room | anchor_type | anchor | offset_px | visual_px | collision_px@offset | interaction_px@offset | parent | wall@ratio | occupied | blocks | interactions | edit_hint")
	print("--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---")
	for row in rows:
		print("%s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s" % [
			row["id"],
			row["name_ko"],
			row["category"],
			row["source"],
			row["room_name_ko"],
			row["anchor_type"],
			row["anchor_cell"],
			row["position_offset_px"],
			row["visual_size_px"],
			"%s@%s" % [row["collision_size_px"], row["collision_offset_px"]],
			"%s@%s" % [row["interaction_size_px"], row["interaction_offset_px"]],
			row["parent_object_id"] if not row["parent_object_id"].is_empty() else "-",
			"%s@%.2f" % [row["wall_segment_id"], row["wall_position_ratio"]] if not row["wall_segment_id"].is_empty() else "-",
			row["occupied_cells"],
			str(row["blocks_movement"]),
			row["interaction_cells"],
			row["edit_hint"],
		])
	print("=== End Object Footprint Summary ===")
	_print_interaction_debug_summary()


func _print_interaction_debug_summary() -> void:
	print("=== Apartment Interaction / Phone Debug Summary ===")
	print("direct_world_interaction_objects=%d debug_menu_entries_including_phone=%d" % [
		_direct_interaction_object_ids().size(), _interaction_debug_object_ids().size(),
	])
	print("interaction_menu_visible=%s interaction_panel_visible=%s phone_debug_overlay_visible=%s" % [
		str(_interaction_menu_panel != null and _interaction_menu_panel.visible),
		str(_interaction_panel != null and _interaction_panel.visible),
		str(_phone_overlay_root != null and _phone_overlay_root.visible),
	])
	print("keys: J=interaction debug menu, H=phone debug overlay, ESC=close top overlay")
	print("=== End Interaction / Phone Debug Summary ===")


func _print_room_measurement_summary() -> void:
	print("=== Apartment Room Measurement Summary ===")
	print("floor cell=space reference; wall edge=door/window boundary; screen px=art/collision/offset tuning. Placement cells are advisory and do not force tile snapping.")
	print("room_id | name_ko | floor_bounds | size_cells | area_floor_cells | bounds_cells | walkable_cells | placement_cells | screen_bounds_px | center_grid | center_screen | doorways | windows | walls")
	print("--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---")
	for definition in _room_measurement_definitions():
		var data := _room_measurement_data(String(definition["room_id"]))
		var rect: Rect2i = data["rect"]
		var screen_bounds: Rect2 = data["screen_bounds"]
		var center_grid: Vector2 = data["center_grid"]
		var center_screen: Vector2 = data["center_screen"]
		print("%s | %s | %s->%s | %s | %d | %d | %d | %d | %dx%d | (%.1f,%.1f) | (%.1f,%.1f) | %s | %s | %s" % [
			data["room_id"],
			data["name_ko"],
			_format_cell(rect.position),
			_format_cell(rect.end),
			_format_cell(rect.size),
			int(data["floor_cells"].size()),
			int(data["bounds_cell_count"]),
			int(data["walkable_cells"].size()),
			int(data["placement_cells"].size()),
			roundi(screen_bounds.size.x),
			roundi(screen_bounds.size.y),
			center_grid.x,
			center_grid.y,
			center_screen.x,
			center_screen.y,
			", ".join(data["doorway_ids"]),
			", ".join(data["window_ids"]) if not data["window_ids"].is_empty() else "-",
			", ".join(data["wall_ids"]),
		])
		print("  placement floor cells: %s" % _format_cells(data["placement_cells"]))
		print("  doorway clearance: %s" % _format_cells(data["doorway_clearance_cells"]))
		print("  required main path: %s" % _format_cells(data["main_path_cells"]))
		for doorway_id in data["doorway_ids"]:
			var doorway_segment := _wall_segment_by_id(String(doorway_id))
			if not doorway_segment.is_empty():
				print("  doorway %s(%s): %s" % [doorway_id, _wall_display_name_ko(String(doorway_id)), _wall_doorway_text(doorway_segment)])
		for window_id in data["window_ids"]:
			print("  window %s: edge from=(%.1f,%.1f) to=(%.1f,%.1f)" % [
				window_id,
				living_window_axis_a,
				living_window_axis_b_start,
				living_window_axis_a,
				living_window_axis_b_start + living_window_width,
			])
	print("no-large-object zone: %s->%s" % [_format_cell(_no_large_object_zone_rect().position), _format_cell(_no_large_object_zone_rect().end)])
	_print_wall_attachment_measurement_summary()
	_print_object_measurement_comparison()
	print("=== End Apartment Room Measurement Summary ===")


func _print_wall_attachment_measurement_summary() -> void:
	print("--- Wall Attachment Availability ---")
	var seen: Dictionary = {}
	for definition in _room_measurement_definitions():
		for wall_id in definition["wall_ids"]:
			var id := String(wall_id)
			if seen.has(id):
				continue
			seen[id] = true
			var segment := _wall_segment_by_id(id)
			if segment.is_empty() or not bool(segment.get("enabled", true)):
				continue
			print("%s | %s | edge %s->%s | grid=%d | screen_px=%d | state=%s | doorway=%s | window=%s | attachable=%s" % [
				_wall_display_name_ko(id),
				id,
				_format_cell(segment.get("start_cell", Vector2i.ZERO)),
				_format_cell(_segment_end_cell_i(segment)),
				int(segment.get("length", 0)),
				roundi(_measurement_wall_length_px(segment)),
				_wall_render_state_ko(segment),
				_wall_doorway_text_ko(segment),
				"있음" if id == "living_right_wall" else "없음",
				_measurement_wall_available_edges_text(segment),
			])
			for unit in _measurement_wall_unit_data(segment):
				if bool(unit["available"]):
					continue
				var edge: Dictionary = unit["edge"]
				print("  unavailable %s->%s: %s" % [
					_format_cell(edge["from_cell"]),
					_format_cell(edge["to_cell"]),
					", ".join(unit["reasons"]),
				])


func _print_object_measurement_comparison() -> void:
	print("--- Candidate Object Measurement Comparison ---")
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var id := String(object_data.get("id", ""))
		if EDITABLE_NODE_OBJECT_IDS.has(id) and not _editable_object_node_authority_active():
			continue
		var warnings := _room_measurement_object_warnings_for(object_data)
		print("%s | expected_room=%s | category=%s | anchor_type=%s | anchor=%s | offset_px=%s | visual_px=%s | collision_px=%s | interaction_px=%s | parent=%s | wall=%s | occupied=%s | interactions=%s | result=%s" % [
			id,
			String(object_data.get("room_area_id", "")),
			_object_category_name(object_data),
			_object_anchor_type_name(object_data),
			_format_cell(object_data.get("anchor_cell", Vector2i.ZERO)),
			str(object_data.get("position_offset_px", Vector2.ZERO)),
			str(object_data.get("visual_size_px", Vector2.ZERO)),
			str(object_data.get("collision_size_px", Vector2.ZERO)),
			str(object_data.get("interaction_size_px", Vector2.ZERO)),
			String(object_data.get("parent_object_id", "-")) if not String(object_data.get("parent_object_id", "")).is_empty() else "-",
			String(object_data.get("wall_segment_id", "-")) if not String(object_data.get("wall_segment_id", "")).is_empty() else "-",
			_format_cells(_object_floor_occupied_cells(object_data)),
			_format_cells(_object_interaction_cells(object_data)),
			"OK" if warnings.is_empty() else "; ".join(warnings),
		])


func _room_measurement_object_warnings() -> Array[String]:
	var warnings: Array[String] = []
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var id := String(object_data.get("id", ""))
		if EDITABLE_NODE_OBJECT_IDS.has(id) and not _editable_object_node_authority_active():
			continue
		for warning in _room_measurement_object_warnings_for(object_data):
			warnings.append("measurement object %s: %s" % [id, warning])
	return warnings


func _room_measurement_object_warnings_for(object_data: Dictionary) -> Array[String]:
	var warnings: Array[String] = []
	var expected_room := String(object_data.get("room_area_id", ""))
	var uses_floor := _object_uses_floor_occupancy(object_data)
	var occupied_cells: Array[Vector2i] = []
	if uses_floor:
		occupied_cells = _object_occupied_cells(object_data)
	var room_data := _room_measurement_data(expected_room)
	if room_data.is_empty():
		warnings.append("unknown expected room %s" % expected_room)
		return warnings

	var door_clearance_keys := _cell_key_map(room_data["doorway_clearance_cells"])
	var path_keys := _cell_key_map(room_data["main_path_cells"])
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var anchor_type := int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR))
	if anchor_type != ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE and anchor_type != ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT and _room_area_for_cell(anchor, false) != expected_room:
		warnings.append("anchor %s is outside expected room" % _format_cell(anchor))
	for cell in occupied_cells:
		var actual_room := _room_area_for_cell(cell, false)
		if actual_room != expected_room:
			warnings.append("cell %s is in %s(%s), not %s(%s)" % [
				_format_cell(cell),
				actual_room,
				_room_area_label(actual_room),
				expected_room,
				_room_area_label(expected_room),
			])
		if door_clearance_keys.has(_cell_key(cell)):
			warnings.append("cell %s intrudes doorway clearance" % _format_cell(cell))
		if path_keys.has(_cell_key(cell)):
			warnings.append("cell %s intrudes required movement path" % _format_cell(cell))
		if _is_cell_in_rect(cell, _no_large_object_zone_rect()):
			warnings.append("cell %s is inside no-large-object zone" % _format_cell(cell))

	for interaction_cell in _object_interaction_cells(object_data):
		if _room_area_for_cell(interaction_cell, false) != expected_room:
			warnings.append("interaction cell %s is outside expected room" % _format_cell(interaction_cell))
		elif not _is_walkable_cell(interaction_cell):
			warnings.append("interaction cell %s is not currently walkable" % _format_cell(interaction_cell))
		elif not _measurement_interaction_is_reachable(expected_room, interaction_cell):
			warnings.append("interaction cell %s is not reachable from a room doorway" % _format_cell(interaction_cell))

	return warnings


func _measurement_wall_mount_candidate(object_id: String) -> bool:
	for object_data in _object_footprints():
		if String(object_data.get("id", "")) == object_id:
			return _object_requires_wall(object_data)
	return false


func _measurement_object_adjacent_wall_ids(object_data: Dictionary) -> Array[String]:
	var expected_room := String(object_data.get("room_area_id", ""))
	var definition := _room_measurement_definition(expected_room)
	var wall_ids: Array[String] = []
	var object_edge_keys: Dictionary = {}
	for cell in _object_occupied_cells(object_data):
		for edge_name in ["top", "right", "bottom", "left"]:
			var edge := _wall_edge_info_for_cell(cell, edge_name)
			object_edge_keys[_edge_key(edge["from_cell"], edge["to_cell"])] = true
	for wall_id in definition.get("wall_ids", []):
		var id := String(wall_id)
		var segment := _wall_segment_by_id(id)
		if segment.is_empty() or not bool(segment.get("enabled", true)):
			continue
		for offset in range(int(segment.get("length", 0))):
			var edge := _wall_segment_unit_edge(segment, offset)
			if object_edge_keys.has(String(edge["key"])):
				wall_ids.append(id)
				break
	return wall_ids


func _cell_key_map(cells: Array[Vector2i]) -> Dictionary:
	var keys: Dictionary = {}
	for cell in cells:
		keys[_cell_key(cell)] = true
	return keys


func _object_footprint_inventory_rows() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for object_data in _object_footprints():
		rows.append({
			"id": String(object_data.get("id", "")),
			"name_ko": String(object_data.get("display_name_ko", _object_display_name_ko(String(object_data.get("id", ""))))),
			"enabled": bool(object_data.get("enabled", true)),
			"source": String(object_data.get("source", "default")),
			"category": _object_category_name(object_data),
			"room_area_id": String(object_data.get("room_area_id", "")),
			"room_name_ko": _room_area_label(String(object_data.get("room_area_id", ""))),
			"anchor_cell": _format_cell(object_data.get("anchor_cell", Vector2i.ZERO)),
			"size_cells": _format_cell(object_data.get("size_cells", Vector2i.ONE)),
			"position_offset_px": str(object_data.get("position_offset_px", Vector2.ZERO)),
			"visual_size_px": str(object_data.get("visual_size_px", Vector2.ZERO)),
			"collision_size_px": str(object_data.get("collision_size_px", Vector2.ZERO)),
			"collision_offset_px": str(object_data.get("collision_offset_px", Vector2.ZERO)),
			"interaction_size_px": str(object_data.get("interaction_size_px", Vector2.ZERO)),
			"interaction_offset_px": str(object_data.get("interaction_offset_px", Vector2.ZERO)),
			"anchor_type": _object_anchor_type_name(object_data),
			"parent_object_id": String(object_data.get("parent_object_id", "")),
			"wall_segment_id": String(object_data.get("wall_segment_id", "")),
			"wall_position_ratio": float(object_data.get("wall_position_ratio", 0.5)),
			"occupied_cells": _format_cells(_object_floor_occupied_cells(object_data)),
			"blocks_movement": bool(object_data.get("blocks_movement", true)),
			"interaction_cells": _format_cells(_object_interaction_cells(object_data)),
			"node_path": String(object_data.get("node_path", "")),
			"edit_hint": _object_edit_hint(object_data),
		})
	return rows


func _object_edit_hint(object_data: Dictionary) -> String:
	var id := String(object_data.get("id", ""))
	var source := String(object_data.get("source", "default"))
	var location := "edit _default_object_footprint_configs() entry id=\"%s\"" % id
	if source == "resource":
		location = "edit godot/resources/quarterview/apartment_shell_object_footprints.tres entry id=\"%s\"" % id
	elif source == "scene_node":
		return "edit Scene > %s; adjust Visual/BodyPolygon/InteractionPolygon/UsePoint/AttachmentSocket" % String(object_data.get("node_path", id))
	elif source == "fallback":
		location = "edit _default_object_footprint_configs() entry id=\"%s\"" % id
	elif source == "custom":
		location = "edit Inspector > custom_object_footprints entry id=\"%s\"" % id
	return "%s; anchor: anchor_type + wall_segment_id / parent_object_id / anchor_cell; offset: position_offset_px; debug sizes: visual/collision/interaction *_px" % location


func _object_anchor_type_name(object_data: Dictionary) -> String:
	match int(object_data.get("anchor_type", 0)):
		ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE:
			return "WALL_EDGE"
		ApartmentObjectFootprintConfigScript.AnchorType.CEILING:
			return "CEILING"
		ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT:
			return "PARENT_OBJECT"
		_:
			return "FLOOR"


func _object_category_name(object_data: Dictionary) -> String:
	match String(object_data.get("category", "")):
		"interaction":
			return "INTERACTION"
		"environment":
			return "ENVIRONMENT"
		"decoration":
			return "DECORATION"
		_:
			return "UNCLASSIFIED"


func _wall_display_name_ko(id: String) -> String:
	match id:
		"work_back_wall":
			return "작업공간 뒤쪽벽"
		"work_left_wall":
			return "작업공간 왼쪽벽"
		"work_right_wall":
			return "작업공간 오른쪽벽"
		"work_front_shared_wall":
			return "생활/작업 공유벽"
		"entrance_wall":
			return "현관 외벽"
		"entrance_inner_wall":
			return "현관 안쪽벽"
		"living_right_wall":
			return "생활공간 오른쪽 숨김벽"
		"living_front_cutaway":
			return "생활공간 앞쪽 낮은벽"
		"living_occlusion_right_wall":
			return "비활성 오른쪽 숨김벽"
		"living_occlusion_front_wall":
			return "비활성 앞쪽 숨김벽"
		"bathroom_wall":
			return "욕실/현관 경계벽"
		"bathroom_right_wall":
			return "욕실 오른쪽벽"
		"bathroom_left_wall":
			return "비활성 욕실 왼쪽벽"
		"service_wall":
			return "비활성 서비스벽"
		"service_right_wall":
			return "비활성 서비스 오른쪽벽"
		_:
			return id


func _object_display_name_ko(id: String) -> String:
	match id:
		"entrance_door":
			return "현관문"
		"bed":
			return "침대"
		"fridge":
			return "냉장고"
		"microwave":
			return "전자레인지"
		"navi_link":
			return "NAVI LINK"
		"power_module_board":
			return "전력 모듈 보드"
		"node_17":
			return "NODE-17"
		"sink_counter":
			return "싱크대·주방 카운터"
		"dining_table":
			return "작은 식탁"
		"signal_booster":
			return "신호 증폭기"
		"ups_unit":
			return "UPS·보조전원"
		"bathroom_fixture":
			return "욕실 통합 설비"
		"sea_horizon_poster":
			return "바다·수평선 포스터"
		"fluorescent_light":
			return "형광등"
		"shoes_slippers":
			return "신발·슬리퍼"
		"cable_bundle":
			return "케이블 묶음"
		"wall_conduit":
			return "벽면 전선관"
		"power_housing":
			return "전력 장비 외장 프레임"
		"phone":
			return "핸드폰"
		_:
			return id


func _room_area_label(area_id: String) -> String:
	match area_id:
		"living_area":
			return "생활공간"
		"work_power_area":
			return "작업공간·전력공간"
		"bathroom":
			return "욕실"
		"entrance_area":
			return "현관"
		"unknown":
			return "미확인"
		_:
			return "미확인"


func _edge_name_ko(edge_name: String) -> String:
	match edge_name:
		"top":
			return "위쪽"
		"right":
			return "오른쪽"
		"bottom":
			return "아래쪽"
		"left":
			return "왼쪽"
		_:
			return edge_name


func _navigation_status_ko(status: String) -> String:
	match status:
		"blocked":
			return "막힘"
		"passable":
			return "통과 가능"
		"open":
			return "열림"
		_:
			return status


func _bool_ko(value: bool) -> String:
	return "예" if value else "아니오"


func _wall_render_state_ko(segment: Dictionary) -> String:
	match _wall_render_state(segment):
		"disabled":
			return "비활성"
		"full":
			return "전체벽"
		"stub":
			return "낮은벽"
		"hidden":
			return "숨김"
		"revealed":
			return "전체벽"
		"logical_only":
			return "논리벽"
		_:
			return _wall_render_state(segment)


func _wall_edit_hint(segment: Dictionary) -> String:
	var id := String(segment["id"])
	var source := String(segment.get("source", "default"))
	if id == "bathroom_left_wall" and not bool(segment.get("enabled", true)):
		var bathroom_location := "edit _default_wall_segment_configs() legacy disabled entry id=\"%s\"" % id
		if source == "custom_wall_segments":
			bathroom_location = "edit Inspector > custom_wall_segments legacy disabled entry id=\"%s\"" % id
		return "%s; legacy disabled bathroom segment; keep enabled=false unless testing old bathroom-left layout; use G for floor cells and E for wall edge coordinates" % bathroom_location
	if id == "service_wall" or id == "service_right_wall":
		var service_location := "edit _default_wall_segment_configs() legacy disabled entry id=\"%s\"" % id
		if source == "custom_wall_segments":
			service_location = "edit Inspector > custom_wall_segments legacy disabled entry id=\"%s\"" % id
		return "%s; legacy disabled service segment; keep enabled=false unless testing old service layout; use G for floor cells and E for wall edge coordinates" % service_location
	if id == "living_occlusion_right_wall" or id == "living_occlusion_front_wall":
		var occlusion_location := "edit _default_wall_segment_configs() legacy disabled entry id=\"%s\"" % id
		if source == "custom_wall_segments":
			occlusion_location = "edit Inspector > custom_wall_segments legacy disabled entry id=\"%s\"" % id
		return "%s; legacy wrong-cell-coordinate segment; keep enabled=false; use living_right_wall / living_front_cutaway for outer grid-line occlusion walls" % occlusion_location
	var location := "edit _default_wall_segment_configs() entry id=\"%s\"" % id
	if source == "custom_wall_segments":
		location = "edit Inspector > custom_wall_segments entry id=\"%s\"" % id
	return "%s; hide/remove wall: enabled=false; display: render_mode; future reveal: reveal_area_id / reveal_when_area_active; move: start_cell; direction: axis; length: length; door: doorway_offset / doorway_width; move right: increase x; move left: decrease x; move downward/forward: increase y; move upward/backward: decrease y; use G for floor cells and E for exact wall edge coordinates because map_rotation changes screen direction" % location


func _draw_doors_and_window_placeholders() -> void:
	if _should_draw_living_window_placeholder():
		_draw_window_axis_b(living_window_axis_a, living_window_axis_b_start, living_window_width, "LivingWindowPlaceholder")


func _should_draw_living_window_placeholder() -> bool:
	for segment in _wall_segments():
		if String(segment.get("id", "")) != "living_right_wall":
			continue
		if not bool(segment.get("enabled", true)):
			return false
		return _should_draw_full_wall_for_segment(segment)
	return true


func _draw_debug_labels() -> void:
	var living_room := _living_room_rect()
	_add_debug_label("living_label", "생활공간", _room_center(living_room) + Vector2(-30, 8))
	_add_debug_label("work_label", "작업공간·전력공간", _room_center(_work_room_rect()) + Vector2(-76, -8))
	_add_debug_label("bath_label", "욕실", _room_center(_bathroom_room_rect()) + Vector2(-18, -8))
	_add_debug_label("entrance_area_label", "현관", _room_center(_entrance_room_rect()) + Vector2(-18, 18))
	_add_debug_label("connection_label", "연결문", _doorway_center(&"work_front_shared_wall") + Vector2(-32, -104))
	_add_debug_label("entrance_door_label", "현관문", _doorway_center(&"entrance_wall") + Vector2(-72, -84))
	_add_debug_label("no_object_zone_label", "전경 대형 오브젝트 금지 구역", _room_center(_no_large_object_zone_rect()) + Vector2(-118, 20))


func _draw_object_placeholders() -> void:
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var blocks_movement := bool(object_data.get("blocks_movement", true))
		if blocks_movement and not show_blocking_object_cells:
			continue
		if not blocks_movement and not show_nonblocking_object_cells:
			continue
		_draw_object_placeholder(object_data)


func _draw_object_placeholder(object_data: Dictionary) -> void:
	var id := String(object_data.get("id", ""))
	var blocks_movement := bool(object_data.get("blocks_movement", true))
	var uses_floor := _object_uses_floor_occupancy(object_data)
	var floor_points := _object_floor_polygon_points(object_data)
	var collision_points := _object_collision_polygon_points(object_data)
	var composite_surface := (
		show_object_floor_footprints
		and show_object_collision_shapes
		and _object_floor_collision_are_equivalent(object_data)
	)

	if show_object_floor_footprints and uses_floor and floor_points.size() >= 3:
		var occupancy_fill := COLOR_OBJECT_OCCUPANCY
		if not blocks_movement:
			occupancy_fill.a *= 0.62
		_add_polygon(_object_layer, "object_%s_floor_footprint" % id, floor_points, occupancy_fill)
		if not composite_surface:
			_add_line(
				_object_layer,
				"object_%s_floor_outline" % id,
				floor_points + [floor_points[0]],
				COLOR_OBJECT_OCCUPANCY_OUTLINE,
				3.0 if blocks_movement else 2.0
			)

	if show_object_collision_shapes and collision_points.size() >= 3:
		if composite_surface:
			_add_line(
				_object_layer,
				"object_%s_composite_collision_outline" % id,
				collision_points + [collision_points[0]],
				COLOR_OBJECT_BLOCKED_CELL,
				3.0
			)
		else:
			var collision_fill := COLOR_OBJECT_BLOCKED_CELL
			collision_fill.a = 0.16
			_add_polygon(_object_layer, "object_%s_collision_shape" % id, collision_points, collision_fill)
			_add_line(
				_object_layer,
				"object_%s_collision_outline" % id,
				collision_points + [collision_points[0]],
				COLOR_OBJECT_BLOCKED_CELL,
				3.0
			)

	if bool(object_data.get("node_backed", false)):
		var selection_polygons := _object_selection_polygons(object_data)
		for selection_index in range(selection_polygons.size()):
			_draw_dashed_polygon(
				_object_layer,
				"object_%s_selection_area_%d" % [id, selection_index],
				selection_polygons[selection_index],
				COLOR_OBJECT_SELECTION_AREA,
				2.0,
				8
			)
		_draw_object_height_guide(_object_layer, "object_%s" % id, object_data, 2.0)

	if show_object_interaction_areas and _object_has_valid_interaction_area(object_data):
		var interaction_polygons := _object_interaction_polygons(object_data)
		for polygon_index in range(interaction_polygons.size()):
			var interaction_points: Array = interaction_polygons[polygon_index]
			_draw_dashed_polygon(
				_object_layer,
				"object_%s_interaction_area_%d" % [id, polygon_index],
				interaction_points,
				COLOR_OBJECT_INTERACTION_AREA
			)
			if not bool(object_data.get("node_backed", false)):
				var interaction_center := _polygon_bounds(interaction_points).get_center()
				_add_marker(
					_object_layer,
					"object_%s_interaction_marker_%d" % [id, polygon_index],
					interaction_center,
					COLOR_OBJECT_INTERACTION_AREA,
					8.0
				)
		if bool(object_data.get("node_backed", false)):
			for use_point_index in range(Array(object_data.get("use_points_world", [])).size()):
				_add_marker(
					_object_layer,
					"object_%s_use_point_%d" % [id, use_point_index],
					Vector2(Array(object_data.get("use_points_world", []))[use_point_index]),
					COLOR_OBJECT_INTERACTION_AREA,
					8.0
				)

	if show_object_parent_links:
		_draw_object_attachment_guide(_object_layer, "object_%s_attachment" % id, object_data, COLOR_OBJECT_ATTACHMENT, 2.0)


func _object_floor_polygon_points(object_data: Dictionary) -> Array[Vector2]:
	if not _object_uses_floor_occupancy(object_data):
		return []
	if bool(object_data.get("node_backed", false)):
		var polygons: Array = object_data.get("floor_polygons", [])
		if polygons.is_empty():
			return []
		return _packed_points_to_array(polygons[0])
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var size: Vector2i = object_data.get("size_cells", Vector2i.ONE)
	return _rect_points(Rect2i(anchor, size))


func _object_visual_polygon_points(object_data: Dictionary) -> Array[Vector2]:
	if bool(object_data.get("node_backed", false)):
		var polygons: Array = object_data.get("visual_polygons", [])
		if polygons.is_empty():
			return []
		return _packed_points_to_array(polygons[0])
	var visual_size: Vector2 = object_data.get("visual_size_px", Vector2.ZERO)
	if visual_size.x <= 0.0 or visual_size.y <= 0.0:
		return []
	return _pixel_rect_points(_object_pixel_center(object_data), visual_size)


func _object_collision_polygon_points(object_data: Dictionary) -> Array[Vector2]:
	if bool(object_data.get("node_backed", false)):
		var polygons: Array = object_data.get("collision_polygons", [])
		if polygons.is_empty():
			return []
		return _packed_points_to_array(polygons[0])
	if not _object_uses_floor_occupancy(object_data):
		return []
	var collision_size: Vector2 = object_data.get("collision_size_px", Vector2.ZERO)
	if collision_size == Vector2.ZERO:
		return []
	# Collision dimensions and offsets are authored as screen pixels. Keep those values in
	# screen space while orienting the polygon sides to the rotated isometric floor axes.
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var center := _object_pixel_center(object_data) + Vector2(object_data.get("collision_offset_px", Vector2.ZERO))
	var axis_a := (_iso(float(anchor.x) + 1.0, float(anchor.y)) - _iso(float(anchor.x), float(anchor.y))).normalized()
	var axis_b := (_iso(float(anchor.x), float(anchor.y) + 1.0) - _iso(float(anchor.x), float(anchor.y))).normalized()
	var half_a := axis_a * collision_size.x * 0.5
	var half_b := axis_b * collision_size.y * 0.5
	return [
		center - half_a - half_b,
		center + half_a - half_b,
		center + half_a + half_b,
		center - half_a + half_b,
	]


func _object_interaction_polygons(object_data: Dictionary) -> Array[Array]:
	var result: Array[Array] = []
	if bool(object_data.get("node_backed", false)):
		for polygon in object_data.get("interaction_polygons", []):
			result.append(_packed_points_to_array(polygon))
		return result
	var interaction_size: Vector2 = object_data.get("interaction_size_px", Vector2.ZERO)
	for interaction_cell in _object_interaction_cells(object_data):
		var interaction_center := _cell_center(interaction_cell) + Vector2(object_data.get("interaction_offset_px", Vector2.ZERO))
		result.append(_pixel_rect_points(interaction_center, interaction_size))
	return result


func _object_selection_polygons(object_data: Dictionary) -> Array[Array]:
	var result: Array[Array] = []
	if not bool(object_data.get("node_backed", false)):
		return result
	for polygon in object_data.get("selection_polygons", []):
		result.append(_packed_points_to_array(polygon))
	return result


func _draw_object_height_guide(parent: Node, prefix: String, object_data: Dictionary, thickness: float) -> void:
	if not bool(object_data.get("node_backed", false)):
		return
	var base_point := Vector2(object_data.get("base_point_world", Vector2.ZERO))
	var top_point := Vector2(object_data.get("top_point_world", Vector2.ZERO))
	_draw_dashed_line(parent, "%s_height_guide" % prefix, base_point, top_point, COLOR_OBJECT_TOP_POINT, thickness, 8)
	_add_marker(parent, "%s_base_point" % prefix, base_point, COLOR_OBJECT_BASE_POINT, 7.0 if thickness <= 2.0 else 11.0)
	_add_marker(parent, "%s_top_point" % prefix, top_point, COLOR_OBJECT_TOP_POINT, 7.0 if thickness <= 2.0 else 11.0)


func _packed_points_to_array(points: PackedVector2Array) -> Array[Vector2]:
	var result: Array[Vector2] = []
	for point in points:
		result.append(point)
	return result


func _object_floor_collision_are_equivalent(object_data: Dictionary) -> bool:
	var floor_points := _object_floor_polygon_points(object_data)
	var collision_points := _object_collision_polygon_points(object_data)
	if bool(object_data.get("node_backed", false)):
		return _polygons_match(floor_points, collision_points)
	if floor_points.size() != 4 or collision_points.size() != 4:
		return false
	var floor_bounds := _polygon_bounds(floor_points)
	var collision_bounds := _polygon_bounds(collision_points)
	var size_delta := (floor_bounds.size - collision_bounds.size).abs()
	var size_tolerance := Vector2(
		maxf(16.0, floor_bounds.size.x * 0.20),
		maxf(14.0, floor_bounds.size.y * 0.28)
	)
	var center_tolerance := maxf(20.0, minf(floor_bounds.size.x, floor_bounds.size.y) * 0.46)
	return (
		size_delta.x <= size_tolerance.x
		and size_delta.y <= size_tolerance.y
		and floor_bounds.get_center().distance_to(collision_bounds.get_center()) <= center_tolerance
	)


func _polygons_match(first: Array[Vector2], second: Array[Vector2], tolerance := 0.01) -> bool:
	if first.size() < 3 or first.size() != second.size():
		return false
	for index in range(first.size()):
		if first[index].distance_to(second[index]) > tolerance:
			return false
	return true


func _polygon_bounds(points: Array[Vector2]) -> Rect2:
	if points.is_empty():
		return Rect2()
	var bounds := Rect2(points[0], Vector2.ZERO)
	for point in points.slice(1):
		bounds = bounds.expand(point)
	return bounds


func _mouse_event_world_position(event: InputEventMouse) -> Vector2:
	return get_canvas_transform().affine_inverse() * event.position


func _draw_dashed_rect(parent: Node, prefix: String, center: Vector2, size: Vector2, color: Color, thickness := 2.0, dash_count := 6) -> void:
	_draw_dashed_polygon(parent, prefix, _pixel_rect_points(center, size), color, thickness, dash_count)


func _draw_dashed_polygon(parent: Node, prefix: String, points: Array, color: Color, thickness := 2.0, dash_count := 6) -> void:
	if points.size() < 3:
		return
	for edge_index in range(points.size()):
		_draw_dashed_line(
			parent,
			"%s_edge_%d" % [prefix, edge_index],
			points[edge_index],
			points[(edge_index + 1) % points.size()],
			color,
			thickness,
			dash_count
		)


func _draw_dashed_line(parent: Node, prefix: String, from: Vector2, to: Vector2, color: Color, thickness := 2.0, dash_count := 6) -> void:
	for index in range(dash_count):
		var start_ratio := float(index) / float(dash_count)
		var end_ratio := minf(start_ratio + 0.10, 1.0)
		_add_line(parent, "%s_dash_%d" % [prefix, index], [from.lerp(to, start_ratio), from.lerp(to, end_ratio)], color, thickness)


func _draw_object_attachment_guide(parent: Node, prefix: String, object_data: Dictionary, color: Color, thickness: float) -> void:
	var anchor_type := int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR))
	var node_backed := bool(object_data.get("node_backed", false))
	if node_backed:
		var socket_position := Vector2(object_data.get("socket_world_position", _object_pixel_center(object_data)))
		_add_marker(parent, "%s_socket" % prefix, socket_position, color, 7.0 if thickness <= 2.0 else 11.0)
		if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.FLOOR:
			return
	elif anchor_type != ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE and anchor_type != ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT:
		return
	var anchor_position := _object_anchor_world_position(object_data)
	var attachment_target := Vector2(object_data.get("socket_world_position", _object_pixel_center(object_data))) if node_backed else _object_pixel_center(object_data)
	if not node_backed:
		_add_marker(parent, "%s_anchor" % prefix, anchor_position, color, 7.0 if thickness <= 2.0 else 11.0)
	if anchor_position.distance_to(attachment_target) > 0.5:
		_draw_dashed_line(parent, "%s_leader" % prefix, anchor_position, attachment_target, color, thickness, 7)
	if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE:
		var wall := _wall_segment_by_id(String(object_data.get("wall_segment_id", "")))
		var unit := _object_wall_attachment_unit(object_data, wall)
		var edge: Dictionary = unit.get("edge", {})
		if not edge.is_empty():
			var from_cell: Vector2i = edge.get("from_cell", Vector2i.ZERO)
			var to_cell: Vector2i = edge.get("to_cell", Vector2i.ZERO)
			_add_line(parent, "%s_wall_edge" % prefix, [_iso(from_cell.x, from_cell.y), _iso(to_cell.x, to_cell.y)], color, thickness + 2.0)


func _object_pixel_center(object_data: Dictionary) -> Vector2:
	return _object_pixel_center_with_guard(object_data, {})


func _object_pixel_center_with_guard(object_data: Dictionary, resolving: Dictionary) -> Vector2:
	if bool(object_data.get("node_backed", false)):
		return Vector2(object_data.get("visual_center_world", Vector2.ZERO))
	var base_anchor := _object_anchor_world_position(object_data, resolving)
	return base_anchor + Vector2(object_data.get("position_offset_px", Vector2.ZERO)) + Vector2(object_data.get("wall_offset_px", Vector2.ZERO))


func _object_anchor_world_position(object_data: Dictionary, resolving: Dictionary = {}) -> Vector2:
	if bool(object_data.get("node_backed", false)):
		return Vector2(object_data.get("anchor_world_position", Vector2.ZERO))
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var fallback := _cell_center(anchor)
	var object_id := String(object_data.get("id", ""))
	if not object_id.is_empty() and resolving.has(object_id):
		return fallback
	var next_resolving := resolving.duplicate()
	if not object_id.is_empty():
		next_resolving[object_id] = true

	match int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR)):
		ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE:
			var wall := _wall_segment_by_id(String(object_data.get("wall_segment_id", "")))
			var unit := _object_wall_attachment_unit(object_data, wall)
			var edge: Dictionary = unit.get("edge", {})
			if not edge.is_empty():
				var from_cell: Vector2i = edge.get("from_cell", anchor)
				var to_cell: Vector2i = edge.get("to_cell", anchor)
				return (_iso(from_cell.x, from_cell.y) + _iso(to_cell.x, to_cell.y)) * 0.5
		ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT:
			var parent_data := _object_data_by_id(String(object_data.get("parent_object_id", "")))
			if not parent_data.is_empty():
				if bool(parent_data.get("node_backed", false)):
					return Vector2(parent_data.get("socket_world_position", Vector2.ZERO))
				return _object_pixel_center_with_guard(parent_data, next_resolving)
	return fallback


func _object_anchor_debug_text(object_data: Dictionary) -> String:
	var type_name := _object_anchor_type_name(object_data)
	var resolved := _object_anchor_world_position(object_data)
	if type_name == "WALL_EDGE":
		var wall_id := String(object_data.get("wall_segment_id", ""))
		var unit := _object_wall_attachment_unit(object_data, _wall_segment_by_id(wall_id))
		var edge: Dictionary = unit.get("edge", {})
		if not edge.is_empty():
			return "%s: %s %s→%s / resolved=%s" % [
				type_name,
				wall_id,
				_format_cell(edge.get("from_cell", Vector2i.ZERO)),
				_format_cell(edge.get("to_cell", Vector2i.ZERO)),
				str(resolved),
			]
	if type_name == "PARENT_OBJECT":
		return "%s: %s / resolved=%s" % [type_name, String(object_data.get("parent_object_id", "-")), str(resolved)]
	return "%s: cell=%s / resolved=%s" % [type_name, _format_cell(object_data.get("anchor_cell", Vector2i.ZERO)), str(resolved)]


func _object_anchor_short_text(object_data: Dictionary) -> String:
	var type_name := _object_anchor_type_name(object_data)
	if type_name == "WALL_EDGE":
		return "%s · %s" % [type_name, String(object_data.get("wall_segment_id", "-"))]
	if type_name == "PARENT_OBJECT":
		return "%s · %s" % [type_name, String(object_data.get("parent_object_id", "-"))]
	return "%s · %s" % [type_name, _format_cell(object_data.get("anchor_cell", Vector2i.ZERO))]


func _object_at_world_position(world_position: Vector2) -> String:
	var candidates := _object_hit_candidates(world_position)
	return String(candidates[0].get("id", "")) if not candidates.is_empty() else ""


func _object_hit_candidates(world_position: Vector2) -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var candidate := _object_hit_candidate(object_data, world_position)
		if not candidate.is_empty():
			candidates.append(candidate)
	candidates.sort_custom(func(first: Dictionary, second: Dictionary) -> bool:
		var first_priority := int(first.get("priority", 99))
		var second_priority := int(second.get("priority", 99))
		if first_priority != second_priority:
			return first_priority < second_priority
		var first_distance := float(first.get("distance", INF))
		var second_distance := float(second.get("distance", INF))
		if not is_equal_approx(first_distance, second_distance):
			return first_distance < second_distance
		return String(first.get("id", "")) < String(second.get("id", ""))
	)
	return candidates


func _object_hit_candidate(object_data: Dictionary, world_position: Vector2) -> Dictionary:
	var id := String(object_data.get("id", ""))
	if bool(object_data.get("node_backed", false)):
		for selection_points in _object_selection_polygons(object_data):
			if _point_in_object_polygon(world_position, selection_points):
				var selection_center := _polygon_bounds(selection_points).get_center()
				return {
					"id": id, "priority": 0, "hit_kind": "selection",
					"distance": selection_center.distance_squared_to(world_position),
				}
		return {}
	if _object_has_valid_interaction_area(object_data):
		for interaction_points in _object_interaction_polygons(object_data):
			if _point_in_object_polygon(world_position, interaction_points):
				var interaction_center := _polygon_bounds(interaction_points).get_center()
				return {
					"id": id, "priority": 0, "hit_kind": "interaction",
					"distance": interaction_center.distance_squared_to(world_position),
				}

	var floor_points := _object_floor_polygon_points(object_data)
	var collision_points := _object_collision_polygon_points(object_data)
	var floor_hit := _point_in_object_polygon(world_position, floor_points)
	var collision_hit := _point_in_object_polygon(world_position, collision_points)
	if floor_hit or collision_hit:
		var physical_center := _object_pixel_center(object_data)
		var hit_kind := "floor+collision" if floor_hit and collision_hit else ("floor occupancy" if floor_hit else "collision")
		return {
			"id": id, "priority": 1, "hit_kind": hit_kind,
			"distance": physical_center.distance_squared_to(world_position),
		}

	var anchor_type := int(object_data.get("anchor_type", ApartmentObjectFootprintConfigScript.AnchorType.FLOOR))
	if anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.WALL_EDGE or anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.PARENT_OBJECT:
		var anchor_position := _object_anchor_world_position(object_data)
		if anchor_position.distance_to(world_position) <= OBJECT_ANCHOR_HIT_RADIUS:
			return {
				"id": id, "priority": 2, "hit_kind": "attachment anchor",
				"distance": anchor_position.distance_squared_to(world_position),
			}

	var visual_points := _object_visual_polygon_points(object_data)
	var center := _object_pixel_center(object_data)
	if not _point_in_object_polygon(world_position, visual_points):
		return {}
	var low_priority_visual := (
		anchor_type == ApartmentObjectFootprintConfigScript.AnchorType.CEILING
		or String(object_data.get("category", "")) != "interaction"
	)
	return {
		"id": id,
		"priority": 4 if low_priority_visual else 3,
		"hit_kind": "ceiling/environment visual" if low_priority_visual else "visual",
		"distance": center.distance_squared_to(world_position),
	}


func _point_in_object_polygon(world_position: Vector2, points: Array[Vector2]) -> bool:
	return points.size() >= 3 and Geometry2D.is_point_in_polygon(world_position, PackedVector2Array(points))


func _object_candidate_signature(candidates: Array[Dictionary]) -> String:
	var parts: Array[String] = []
	for candidate in candidates:
		parts.append("%s:%s" % [String(candidate.get("id", "")), String(candidate.get("hit_kind", ""))])
	return "|".join(parts)


func _update_object_hover_at(world_position: Vector2) -> void:
	var next_candidates: Array[Dictionary] = []
	if show_object_placeholders:
		next_candidates = _object_hit_candidates(world_position)
	var next_id := String(next_candidates[0].get("id", "")) if not next_candidates.is_empty() else ""
	if next_id == _hovered_object_id and _object_candidate_signature(next_candidates) == _object_candidate_signature(_hovered_object_candidates):
		return
	_hovered_object_candidates = next_candidates
	_hovered_object_id = next_id
	_redraw_object_selection_overlay()
	_update_debug_detail_panel()


func _select_hovered_object(world_position: Vector2 = Vector2(INF, INF)) -> bool:
	if _hovered_object_candidates.is_empty():
		return false
	var candidate_ids: Array[String] = []
	for candidate in _hovered_object_candidates:
		candidate_ids.append(String(candidate.get("id", "")))
	var signature := _object_candidate_signature(_hovered_object_candidates)
	var same_click_group := (
		signature == _last_selection_signature
		and _last_selection_world_position.distance_to(world_position) <= OBJECT_CLICK_CYCLE_RADIUS
	)
	_selected_candidate_index = (_selected_candidate_index + 1) % candidate_ids.size() if same_click_group else 0
	_selected_candidate_ids = candidate_ids
	var selected_candidate := _hovered_object_candidates[_selected_candidate_index]
	_selected_object_id = String(selected_candidate.get("id", ""))
	_selected_hit_kind = String(selected_candidate.get("hit_kind", ""))
	_last_selection_signature = signature
	_last_selection_world_position = world_position
	debug_focus_object_id = _selected_object_id
	_redraw_object_selection_overlay()
	_update_debug_detail_panel()
	return true


func _select_object_for_debug(object_id: String) -> void:
	if _object_data_by_id(object_id).is_empty():
		return
	_selected_object_id = object_id
	_selected_candidate_ids = [object_id]
	_selected_candidate_index = 0
	_selected_hit_kind = "direct debug selection"
	_last_selection_signature = ""
	_last_selection_world_position = Vector2(INF, INF)
	debug_focus_object_id = object_id
	_redraw_object_selection_overlay()
	_update_debug_detail_panel()


func _object_data_by_id(object_id: String) -> Dictionary:
	for object_data in _object_footprints():
		if String(object_data.get("id", "")) == object_id:
			return object_data
	return {}


func _redraw_object_selection_overlay() -> void:
	if _debug_selection_layer == null:
		return
	_clear_layer_children(_debug_selection_layer)
	if not show_object_placeholders:
		return
	var ids: Array[String] = []
	if not _hovered_object_id.is_empty():
		ids.append(_hovered_object_id)
	if not _selected_object_id.is_empty() and not ids.has(_selected_object_id):
		ids.append(_selected_object_id)
	for object_id in ids:
		var object_data := _object_data_by_id(object_id)
		if object_data.is_empty():
			continue
		var is_selected := object_id == _selected_object_id
		var center := _object_pixel_center(object_data)
		var visual_points := _object_visual_polygon_points(object_data)
		var composite_surface := _object_floor_collision_are_equivalent(object_data)
		if is_selected and visual_points.size() >= 3:
			_draw_dashed_polygon(_debug_selection_layer, "object_%s_visual_bounds" % object_id, visual_points, COLOR_OBJECT_VISUAL_BOUNDS, 3.5, 10)
		if is_selected and bool(object_data.get("node_backed", false)):
			for selection_index in range(_object_selection_polygons(object_data).size()):
				_draw_dashed_polygon(
					_debug_selection_layer,
					"object_%s_selected_selection_area_%d" % [object_id, selection_index],
					_object_selection_polygons(object_data)[selection_index],
					COLOR_OBJECT_SELECTION_AREA,
					4.0,
					8
				)
			_draw_object_height_guide(_debug_selection_layer, "object_%s_selected" % object_id, object_data, 4.0)
		if is_selected and show_object_floor_footprints and _object_uses_floor_occupancy(object_data):
			var floor_points := _object_floor_polygon_points(object_data)
			if floor_points.size() >= 3:
				_add_line(_debug_selection_layer, "object_%s_occupancy_bounds" % object_id, floor_points + [floor_points[0]], COLOR_OBJECT_OCCUPANCY_OUTLINE.lightened(0.22), 5.0)
		if is_selected and show_object_collision_shapes:
			var collision_points := _object_collision_polygon_points(object_data)
			if not collision_points.is_empty():
				if not composite_surface:
					var collision_fill := COLOR_OBJECT_BLOCKED_CELL
					collision_fill.a = 0.22
					_add_polygon(_debug_selection_layer, "object_%s_collision_bounds" % object_id, collision_points, collision_fill)
				_add_line(
					_debug_selection_layer,
					"object_%s_composite_collision_outline" % object_id if composite_surface else "object_%s_collision_outline" % object_id,
					collision_points + [collision_points[0]],
					COLOR_OBJECT_BLOCKED_CELL,
					5.0
				)
		if is_selected and show_object_interaction_areas and _object_has_valid_interaction_area(object_data):
			var interaction_polygons := _object_interaction_polygons(object_data)
			for polygon_index in range(interaction_polygons.size()):
				var interaction_points: Array = interaction_polygons[polygon_index]
				if interaction_points.size() >= 3:
					_draw_dashed_polygon(
						_debug_selection_layer,
						"object_%s_interaction_bounds_%d" % [object_id, polygon_index],
						interaction_points,
						COLOR_OBJECT_INTERACTION_AREA,
						4.0,
						9
					)
			if bool(object_data.get("node_backed", false)):
				for use_point_index in range(Array(object_data.get("use_points_world", [])).size()):
					_add_marker(
						_debug_selection_layer,
						"object_%s_selected_use_point_%d" % [object_id, use_point_index],
						Vector2(Array(object_data.get("use_points_world", []))[use_point_index]),
						COLOR_OBJECT_INTERACTION_AREA,
						12.0
					)
		if is_selected and show_object_parent_links:
			_draw_object_attachment_guide(_debug_selection_layer, "object_%s_selected_attachment" % object_id, object_data, COLOR_OBJECT_ATTACHMENT, 4.0)
		if show_object_names and show_object_labels:
			var name_ko := String(object_data.get("display_name_ko", _object_display_name_ko(object_id)))
			var hit_kind := _object_selection_hit_kind(object_id)
			var context_text := "%s owner: %s" % [hit_kind, object_id] if hit_kind == "interaction" or hit_kind == "selection" else _object_anchor_short_text(object_data)
			_add_label_with_background(
				_debug_selection_layer,
				"object_%s_short_name" % object_id,
				"%s\n%s" % [name_ko, context_text],
				center + Vector2(12.0, -34.0),
				12,
				COLOR_OBJECT_LABEL_BACKGROUND,
				COLOR_LABEL
			)


func _object_selection_hit_kind(object_id: String) -> String:
	if object_id == _selected_object_id and not _selected_hit_kind.is_empty():
		return _selected_hit_kind
	for candidate in _hovered_object_candidates:
		if String(candidate.get("id", "")) == object_id:
			return String(candidate.get("hit_kind", ""))
	return ""


func _object_collision_grid_rect(object_data: Dictionary) -> Rect2:
	if bool(object_data.get("node_backed", false)):
		var collision_points := _object_collision_polygon_points(object_data)
		if collision_points.is_empty():
			return Rect2()
		var grid_bounds := Rect2(_screen_to_grid_point(collision_points[0]), Vector2.ZERO)
		for point in collision_points.slice(1):
			grid_bounds = grid_bounds.expand(_screen_to_grid_point(point))
		return grid_bounds
	var px_size: Vector2 = object_data.get("collision_size_px", Vector2.ZERO)
	var grid_size := Vector2(px_size.x / tile_width, px_size.y / tile_height)
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var footprint_size: Vector2i = object_data.get("size_cells", Vector2i.ONE)
	var center := Vector2(anchor) + Vector2(footprint_size) * 0.5
	var offset_px: Vector2 = object_data.get("collision_offset_px", Vector2.ZERO)
	center += Vector2(offset_px.x / tile_width, offset_px.y / tile_height)
	return Rect2(center - grid_size * 0.5, grid_size)


func _pixel_rect_points(center: Vector2, size: Vector2) -> Array[Vector2]:
	var half := size * 0.5
	return [
		center + Vector2(-half.x, -half.y),
		center + Vector2(half.x, -half.y),
		center + Vector2(half.x, half.y),
		center + Vector2(-half.x, half.y),
	]
# Room measurements are derived from the current shell rectangles, wall segments, doorway
# edges, navigation cells, and footprint Resources. They do not move or resize shell data.
func _room_measurement_definitions() -> Array[Dictionary]:
	return [
		{
			"room_id": "entrance_area",
			"name_ko": "현관",
			"rect": _entrance_room_rect(),
			"color": COLOR_MEASUREMENT_ENTRANCE,
			"doorway_ids": ["entrance_wall", "entrance_inner_wall"],
			"window_ids": [],
			"wall_ids": ["entrance_wall", "entrance_inner_wall", "bathroom_wall", "living_front_cutaway"],
		},
		{
			"room_id": "bathroom",
			"name_ko": "욕실",
			"rect": _bathroom_room_rect(),
			"color": COLOR_MEASUREMENT_BATHROOM,
			"doorway_ids": ["bathroom_right_wall"],
			"window_ids": [],
			"wall_ids": ["entrance_wall", "bathroom_right_wall", "bathroom_wall", "work_front_shared_wall"],
		},
		{
			"room_id": "living_area",
			"name_ko": "생활공간",
			"rect": _living_room_rect(),
			"color": COLOR_MEASUREMENT_LIVING,
			"doorway_ids": ["work_front_shared_wall", "bathroom_right_wall", "entrance_inner_wall"],
			"window_ids": ["living_window"],
			"wall_ids": ["work_front_shared_wall", "bathroom_right_wall", "entrance_inner_wall", "living_right_wall", "living_front_cutaway"],
		},
		{
			"room_id": "work_power_area",
			"name_ko": "작업공간·전력공간",
			"rect": _work_room_rect(),
			"color": COLOR_MEASUREMENT_WORK,
			"doorway_ids": ["work_front_shared_wall"],
			"window_ids": [],
			"wall_ids": ["work_back_wall", "work_left_wall", "work_right_wall", "work_front_shared_wall"],
		},
	]


func _room_measurement_definition(room_id: String) -> Dictionary:
	for definition in _room_measurement_definitions():
		if String(definition.get("room_id", "")) == room_id:
			return definition
	return {}


func _room_measurement_data(room_id: String) -> Dictionary:
	var definition := _room_measurement_definition(room_id)
	if definition.is_empty():
		return {}
	var rect: Rect2i = definition["rect"]
	var floor_cells := _measurement_room_floor_cells(room_id)
	var walkable_cells := _measurement_room_walkable_cells(room_id)
	var doorway_cells := _measurement_doorway_clearance_cells(room_id)
	var main_path_cells := _measurement_main_path_cells(room_id)
	var placement_cells := _measurement_placement_cells(room_id, doorway_cells, main_path_cells)
	var screen_bounds := _measurement_screen_bounds(rect)
	return {
		"room_id": room_id,
		"name_ko": String(definition["name_ko"]),
		"rect": rect,
		"color": definition["color"],
		"floor_cells": floor_cells,
		"bounds_cell_count": rect.size.x * rect.size.y,
		"walkable_cells": walkable_cells,
		"doorway_clearance_cells": doorway_cells,
		"main_path_cells": main_path_cells,
		"placement_cells": placement_cells,
		"screen_bounds": screen_bounds,
		"center_grid": Vector2(rect.position) + Vector2(rect.size) * 0.5,
		"center_screen": _room_center(rect),
		"doorway_ids": definition["doorway_ids"],
		"window_ids": definition["window_ids"],
		"wall_ids": definition["wall_ids"],
	}


func _measurement_room_floor_cells(room_id: String) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in _visible_floor_cells():
		if _room_area_for_cell(cell, false) == room_id:
			cells.append(cell)
	_sort_cells(cells)
	return cells


func _measurement_room_walkable_cells(room_id: String) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in _walkable_floor_cells():
		if _room_area_for_cell(cell, false) == room_id:
			cells.append(cell)
	_sort_cells(cells)
	return cells


func _measurement_placement_cells(
	room_id: String,
	doorway_cells: Array[Vector2i],
	main_path_cells: Array[Vector2i]
) -> Array[Vector2i]:
	var excluded: Dictionary = {}
	for cell in doorway_cells + main_path_cells + _measurement_all_object_cells():
		excluded[_cell_key(cell)] = true
	for cell in _cells_in_rect(_no_large_object_zone_rect()):
		excluded[_cell_key(cell)] = true

	var cells: Array[Vector2i] = []
	for cell in _measurement_room_floor_cells(room_id):
		if not excluded.has(_cell_key(cell)):
			cells.append(cell)
	_sort_cells(cells)
	return cells


func _measurement_all_object_cells() -> Array[Vector2i]:
	var cells_by_key: Dictionary = {}
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)) or not _object_uses_floor_occupancy(object_data):
			continue
		for cell in _object_occupied_cells(object_data):
			cells_by_key[_cell_key(cell)] = cell
	return _cells_from_map(cells_by_key)


func _measurement_doorway_entry_cells(room_id: String) -> Array[Vector2i]:
	var definition := _room_measurement_definition(room_id)
	var cells_by_key: Dictionary = {}
	for doorway_id in definition.get("doorway_ids", []):
		var segment := _wall_segment_by_id(String(doorway_id))
		if segment.is_empty() or not bool(segment.get("enabled", true)):
			continue
		var offset_start := int(segment.get("doorway_offset", -1))
		var doorway_width := int(segment.get("doorway_width", 0))
		if offset_start < 0 or doorway_width <= 0:
			continue
		for offset in range(offset_start, offset_start + doorway_width):
			var edge := _wall_segment_unit_edge(segment, offset)
			for cell in _measurement_adjacent_cells_for_edge(edge):
				if _room_area_for_cell(cell, false) == room_id:
					cells_by_key[_cell_key(cell)] = cell
	return _cells_from_map(cells_by_key)


func _measurement_doorway_clearance_cells(room_id: String) -> Array[Vector2i]:
	var radius := maxi(0, doorway_clearance_cells - 1)
	return _measurement_expand_room_cells(room_id, _measurement_doorway_entry_cells(room_id), radius)


func _measurement_adjacent_cells_for_edge(edge: Dictionary) -> Array[Vector2i]:
	var from_cell: Vector2i = edge.get("from_cell", Vector2i.ZERO)
	var axis: WallAxis = edge.get("axis", WallAxis.AXIS_A)
	if axis == WallAxis.AXIS_B:
		return [from_cell + Vector2i(-1, 0), from_cell]
	return [from_cell + Vector2i(0, -1), from_cell]


func _measurement_main_path_cells(room_id: String) -> Array[Vector2i]:
	var room_cells := _measurement_room_walkable_cells(room_id)
	if room_cells.is_empty():
		return []
	var targets := _measurement_doorway_entry_cells(room_id)
	for object_data in _object_footprints():
		if String(object_data.get("room_area_id", "")) != room_id:
			continue
		for interaction_cell in _object_interaction_cells(object_data):
			if _is_walkable_cell(interaction_cell) and not targets.has(interaction_cell):
				targets.append(interaction_cell)
	if targets.is_empty():
		return []
	var source: Vector2i = targets[0]
	var path_by_key: Dictionary = {}
	for target in targets:
		for cell in _measurement_cell_path(source, target, room_cells):
			path_by_key[_cell_key(cell)] = cell
	var radius := maxi(0, main_path_clearance_cells - 1)
	return _measurement_expand_room_cells(room_id, _cells_from_map(path_by_key), radius)


func _measurement_interaction_is_reachable(room_id: String, interaction_cell: Vector2i) -> bool:
	var room_cells := _measurement_room_walkable_cells(room_id)
	for doorway_cell in _measurement_doorway_entry_cells(room_id):
		if not _measurement_cell_path(doorway_cell, interaction_cell, room_cells).is_empty():
			return true
	return false


func _measurement_cell_path(
	start_cell: Vector2i,
	target_cell: Vector2i,
	allowed_cells: Array[Vector2i]
) -> Array[Vector2i]:
	var allowed: Dictionary = {}
	for cell in allowed_cells:
		allowed[_cell_key(cell)] = true
	if not allowed.has(_cell_key(start_cell)) or not allowed.has(_cell_key(target_cell)):
		return []

	var frontier: Array[Vector2i] = [start_cell]
	var cursor := 0
	var came_from: Dictionary = {_cell_key(start_cell): start_cell}
	while cursor < frontier.size():
		var current := frontier[cursor]
		cursor += 1
		if current == target_cell:
			break
		for edge_name in ["top", "right", "bottom", "left"]:
			var next_cell := _neighbor_cell_for_edge(current, edge_name)
			var next_key := _cell_key(next_cell)
			if not allowed.has(next_key) or came_from.has(next_key):
				continue
			if String(_navigation_edge_status_for_cell(current, edge_name).get("status", "open")) == "blocked":
				continue
			came_from[next_key] = current
			frontier.append(next_cell)

	if not came_from.has(_cell_key(target_cell)):
		return []
	var path: Array[Vector2i] = []
	var current := target_cell
	while current != start_cell:
		path.push_front(current)
		current = came_from[_cell_key(current)]
	path.push_front(start_cell)
	return path


func _measurement_expand_room_cells(
	room_id: String,
	source_cells: Array[Vector2i],
	radius: int
) -> Array[Vector2i]:
	var cells_by_key: Dictionary = {}
	for source in source_cells:
		for x_offset in range(-radius, radius + 1):
			for y_offset in range(-radius, radius + 1):
				if abs(x_offset) + abs(y_offset) > radius:
					continue
				var cell := source + Vector2i(x_offset, y_offset)
				if _room_area_for_cell(cell, false) == room_id:
					cells_by_key[_cell_key(cell)] = cell
	return _cells_from_map(cells_by_key)


func _measurement_nearest_cell(cells: Array[Vector2i], target: Vector2) -> Vector2i:
	var nearest := cells[0]
	var nearest_distance := Vector2(nearest).distance_squared_to(target)
	for cell in cells:
		var distance := Vector2(cell).distance_squared_to(target)
		if distance < nearest_distance:
			nearest = cell
			nearest_distance = distance
	return nearest


func _measurement_screen_bounds(rect: Rect2i) -> Rect2:
	var points := _rect_points(rect)
	var minimum := points[0]
	var maximum := points[0]
	for point in points:
		minimum.x = minf(minimum.x, point.x)
		minimum.y = minf(minimum.y, point.y)
		maximum.x = maxf(maximum.x, point.x)
		maximum.y = maxf(maximum.y, point.y)
	return Rect2(minimum, maximum - minimum)


func _cells_in_rect(rect: Rect2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			cells.append(Vector2i(x, y))
	return cells


func _cells_from_map(cells_by_key: Dictionary) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for key in cells_by_key.keys():
		cells.append(cells_by_key[key])
	_sort_cells(cells)
	return cells


func _sort_cells(cells: Array[Vector2i]) -> void:
	cells.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		if a.y == b.y:
			return a.x < b.x
		return a.y < b.y
	)


func _wall_segment_by_id(segment_id: String) -> Dictionary:
	for segment in _wall_segments():
		if String(segment.get("id", "")) == segment_id:
			return segment
	return {}


func _measurement_wall_unit_data(segment: Dictionary) -> Array[Dictionary]:
	var units: Array[Dictionary] = []
	var length := int(segment.get("length", 0))
	for offset in range(length):
		var edge := _wall_segment_unit_edge(segment, offset)
		var reasons: Array[String] = []
		if _is_wall_segment_doorway_unit(segment, offset):
			reasons.append("문")
		if _measurement_wall_unit_has_window(segment, offset):
			reasons.append("창문")
		if length > 2 and (offset == 0 or offset == length - 1):
			reasons.append("코너")
		units.append({
			"offset": offset,
			"edge": edge,
			"available": reasons.is_empty(),
			"reasons": reasons,
		})
	return units


func _measurement_wall_unit_has_window(segment: Dictionary, offset: int) -> bool:
	if String(segment.get("id", "")) != "living_right_wall":
		return false
	var start_cell: Vector2i = segment.get("start_cell", Vector2i.ZERO)
	var segment_start := float(start_cell.y)
	var unit_start := segment_start + float(offset)
	var unit_end := unit_start + 1.0
	var window_start := living_window_axis_b_start
	var window_end := living_window_axis_b_start + living_window_width
	return unit_start < window_end and unit_end > window_start


func _measurement_wall_available_edges_text(segment: Dictionary) -> String:
	var edge_parts: Array[String] = []
	for unit in _measurement_wall_unit_data(segment):
		if not bool(unit.get("available", false)):
			continue
		var edge: Dictionary = unit["edge"]
		edge_parts.append("%s→%s" % [
			_format_cell(edge.get("from_cell", Vector2i.ZERO)),
			_format_cell(edge.get("to_cell", Vector2i.ZERO)),
		])
	return ", ".join(edge_parts) if not edge_parts.is_empty() else "없음"


func _measurement_wall_length_px(segment: Dictionary) -> float:
	var start_cell := _segment_start_cell(segment)
	var end_cell := Vector2(_segment_end_cell_i(segment))
	return _iso(start_cell.x, start_cell.y).distance_to(_iso(end_cell.x, end_cell.y))


func _draw_room_measurement_overlay() -> void:
	if _room_measurement_layer == null:
		return
	for definition in _room_measurement_definitions():
		var room_id := String(definition["room_id"])
		var data := _room_measurement_data(room_id)
		_draw_room_measurement_cells(data)
	_draw_wall_attachment_measurements()


func _draw_room_measurement_cells(data: Dictionary) -> void:
	var room_color: Color = data.get("color", COLOR_MEASUREMENT_LIVING)
	var room_rect: Rect2i = data.get("rect", Rect2i())
	for cell in data.get("floor_cells", []):
		_add_polygon(
			_room_measurement_layer,
			"measurement_room_%s_%d_%d" % [data["room_id"], cell.x, cell.y],
			_measurement_inset_tile_points(cell, 0.04),
			room_color
		)
	for cell in data.get("placement_cells", []):
		_add_polygon(
			_room_measurement_layer,
			"measurement_placement_%s_%d_%d" % [data["room_id"], cell.x, cell.y],
			_measurement_inset_tile_points(cell, 0.42),
			COLOR_MEASUREMENT_PLACEMENT
		)
	var bounds_points := _rect_points(room_rect)
	_add_line(
		_room_measurement_layer,
		"measurement_room_%s_bounds" % data["room_id"],
		bounds_points + [bounds_points[0]],
		room_color.lightened(0.55),
		4.0
	)
	_add_label_with_background(
		_room_measurement_layer,
		"measurement_room_%s_name" % data["room_id"],
		String(data.get("name_ko", data["room_id"])),
		_room_center(room_rect) + Vector2(-44.0, -18.0),
		13,
		COLOR_MEASUREMENT_LABEL_BACKGROUND,
		COLOR_DEBUG_TEXT
	)
	for cell in data.get("main_path_cells", []):
		_add_polygon(
			_room_measurement_layer,
			"measurement_path_%s_%d_%d" % [data["room_id"], cell.x, cell.y],
			_measurement_inset_tile_points(cell, 0.31),
			COLOR_MEASUREMENT_MAIN_PATH
		)
	for cell in data.get("doorway_clearance_cells", []):
		_add_polygon(
			_room_measurement_layer,
			"measurement_door_clearance_%s_%d_%d" % [data["room_id"], cell.x, cell.y],
			_measurement_inset_tile_points(cell, 0.22),
			COLOR_MEASUREMENT_DOOR_CLEARANCE
		)


func _measurement_inset_tile_points(cell: Vector2i, inset_ratio: float) -> Array[Vector2]:
	var points := _tile_points(float(cell.x), float(cell.y))
	var center := _cell_center(cell)
	var inset: Array[Vector2] = []
	for point in points:
		inset.append(point.lerp(center, inset_ratio))
	return inset


func _draw_wall_attachment_measurements() -> void:
	var seen: Dictionary = {}
	for definition in _room_measurement_definitions():
		for wall_id in definition.get("wall_ids", []):
			var id := String(wall_id)
			if seen.has(id):
				continue
			seen[id] = true
			var segment := _wall_segment_by_id(id)
			if segment.is_empty() or not bool(segment.get("enabled", true)):
				continue
			_draw_wall_attachment_segment(segment)


func _draw_wall_attachment_segment(segment: Dictionary) -> void:
	var id := String(segment["id"])
	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	for unit in _measurement_wall_unit_data(segment):
		var edge: Dictionary = unit["edge"]
		var from_cell: Vector2i = edge["from_cell"]
		var to_cell: Vector2i = edge["to_cell"]
		var color := COLOR_MEASUREMENT_WALL_AVAILABLE if bool(unit["available"]) else COLOR_MEASUREMENT_WALL_UNAVAILABLE
		if bool(unit["available"]) and render_mode != WallRenderMode.FULL:
			color = COLOR_MEASUREMENT_WALL_LOGICAL
		var p0 := _iso(from_cell.x, from_cell.y) + Vector2(0.0, -9.0)
		var p1 := _iso(to_cell.x, to_cell.y) + Vector2(0.0, -9.0)
		if bool(unit["available"]) and render_mode != WallRenderMode.FULL:
			_draw_measurement_dashed_line("measurement_wall_%s_%d" % [id, int(unit["offset"])], p0, p1, color)
		else:
			_add_line(_room_measurement_layer, "measurement_wall_%s_%d" % [id, int(unit["offset"])], [p0, p1], color, 5.0)

func _draw_measurement_dashed_line(line_name: String, p0: Vector2, p1: Vector2, color: Color) -> void:
	const DASH_COUNT := 5
	for index in range(DASH_COUNT):
		var start_ratio := float(index) / float(DASH_COUNT)
		var end_ratio := minf(start_ratio + 0.11, 1.0)
		_add_line(
			_room_measurement_layer,
			"%s_dash_%d" % [line_name, index],
			[p0.lerp(p1, start_ratio), p0.lerp(p1, end_ratio)],
			color,
			5.0
		)


func _draw_control_hint() -> void:
	_compact_help_label = Label.new()
	_compact_help_label.name = "CompactDebugHelp"
	_compact_help_label.position = Vector2(24, 20)
	_compact_help_label.modulate = COLOR_LABEL
	_compact_help_label.add_theme_font_size_override("font_size", 14)
	_compact_help_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_compact_help_label.add_theme_constant_override("shadow_offset_x", 2)
	_compact_help_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_compact_help_label)
	_create_hover_coord_overlay()
	_create_active_room_overlay()
	_create_measurement_legend_overlay()
	_create_object_legend_overlay()
	_create_debug_detail_panel()
	_create_full_debug_help_panel()
	_create_interaction_debug_ui()
	_update_compact_debug_help()


func _create_object_legend_overlay() -> void:
	_object_legend_background = ColorRect.new()
	_object_legend_background.name = "ObjectPlacementLegendBackground"
	_object_legend_background.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_object_legend_background.position = Vector2(-430.0, 20.0)
	_object_legend_background.size = Vector2(406.0, 184.0)
	_object_legend_background.color = COLOR_OBJECT_LEGEND_BACKGROUND
	_debug_overlay_layer.add_child(_object_legend_background)

	_object_legend_label = Label.new()
	_object_legend_label.name = "ObjectPlacementLegendLabel"
	_object_legend_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_object_legend_label.position = Vector2(-418.0, 28.0)
	_object_legend_label.text = "오브젝트 배치 범례\n파랑 면: BodyPolygon 기반 floor occupancy  |  빨강: BodyPolygon collision\n같은 면: 파랑 채움 + 빨강 테두리  |  PlacementFootprint는 선택 사항\n청록 점선: SelectionPolygon (hover/click 전용)\n주황 점선: InteractionPolygon  |  주황 마커: UsePoint\n흰 점선: 선택된 Sprite2D/VisualPreview bounds  |  분홍: AttachmentSocket\n초록: BasePoint  |  노랑: TopPoint/높이 가이드\n같은 위치 반복 클릭: 후보 순환  |  V: 전체 벽 반투명"
	_object_legend_label.modulate = COLOR_DEBUG_TEXT
	_object_legend_label.add_theme_font_size_override("font_size", 12)
	_object_legend_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_object_legend_label.add_theme_constant_override("shadow_offset_x", 2)
	_object_legend_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_object_legend_label)


func _create_debug_detail_panel() -> void:
	_debug_detail_panel = _make_debug_panel("DebugDetailPanel", Vector2.ZERO, Vector2(410.0, 470.0))
	_debug_detail_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_debug_detail_panel.position = Vector2(-430.0, 200.0)
	_debug_overlay_layer.add_child(_debug_detail_panel)
	var box := _make_panel_vbox(_debug_detail_panel)
	_debug_detail_label = _make_debug_label_control("", 12, COLOR_DEBUG_TEXT)
	_debug_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_debug_detail_label)
	_update_debug_detail_panel()


func _create_full_debug_help_panel() -> void:
	_debug_help_panel = _make_debug_panel("DebugHelpPanel", Vector2(300.0, 90.0), Vector2(760.0, 620.0))
	_debug_overlay_layer.add_child(_debug_help_panel)
	var box := _make_panel_vbox(_debug_help_panel)
	box.add_child(_make_debug_label_control("아파트 shell 디버그 단축키", 20, COLOR_DEBUG_TEXT))
	box.add_child(_make_debug_label_control(
		"기준 시점: ROTATE_90 / full_map (이번 배치 검토 기준)\n\nM  방 측량 모드\nP  오브젝트 배치 모드 (같은 위치 반복 클릭: 후보 순환)\nN  이동·충돌 모드\nShift+M/P/N  임시 조합 표시\n\nV  전체 candidate 벽·문·창 반투명\nG  바닥 좌표  /  E  벽선 좌표  /  W  벽 정보\nO  숨김벽 논리선  /  L  구역 라벨  /  I  inventory 출력\nJ  7개 직접 상호작용 mock  /  H  Phone mock\n1/2/3  카메라 preset  /  방향키  N marker 이동\n\nF1 또는 ESC  이 도움말 닫기\nESC  열린 mock UI 또는 현재 M/P/N 모드 닫기",
		15,
		COLOR_DEBUG_TEXT
	))
	_debug_help_panel.visible = false


func _toggle_full_debug_help() -> void:
	if _debug_help_panel == null:
		return
	if not _debug_help_panel.visible:
		_close_interaction_debug_ui()
		if _phone_overlay_root != null:
			_phone_overlay_root.visible = false
	_debug_help_panel.visible = not _debug_help_panel.visible


func _update_compact_debug_help() -> void:
	if _compact_help_label == null:
		return
	var wall_state := "반투명" if wall_inspection_transparency else "기본"
	_compact_help_label.text = "기준 시점 ROTATE_90  |  현재 모드: %s  |  M 측량  P 오브젝트  N 이동·충돌  |  V 전체벽=%s  |  F1 도움말" % [_debug_mode_display_name(), wall_state]


func _update_debug_detail_panel() -> void:
	if _debug_detail_label == null:
		return
	if show_object_placeholders:
		var object_id := _selected_object_id if not _selected_object_id.is_empty() else _hovered_object_id
		var object_data := _object_data_by_id(object_id)
		_debug_detail_label.text = _object_debug_detail_text(object_data)
	elif show_room_measurements:
		_debug_detail_label.text = _room_measurement_detail_text()
	elif show_navigation_debug:
		_debug_detail_label.text = _navigation_debug_detail_text()
	else:
		_debug_detail_label.text = ""


func _object_debug_detail_text(object_data: Dictionary) -> String:
	if object_data.is_empty():
		return "오브젝트 배치\n\n오브젝트를 가리키거나 클릭하면 상세 정보가 표시됩니다."
	var id := String(object_data.get("id", ""))
	var hit_kind := _object_selection_hit_kind(id)
	var selection_text := "hover 판정: %s" % hit_kind
	if id == _selected_object_id:
		var candidate_count := maxi(1, _selected_candidate_ids.size())
		var candidate_position := clampi(_selected_candidate_index + 1, 1, candidate_count)
		selection_text = "선택 %d/%d · 판정: %s" % [candidate_position, candidate_count, hit_kind]
	if hit_kind == "interaction":
		selection_text += " · interaction owner: %s" % id
	elif hit_kind == "selection":
		selection_text += " · selection owner: %s" % id
	var detail := "%s\n%s\nid: %s\ncategory: %s\nroom: %s\nanchor type: %s\nanchor resolved: %s\nposition offset: %s\nvisual: %s\ncollision: %s @ %s\ninteraction: %s @ %s\ninteraction cells: %s\nmovement block: %s / floor occupancy: %s\nparent: %s\nwall: %s @ %.2f" % [
		selection_text,
		String(object_data.get("display_name_ko", _object_display_name_ko(id))), id,
		_object_category_name(object_data), _room_area_label(String(object_data.get("room_area_id", ""))), _object_anchor_type_name(object_data),
		_object_anchor_debug_text(object_data), str(object_data.get("position_offset_px", Vector2.ZERO)),
		str(object_data.get("visual_size_px", Vector2.ZERO)), str(object_data.get("collision_size_px", Vector2.ZERO)),
		str(object_data.get("collision_offset_px", Vector2.ZERO)), str(object_data.get("interaction_size_px", Vector2.ZERO)),
		str(object_data.get("interaction_offset_px", Vector2.ZERO)), _format_cells(_object_interaction_cells(object_data)),
		_bool_ko(bool(object_data.get("blocks_movement", false))), _bool_ko(_object_uses_floor_occupancy(object_data)),
		String(object_data.get("parent_object_id", "-")) if not String(object_data.get("parent_object_id", "")).is_empty() else "-",
		String(object_data.get("wall_segment_id", "-")) if not String(object_data.get("wall_segment_id", "")).is_empty() else "-",
		float(object_data.get("wall_position_ratio", 0.5)),
	]
	if bool(object_data.get("node_backed", false)):
		detail += "\ngeometry source: SCENE_NODE\nnode: %s\nvisual source: %s\nfloor source: %s\nselection source: %s / size: %s\nBasePoint: %s\nTopPoint: %s / height: %.1f px\nUsePoint: %s\nAttachmentSocket: %s" % [
			String(object_data.get("node_path", "-")),
			String(object_data.get("visual_source", "-")),
			String(object_data.get("floor_occupancy_source", "NONE")),
			String(object_data.get("selection_source", "-")),
			str(object_data.get("selection_size_px", Vector2.ZERO)),
			str(object_data.get("base_point_world", Vector2.ZERO)),
			str(object_data.get("top_point_world", Vector2.ZERO)),
			float(object_data.get("height_px", 0.0)),
			str(Array(object_data.get("use_points_world", []))),
			str(object_data.get("socket_world_position", Vector2.ZERO)),
		]
	return detail


func _room_measurement_detail_text() -> String:
	var lines: Array[String] = ["방 측량 요약"]
	for definition in _room_measurement_definitions():
		var data := _room_measurement_data(String(definition["room_id"]))
		var rect: Rect2i = data["rect"]
		lines.append("\n%s  %s→%s" % [data["name_ko"], _format_cell(rect.position), _format_cell(rect.end)])
		lines.append("이동 %d / 배치 후보 %d / 문 여유 %d / 필수 경로 %d" % [
			data["walkable_cells"].size(), data["placement_cells"].size(),
			data["doorway_clearance_cells"].size(), data["main_path_cells"].size(),
		])
	return "\n".join(lines)


func _navigation_debug_detail_text() -> String:
	return "이동·충돌\n\n초록: 이동 가능\n빨강: 오브젝트 차단\n빨강 선: 벽 차단\n청록 선: 문 통과 가능\n노랑: 디버그 플레이어\n\n현재 칸: %s\n현재 방: %s\nwalkable: %d / blocked objects: %d" % [
		_format_cell(player_debug_cell), _room_area_label(_active_room_area()),
		_walkable_floor_cells().size(), _object_blocked_cells().size(),
	]


# Builds shell-only interaction / phone UI. This deliberately stays in the candidate
# scene and does not call production PhoneUI, object interaction, save, power, or time systems.
func _create_interaction_debug_ui() -> void:
	_interaction_menu_panel = _make_debug_panel("InteractionDebugMenu", Vector2(24.0, 132.0), Vector2(330.0, 520.0))
	var menu_box: VBoxContainer = _make_panel_vbox(_interaction_menu_panel)
	menu_box.add_child(_make_debug_label_control("상호작용 테스트", 18, COLOR_DEBUG_TEXT))
	menu_box.add_child(_make_debug_label_control("shell debug mock / 실제 오브젝트 클릭 연결 없음", 12, COLOR_DEBUG_MUTED_TEXT))
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(300.0, 410.0)
	_interaction_object_list = VBoxContainer.new()
	_interaction_object_list.add_theme_constant_override("separation", 4)
	scroll.add_child(_interaction_object_list)
	menu_box.add_child(scroll)
	for object_id in _interaction_debug_object_ids():
		var data := _interaction_debug_object_data(object_id)
		var button := Button.new()
		button.text = "%s / %s" % [String(data.get("name", object_id)), object_id]
		button.pressed.connect(Callable(self, "_open_interaction_panel").bind(object_id))
		_interaction_object_list.add_child(button)
	var close_menu_button := Button.new()
	close_menu_button.text = "닫기"
	close_menu_button.pressed.connect(func() -> void:
		_close_interaction_debug_ui()
	)
	menu_box.add_child(close_menu_button)
	_debug_overlay_layer.add_child(_interaction_menu_panel)
	_interaction_menu_panel.visible = false

	_interaction_panel = _make_debug_panel("InteractionDebugPanel", Vector2(380.0, 132.0), Vector2(420.0, 330.0), COLOR_DEBUG_PANEL_ALT)
	var interaction_box: VBoxContainer = _make_panel_vbox(_interaction_panel)
	_interaction_title_label = _make_debug_label_control("오브젝트", 18, COLOR_DEBUG_TEXT)
	_interaction_body_label = _make_debug_label_control("", 13, COLOR_DEBUG_TEXT)
	_interaction_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_interaction_result_label = _make_debug_label_control("", 13, COLOR_DEBUG_MUTED_TEXT)
	_interaction_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	interaction_box.add_child(_interaction_title_label)
	interaction_box.add_child(_interaction_body_label)
	interaction_box.add_child(_interaction_result_label)
	var interaction_buttons := HBoxContainer.new()
	interaction_buttons.add_theme_constant_override("separation", 8)
	for button_data in [
		{"label": "사용하기", "mode": "use"},
		{"label": "살펴보기", "mode": "inspect"},
		{"label": "취소", "mode": "cancel"},
	]:
		var button := Button.new()
		button.text = String(button_data["label"])
		var mode := String(button_data["mode"])
		button.pressed.connect(Callable(self, "_handle_interaction_panel_action").bind(mode))
		interaction_buttons.add_child(button)
	interaction_box.add_child(interaction_buttons)
	_debug_overlay_layer.add_child(_interaction_panel)
	_interaction_panel.visible = false

	_create_phone_debug_overlay()


func _create_phone_debug_overlay() -> void:
	_phone_overlay_root = Control.new()
	_phone_overlay_root.name = "ApartmentShellPhoneDebugOverlay"
	_phone_overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_phone_overlay_root.visible = false
	var backdrop := ColorRect.new()
	backdrop.name = "PhoneDebugBackdrop"
	backdrop.color = COLOR_DEBUG_PANEL_BACKDROP
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_phone_overlay_root.add_child(backdrop)
	var panel := _make_debug_panel("PhoneDebugPanel", Vector2(500.0, 90.0), Vector2(430.0, 470.0), COLOR_DEBUG_PANEL_ALT)
	var phone_box: VBoxContainer = _make_panel_vbox(panel)
	phone_box.add_child(_make_debug_label_control("CONCENT Phone", 22, COLOR_DEBUG_TEXT))
	phone_box.add_child(_make_debug_label_control("shell debug overlay / production PhoneUI 미연결", 12, COLOR_DEBUG_MUTED_TEXT))
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	for tab_data in [
		{"label": "메시지", "tab": "messages"},
		{"label": "전력", "tab": "power"},
		{"label": "의뢰", "tab": "jobs"},
		{"label": "설정", "tab": "settings"},
	]:
		var tab_button := Button.new()
		tab_button.text = String(tab_data["label"])
		var tab := String(tab_data["tab"])
		tab_button.pressed.connect(Callable(self, "_show_phone_tab").bind(tab))
		tabs.add_child(tab_button)
	phone_box.add_child(tabs)
	_phone_content_label = _make_debug_label_control("", 14, COLOR_DEBUG_TEXT)
	_phone_content_label.custom_minimum_size = Vector2(380.0, 250.0)
	_phone_content_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	phone_box.add_child(_phone_content_label)
	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(func() -> void:
		_close_phone_overlay()
	)
	phone_box.add_child(close_button)
	_phone_overlay_root.add_child(panel)
	_debug_overlay_layer.add_child(_phone_overlay_root)
	_show_phone_tab("messages")


func _make_debug_panel(panel_name: String, position: Vector2, size: Vector2, fill_color := COLOR_DEBUG_PANEL) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.position = position
	panel.custom_minimum_size = size
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = COLOR_DEBUG_PANEL_BORDER
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _make_panel_vbox(panel: PanelContainer) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	return box


func _make_debug_label_control(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.modulate = color
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _toggle_interaction_debug_menu() -> void:
	if _debug_help_panel != null:
		_debug_help_panel.visible = false
	if _phone_overlay_root != null and _phone_overlay_root.visible:
		_close_phone_overlay()
	if _interaction_menu_panel == null:
		return
	var should_show := not _interaction_menu_panel.visible
	_interaction_menu_panel.visible = should_show
	if not should_show and _interaction_panel != null:
		_interaction_panel.visible = false


func _close_interaction_debug_ui() -> void:
	if _interaction_menu_panel != null:
		_interaction_menu_panel.visible = false
	if _interaction_panel != null:
		_interaction_panel.visible = false
	_interaction_active_object_id = ""


func _open_interaction_panel(object_id: String) -> void:
	if _phone_overlay_root != null and _phone_overlay_root.visible:
		_close_phone_overlay()
	_interaction_active_object_id = object_id
	var data := _interaction_debug_object_data(object_id)
	if _interaction_title_label != null:
		_interaction_title_label.text = "%s / %s" % [String(data.get("name", object_id)), object_id]
	if _interaction_body_label != null:
		_interaction_body_label.text = "%s\n\n현재 패널은 shell debug mock입니다. 실제 오브젝트 클릭, 이동, 허기, 전력, 시간 변화와 연결되지 않았습니다." % String(data.get("summary", "설명이 없는 shell object입니다."))
	if _interaction_result_label != null:
		_interaction_result_label.text = "버튼을 눌러 mock 결과를 확인하세요."
	if _interaction_panel != null:
		_interaction_panel.visible = true
	if _interaction_menu_panel != null:
		_interaction_menu_panel.visible = true


func _handle_interaction_panel_action(mode: String) -> void:
	if mode == "cancel":
		if _interaction_panel != null:
			_interaction_panel.visible = false
		_interaction_active_object_id = ""
		return
	if _interaction_active_object_id.is_empty():
		return
	var data := _interaction_debug_object_data(_interaction_active_object_id)
	if _interaction_result_label == null:
		return
	if mode == "inspect":
		_interaction_result_label.text = "살펴보기: %s" % String(data.get("inspect", data.get("summary", "")))
	elif mode == "use":
		_interaction_result_label.text = "사용 결과: %s" % String(data.get("use_result", "아직 실제 효과는 연결되지 않았습니다. 나중에 허기/전력/시간 변화와 연결 예정."))


func _toggle_phone_overlay() -> void:
	if _phone_overlay_root == null:
		return
	if _phone_overlay_root.visible:
		_close_phone_overlay()
	else:
		_open_phone_overlay()


func _open_phone_overlay() -> void:
	if _debug_help_panel != null:
		_debug_help_panel.visible = false
	_close_interaction_debug_ui()
	if _phone_overlay_root != null:
		_show_phone_tab("messages")
		_phone_overlay_root.visible = true


func _close_phone_overlay() -> void:
	if _phone_overlay_root != null:
		_phone_overlay_root.visible = false


func _close_top_debug_overlay() -> bool:
	if _phone_overlay_root != null and _phone_overlay_root.visible:
		_close_phone_overlay()
		return true
	if _interaction_panel != null and _interaction_panel.visible:
		_interaction_panel.visible = false
		_interaction_active_object_id = ""
		return true
	if _interaction_menu_panel != null and _interaction_menu_panel.visible:
		_close_interaction_debug_ui()
		return true
	if _debug_help_panel != null and _debug_help_panel.visible:
		_debug_help_panel.visible = false
		return true
	return false


func _show_phone_tab(tab: String) -> void:
	if _phone_content_label == null:
		return
	match tab:
		"messages":
			_phone_content_label.text = "메시지\n\n읽지 않은 메시지: 1\n브로커: 오늘 배급 전력 확인했어?\n\n이 화면은 shell debug mock입니다."
		"power":
			_phone_content_label.text = "전력\n\n현재 전력: mock\n소비량: mock\n주의: 실제 전력 시스템과 아직 연결되지 않음"
		"jobs":
			_phone_content_label.text = "의뢰\n\n진행 가능한 의뢰 없음\n나중에 브로커 의뢰 / 해킹 의뢰와 연결 예정"
		"settings":
			_phone_content_label.text = "설정\n\ndebug phone overlay\nproduction PhoneUI와 연결되지 않음\nESC 또는 닫기로 종료"
		_:
			_phone_content_label.text = "알 수 없는 debug phone tab: %s" % tab


func _direct_interaction_object_ids() -> Array[String]:
	var ids: Array[String] = []
	for contract_id in DIRECT_INTERACTION_OBJECT_IDS:
		var object_data := _object_data_by_id(contract_id)
		if not object_data.is_empty() and bool(object_data.get("enabled", true)) and _object_is_direct_interaction(object_data):
			ids.append(contract_id)
	return ids


func _interaction_debug_object_ids() -> Array[String]:
	var ids := _direct_interaction_object_ids()
	ids.append("phone")
	return ids


func _interaction_debug_object_data(object_id: String) -> Dictionary:
	var data := {
		"name": _object_display_name_ko(object_id),
		"summary": "아파트 shell object footprint 후보입니다.",
		"inspect": "아직 상세 설명이 연결되지 않았습니다.",
		"use_result": "아직 실제 효과는 연결되지 않았습니다. 나중에 허기/전력/시간 변화와 연결 예정.",
	}
	match object_id:
		"entrance_door":
			data["summary"] = "현관 외벽 doorway inventory 오브젝트입니다."
			data["inspect"] = "문 자체는 바닥 footprint를 중복 차단하지 않는다."
		"bed":
			data["summary"] = "수면 구역의 침대 후보입니다."
			data["inspect"] = "정돈된 침대다. 휴식과 하루 종료 후보가 될 수 있다."
		"fridge":
			data["summary"] = "생활공간 주방 쪽 소형 냉장고 후보입니다."
			data["inspect"] = "소형 냉장고다. 배급 식품을 보관한다."
		"microwave":
			data["summary"] = "비차단 전자레인지 후보입니다."
			data["inspect"] = "전자레인지다. 간단한 배급식을 데울 수 있을 것 같다."
		"navi_link":
			data["summary"] = "NAVI LINK 해킹 진입 장비 후보입니다."
			data["inspect"] = "작업공간의 가장 큰 바닥형 장비다."
		"power_module_board":
			data["summary"] = "통합된 벽면 전력 모듈 보드 후보입니다."
			data["inspect"] = "전력 패널과 커넥터 보드를 하나로 통합한 장비다."
		"node_17":
			data["summary"] = "NODE-17 통신·스토리 장비 후보입니다."
			data["inspect"] = "신호 증폭기와 연결된 작업공간 장비다."
		"phone":
			data["name"] = "핸드폰"
			data["summary"] = "유이가 휴대하는 Phone mock 항목입니다."
			data["inspect"] = "Phone은 방 고정 오브젝트가 아니라 휴대 장비다. 이 shell에서는 H 키로 debug overlay를 연다."
			data["use_result"] = "Phone debug overlay는 H 키로 열 수 있습니다. production PhoneUI와는 연결되지 않았습니다."
	return data


func _draw_floor_grid_overlay() -> void:
	for cell in _visible_floor_cells():
		var coord_label := _add_label_with_background(
			_grid_coord_layer,
			"grid_coord_%d_%d" % [cell.x, cell.y],
			"칸 %s" % _format_cell(cell),
			_iso(float(cell.x) + 0.5, float(cell.y) + 0.5) + Vector2(-30.0, -12.0),
			12,
			COLOR_GRID_LABEL_BACKGROUND,
			COLOR_GRID_LABEL_TEXT
		)
		coord_label.modulate = COLOR_GRID_LABEL_TEXT
	_draw_grid_axis_overlay()


func _draw_grid_axis_overlay() -> void:
	var origin := _iso(0.0, 0.0)
	var x_end := _iso(1.45, 0.0)
	var y_end := _iso(0.0, 1.45)
	_add_marker(_grid_coord_layer, "grid_origin_marker", origin, COLOR_GRID_ORIGIN, 15.0)
	_add_label_with_background(_grid_coord_layer, "grid_origin_label", "원점 (0,0)", origin + Vector2(16.0, -36.0), 14, COLOR_GRID_LABEL_BACKGROUND, COLOR_GRID_LABEL_TEXT)
	_add_line(_grid_coord_layer, "grid_axis_x", [origin, x_end], COLOR_GRID_AXIS_X, 5.0)
	_add_line(_grid_coord_layer, "grid_axis_y", [origin, y_end], COLOR_GRID_AXIS_Y, 5.0)
	_add_arrow_head(_grid_coord_layer, "grid_axis_x_head", origin, x_end, COLOR_GRID_AXIS_X)
	_add_arrow_head(_grid_coord_layer, "grid_axis_y_head", origin, y_end, COLOR_GRID_AXIS_Y)
	_add_label_with_background(_grid_coord_layer, "grid_axis_x_label", "+X", x_end + Vector2(12.0, -16.0), 15, COLOR_GRID_LABEL_BACKGROUND, COLOR_GRID_AXIS_X)
	_add_label_with_background(_grid_coord_layer, "grid_axis_y_label", "+Y", y_end + Vector2(12.0, -16.0), 15, COLOR_GRID_LABEL_BACKGROUND, COLOR_GRID_AXIS_Y)


func _draw_navigation_overlay() -> void:
	for area_id in _navigation_area_ids():
		var cells := _navigation_room_cells(area_id)
		for cell in cells:
			_draw_navigation_cell(cell, area_id)
		if not cells.is_empty():
			_add_label_with_background(
				_navigation_layer,
				"nav_area_%s_label" % area_id,
				_navigation_area_label(area_id),
				_navigation_cells_center(cells) + Vector2(-52.0, -18.0),
				13,
				COLOR_NAV_LABEL_BACKGROUND,
				COLOR_NAV_WALKABLE_MARKER
			)
	for cell in _object_blocked_cells():
		var points := _measurement_inset_tile_points(cell, 0.18)
		_add_polygon(_navigation_layer, "nav_object_blocked_%d_%d" % [cell.x, cell.y], points, Color(1.0, 0.22, 0.16, 0.34))
		_add_line(_navigation_layer, "nav_object_blocked_outline_%d_%d" % [cell.x, cell.y], points + [points[0]], COLOR_OBJECT_BLOCKED_CELL, 2.0)

	var edge_sets := _navigation_edge_sets()
	for edge_data in edge_sets["blocked"].values():
		_draw_navigation_edge(edge_data, false)
	for edge_data in edge_sets["passable"].values():
		_draw_navigation_edge(edge_data, true)
	_draw_player_debug_marker()


func _draw_navigation_cell(cell: Vector2i, area_id: String) -> void:
	var points := _tile_points(float(cell.x), float(cell.y))
	_add_polygon(_navigation_layer, "nav_%s_cell_%d_%d" % [area_id, cell.x, cell.y], points, _navigation_area_color(area_id))
	_add_marker(
		_navigation_layer,
		"nav_walkable_marker_%d_%d" % [cell.x, cell.y],
		_iso(float(cell.x) + 0.5, float(cell.y) + 0.5),
		COLOR_NAV_WALKABLE_MARKER,
		5.0
	)


func _draw_navigation_edge(edge_data: Dictionary, is_passable: bool) -> void:
	var from_cell: Vector2i = edge_data.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_data.get("to_cell", Vector2i.ZERO)
	var segment_id := String(edge_data.get("segment_id", ""))
	var color := COLOR_NAV_PASSABLE_EDGE if is_passable else COLOR_NAV_BLOCKED_EDGE
	var width := 8.0 if is_passable else 6.0
	if not is_passable and _is_navigation_occlusion_edge(edge_data):
		color = COLOR_NAV_OCCLUSION_EDGE
		width = 7.0
	_add_line(
		_navigation_layer,
		"nav_%s_edge_%s" % ["passable" if is_passable else "blocked", _edge_key(from_cell, to_cell)],
		[_iso(from_cell.x, from_cell.y), _iso(to_cell.x, to_cell.y)],
		color,
		width
	)
	var midpoint := (_iso(from_cell.x, from_cell.y) + _iso(to_cell.x, to_cell.y)) * 0.5
	if is_passable:
		_add_label_with_background(
			_navigation_layer,
			"nav_door_%s" % segment_id,
			"통과 가능\n%s" % _wall_display_name_ko(segment_id),
			midpoint + Vector2(-42.0, -34.0),
			11,
			COLOR_NAV_LABEL_BACKGROUND,
			COLOR_NAV_PASSABLE_EDGE
		)
	else:
		_add_label_with_background(
			_navigation_layer,
			"nav_block_%s_%s" % [segment_id, _edge_key(from_cell, to_cell)],
			"막힘",
			midpoint + Vector2(8.0, -18.0),
			10,
			COLOR_WALL_ID_BACKGROUND,
			color
		)


func _draw_player_debug_marker() -> void:
	var center := _cell_center(player_debug_cell)
	_player_debug_marker = _add_marker(_navigation_layer, "PlayerDebugMarker", center, COLOR_NAV_PLAYER, 15.0)
	_player_debug_label = _add_label_with_background(
		_navigation_layer,
		"PlayerDebugMarkerLabel",
		_player_debug_text(),
		center + Vector2(14.0, -42.0),
		14,
		COLOR_NAV_LABEL_BACKGROUND,
		COLOR_NAV_PLAYER
	)
	_update_player_debug_marker()


func _draw_wall_edge_overlay() -> void:
	for vertex in _visible_wall_vertices():
		var point := _iso(float(vertex.x), float(vertex.y))
		_add_marker(_wall_edge_coord_layer, "wall_vertex_%d_%d" % [vertex.x, vertex.y], point, COLOR_WALL_EDGE_MARKER, 6.0)
		var label := _add_label_with_background(
			_wall_edge_coord_layer,
			"wall_vertex_label_%d_%d" % [vertex.x, vertex.y],
			"벽점 %s" % _format_cell(vertex),
			point + Vector2(8.0, -28.0),
			11,
			COLOR_WALL_EDGE_LABEL_BACKGROUND,
			COLOR_WALL_EDGE_COORD
		)
		label.modulate = COLOR_WALL_EDGE_COORD


func _visible_wall_vertices() -> Array[Vector2i]:
	var vertices_by_key: Dictionary = {}
	for cell in _visible_floor_cells():
		for vertex in [
			cell,
			cell + Vector2i(1, 0),
			cell + Vector2i(1, 1),
			cell + Vector2i(0, 1),
		]:
			vertices_by_key["%d,%d" % [vertex.x, vertex.y]] = vertex

	var vertices: Array[Vector2i] = []
	for key in vertices_by_key.keys():
		vertices.append(vertices_by_key[key])
	vertices.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		if a.y == b.y:
			return a.x < b.x
		return a.y < b.y
	)
	return vertices


func _visible_floor_cells() -> Array[Vector2i]:
	var cells_by_key: Dictionary = {}
	_append_floor_cells(cells_by_key, _living_room_rect())
	_append_floor_cells(cells_by_key, _work_room_rect())
	_append_floor_cells(cells_by_key, _bathroom_room_rect())
	var cells: Array[Vector2i] = []
	for key in cells_by_key.keys():
		cells.append(cells_by_key[key])
	return cells


func _append_floor_cells(cells_by_key: Dictionary, room: Rect2i) -> void:
	for a in range(room.position.x, room.position.x + room.size.x):
		for b in range(room.position.y, room.position.y + room.size.y):
			var cell := Vector2i(a, b)
			cells_by_key["%d,%d" % [cell.x, cell.y]] = cell


func _navigation_area_ids() -> Array[String]:
	return ["living_area", "work_power_area", "bathroom", "entrance_area"]


func _navigation_room_cells(area_id: String) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in _walkable_floor_cells():
		if _room_area_for_cell(cell) == area_id:
			cells.append(cell)
	return cells


func _walkable_floor_cells() -> Array[Vector2i]:
	var cells_by_key := _base_walkable_floor_cell_map()
	for cell in _object_blocked_cells():
		cells_by_key.erase(_cell_key(cell))

	var cells: Array[Vector2i] = []
	for key in cells_by_key.keys():
		cells.append(cells_by_key[key])
	return cells


func _base_walkable_floor_cells() -> Array[Vector2i]:
	var cells_by_key := _base_walkable_floor_cell_map()
	var cells: Array[Vector2i] = []
	for key in cells_by_key.keys():
		cells.append(cells_by_key[key])
	return cells


func _base_walkable_floor_cell_map() -> Dictionary:
	var cells_by_key: Dictionary = {}
	for cell in _visible_floor_cells():
		cells_by_key[_cell_key(cell)] = cell
	for cell in _navigation_extra_walkable_cells():
		cells_by_key[_cell_key(cell)] = cell
	for cell in _navigation_unwalkable_cells():
		cells_by_key.erase(_cell_key(cell))
	return cells_by_key


# Keep these lists as the edit points for future navigation exceptions.
func _navigation_extra_walkable_cells() -> Array[Vector2i]:
	return []


func _navigation_unwalkable_cells() -> Array[Vector2i]:
	return []


func _room_area_for_cell(cell: Vector2i, include_object_blocks := true) -> String:
	if include_object_blocks:
		if not _is_walkable_cell(cell):
			return "none"
	elif not _is_base_walkable_cell(cell):
		return "none"
	if _is_entrance_area_cell(cell):
		return "entrance_area"
	if _is_cell_in_rect(cell, _bathroom_room_rect()):
		return "bathroom"
	if _is_cell_in_rect(cell, _work_room_rect()):
		return "work_power_area"
	if _is_cell_in_rect(cell, _living_room_rect()):
		return "living_area"
	return "none"


func _active_room_area() -> String:
	var area_id := _room_area_for_cell(player_debug_cell)
	if area_id.is_empty() or area_id == "none":
		return "unknown"
	return area_id


func _is_entrance_area_cell(cell: Vector2i) -> bool:
	return _is_cell_in_rect(cell, _entrance_room_rect())


func _is_walkable_cell(cell: Vector2i) -> bool:
	for walkable_cell in _walkable_floor_cells():
		if walkable_cell == cell:
			return true
	return false


func _is_base_walkable_cell(cell: Vector2i) -> bool:
	for walkable_cell in _base_walkable_floor_cells():
		if walkable_cell == cell:
			return true
	return false


func _object_blocked_cells() -> Array[Vector2i]:
	var blocked_by_key: Dictionary = {}
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)) or not bool(object_data.get("blocks_movement", true)) or not _object_uses_floor_occupancy(object_data):
			continue
		for cell in _object_occupied_cells(object_data):
			blocked_by_key[_cell_key(cell)] = cell

	var cells: Array[Vector2i] = []
	for key in blocked_by_key.keys():
		cells.append(blocked_by_key[key])
	return cells


func _object_blocker_ids_for_cell(cell: Vector2i) -> Array[String]:
	var ids: Array[String] = []
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)) or not bool(object_data.get("blocks_movement", true)) or not _object_uses_floor_occupancy(object_data):
			continue
		for occupied_cell in _object_occupied_cells(object_data):
			if occupied_cell == cell:
				ids.append(String(object_data.get("id", "")))
				break
	return ids


func _object_occupied_cells(object_data: Dictionary) -> Array[Vector2i]:
	if bool(object_data.get("node_backed", false)):
		var node_cells: Array[Vector2i] = []
		for cell in object_data.get("occupied_cells", []):
			node_cells.append(Vector2i(cell))
		return node_cells
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var size: Vector2i = object_data.get("size_cells", Vector2i.ONE)
	var width := maxi(0, size.x)
	var height := maxi(0, size.y)
	var cells: Array[Vector2i] = []
	for x in range(anchor.x, anchor.x + width):
		for y in range(anchor.y, anchor.y + height):
			cells.append(Vector2i(x, y))
	return cells


func _object_floor_occupied_cells(object_data: Dictionary) -> Array[Vector2i]:
	if _object_uses_floor_occupancy(object_data):
		return _object_occupied_cells(object_data)
	return []


func _object_interaction_cells(object_data: Dictionary) -> Array[Vector2i]:
	if not _object_has_valid_interaction_area(object_data):
		return []
	return _object_raw_interaction_cells(object_data)


func _object_raw_interaction_cells(object_data: Dictionary) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in object_data.get("interaction_cells", []):
		var cell_i: Vector2i = cell
		if not cells.has(cell_i):
			cells.append(cell_i)
	return cells


func _object_is_direct_interaction(object_data: Dictionary) -> bool:
	return (
		DIRECT_INTERACTION_OBJECT_IDS.has(String(object_data.get("id", "")))
		and String(object_data.get("category", "")) == "interaction"
	)


func _object_has_valid_interaction_area(object_data: Dictionary) -> bool:
	if not _object_is_direct_interaction(object_data):
		return false
	if bool(object_data.get("node_backed", false)):
		var polygons: Array = object_data.get("interaction_polygons", [])
		return not polygons.is_empty() and not _object_raw_interaction_cells(object_data).is_empty()
	var size: Vector2 = object_data.get("interaction_size_px", Vector2.ZERO)
	return size.x > 0.0 and size.y > 0.0 and not _object_raw_interaction_cells(object_data).is_empty()


func _object_cells_center(cells: Array[Vector2i]) -> Vector2:
	if cells.is_empty():
		return Vector2.ZERO
	var total := Vector2.ZERO
	for cell in cells:
		total += _cell_center(cell)
	return total / float(cells.size())


func _is_cell_in_rect(cell: Vector2i, room: Rect2i) -> bool:
	return cell.x >= room.position.x and cell.x < room.position.x + room.size.x and cell.y >= room.position.y and cell.y < room.position.y + room.size.y


func _navigation_area_label(area_id: String) -> String:
	return _room_area_label(area_id)


func _navigation_area_color(area_id: String) -> Color:
	match area_id:
		"work_power_area":
			return Color(0.22, 0.56, 1.0, 0.22)
		"bathroom":
			return Color(0.36, 0.76, 0.94, 0.26)
		"entrance_area":
			return Color(0.90, 0.72, 0.28, 0.28)
		_:
			return COLOR_NAV_WALKABLE


func _navigation_cells_center(cells: Array[Vector2i]) -> Vector2:
	var total := Vector2.ZERO
	for cell in cells:
		total += _cell_center(cell)
	return total / float(cells.size())


func _cell_center(cell: Vector2i) -> Vector2:
	return _iso(float(cell.x) + 0.5, float(cell.y) + 0.5)


func _cell_key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]


func _create_hover_coord_overlay() -> void:
	_hover_coord_background = ColorRect.new()
	_hover_coord_background.name = "HoverCellBackground"
	_hover_coord_background.position = Vector2(24.0, 48.0)
	_hover_coord_background.size = Vector2(230.0, 34.0)
	_hover_coord_background.color = COLOR_GRID_LABEL_BACKGROUND
	_debug_overlay_layer.add_child(_hover_coord_background)

	_hover_coord_label = Label.new()
	_hover_coord_label.name = "HoverCellLabel"
	_hover_coord_label.text = "현재 칸: -"
	_hover_coord_label.position = Vector2(34.0, 52.0)
	_hover_coord_label.modulate = COLOR_GRID_LABEL_TEXT
	_hover_coord_label.add_theme_font_size_override("font_size", 15)
	_hover_coord_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_hover_coord_label.add_theme_constant_override("shadow_offset_x", 2)
	_hover_coord_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_hover_coord_label)

	_hover_edge_background = ColorRect.new()
	_hover_edge_background.name = "HoverEdgeBackground"
	_hover_edge_background.position = Vector2(24.0, 84.0)
	_hover_edge_background.size = Vector2(430.0, 104.0)
	_hover_edge_background.color = COLOR_WALL_EDGE_LABEL_BACKGROUND
	_debug_overlay_layer.add_child(_hover_edge_background)

	_hover_edge_label = Label.new()
	_hover_edge_label.name = "HoverEdgeLabel"
	_hover_edge_label.text = "벽선: -"
	_hover_edge_label.position = Vector2(34.0, 90.0)
	_hover_edge_label.modulate = COLOR_WALL_EDGE_COORD
	_hover_edge_label.add_theme_font_size_override("font_size", 14)
	_hover_edge_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_hover_edge_label.add_theme_constant_override("shadow_offset_x", 2)
	_hover_edge_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_hover_edge_label)
	_update_hover_cell()


func _create_active_room_overlay() -> void:
	_active_room_background = ColorRect.new()
	_active_room_background.name = "ActiveRoomBackground"
	_active_room_background.position = Vector2(24.0, 198.0)
	_active_room_background.size = Vector2(300.0, 66.0)
	_active_room_background.color = COLOR_NAV_LABEL_BACKGROUND
	_debug_overlay_layer.add_child(_active_room_background)

	_active_room_label = Label.new()
	_active_room_label.name = "ActiveRoomLabel"
	_active_room_label.position = Vector2(34.0, 204.0)
	_active_room_label.modulate = COLOR_NAV_PLAYER
	_active_room_label.add_theme_font_size_override("font_size", 14)
	_active_room_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_active_room_label.add_theme_constant_override("shadow_offset_x", 2)
	_active_room_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_active_room_label)
	_update_active_room_overlay()


func _create_measurement_legend_overlay() -> void:
	_measurement_legend_background = ColorRect.new()
	_measurement_legend_background.name = "RoomMeasurementLegendBackground"
	_measurement_legend_background.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_measurement_legend_background.position = Vector2(-470.0, 20.0)
	_measurement_legend_background.size = Vector2(446.0, 154.0)
	_measurement_legend_background.color = COLOR_MEASUREMENT_LABEL_BACKGROUND
	_debug_overlay_layer.add_child(_measurement_legend_background)

	_measurement_legend_label = Label.new()
	_measurement_legend_label.name = "RoomMeasurementLegendLabel"
	_measurement_legend_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_measurement_legend_label.position = Vector2(-458.0, 28.0)
	_measurement_legend_label.text = "방 측량 범례\n방색: 현관 / 욕실 / 생활 / 작업·전력\n초록 외곽: 이동 가능  |  파랑: 배치 후보\n노랑: 문 여유  |  보라: 필수 이동선  |  주황: 대형 금지\n벽 녹색: 부착 가능  |  빨강: 문·창문·코너\n벽 청록 점선: 시야벽이지만 논리적으로 부착 가능"
	_measurement_legend_label.modulate = COLOR_DEBUG_TEXT
	_measurement_legend_label.add_theme_font_size_override("font_size", 13)
	_measurement_legend_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_measurement_legend_label.add_theme_constant_override("shadow_offset_x", 2)
	_measurement_legend_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_measurement_legend_label)


func _create_measurement_summary_overlay() -> void:
	_measurement_summary_background = ColorRect.new()
	_measurement_summary_background.name = "RoomMeasurementSummaryBackground"
	_measurement_summary_background.position = Vector2(24.0, 102.0)
	_measurement_summary_background.size = Vector2(286.0, 360.0)
	_measurement_summary_background.color = COLOR_MEASUREMENT_LABEL_BACKGROUND
	_debug_overlay_layer.add_child(_measurement_summary_background)

	_measurement_summary_label = Label.new()
	_measurement_summary_label.name = "RoomMeasurementSummaryLabel"
	_measurement_summary_label.position = Vector2(36.0, 112.0)
	_measurement_summary_label.text = _measurement_summary_overlay_text()
	_measurement_summary_label.modulate = COLOR_DEBUG_TEXT
	_measurement_summary_label.add_theme_font_size_override("font_size", 12)
	_measurement_summary_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_measurement_summary_label.add_theme_constant_override("shadow_offset_x", 2)
	_measurement_summary_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_measurement_summary_label)


func _measurement_summary_overlay_text() -> String:
	var lines: Array[String] = ["방별 측량 요약"]
	for definition in _room_measurement_definitions():
		var data := _room_measurement_data(String(definition["room_id"]))
		var rect: Rect2i = data["rect"]
		var screen_bounds: Rect2 = data["screen_bounds"]
		lines.append("")
		lines.append("%s  %s~%s" % [data["name_ko"], _format_cell(rect.position), _format_cell(rect.end)])
		lines.append("%d×%d칸 / 구역 %d / 이동 %d / 배치 %d" % [
			rect.size.x,
			rect.size.y,
			int(data["floor_cells"].size()),
			int(data["walkable_cells"].size()),
			int(data["placement_cells"].size()),
		])
		lines.append("화면 약 %d×%dpx / 문 %d / 창 %d / 벽 %d" % [
			roundi(screen_bounds.size.x),
			roundi(screen_bounds.size.y),
			int(data["doorway_ids"].size()),
			int(data["window_ids"].size()),
			int(data["wall_ids"].size()),
		])
	lines.append("")
	lines.append("I: 방·벽·placeholder 상세 출력")
	return "\n".join(lines)


func _update_active_room_overlay() -> void:
	if _active_room_label == null:
		return
	_active_room_label.text = "디버그 위치: %s\n현재 구역: %s\nauto reveal=%s" % [
		_format_cell(player_debug_cell),
		_room_area_label(_active_room_area()),
		str(debug_auto_reveal_walls),
	]


func _update_hover_cell() -> void:
	if _hover_coord_label != null:
		_hover_coord_label.visible = show_floor_grid_coords
	if _hover_coord_background != null:
		_hover_coord_background.visible = show_floor_grid_coords
	if _hover_edge_label != null:
		_hover_edge_label.visible = show_wall_edge_coords
	if _hover_edge_background != null:
		_hover_edge_background.visible = show_wall_edge_coords

	var hover_cell: Variant = _hover_floor_cell()
	if show_floor_grid_coords and _hover_coord_label != null:
		if hover_cell == null:
			_hover_coord_label.text = "현재 칸: -"
		else:
			var hover_cell_i: Vector2i = hover_cell
			_hover_coord_label.text = "현재 칸: 칸 %s" % _format_cell(hover_cell_i)

	if not show_wall_edge_coords or _hover_edge_label == null:
		_update_hover_edge_highlight({})
		return
	var edge_info := _hover_wall_edge()
	if edge_info.is_empty():
		if _hover_coord_label != null:
			_hover_coord_label.text = "현재 칸: -"
		_hover_edge_label.text = "벽선: -"
		_update_hover_edge_highlight({})
		return
	_hover_edge_label.text = _wall_edge_hover_text(edge_info)
	_update_hover_edge_highlight(edge_info)


func _hover_floor_cell() -> Variant:
	var grid_point := _screen_to_grid_point(get_global_mouse_position())
	var cell := Vector2i(floori(grid_point.x), floori(grid_point.y))
	if _is_visible_floor_cell(cell):
		return cell
	return null


func _hover_wall_edge() -> Dictionary:
	var grid_point := _screen_to_grid_point(get_global_mouse_position())
	var cell := Vector2i(floori(grid_point.x), floori(grid_point.y))
	if not _is_visible_floor_cell(cell):
		return {}
	return _nearest_wall_edge_for_cell(cell, grid_point)


# Converts a floor-cell side into the wall grid-line coordinates used by wall segments.
func _wall_edge_info_for_cell(cell: Vector2i, edge_name: String) -> Dictionary:
	var normalized_edge := edge_name.to_lower()
	match normalized_edge:
		"top":
			return {
				"cell": cell,
				"edge": "top",
				"from_cell": cell,
				"to_cell": cell + Vector2i(1, 0),
				"axis": WallAxis.AXIS_A,
			}
		"right":
			return {
				"cell": cell,
				"edge": "right",
				"from_cell": cell + Vector2i(1, 0),
				"to_cell": cell + Vector2i(1, 1),
				"axis": WallAxis.AXIS_B,
			}
		"bottom":
			return {
				"cell": cell,
				"edge": "bottom",
				"from_cell": cell + Vector2i(0, 1),
				"to_cell": cell + Vector2i(1, 1),
				"axis": WallAxis.AXIS_A,
			}
		"left":
			return {
				"cell": cell,
				"edge": "left",
				"from_cell": cell,
				"to_cell": cell + Vector2i(0, 1),
				"axis": WallAxis.AXIS_B,
			}
		_:
			return {}


func _nearest_wall_edge_for_cell(cell: Vector2i, grid_point: Vector2) -> Dictionary:
	var local := grid_point - Vector2(cell)
	var distances := {
		"top": local.y,
		"right": 1.0 - local.x,
		"bottom": 1.0 - local.y,
		"left": local.x,
	}
	var nearest_edge := "top"
	var nearest_distance := INF
	for edge_name in distances.keys():
		var distance := absf(float(distances[edge_name]))
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_edge = edge_name
	return _wall_edge_info_for_cell(cell, nearest_edge)


func _wall_edge_hover_text(edge_info: Dictionary) -> String:
	var cell: Vector2i = edge_info.get("cell", Vector2i.ZERO)
	var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
	var axis: WallAxis = edge_info.get("axis", WallAxis.AXIS_A)
	return "칸 %s\n벽선: %s\nfrom=%s → to=%s\n축=%s" % [
		_format_cell(cell),
		_edge_name_ko(String(edge_info.get("edge", "-"))),
		_format_cell(from_cell),
		_format_cell(to_cell),
		_wall_axis_name(axis),
	]


func _update_hover_edge_highlight(edge_info: Dictionary) -> void:
	if _hover_edge_highlight_layer == null:
		return
	_clear_layer_children(_hover_edge_highlight_layer)
	if edge_info.is_empty():
		return
	var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
	_add_line(
		_hover_edge_highlight_layer,
		"HoverWallEdgeHighlight",
		[_iso(from_cell.x, from_cell.y), _iso(to_cell.x, to_cell.y)],
		COLOR_WALL_EDGE_HOVER,
		10.0
	)


func _print_clicked_cell_edges(cell: Vector2i) -> void:
	print("clicked floor cell / 바닥칸: %s" % _format_cell(cell))
	for edge_name in ["top", "right", "bottom", "left"]:
		var edge_info := _wall_edge_info_for_cell(cell, edge_name)
		var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
		var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
		print("%s edge / %s 벽선: from=%s to=%s" % [
			edge_name,
			_edge_name_ko(edge_name),
			_format_cell(from_cell),
			_format_cell(to_cell),
		])


func _print_clicked_wall_edge(edge_info: Dictionary) -> void:
	var cell: Vector2i = edge_info.get("cell", Vector2i.ZERO)
	var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
	var axis: WallAxis = edge_info.get("axis", WallAxis.AXIS_A)
	print("clicked wall edge / 벽선 선택:")
	print("cell=%s / 칸=%s" % [_format_cell(cell), _format_cell(cell)])
	print("edge=%s / 벽선=%s" % [String(edge_info.get("edge", "-")), _edge_name_ko(String(edge_info.get("edge", "-")))])
	print("from=%s" % _format_cell(from_cell))
	print("to=%s" % _format_cell(to_cell))
	print("axis=%s / 축=%s" % [_wall_axis_name(axis), _wall_axis_name(axis)])


func _navigation_edge_sets() -> Dictionary:
	var blocked: Dictionary = {}
	var passable: Dictionary = {}
	for segment in _wall_segments():
		if not bool(segment.get("enabled", true)):
			continue
		var length := int(segment.get("length", 0))
		for offset in range(length):
			var edge_data := _wall_segment_unit_edge(segment, offset)
			var key := String(edge_data["key"])
			if _is_wall_segment_doorway_unit(segment, offset):
				passable[key] = edge_data
				blocked.erase(key)
			elif not passable.has(key):
				blocked[key] = edge_data
	return {
		"blocked": blocked,
		"passable": passable,
	}


func _wall_segment_unit_edge(segment: Dictionary, unit_offset: int) -> Dictionary:
	var axis: WallAxis = segment.get("axis", WallAxis.AXIS_A)
	var start_cell := _segment_start_cell(segment)
	var from_cell := Vector2i(_offset_cell(start_cell, axis, float(unit_offset)))
	var to_cell := Vector2i(_offset_cell(start_cell, axis, float(unit_offset + 1)))
	return {
		"key": _edge_key(from_cell, to_cell),
		"segment_id": String(segment.get("id", "")),
		"from_cell": from_cell,
		"to_cell": to_cell,
		"axis": axis,
		"wall_type": int(segment.get("wall_type", WallType.NORMAL)),
		"render_mode": int(segment.get("render_mode", WallRenderMode.FULL)),
		"doorway": _is_wall_segment_doorway_unit(segment, unit_offset),
	}


func _is_wall_segment_doorway_unit(segment: Dictionary, unit_offset: int) -> bool:
	var wall_type := int(segment.get("wall_type", WallType.NORMAL))
	if wall_type != WallType.DOORWAY_FRAME and wall_type != WallType.DOORWAY_EMPTY:
		return false
	var doorway_offset := int(segment.get("doorway_offset", -1))
	var doorway_width := int(segment.get("doorway_width", 0))
	return doorway_width > 0 and unit_offset >= doorway_offset and unit_offset < doorway_offset + doorway_width


func _edge_key(from_cell: Vector2i, to_cell: Vector2i) -> String:
	var a := from_cell
	var b := to_cell
	if b.x < a.x or (b.x == a.x and b.y < a.y):
		a = to_cell
		b = from_cell
	return "%d,%d>%d,%d" % [a.x, a.y, b.x, b.y]


func _is_navigation_occlusion_edge(edge_data: Dictionary) -> bool:
	var render_mode := int(edge_data.get("render_mode", WallRenderMode.FULL))
	return render_mode == WallRenderMode.REVEALABLE or render_mode == WallRenderMode.HIDDEN_STUB or render_mode == WallRenderMode.CUTAWAY_STUB


func _navigation_edge_status_for_cell(cell: Vector2i, edge_name: String) -> Dictionary:
	var edge_info := _wall_edge_info_for_cell(cell, edge_name)
	if edge_info.is_empty():
		return {"status": "open", "segment_id": "", "edge": edge_name}
	var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
	var edge_sets := _navigation_edge_sets()
	var key := _edge_key(from_cell, to_cell)
	if edge_sets["passable"].has(key):
		var passable_data: Dictionary = edge_sets["passable"][key]
		return {"status": "passable", "segment_id": String(passable_data.get("segment_id", "")), "edge": edge_name}
	if edge_sets["blocked"].has(key):
		var blocked_data: Dictionary = edge_sets["blocked"][key]
		return {"status": "blocked", "segment_id": String(blocked_data.get("segment_id", "")), "edge": edge_name}
	return {"status": "open", "segment_id": "", "edge": edge_name}


func _neighbor_cell_for_edge(cell: Vector2i, edge_name: String) -> Vector2i:
	match edge_name:
		"top":
			return cell + Vector2i(0, -1)
		"right":
			return cell + Vector2i(1, 0)
		"bottom":
			return cell + Vector2i(0, 1)
		"left":
			return cell + Vector2i(-1, 0)
		_:
			return cell


func _print_clicked_cell_navigation(cell: Vector2i) -> void:
	print("navigation cell / 이동 판정 칸:")
	print("clicked cell / 칸: %s" % _format_cell(cell))
	print("room_area: %s / %s" % [_room_area_for_cell(cell), _room_area_label(_room_area_for_cell(cell))])
	print("walkable / 이동 가능: %s" % _bool_ko(_is_walkable_cell(cell)))
	var blocker_ids := _object_blocker_ids_for_cell(cell)
	print("object_blockers / 오브젝트 막힘: %s" % (", ".join(blocker_ids) if not blocker_ids.is_empty() else "-"))
	print("neighbors / 이웃칸: top=%s right=%s bottom=%s left=%s" % [
		_format_cell(_neighbor_cell_for_edge(cell, "top")),
		_format_cell(_neighbor_cell_for_edge(cell, "right")),
		_format_cell(_neighbor_cell_for_edge(cell, "bottom")),
		_format_cell(_neighbor_cell_for_edge(cell, "left")),
	])
	for edge_name in ["top", "right", "bottom", "left"]:
		var edge_status := _navigation_edge_status_for_cell(cell, edge_name)
		var status := String(edge_status.get("status", "open"))
		var segment_id := String(edge_status.get("segment_id", ""))
		if segment_id.is_empty():
			print("%s edge / %s 벽선: %s" % [edge_name, _edge_name_ko(edge_name), _navigation_status_ko(status)])
		else:
			print("%s edge / %s 벽선: %s by %s(%s)" % [edge_name, _edge_name_ko(edge_name), _navigation_status_ko(status), segment_id, _wall_display_name_ko(segment_id)])


func _try_move_player_debug_marker(keycode: Key) -> bool:
	match keycode:
		KEY_UP:
			return _move_player_debug_marker("top")
		KEY_RIGHT:
			return _move_player_debug_marker("right")
		KEY_DOWN:
			return _move_player_debug_marker("bottom")
		KEY_LEFT:
			return _move_player_debug_marker("left")
		_:
			return false


func _move_player_debug_marker(edge_name: String) -> bool:
	var edge_status := _navigation_edge_status_for_cell(player_debug_cell, edge_name)
	var status := String(edge_status.get("status", "open"))
	var segment_id := String(edge_status.get("segment_id", ""))
	var next_cell := _neighbor_cell_for_edge(player_debug_cell, edge_name)
	if status == "blocked":
		print("debug marker blocked / 이동 막힘: %s 벽선 by %s(%s) at %s" % [_edge_name_ko(edge_name), segment_id, _wall_display_name_ko(segment_id), _format_cell(player_debug_cell)])
		return true
	if not _is_walkable_cell(next_cell):
		var blocker_ids := _object_blocker_ids_for_cell(next_cell)
		if not blocker_ids.is_empty():
			print("debug marker blocked / 이동 막힘: target %s is occupied by %s" % [_format_cell(next_cell), ", ".join(blocker_ids)])
		else:
			print("debug marker blocked / 이동 막힘: target %s is not walkable" % _format_cell(next_cell))
		return true

	player_debug_cell = next_cell
	_update_player_debug_marker()
	print("debug marker moved / 이동: %s to %s via %s%s" % [
		edge_name,
		_format_cell(player_debug_cell),
		status,
		" %s" % segment_id if not segment_id.is_empty() else "",
	])
	return true


func _update_player_debug_marker() -> void:
	var center := _cell_center(player_debug_cell)
	if _player_debug_marker != null:
		var radius := 15.0
		_player_debug_marker.polygon = PackedVector2Array([
			center + Vector2(0.0, -radius),
			center + Vector2(radius, 0.0),
			center + Vector2(0.0, radius),
			center + Vector2(-radius, 0.0),
		])
	if _player_debug_label != null:
		_player_debug_label.text = _player_debug_text()
		_player_debug_label.position = center + Vector2(14.0, -42.0)
		var label_background := _navigation_layer.get_node_or_null("PlayerDebugMarkerLabelBackground")
		if label_background is ColorRect:
			label_background.position = _player_debug_label.position - Vector2(9.0, 6.0)
	var area_id := _active_room_area()
	var area_changed := not _last_active_room_area.is_empty() and _last_active_room_area != area_id
	if area_changed:
		print("active room changed / 현재 구역 변경: %s(%s) -> %s(%s)" % [_last_active_room_area, _room_area_label(_last_active_room_area), area_id, _room_area_label(area_id)])
	_last_active_room_area = area_id
	_update_active_room_overlay()
	_update_debug_detail_panel()
	if area_changed and debug_auto_reveal_walls:
		_redraw_reveal_sensitive_layers()


func _player_debug_text() -> String:
	return "디버그 위치\n칸=%s\n구역=%s" % [
		_format_cell(player_debug_cell),
		_room_area_label(_active_room_area()),
	]


func _is_visible_floor_cell(cell: Vector2i) -> bool:
	for room in [_living_room_rect(), _work_room_rect(), _bathroom_room_rect()]:
		if cell.x >= room.position.x and cell.x < room.position.x + room.size.x and cell.y >= room.position.y and cell.y < room.position.y + room.size.y:
			return true
	return false


func _draw_wall_axis_a(a_start: float, b: float, length: float, wall_name: String, height := -1.0) -> void:
	if length <= 0.0:
		return
	_draw_wall_segment(_iso(a_start, b), _iso(a_start + length, b), wall_name, _resolve_wall_height(height))


func _draw_wall_axis_b(a: float, b_start: float, length: float, wall_name: String, height := -1.0) -> void:
	if length <= 0.0:
		return
	_draw_wall_segment(_iso(a, b_start), _iso(a, b_start + length), wall_name, _resolve_wall_height(height))


func _draw_wall_segment_data(segment: Dictionary) -> void:
	if not bool(segment.get("enabled", true)):
		return

	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	if _should_draw_full_wall_for_segment(segment):
		_draw_full_wall_segment_data(segment)
		if render_mode == WallRenderMode.REVEALABLE:
			_draw_reveal_wall_debug_for_segment(segment)
	elif render_mode == WallRenderMode.CUTAWAY_STUB:
		_draw_cutaway_stub_segment_data(segment)
	elif render_mode == WallRenderMode.HIDDEN_STUB or render_mode == WallRenderMode.REVEALABLE:
		_draw_hidden_stub_segment_data(segment)
	elif render_mode == WallRenderMode.LOGICAL_ONLY:
		pass
	else:
		_draw_full_wall_segment_data(segment)

	_add_wall_id_debug(segment)


func _should_draw_full_wall_for_segment(segment: Dictionary) -> bool:
	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	if render_mode == WallRenderMode.FULL:
		return true
	if render_mode != WallRenderMode.REVEALABLE:
		return false
	return _should_reveal_wall_for_active_area(segment)


func _should_reveal_wall_for_active_area(segment: Dictionary) -> bool:
	if preview_revealed_walls:
		return true
	if not debug_auto_reveal_walls:
		return false
	if not bool(segment.get("reveal_when_area_active", false)):
		return false
	var reveal_area_id := String(segment.get("reveal_area_id", ""))
	return not reveal_area_id.is_empty() and reveal_area_id == _active_room_area()


func _wall_render_state(segment: Dictionary) -> String:
	if not bool(segment.get("enabled", true)):
		return "disabled"
	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	match render_mode:
		WallRenderMode.REVEALABLE:
			return "revealed" if _should_draw_full_wall_for_segment(segment) else "stub"
		WallRenderMode.CUTAWAY_STUB, WallRenderMode.HIDDEN_STUB:
			return "stub"
		WallRenderMode.LOGICAL_ONLY:
			return "logical_only"
		_:
			return "full"


func _redraw_reveal_sensitive_layers() -> void:
	_clear_layer_children(_occlusion_stub_layer)
	_clear_layer_children(_wall_layer)
	_clear_layer_children(_door_layer)
	_clear_layer_children(_wall_id_layer)
	_clear_layer_children(_occlusion_debug_layer)
	_clear_layer_children(_room_measurement_layer)
	_draw_walls()
	_draw_doors_and_window_placeholders()
	_draw_room_measurement_overlay()
	_apply_wall_inspection_transparency()
	_update_label_visibility()


func _clear_layer_children(layer: Node) -> void:
	if layer == null:
		return
	for child in layer.get_children():
		child.free()


func _draw_full_wall_segment_data(segment: Dictionary) -> void:
	var wall_type: WallType = segment.get("wall_type", WallType.NORMAL)
	match wall_type:
		WallType.CUTAWAY_STUB:
			_draw_cutaway_stub_segment_data(segment)
		WallType.DOORWAY_EMPTY:
			_draw_wall_with_doorway(segment, false)
		WallType.DOORWAY_FRAME:
			_draw_wall_with_doorway(segment, true)
		WallType.END:
			_draw_solid_wall_segment(segment)
			_draw_wall_end_marker(segment)
		WallType.CORNER:
			_draw_solid_wall_segment(segment)
			_draw_wall_corner_marker(segment)
		_:
			_draw_solid_wall_segment(segment)


func _draw_solid_wall_segment(segment: Dictionary) -> void:
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var length := float(segment["length"])
	var height := float(segment.get("height", -1.0))
	_draw_wall_piece(axis, start_cell, length, id, height)


func _draw_wall_with_doorway(segment: Dictionary, draw_frame: bool) -> void:
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var length := float(segment["length"])
	var height := float(segment.get("height", -1.0))
	var doorway_offset := clampf(float(segment.get("doorway_offset", -1.0)), 0.0, length)
	var doorway_width := clampf(float(segment.get("doorway_width", 0.0)), 0.0, length - doorway_offset)
	var doorway_end := doorway_offset + doorway_width

	if doorway_offset > 0.0:
		_draw_wall_piece(axis, start_cell, doorway_offset, "%s_before" % id, height)
	if doorway_end < length:
		_draw_wall_piece(axis, _offset_cell(start_cell, axis, doorway_end), length - doorway_end, "%s_after" % id, height)
	if draw_frame and doorway_width > 0.0:
		_draw_doorway_segment(axis, _offset_cell(start_cell, axis, doorway_offset), doorway_width, id, segment.get("doorway_color", doorway_debug_color))


func _draw_wall_piece(axis: WallAxis, start_cell: Vector2, length: float, wall_name: String, height := -1.0) -> void:
	match axis:
		WallAxis.AXIS_B:
			_draw_wall_axis_b(start_cell.x, start_cell.y, length, wall_name, height)
		_:
			_draw_wall_axis_a(start_cell.x, start_cell.y, length, wall_name, height)


func _draw_doorway_segment(axis: WallAxis, start_cell: Vector2, width: float, door_name: String, color: Color) -> void:
	match axis:
		WallAxis.AXIS_B:
			_draw_doorway_axis_b(start_cell.x, start_cell.y, width, door_name, color)
		_:
			_draw_doorway_axis_a(start_cell.x, start_cell.y, width, door_name, color)


func _draw_cutaway_stub_segment_data(segment: Dictionary) -> void:
	_draw_hidden_stub_segment_data(segment)


func _draw_hidden_stub_segment_data(segment: Dictionary) -> void:
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var end_cell := _offset_cell(start_cell, axis, float(segment["length"]))
	var p0 := _iso(start_cell.x, start_cell.y)
	var p1 := _iso(end_cell.x, end_cell.y)
	var stub_height := clampf(cutaway_front_stub_height * 0.82, 32.0, 40.0)
	var stub_color := COLOR_OCCLUSION_STUB_BODY
	if axis == WallAxis.AXIS_B:
		stub_color = stub_color.darkened(0.08)
	var cap_color := COLOR_OCCLUSION_STUB_CAP
	if axis == WallAxis.AXIS_B:
		cap_color = cap_color.darkened(0.05)
	var shadow_color := COLOR_OCCLUSION_STUB_SHADOW
	var layer := _occlusion_stub_layer if _occlusion_stub_layer != null else _edge_layer
	_add_line(layer, "%sHiddenStubShadow" % id, [
		p0 + Vector2(0.0, stub_height + 3.0),
		p1 + Vector2(0.0, stub_height + 3.0),
	], shadow_color, 8.0)
	_add_polygon(layer, "%sHiddenStub" % id, [
		p0,
		p1,
		p1 + Vector2(0.0, stub_height),
		p0 + Vector2(0.0, stub_height),
	], stub_color)
	_add_line(layer, "%sHiddenStubCap" % id, [p0, p1], cap_color, 5.0)
	_add_line(layer, "%sHiddenStubBase" % id, [
		p0 + Vector2(0.0, stub_height),
		p1 + Vector2(0.0, stub_height),
	], shadow_color.lightened(0.18), 3.0)
	_draw_occlusion_wall_debug(segment, p0, p1, stub_height)


func _draw_reveal_wall_debug_for_segment(segment: Dictionary) -> void:
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var end_cell := _offset_cell(start_cell, axis, float(segment["length"]))
	_draw_occlusion_wall_debug(segment, _iso(start_cell.x, start_cell.y), _iso(end_cell.x, end_cell.y), 0.0)


# Draws the edit-only overlay for walls that exist logically but are cut down for camera visibility.
func _draw_occlusion_wall_debug(segment: Dictionary, p0: Vector2, p1: Vector2, stub_height: float) -> void:
	if _occlusion_debug_layer == null:
		return
	var id := String(segment["id"])
	var center := (p0 + p1) * 0.5 + Vector2(0.0, stub_height * 0.55)
	_add_line(_occlusion_debug_layer, "%sOcclusionDebugLine" % id, [p0, p1], COLOR_OCCLUSION_STUB_DEBUG, 8.0)
	_add_line(_occlusion_debug_layer, "%sOcclusionDebugBase" % id, [
		p0 + Vector2(0.0, stub_height),
		p1 + Vector2(0.0, stub_height),
	], COLOR_OCCLUSION_STUB_DEBUG.darkened(0.24), 5.0)
	_add_marker(_occlusion_debug_layer, "%sOcclusionDebugStart" % id, p0, COLOR_OCCLUSION_STUB_DEBUG, 13.0)
	_add_marker(_occlusion_debug_layer, "%sOcclusionDebugEnd" % id, p1, COLOR_OCCLUSION_STUB_DEBUG.darkened(0.18), 13.0)
	_add_label_with_background(
		_occlusion_debug_layer,
		"%sOcclusionDebugLabel" % id,
		"숨김벽: %s\nid=%s\n표시상태=%s\nmode=%s" % [
			_wall_display_name_ko(id),
			id,
			_wall_render_state_ko(segment),
			_render_mode_name(int(segment.get("render_mode", WallRenderMode.FULL))),
		],
		center + Vector2(-76.0, 8.0),
		14,
		COLOR_OCCLUSION_LABEL_BACKGROUND,
		COLOR_OCCLUSION_STUB_DEBUG
	)


func _draw_wall_end_marker(segment: Dictionary) -> void:
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var length := float(segment["length"])
	var height := _resolve_wall_height(float(segment.get("height", -1.0)))
	var end_cell := _offset_cell(start_cell, axis, length)
	var end_point := _iso(end_cell.x, end_cell.y)
	_add_line(_wall_layer, "%sEndMarker" % id, [end_point, end_point + Vector2(0.0, -height)], wall_cap_color, 3.0)


func _draw_wall_corner_marker(segment: Dictionary) -> void:
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var height := _resolve_wall_height(float(segment.get("height", -1.0)))
	var point := _iso(start_cell.x, start_cell.y)
	var side_cell := _offset_cell(start_cell, axis, 0.25)
	var side_point := _iso(side_cell.x, side_cell.y)
	_add_line(_wall_layer, "%sCornerMarker" % id, [point, point + Vector2(0.0, -height), side_point + Vector2(0.0, -height)], wall_cap_color, 3.0)


func _offset_cell(start_cell: Vector2, axis: WallAxis, offset: float) -> Vector2:
	if axis == WallAxis.AXIS_B:
		return Vector2(start_cell.x, start_cell.y + offset)
	return Vector2(start_cell.x + offset, start_cell.y)


func _segment_start_cell(segment: Dictionary) -> Vector2:
	var start_cell: Vector2i = segment.get("start_cell", Vector2i.ZERO)
	return Vector2(start_cell)


func _segment_end_cell_i(segment: Dictionary) -> Vector2i:
	var start_cell: Vector2i = segment.get("start_cell", Vector2i.ZERO)
	var length := int(segment.get("length", 0))
	var axis: WallAxis = segment.get("axis", WallAxis.AXIS_A)
	if axis == WallAxis.AXIS_B:
		return start_cell + Vector2i(0, length)
	return start_cell + Vector2i(length, 0)


func _wall_doorway_text(segment: Dictionary) -> String:
	var offset := int(segment.get("doorway_offset", -1))
	var width := int(segment.get("doorway_width", 0))
	if offset < 0 or width <= 0:
		return "none offset=%d width=%d" % [offset, width]

	var axis: WallAxis = segment.get("axis", WallAxis.AXIS_A)
	var start_cell := Vector2(segment.get("start_cell", Vector2i.ZERO))
	var doorway_start := _offset_cell(start_cell, axis, float(offset))
	var doorway_end := _offset_cell(start_cell, axis, float(offset + width))
	return "edge from=%s to=%s offset=%d width=%d" % [
		_format_cell(Vector2i(doorway_start)),
		_format_cell(Vector2i(doorway_end)),
		offset,
		width,
	]


func _wall_doorway_text_ko(segment: Dictionary) -> String:
	var offset := int(segment.get("doorway_offset", -1))
	var width := int(segment.get("doorway_width", 0))
	if offset < 0 or width <= 0:
		return "없음 offset=%d width=%d" % [offset, width]

	var axis: WallAxis = segment.get("axis", WallAxis.AXIS_A)
	var start_cell := Vector2(segment.get("start_cell", Vector2i.ZERO))
	var doorway_start := _offset_cell(start_cell, axis, float(offset))
	var doorway_end := _offset_cell(start_cell, axis, float(offset + width))
	return "%s → %s" % [
		_format_cell(Vector2i(doorway_start)),
		_format_cell(Vector2i(doorway_end)),
	]


func _wall_reveal_text(segment: Dictionary) -> String:
	var area_id := String(segment.get("reveal_area_id", ""))
	var when_active := bool(segment.get("reveal_when_area_active", false))
	if area_id.is_empty() and not when_active:
		return "-"
	return "area=%s when_active=%s state=%s" % [area_id, str(when_active), _wall_render_state(segment)]


func _is_logical_wall(segment: Dictionary) -> bool:
	if not bool(segment.get("enabled", true)):
		return false
	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	return render_mode != WallRenderMode.FULL


func _wall_axis_name(axis: int) -> String:
	match axis:
		WallAxis.AXIS_B:
			return "B"
		_:
			return "A"


func _wall_type_name(wall_type: int) -> String:
	match wall_type:
		WallType.DOORWAY_EMPTY:
			return "doorway_empty"
		WallType.DOORWAY_FRAME:
			return "doorway_frame"
		WallType.CUTAWAY_STUB:
			return "cutaway_stub"
		WallType.END:
			return "end"
		WallType.CORNER:
			return "corner"
		_:
			return "normal"


func _render_mode_name(render_mode: int) -> String:
	match render_mode:
		WallRenderMode.CUTAWAY_STUB:
			return "CUTAWAY_STUB"
		WallRenderMode.HIDDEN_STUB:
			return "HIDDEN_STUB"
		WallRenderMode.LOGICAL_ONLY:
			return "LOGICAL_ONLY"
		WallRenderMode.REVEALABLE:
			return "REVEALABLE"
		_:
			return "FULL"


func _height_mode_name(height_mode: int) -> String:
	match height_mode:
		ApartmentWallSegmentConfigScript.HeightMode.CUSTOM:
			return "custom"
		ApartmentWallSegmentConfigScript.HeightMode.CUTAWAY:
			return "cutaway"
		_:
			return "default"


func _format_cell(cell: Vector2i) -> String:
	return "(%d,%d)" % [cell.x, cell.y]


func _format_cells(cells: Array[Vector2i]) -> String:
	if cells.is_empty():
		return "[]"
	var parts: Array[String] = []
	for cell in cells:
		parts.append(_format_cell(cell))
	return "[%s]" % ", ".join(parts)


func _is_focus_wall(id: String) -> bool:
	return not debug_focus_wall_id.strip_edges().is_empty() and id == debug_focus_wall_id.strip_edges()


func _doorway_center(segment_id: StringName) -> Vector2:
	for segment in _wall_segments():
		if StringName(String(segment["id"])) != segment_id:
			continue
		var axis: WallAxis = segment["axis"]
		var start_cell := _segment_start_cell(segment)
		var offset := float(segment.get("doorway_offset", -1))
		var width := float(segment.get("doorway_width", 0))
		if offset < 0.0 or width <= 0.0:
			var midpoint := _offset_cell(start_cell, axis, float(segment["length"]) * 0.5)
			return _iso(midpoint.x, midpoint.y)
		var doorway_cell := _offset_cell(start_cell, axis, offset + width * 0.5)
		return _iso(doorway_cell.x, doorway_cell.y)
	return Vector2.ZERO


func _add_wall_id_debug(segment: Dictionary) -> void:
	if _wall_id_layer == null:
		return
	var id := String(segment["id"])
	var axis: WallAxis = segment["axis"]
	var start_cell := _segment_start_cell(segment)
	var start_cell_i: Vector2i = segment.get("start_cell", Vector2i.ZERO)
	var length := float(segment["length"])
	var length_i := int(segment["length"])
	var wall_type: WallType = segment.get("wall_type", WallType.NORMAL)
	var render_mode := int(segment.get("render_mode", WallRenderMode.FULL))
	var end_cell_i := _segment_end_cell_i(segment)
	var end_cell := Vector2(end_cell_i)
	var midpoint := _offset_cell(start_cell, axis, length * 0.5)
	var focused := _is_focus_wall(id)
	var marker_radius := 16.0 if focused else 11.0
	var label_font_size := 18 if focused else 15
	var label_offset := Vector2(-72.0, -_resolve_wall_height(float(segment.get("height", -1.0))) - 40.0)
	if wall_type == WallType.CUTAWAY_STUB or render_mode != WallRenderMode.FULL:
		label_offset = Vector2(-72.0, 24.0)
	if focused:
		_add_line(_wall_id_layer, "wall_focus_%s" % id, [_iso(start_cell.x, start_cell.y), _iso(end_cell.x, end_cell.y)], Color(1.0, 0.90, 0.20, 0.95), 9.0)
	_add_marker(_wall_id_layer, "wall_start_%s" % id, _iso(start_cell.x, start_cell.y), COLOR_WALL_START_MARKER, marker_radius)
	_add_marker(_wall_id_layer, "wall_end_%s" % id, _iso(end_cell.x, end_cell.y), COLOR_WALL_END_MARKER, marker_radius)
	_add_label_with_background(
		_wall_id_layer,
		"wall_start_label_%s" % id,
		"시작 %s" % _format_cell(start_cell_i),
		_iso(start_cell.x, start_cell.y) + Vector2(12.0, -8.0),
		12,
		COLOR_WALL_ID_BACKGROUND,
		COLOR_WALL_START_MARKER
	)
	_add_label_with_background(
		_wall_id_layer,
		"wall_end_label_%s" % id,
		"끝 %s" % _format_cell(end_cell_i),
		_iso(end_cell.x, end_cell.y) + Vector2(12.0, 8.0),
		12,
		COLOR_WALL_ID_BACKGROUND,
		COLOR_WALL_END_MARKER
	)
	_add_label_with_background(
		_wall_id_layer,
		"wall_id_%s" % id,
		_wall_id_label_text(id, start_cell_i, end_cell_i, axis, length_i, render_mode, segment),
		_iso(midpoint.x, midpoint.y) + label_offset,
		label_font_size,
		COLOR_WALL_ID_BACKGROUND
	)


func _wall_id_label_text(
	id: String,
	start_cell_i: Vector2i,
	end_cell_i: Vector2i,
	axis: WallAxis,
	length_i: int,
	render_mode: int,
	segment: Dictionary
) -> String:
	var text := "벽: %s\nid=%s\nedge %s → %s\n축=%s 길이=%d\n표시=%s (%s)" % [
		_wall_display_name_ko(id),
		id,
		_format_cell(start_cell_i),
		_format_cell(end_cell_i),
		_wall_axis_name(axis),
		length_i,
		_wall_render_state_ko(segment),
		_render_mode_name(render_mode),
	]
	if int(segment.get("doorway_width", 0)) > 0:
		text += "\n문 %s" % _wall_doorway_text_ko(segment)
	return text


func _draw_wall_segment(p0: Vector2, p1: Vector2, wall_name: String, height: float) -> void:
	var up := Vector2(0.0, -height)
	var segment_color := wall_color if p1.y <= p0.y else wall_side_color
	_add_polygon(_wall_layer, wall_name, [p0, p1, p1 + up, p0 + up], segment_color)
	_add_wall_cap(p0, p1, up, "%sCap" % wall_name)
	_add_polygon(_wall_layer, "%sBaseboard" % wall_name, [
		p0,
		p1,
		p1 + Vector2(0.0, -baseboard_height),
		p0 + Vector2(0.0, -baseboard_height),
	], baseboard_color)


func _add_wall_cap(p0: Vector2, p1: Vector2, up: Vector2, cap_name: String) -> void:
	var direction := (p1 - p0).normalized()
	var cap_depth := Vector2(-direction.y, direction.x) * wall_cap_height
	if cap_depth.y < 0.0:
		cap_depth = -cap_depth
	_add_polygon(_wall_layer, cap_name, [
		p0 + up,
		p1 + up,
		p1 + up + cap_depth,
		p0 + up + cap_depth,
	], wall_cap_color)


func _draw_doorway_axis_a(a_start: float, b: float, width: float, door_name: String, color: Color) -> void:
	var p0 := _iso(a_start, b)
	var p1 := _iso(a_start + width, b)
	_draw_doorway_frame(p0, p1, door_name, color)


func _draw_doorway_axis_b(a: float, b_start: float, width: float, door_name: String, color: Color) -> void:
	var p0 := _iso(a, b_start)
	var p1 := _iso(a, b_start + width)
	_draw_doorway_frame(p0, p1, door_name, color)


func _draw_doorway_frame(p0: Vector2, p1: Vector2, door_name: String, color: Color) -> void:
	var up := Vector2(0.0, -wall_height + 10.0)
	_add_line(_door_layer, "%sDoorwayOpening" % door_name, [p0, p1], color.lightened(0.34), 8.0)
	_add_line(_door_layer, "%sFrameLeft" % door_name, [p0, p0 + up], color, 6.0)
	_add_line(_door_layer, "%sFrameRight" % door_name, [p1, p1 + up], color, 6.0)
	_add_line(_door_layer, "%sFrameTop" % door_name, [p0 + up, p1 + up], color.lightened(0.12), 6.0)
	_add_line(_door_layer, "%sThresholdShadow" % door_name, [p0 + Vector2(0.0, 5.0), p1 + Vector2(0.0, 5.0)], COLOR_LABEL_SHADOW, 5.0)
	_add_line(_door_layer, "%sThreshold" % door_name, [p0, p1], color.lightened(0.24), 6.0)


func _draw_window_axis_b(a: float, b_start: float, width: float, window_name: String) -> void:
	var p0 := _iso(a, b_start) + Vector2(0.0, -78.0)
	var p1 := _iso(a, b_start + width) + Vector2(0.0, -78.0)
	var up := Vector2(0.0, -54.0)
	_add_line(_door_layer, "%sBottom" % window_name, [p0, p1], COLOR_WINDOW, 5.0)
	_add_line(_door_layer, "%sTop" % window_name, [p0 + up, p1 + up], COLOR_WINDOW, 5.0)
	_add_line(_door_layer, "%sSideA" % window_name, [p0, p0 + up], COLOR_WINDOW, 5.0)
	_add_line(_door_layer, "%sSideB" % window_name, [p1, p1 + up], COLOR_WINDOW, 5.0)


func _draw_room_outline(room: Rect2i, outline_name: String, color: Color) -> void:
	var points := _rect_points(room)
	_add_line(_edge_layer, outline_name, points + [points[0]], color, 5.0)


func _draw_front_stub_axis_a(a_start: float, b: float, length: float, stub_name: String, stub_height := -1.0) -> void:
	var p0 := _iso(a_start, b)
	var p1 := _iso(a_start + length, b)
	var height := cutaway_front_stub_height if stub_height < 0.0 else stub_height
	_add_polygon(_edge_layer, stub_name, [
		p0,
		p1,
		p1 + Vector2(0.0, height),
		p0 + Vector2(0.0, height),
	], cutaway_stub_color)


func _draw_front_stub_axis_b(a: float, b_start: float, length: float, stub_name: String, stub_height := -1.0) -> void:
	var p0 := _iso(a, b_start)
	var p1 := _iso(a, b_start + length)
	var height := cutaway_front_stub_height if stub_height < 0.0 else stub_height
	_add_polygon(_edge_layer, stub_name, [
		p0,
		p1,
		p1 + Vector2(0.0, height),
		p0 + Vector2(0.0, height),
	], cutaway_stub_color.darkened(0.08))


func _work_room_rect() -> Rect2i:
	return Rect2i(work_room_origin, work_room_size)


func _living_room_rect() -> Rect2i:
	return Rect2i(living_room_origin, living_room_size)


func _bathroom_room_rect() -> Rect2i:
	return Rect2i(bathroom_room_origin, bathroom_room_size)


func _entrance_room_rect() -> Rect2i:
	return Rect2i(entrance_room_origin, entrance_room_size)


func _service_room_rect() -> Rect2i:
	return Rect2i(service_room_origin, service_room_size)


func _no_large_object_zone_rect() -> Rect2i:
	return Rect2i(no_large_object_zone_origin, no_large_object_zone_size)


func _tile_points(a: float, b: float) -> Array[Vector2]:
	return _grid_points_to_screen([
		_transform_grid_point(Vector2(a, b)),
		_transform_grid_point(Vector2(a + 1.0, b)),
		_transform_grid_point(Vector2(a + 1.0, b + 1.0)),
		_transform_grid_point(Vector2(a, b + 1.0)),
	])


func _rect_points(room: Rect2i) -> Array[Vector2]:
	return _grid_points_to_screen(_rotate_grid_rect(room))


func _room_center(room: Rect2i) -> Vector2:
	return _iso(
		float(room.position.x) + float(room.size.x) * 0.5,
		float(room.position.y) + float(room.size.y) * 0.5
	)


func _resolve_wall_height(override_height: float) -> float:
	if override_height >= 0.0:
		return override_height
	return wall_height


func _iso(a: float, b: float) -> Vector2:
	return _grid_to_screen_point(_transform_grid_point(Vector2(a, b)))


func _grid_points_to_screen(points: Array[Vector2]) -> Array[Vector2]:
	var screen_points: Array[Vector2] = []
	for point in points:
		screen_points.append(_grid_to_screen_point(point))
	return screen_points


func _grid_to_screen_point(point: Vector2) -> Vector2:
	return map_origin + _axis_a() * point.x + _axis_b() * point.y


func _transform_grid_point(point: Vector2) -> Vector2:
	return _rotate_grid_point(point)


func _screen_to_grid_point(screen_position: Vector2) -> Vector2:
	return _inverse_rotate_grid_point(_screen_to_transformed_grid_point(screen_position))


# Converts a world-space screen position back into the currently projected grid basis.
func _screen_to_transformed_grid_point(screen_position: Vector2) -> Vector2:
	var delta := screen_position - map_origin
	var axis_a := _axis_a()
	var axis_b := _axis_b()
	var determinant := axis_a.x * axis_b.y - axis_a.y * axis_b.x
	if absf(determinant) < 0.001:
		return Vector2.ZERO
	return Vector2(
		(delta.x * axis_b.y - delta.y * axis_b.x) / determinant,
		(axis_a.x * delta.y - axis_a.y * delta.x) / determinant
	)


func _inverse_rotate_grid_point(point: Vector2) -> Vector2:
	var delta := point - map_rotation_pivot
	var restored := delta
	match map_rotation:
		MapRotation.ROTATE_90:
			restored = Vector2(delta.y, -delta.x)
		MapRotation.ROTATE_180:
			restored = -delta
		MapRotation.ROTATE_270:
			restored = Vector2(-delta.y, delta.x)
		_:
			restored = delta
	return map_rotation_pivot + restored


# ROTATE_90 maps the original upper work-room side toward the right side around the pivot.
func _rotate_grid_point(point: Vector2) -> Vector2:
	var delta := point - map_rotation_pivot
	var rotated := delta
	match map_rotation:
		MapRotation.ROTATE_90:
			rotated = Vector2(-delta.y, delta.x)
		MapRotation.ROTATE_180:
			rotated = -delta
		MapRotation.ROTATE_270:
			rotated = Vector2(delta.y, -delta.x)
		_:
			rotated = delta
	return map_rotation_pivot + rotated


func _rotate_grid_rect(room: Rect2i) -> Array[Vector2]:
	var a := float(room.position.x)
	var b := float(room.position.y)
	var w := float(room.size.x)
	var h := float(room.size.y)
	return [
		_transform_grid_point(Vector2(a, b)),
		_transform_grid_point(Vector2(a + w, b)),
		_transform_grid_point(Vector2(a + w, b + h)),
		_transform_grid_point(Vector2(a, b + h)),
	]


# View orientation changes the room projection by swapping the grid basis vectors,
# not by moving Camera2D. This keeps floor, walls, doors, labels, and stubs coherent.
func _axis_a() -> Vector2:
	var half_width := tile_width * 0.5
	var half_height := tile_height * 0.5
	match view_orientation:
		ViewOrientation.FRONT_LEFT:
			return Vector2(-half_width, -half_height)
		ViewOrientation.BACK_RIGHT:
			return Vector2(half_width, half_height)
		ViewOrientation.BACK_LEFT:
			return Vector2(-half_width, half_height)
		_:
			return Vector2(half_width, -half_height)


func _axis_b() -> Vector2:
	var half_width := tile_width * 0.5
	var half_height := tile_height * 0.5
	match view_orientation:
		ViewOrientation.FRONT_LEFT:
			return Vector2(-half_width, half_height)
		ViewOrientation.BACK_RIGHT:
			return Vector2(half_width, -half_height)
		ViewOrientation.BACK_LEFT:
			return Vector2(-half_width, -half_height)
		_:
			return Vector2(half_width, half_height)


func _add_layer(layer_name: String, z: int) -> Node2D:
	var layer := Node2D.new()
	layer.name = layer_name
	layer.z_index = z
	add_child(layer)
	return layer


func _add_polygon(parent: Node, polygon_name: String, points: Array[Vector2], color: Color) -> Polygon2D:
	var polygon := Polygon2D.new()
	polygon.name = polygon_name
	polygon.polygon = PackedVector2Array(points)
	polygon.color = color
	parent.add_child(polygon)
	return polygon


func _add_line(parent: Node, line_name: String, points: Array, color: Color, width: float) -> Line2D:
	var line := Line2D.new()
	line.name = line_name
	line.points = PackedVector2Array(points)
	line.default_color = color
	line.width = width
	line.joint_mode = Line2D.LINE_JOINT_SHARP
	parent.add_child(line)
	return line


func _add_arrow_head(parent: Node, arrow_name: String, start: Vector2, end: Vector2, color: Color) -> void:
	var direction := end - start
	if direction.length() < 0.001:
		return
	direction = direction.normalized()
	var normal := Vector2(-direction.y, direction.x)
	var back := end - direction * 18.0
	_add_line(parent, "%s_left" % arrow_name, [end, back + normal * 7.0], color, 4.0)
	_add_line(parent, "%s_right" % arrow_name, [end, back - normal * 7.0], color, 4.0)


func _add_marker(parent: Node, marker_name: String, position: Vector2, color: Color, radius := 7.0) -> Polygon2D:
	var marker := Polygon2D.new()
	marker.name = marker_name
	marker.polygon = PackedVector2Array([
		position + Vector2(0.0, -radius),
		position + Vector2(radius, 0.0),
		position + Vector2(0.0, radius),
		position + Vector2(-radius, 0.0),
	])
	marker.color = color
	parent.add_child(marker)
	return marker


func _add_label_with_background(
	parent: Node,
	label_name: String,
	text: String,
	position: Vector2,
	font_size := 15,
	background_color := COLOR_WALL_ID_BACKGROUND,
	text_color := COLOR_LABEL
) -> Label:
	var lines := text.split("\n")
	var longest_line := 0
	for line in lines:
		longest_line = maxi(longest_line, line.length())

	var padding := Vector2(9.0, 6.0)
	var background := ColorRect.new()
	background.name = "%sBackground" % label_name
	background.position = position - padding
	background.size = Vector2(float(longest_line) * float(font_size) * 0.62 + padding.x * 2.0, float(lines.size()) * float(font_size + 5) + padding.y * 2.0)
	background.color = background_color
	parent.add_child(background)
	var label := _add_label(parent, label_name, text, position, font_size)
	label.modulate = text_color
	return label


func _add_debug_label(label_name: String, text: String, position: Vector2, font_size := 15) -> Label:
	return _add_label(_label_layer, label_name, text, position, font_size)


func _add_label(parent: Node, label_name: String, text: String, position: Vector2, font_size := 15) -> Label:
	var label := Label.new()
	label.name = label_name
	label.text = text
	label.position = position
	label.modulate = COLOR_LABEL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	parent.add_child(label)
	return label


func _update_label_visibility() -> void:
	if _label_layer != null:
		# M owns one room-name label per measured room; suppress the legacy broad label set there.
		_label_layer.visible = show_debug_labels and not show_room_measurements
	if _object_layer != null:
		_object_layer.visible = show_object_placeholders
	if _debug_selection_layer != null:
		_debug_selection_layer.visible = show_object_placeholders
	if _navigation_layer != null:
		_navigation_layer.visible = show_navigation_debug
	if _wall_id_layer != null:
		_wall_id_layer.visible = show_wall_ids
	if _grid_coord_layer != null:
		_grid_coord_layer.visible = show_floor_grid_coords
	if _wall_edge_coord_layer != null:
		_wall_edge_coord_layer.visible = show_wall_edge_coords
	if _hover_edge_highlight_layer != null:
		_hover_edge_highlight_layer.visible = show_wall_edge_coords
	if _occlusion_debug_layer != null:
		_occlusion_debug_layer.visible = show_occlusion_wall_debug
	if _room_measurement_layer != null:
		_room_measurement_layer.visible = show_room_measurements
	if _zone_layer != null:
		_zone_layer.visible = show_room_measurements
	if _hover_coord_label != null:
		_hover_coord_label.visible = show_floor_grid_coords
	if _hover_coord_background != null:
		_hover_coord_background.visible = show_floor_grid_coords
	if _hover_edge_label != null:
		_hover_edge_label.visible = show_wall_edge_coords
	if _hover_edge_background != null:
		_hover_edge_background.visible = show_wall_edge_coords
	if _active_room_label != null:
		_active_room_label.visible = show_navigation_debug
	if _active_room_background != null:
		_active_room_background.visible = show_navigation_debug
	if _measurement_legend_label != null:
		_measurement_legend_label.visible = show_room_measurements
	if _measurement_legend_background != null:
		_measurement_legend_background.visible = show_room_measurements
	if _object_legend_label != null:
		_object_legend_label.visible = show_object_placeholders
	if _object_legend_background != null:
		_object_legend_background.visible = show_object_placeholders
	if _measurement_summary_label != null:
		_measurement_summary_label.visible = false
	if _measurement_summary_background != null:
		_measurement_summary_background.visible = false
	if _debug_detail_panel != null:
		_debug_detail_panel.visible = _has_primary_debug_mode()
	if not show_object_placeholders:
		_hovered_object_id = ""
		_hovered_object_candidates.clear()
	_update_compact_debug_help()
	_update_debug_detail_panel()
	_redraw_object_selection_overlay()
	_update_active_room_overlay()
	_update_hover_cell()


func _apply_camera_preset(preset: String) -> void:
	if camera_2d == null:
		return

	match preset:
		"living_area":
			camera_2d.position = _room_center(_living_room_rect()) + living_camera_center_offset
			camera_2d.zoom = living_camera_zoom
		"work_power_area":
			camera_2d.position = _room_center(_work_room_rect()) + work_camera_center_offset
			camera_2d.zoom = work_camera_zoom
		_:
			camera_2d.position = _grid_to_screen_point(_transform_grid_point(map_rotation_pivot)) + full_map_camera_center_offset
			camera_2d.zoom = full_map_camera_zoom
