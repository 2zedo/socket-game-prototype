extends Node2D

const ApartmentWallSegmentConfigScript := preload("res://scripts/quarterview/ApartmentWallSegmentConfig.gd")
const ApartmentObjectFootprintConfigScript := preload("res://scripts/quarterview/ApartmentObjectFootprintConfig.gd")

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
const DEFAULT_BATHROOM_ROOM_ORIGIN := Vector2i(0, 7)
const DEFAULT_BATHROOM_ROOM_SIZE := Vector2i(2, 3)
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
const COLOR_GRID_ORIGIN := Color(1.0, 0.92, 0.22, 1.0)
const COLOR_GRID_AXIS_X := Color(0.35, 0.78, 1.0, 0.95)
const COLOR_GRID_AXIS_Y := Color(0.50, 1.0, 0.60, 0.95)
const COLOR_WALL_EDGE_COORD := Color(1.0, 0.84, 0.46, 0.98)
const COLOR_WALL_EDGE_MARKER := Color(1.0, 0.54, 0.18, 0.92)
const COLOR_NAV_WALKABLE := Color(0.22, 0.92, 0.66, 0.24)
const COLOR_NAV_WALKABLE_MARKER := Color(0.44, 1.0, 0.78, 0.72)
const COLOR_NAV_BLOCKED_EDGE := Color(1.0, 0.30, 0.18, 0.92)
const COLOR_NAV_OCCLUSION_EDGE := Color(1.0, 0.56, 0.18, 0.95)
const COLOR_NAV_PASSABLE_EDGE := Color(0.22, 0.86, 1.0, 0.96)
const COLOR_NAV_PLAYER := Color(1.0, 0.92, 0.24, 0.96)
const COLOR_OCCLUSION_STUB_BODY := Color(0.20, 0.22, 0.22, 0.58)
const COLOR_OCCLUSION_STUB_CAP := Color(0.58, 0.61, 0.58, 0.90)
const COLOR_OCCLUSION_STUB_SHADOW := Color(0.03, 0.035, 0.04, 0.58)
const COLOR_OCCLUSION_STUB_DEBUG := Color(1.0, 0.62, 0.16, 0.95)
const COLOR_OBJECT_INTERACTION := Color(0.26, 1.0, 0.86, 0.94)
const COLOR_OBJECT_BLOCKED_CELL := Color(1.0, 0.28, 0.20, 0.92)

@export_group("View Orientation")
# view_orientation controls the isometric projection basis / mirroring only.
@export var view_orientation: ViewOrientation = ViewOrientation.FRONT_RIGHT
@export var map_origin := DEFAULT_MAP_ORIGIN

@export_group("Map Rotation")
# map_rotation rotates the floor-plan layout before the isometric projection is applied.
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
@export var service_room_origin := DEFAULT_SERVICE_ROOM_ORIGIN
@export var service_room_size := DEFAULT_SERVICE_ROOM_SIZE
@export var no_large_object_zone_origin := DEFAULT_NO_LARGE_OBJECT_ZONE_ORIGIN
@export var no_large_object_zone_size := DEFAULT_NO_LARGE_OBJECT_ZONE_SIZE

@export_group("Wall Segment Editing")
# Leave this empty to use the named default shell walls below. Add Resource items here to test
# wall movement, deletion, or extra walls without touching the renderer.
@export var custom_wall_segments: Array[Resource] = []

@export_group("Object Footprint Editing")
# Floor object placeholders use floor-cell coordinates. Leave this empty to use the default
# shell footprint test set, or add Resource items here to override the default list.
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
@export var show_debug_labels := true
@export var show_wall_ids := false
@export var show_floor_grid_coords := false
# Shows wall grid-line vertices / edges. Wall segments use these coordinates, not floor centers.
@export var show_wall_edge_coords := false
# Shows walkable cells, logical blocked edges, passable doorway edges, and the shell-only marker.
@export var show_navigation_debug := false
# Shows coordinate-based furniture / device footprint placeholders. These are shell-only guides.
@export var show_object_placeholders := false
# Highlights logical occlusion walls that are rendered as low stubs in the current shell view.
@export var show_occlusion_wall_debug := false
# Preview helper only: draw REVEALABLE walls at full height without adding character/area logic.
@export var preview_revealed_walls := false
# Shell-only reveal test. When true, REVEALABLE walls can become full walls for the active room area.
@export var debug_auto_reveal_walls := false
@export var debug_focus_wall_id := ""
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
var _navigation_layer: Node2D
var _grid_coord_layer: Node2D
var _wall_edge_coord_layer: Node2D
var _wall_id_layer: Node2D
var _occlusion_debug_layer: Node2D
var _debug_overlay_layer: CanvasLayer
var _hover_coord_label: Label
var _hover_coord_background: ColorRect
var _hover_edge_label: Label
var _hover_edge_background: ColorRect
var _active_room_label: Label
var _active_room_background: ColorRect
var _player_debug_marker: Polygon2D
var _player_debug_label: Label
var _last_active_room_area := ""


func _ready() -> void:
	_create_layers()
	_build_shell()
	_validate_object_footprints()
	_apply_camera_preset(camera_preset)
	_update_label_visibility()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
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
			show_navigation_debug = not show_navigation_debug
			_update_label_visibility()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_P:
			show_object_placeholders = not show_object_placeholders
			_update_label_visibility()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_O:
			show_occlusion_wall_debug = not show_occlusion_wall_debug
			_update_label_visibility()
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
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
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


func _create_layers() -> void:
	_background_layer = _add_layer("BackgroundLayer", -30)
	_floor_layer = _add_layer("FloorTileLayer", -20)
	_zone_layer = _add_layer("DebugZoneLayer", -15)
	_edge_layer = _add_layer("FloorEdgeLayer", -10)
	_occlusion_stub_layer = _add_layer("OcclusionStubLayer", -4)
	_wall_layer = _add_layer("WallLayer", 0)
	_door_layer = _add_layer("DoorAndWindowLayer", 10)
	_label_layer = _add_layer("DebugLabelLayer", 40)
	_object_layer = _add_layer("ObjectFootprintLayer", 65)
	_navigation_layer = _add_layer("NavigationDebugLayer", 70)
	_grid_coord_layer = _add_layer("GridCoordinateLayer", 85)
	_wall_edge_coord_layer = _add_layer("WallEdgeCoordinateLayer", 88)
	_wall_id_layer = _add_layer("WallIdLayer", 90)
	_occlusion_debug_layer = _add_layer("OcclusionWallDebugLayer", 95)
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
			bathroom_room.position,
			bathroom_room.size.x,
		),
		_make_wall_segment_config(
			&"bathroom_left_wall",
			ApartmentWallSegmentConfigScript.Axis.AXIS_B,
			bathroom_room.position,
			bathroom_room.size.y,
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


# Object footprints are shell-only floor-cell placeholders. They make future furniture/device
# placement editable before final sprites exist, and can feed the navigation debug blocker layer.
func _object_footprints() -> Array[Dictionary]:
	var footprints: Array[Dictionary] = []
	for entry in _active_object_footprint_config_entries():
		var config: Resource = entry.get("config")
		if config == null:
			continue
		footprints.append(_object_footprint_from_config(config, String(entry.get("source", "default"))))
	return footprints


func _active_object_footprint_config_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var source := "default"
	var configs := _default_object_footprint_configs()
	if not custom_object_footprints.is_empty():
		source = "custom_object_footprints"
		configs = custom_object_footprints

	for config in configs:
		entries.append({
			"source": source,
			"config": config,
		})
	return entries


# Edit these defaults to rough in furniture/device footprints. Coordinates are floor cells,
# unlike wall segments, whose from/to values are wall edge grid-line coordinates.
func _default_object_footprint_configs() -> Array[Resource]:
	return [
		_make_object_footprint_config(
			&"bed_placeholder",
			&"living_area",
			&"sleep",
			Vector2i(8, 7),
			Vector2i(2, 2),
			true,
			[Vector2i(7, 8)],
			Color(0.45, 0.62, 0.95, 0.36),
			"Bed placeholder",
			"Sleep-area footprint candidate."
		),
		_make_object_footprint_config(
			&"fridge_placeholder",
			&"living_area",
			&"kitchen",
			Vector2i(10, 4),
			Vector2i(1, 1),
			true,
			[Vector2i(9, 4)],
			Color(0.82, 0.82, 0.72, 0.36),
			"Fridge placeholder",
			"Single-door fridge footprint candidate."
		),
		_make_object_footprint_config(
			&"sink_counter_placeholder",
			&"living_area",
			&"kitchen",
			Vector2i(8, 4),
			Vector2i(1, 1),
			true,
			[Vector2i(8, 5)],
			Color(0.42, 0.60, 0.62, 0.36),
			"Sink counter placeholder",
			"Small counter / sink footprint candidate."
		),
		_make_object_footprint_config(
			&"microwave_placeholder",
			&"living_area",
			&"kitchen",
			Vector2i(9, 4),
			Vector2i(1, 1),
			false,
			[Vector2i(9, 5)],
			Color(0.70, 0.70, 0.66, 0.30),
			"Microwave placeholder",
			"Non-blocking counter-top appliance marker."
		),
		_make_object_footprint_config(
			&"small_table_placeholder",
			&"living_area",
			&"living",
			Vector2i(5, 7),
			Vector2i(2, 1),
			true,
			[Vector2i(5, 8)],
			Color(0.72, 0.50, 0.28, 0.34),
			"Small table placeholder",
			"Two-seat table footprint candidate."
		),
		_make_object_footprint_config(
			&"desk_placeholder",
			&"work_power_area",
			&"work",
			Vector2i(2, 1),
			Vector2i(2, 1),
			true,
			[Vector2i(2, 2)],
			Color(0.50, 0.62, 0.74, 0.34),
			"Desk placeholder",
			"Small work surface candidate."
		),
		_make_object_footprint_config(
			&"navi_chair_placeholder",
			&"work_power_area",
			&"navi",
			Vector2i(4, 1),
			Vector2i(2, 2),
			true,
			[Vector2i(4, 3)],
			Color(0.55, 0.48, 0.92, 0.34),
			"NAVI chair placeholder",
			"NAVI LINK seat footprint candidate."
		),
		_make_object_footprint_config(
			&"power_panel_placeholder",
			&"work_power_area",
			&"power",
			Vector2i(8, 0),
			Vector2i(1, 2),
			true,
			[Vector2i(7, 1)],
			Color(0.18, 0.76, 0.98, 0.32),
			"Power panel placeholder",
			"Wall-side power panel footprint candidate."
		),
		_make_object_footprint_config(
			&"connector_board_placeholder",
			&"work_power_area",
			&"power",
			Vector2i(7, 0),
			Vector2i(1, 1),
			true,
			[Vector2i(7, 1)],
			Color(0.34, 0.86, 0.66, 0.32),
			"Connector board placeholder",
			"Compact connector-board footprint candidate."
		),
		_make_object_footprint_config(
			&"comm_device_placeholder",
			&"work_power_area",
			&"signal",
			Vector2i(1, 1),
			Vector2i(1, 1),
			false,
			[Vector2i(1, 2)],
			Color(0.38, 0.70, 1.0, 0.30),
			"Comm device placeholder",
			"Non-blocking small comm-device marker."
		),
		_make_object_footprint_config(
			&"bathroom_fixture_placeholder",
			&"bathroom",
			&"bathroom",
			Vector2i(0, 7),
			Vector2i(1, 1),
			true,
			[Vector2i(1, 7)],
			Color(0.42, 0.82, 0.92, 0.34),
			"Bathroom fixture placeholder",
			"Minimal bathroom fixture footprint candidate."
		),
		_make_object_footprint_config(
			&"entrance_shoe_area_placeholder",
			&"entrance_area",
			&"entrance",
			Vector2i(0, 8),
			Vector2i(1, 1),
			false,
			[Vector2i(1, 8)],
			Color(0.90, 0.76, 0.36, 0.30),
			"Entrance shoe area placeholder",
			"Non-blocking entry shoe/slipper marker."
		),
	]


func _make_object_footprint_config(
	object_id: StringName,
	object_room_area_id: StringName,
	object_category: StringName,
	object_anchor_cell: Vector2i,
	object_size_cells: Vector2i,
	object_blocks_movement: bool,
	object_interaction_cells: Array[Vector2i],
	object_debug_color: Color,
	object_display_name := "",
	object_note := ""
) -> Resource:
	var config: Resource = ApartmentObjectFootprintConfigScript.new()
	config.id = object_id
	config.enabled = true
	config.room_area_id = object_room_area_id
	config.category = object_category
	config.anchor_cell = object_anchor_cell
	config.size_cells = object_size_cells
	config.blocks_movement = object_blocks_movement
	config.interaction_cells = object_interaction_cells
	config.debug_color = object_debug_color
	config.display_name = object_display_name
	config.note = object_note
	return config


func _object_footprint_from_config(config: Resource, source: String = "default") -> Dictionary:
	return {
		"id": String(config.id),
		"enabled": config.enabled,
		"source": source,
		"room_area_id": String(config.room_area_id),
		"category": String(config.category),
		"anchor_cell": config.anchor_cell,
		"size_cells": config.size_cells,
		"blocks_movement": config.blocks_movement,
		"interaction_cells": _object_config_interaction_cells(config),
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


func _object_placement_warnings() -> Array[String]:
	var warnings: Array[String] = []
	var occupied_by_cell: Dictionary = {}
	var passable_edges: Dictionary = _navigation_edge_sets()["passable"]

	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		var object_id := String(object_data.get("id", ""))
		var blocks_movement := bool(object_data.get("blocks_movement", true))
		var occupied_cells := _object_occupied_cells(object_data)
		if occupied_cells.is_empty():
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
	return warnings


# Prints an editor-friendly inventory so the user can identify which wall segment to edit.
func print_wall_segment_inventory() -> void:
	var rows := _wall_segment_inventory_rows()
	print("")
	print("=== Apartment Wall Segment Inventory ===")
	print("from_cell / to_cell are wall grid-line coordinates, not floor cell centers. Use E wall edge overlay to pick exact edge coordinates.")
	print("To place a wall around floor cell (x,y), use that cell's printed edge coordinates from G or E.")
	print("id | enabled | source | axis | edge_from_cell | edge_to_cell | length | wall_type | render_mode | current_state | doorway | reveal | logical | height_mode | edit_hint")
	print("--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---")
	for row in rows:
		print("%s | %s | %s | %s | %s | %s | %d | %s | %s | %s | %s | %s | %s | %s | %s" % [
			row["id"],
			str(row["enabled"]),
			row["source"],
			row["axis"],
			row["from_cell"],
			row["to_cell"],
			row["length"],
			row["wall_type"],
			row["render_mode"],
			row["current_state"],
			row["doorway"],
			row["reveal"],
			row["logical"],
			row["height_mode"],
			row["edit_hint"],
		])
	print("=== End Wall Segment Inventory ===")
	_print_navigation_summary()
	_print_object_footprint_summary()


func _wall_segment_inventory_rows() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for segment in _wall_segments():
		var axis: WallAxis = segment["axis"]
		var start_cell_i: Vector2i = segment.get("start_cell", Vector2i.ZERO)
		var end_cell_i := _segment_end_cell_i(segment)
		rows.append({
			"id": String(segment["id"]),
			"enabled": bool(segment.get("enabled", true)),
			"source": String(segment.get("source", "default")),
			"axis": _wall_axis_name(axis),
			"from_cell": _format_cell(start_cell_i),
			"to_cell": _format_cell(end_cell_i),
			"length": int(segment.get("length", 0)),
			"wall_type": _wall_type_name(segment.get("wall_type", WallType.NORMAL)),
			"render_mode": _render_mode_name(segment.get("render_mode", WallRenderMode.FULL)),
			"current_state": _wall_render_state(segment),
			"doorway": _wall_doorway_text(segment),
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
		area_text += area_id
	print("=== Apartment Navigation Debug Summary ===")
	print("walkable_cells=%d" % _walkable_floor_cells().size())
	print("blocked_edges=%d" % edge_sets["blocked"].size())
	print("passable_edges=%d" % edge_sets["passable"].size())
	print("room_areas=%s" % area_text)
	print("player_debug_cell=%s active_room_area=%s" % [_format_cell(player_debug_cell), _active_room_area()])
	print("debug_auto_reveal_walls=%s preview_revealed_walls=%s" % [str(debug_auto_reveal_walls), str(preview_revealed_walls)])
	for segment in _wall_segments():
		if int(segment.get("render_mode", WallRenderMode.FULL)) != WallRenderMode.REVEALABLE:
			continue
		print("revealable id=%s reveal_area_id=%s reveal_when_area_active=%s current_state=%s" % [
			String(segment.get("id", "")),
			String(segment.get("reveal_area_id", "")),
			str(bool(segment.get("reveal_when_area_active", false))),
			_wall_render_state(segment),
		])
	print("=== End Navigation Debug Summary ===")


func _print_object_footprint_summary() -> void:
	var rows := _object_footprint_inventory_rows()
	print("=== Apartment Object Footprint Summary ===")
	print("Object anchor/size/occupied/interactions are floor-cell coordinates. Wall segments use edge coordinates instead.")
	print("id | enabled | source | room_area_id | anchor_cell | size_cells | occupied_cells | blocks_movement | interaction_cells | edit_hint")
	print("--- | --- | --- | --- | --- | --- | --- | --- | --- | ---")
	for row in rows:
		print("%s | %s | %s | %s | %s | %s | %s | %s | %s | %s" % [
			row["id"],
			str(row["enabled"]),
			row["source"],
			row["room_area_id"],
			row["anchor_cell"],
			row["size_cells"],
			row["occupied_cells"],
			str(row["blocks_movement"]),
			row["interaction_cells"],
			row["edit_hint"],
		])
	print("=== End Object Footprint Summary ===")


func _object_footprint_inventory_rows() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for object_data in _object_footprints():
		rows.append({
			"id": String(object_data.get("id", "")),
			"enabled": bool(object_data.get("enabled", true)),
			"source": String(object_data.get("source", "default")),
			"room_area_id": String(object_data.get("room_area_id", "")),
			"anchor_cell": _format_cell(object_data.get("anchor_cell", Vector2i.ZERO)),
			"size_cells": _format_cell(object_data.get("size_cells", Vector2i.ONE)),
			"occupied_cells": _format_cells(_object_occupied_cells(object_data)),
			"blocks_movement": bool(object_data.get("blocks_movement", true)),
			"interaction_cells": _format_cells(_object_interaction_cells(object_data)),
			"edit_hint": _object_edit_hint(object_data),
		})
	return rows


func _object_edit_hint(object_data: Dictionary) -> String:
	var id := String(object_data.get("id", ""))
	var source := String(object_data.get("source", "default"))
	var location := "edit _default_object_footprint_configs() entry id=\"%s\"" % id
	if source == "custom_object_footprints":
		location = "edit Inspector > custom_object_footprints entry id=\"%s\"" % id
	return "%s; hide: enabled=false; move: anchor_cell; resize: size_cells; movement block: blocks_movement; use point: interaction_cell / interaction_cells; use G floor cell overlay for exact floor coordinates" % location


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
	_add_debug_label("work_label", "작업공간+전력공간", _room_center(_work_room_rect()) + Vector2(-76, -8))
	_add_debug_label("bath_label", "욕실", _room_center(_bathroom_room_rect()) + Vector2(-18, -8))
	_add_debug_label("connection_label", "연결문", _doorway_center(&"work_front_shared_wall") + Vector2(-32, -104))
	_add_debug_label("entrance_label", "현관문", _doorway_center(&"entrance_wall") + Vector2(-72, -84))
	_add_debug_label("no_object_zone_label", "camera foreground no-large-object zone", _room_center(_no_large_object_zone_rect()) + Vector2(-148, 20))


func _draw_object_placeholders() -> void:
	for object_data in _object_footprints():
		if not bool(object_data.get("enabled", true)):
			continue
		_draw_object_placeholder(object_data)


func _draw_object_placeholder(object_data: Dictionary) -> void:
	var id := String(object_data.get("id", ""))
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var size: Vector2i = object_data.get("size_cells", Vector2i.ONE)
	var blocks_movement := bool(object_data.get("blocks_movement", true))
	var color: Color = object_data.get("debug_color", Color(0.55, 0.74, 1.0, 0.38))
	if not blocks_movement:
		color.a *= 0.72

	var points := _rect_points(Rect2i(anchor, size))
	_add_polygon(_object_layer, "object_%s_footprint" % id, points, color)
	_add_line(
		_object_layer,
		"object_%s_outline" % id,
		points + [points[0]],
		color.lightened(0.34),
		3.0 if blocks_movement else 2.0
	)

	var label_position := _object_cells_center(_object_occupied_cells(object_data)) + Vector2(-58.0, -22.0)
	if blocks_movement:
		for occupied_cell in _object_occupied_cells(object_data):
			_add_marker(
				_object_layer,
				"object_%s_block_marker_%d_%d" % [id, occupied_cell.x, occupied_cell.y],
				_cell_center(occupied_cell),
				COLOR_OBJECT_BLOCKED_CELL,
				5.0
			)
	_add_label_with_background(
		_object_layer,
		"object_%s_label" % id,
		"%s\nanchor=%s size=%s\nblock=%s" % [
			id,
			_format_cell(anchor),
			_format_cell(size),
			str(blocks_movement),
		],
		label_position,
		11
	)

	for interaction_cell in _object_interaction_cells(object_data):
		var center := _cell_center(interaction_cell)
		_add_marker(
			_object_layer,
			"object_%s_interaction_%d_%d" % [id, interaction_cell.x, interaction_cell.y],
			center,
			COLOR_OBJECT_INTERACTION,
			8.0
		)
		_add_label_with_background(
			_object_layer,
			"object_%s_interaction_label_%d_%d" % [id, interaction_cell.x, interaction_cell.y],
			"use %s" % _format_cell(interaction_cell),
			center + Vector2(9.0, -28.0),
			10
		)


func _draw_control_hint() -> void:
	var label := Label.new()
	label.name = "ShellControlHint"
	label.text = "1/2/3: camera  |  L: labels  |  W: wall ids  |  G: grid coords  |  E: wall edges  |  N: navigation  |  P: object placeholders  |  O: occlusion walls  |  I: inventory"
	label.position = Vector2(24, 20)
	label.modulate = COLOR_LABEL
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(label)
	_create_hover_coord_overlay()
	_create_active_room_overlay()


func _draw_floor_grid_overlay() -> void:
	for cell in _visible_floor_cells():
		var coord_label := _add_label_with_background(
			_grid_coord_layer,
			"grid_coord_%d_%d" % [cell.x, cell.y],
			_format_cell(cell),
			_iso(float(cell.x) + 0.5, float(cell.y) + 0.5) + Vector2(-23.0, -12.0),
			13
		)
		coord_label.modulate = COLOR_GRID_COORD
	_draw_grid_axis_overlay()


func _draw_grid_axis_overlay() -> void:
	var origin := _iso(0.0, 0.0)
	var x_end := _iso(1.45, 0.0)
	var y_end := _iso(0.0, 1.45)
	_add_marker(_grid_coord_layer, "grid_origin_marker", origin, COLOR_GRID_ORIGIN, 15.0)
	_add_label_with_background(_grid_coord_layer, "grid_origin_label", "origin (0,0)", origin + Vector2(16.0, -36.0), 14)
	_add_line(_grid_coord_layer, "grid_axis_x", [origin, x_end], COLOR_GRID_AXIS_X, 5.0)
	_add_line(_grid_coord_layer, "grid_axis_y", [origin, y_end], COLOR_GRID_AXIS_Y, 5.0)
	_add_arrow_head(_grid_coord_layer, "grid_axis_x_head", origin, x_end, COLOR_GRID_AXIS_X)
	_add_arrow_head(_grid_coord_layer, "grid_axis_y_head", origin, y_end, COLOR_GRID_AXIS_Y)
	_add_label_with_background(_grid_coord_layer, "grid_axis_x_label", "+X", x_end + Vector2(12.0, -16.0), 15)
	_add_label_with_background(_grid_coord_layer, "grid_axis_y_label", "+Y", y_end + Vector2(12.0, -16.0), 15)


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
				13
			)

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
		_add_label_with_background(_navigation_layer, "nav_door_%s" % segment_id, "door %s" % segment_id, midpoint + Vector2(-38.0, -28.0), 11)


func _draw_player_debug_marker() -> void:
	var center := _cell_center(player_debug_cell)
	_player_debug_marker = _add_marker(_navigation_layer, "PlayerDebugMarker", center, COLOR_NAV_PLAYER, 15.0)
	_player_debug_label = _add_label(
		_navigation_layer,
		"PlayerDebugMarkerLabel",
		_player_debug_text(),
		center + Vector2(14.0, -42.0),
		14
	)
	_update_player_debug_marker()


func _draw_wall_edge_overlay() -> void:
	for vertex in _visible_wall_vertices():
		var point := _iso(float(vertex.x), float(vertex.y))
		_add_marker(_wall_edge_coord_layer, "wall_vertex_%d_%d" % [vertex.x, vertex.y], point, COLOR_WALL_EDGE_MARKER, 6.0)
		var label := _add_label_with_background(
			_wall_edge_coord_layer,
			"wall_vertex_label_%d_%d" % [vertex.x, vertex.y],
			_format_cell(vertex),
			point + Vector2(8.0, -28.0),
			11
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
	return cell.x >= 0 and cell.x < 2 and cell.y >= 8 and cell.y < 10


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
		if not bool(object_data.get("enabled", true)) or not bool(object_data.get("blocks_movement", true)):
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
		if not bool(object_data.get("enabled", true)) or not bool(object_data.get("blocks_movement", true)):
			continue
		for occupied_cell in _object_occupied_cells(object_data):
			if occupied_cell == cell:
				ids.append(String(object_data.get("id", "")))
				break
	return ids


func _object_occupied_cells(object_data: Dictionary) -> Array[Vector2i]:
	var anchor: Vector2i = object_data.get("anchor_cell", Vector2i.ZERO)
	var size: Vector2i = object_data.get("size_cells", Vector2i.ONE)
	var width := maxi(0, size.x)
	var height := maxi(0, size.y)
	var cells: Array[Vector2i] = []
	for x in range(anchor.x, anchor.x + width):
		for y in range(anchor.y, anchor.y + height):
			cells.append(Vector2i(x, y))
	return cells


func _object_interaction_cells(object_data: Dictionary) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in object_data.get("interaction_cells", []):
		var cell_i: Vector2i = cell
		if not cells.has(cell_i):
			cells.append(cell_i)
	return cells


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
	match area_id:
		"work_power_area":
			return "work_power_area"
		"bathroom":
			return "bathroom"
		"entrance_area":
			return "entrance_area"
		_:
			return "living_area"


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
	_hover_coord_background.size = Vector2(210.0, 31.0)
	_hover_coord_background.color = COLOR_WALL_ID_BACKGROUND
	_debug_overlay_layer.add_child(_hover_coord_background)

	_hover_coord_label = Label.new()
	_hover_coord_label.name = "HoverCellLabel"
	_hover_coord_label.text = "hover cell: -"
	_hover_coord_label.position = Vector2(34.0, 52.0)
	_hover_coord_label.modulate = COLOR_GRID_COORD
	_hover_coord_label.add_theme_font_size_override("font_size", 15)
	_hover_coord_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_hover_coord_label.add_theme_constant_override("shadow_offset_x", 2)
	_hover_coord_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_hover_coord_label)

	_hover_edge_background = ColorRect.new()
	_hover_edge_background.name = "HoverEdgeBackground"
	_hover_edge_background.position = Vector2(24.0, 84.0)
	_hover_edge_background.size = Vector2(385.0, 93.0)
	_hover_edge_background.color = COLOR_WALL_ID_BACKGROUND
	_debug_overlay_layer.add_child(_hover_edge_background)

	_hover_edge_label = Label.new()
	_hover_edge_label.name = "HoverEdgeLabel"
	_hover_edge_label.text = "nearest edge: -"
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
	_active_room_background.position = Vector2(24.0, 184.0)
	_active_room_background.size = Vector2(280.0, 58.0)
	_active_room_background.color = COLOR_WALL_ID_BACKGROUND
	_debug_overlay_layer.add_child(_active_room_background)

	_active_room_label = Label.new()
	_active_room_label.name = "ActiveRoomLabel"
	_active_room_label.position = Vector2(34.0, 190.0)
	_active_room_label.modulate = COLOR_NAV_PLAYER
	_active_room_label.add_theme_font_size_override("font_size", 14)
	_active_room_label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	_active_room_label.add_theme_constant_override("shadow_offset_x", 2)
	_active_room_label.add_theme_constant_override("shadow_offset_y", 2)
	_debug_overlay_layer.add_child(_active_room_label)
	_update_active_room_overlay()


func _update_active_room_overlay() -> void:
	if _active_room_label == null:
		return
	_active_room_label.text = "player cell: %s\nactive room: %s\nauto reveal: %s" % [
		_format_cell(player_debug_cell),
		_active_room_area(),
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
			_hover_coord_label.text = "hover cell: -"
		else:
			var hover_cell_i: Vector2i = hover_cell
			_hover_coord_label.text = "hover cell: %s" % _format_cell(hover_cell_i)

	if not show_wall_edge_coords or _hover_edge_label == null:
		return
	var edge_info := _hover_wall_edge()
	if edge_info.is_empty():
		if _hover_coord_label != null:
			_hover_coord_label.text = "hover cell: -"
		_hover_edge_label.text = "nearest edge: -"
		return
	_hover_edge_label.text = _wall_edge_hover_text(edge_info)


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
	return "hover cell: %s\nnearest edge: %s\nedge from=%s to=%s\naxis=%s" % [
		_format_cell(cell),
		String(edge_info.get("edge", "-")),
		_format_cell(from_cell),
		_format_cell(to_cell),
		_wall_axis_name(axis),
	]


func _print_clicked_cell_edges(cell: Vector2i) -> void:
	print("clicked cell: %s" % _format_cell(cell))
	for edge_name in ["top", "right", "bottom", "left"]:
		var edge_info := _wall_edge_info_for_cell(cell, edge_name)
		var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
		var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
		print("%s edge: from=%s to=%s" % [
			edge_name,
			_format_cell(from_cell),
			_format_cell(to_cell),
		])


func _print_clicked_wall_edge(edge_info: Dictionary) -> void:
	var cell: Vector2i = edge_info.get("cell", Vector2i.ZERO)
	var from_cell: Vector2i = edge_info.get("from_cell", Vector2i.ZERO)
	var to_cell: Vector2i = edge_info.get("to_cell", Vector2i.ZERO)
	var axis: WallAxis = edge_info.get("axis", WallAxis.AXIS_A)
	print("clicked wall edge:")
	print("cell=%s" % _format_cell(cell))
	print("edge=%s" % String(edge_info.get("edge", "-")))
	print("from=%s" % _format_cell(from_cell))
	print("to=%s" % _format_cell(to_cell))
	print("axis=%s" % _wall_axis_name(axis))


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
	print("navigation cell:")
	print("clicked cell: %s" % _format_cell(cell))
	print("room_area: %s" % _room_area_for_cell(cell))
	print("walkable: %s" % str(_is_walkable_cell(cell)))
	var blocker_ids := _object_blocker_ids_for_cell(cell)
	print("object_blockers: %s" % (", ".join(blocker_ids) if not blocker_ids.is_empty() else "-"))
	print("neighbors: top=%s right=%s bottom=%s left=%s" % [
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
			print("%s edge: %s" % [edge_name, status])
		else:
			print("%s edge: %s by %s" % [edge_name, status, segment_id])


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
		print("debug marker blocked: %s edge by %s at %s" % [edge_name, segment_id, _format_cell(player_debug_cell)])
		return true
	if not _is_walkable_cell(next_cell):
		var blocker_ids := _object_blocker_ids_for_cell(next_cell)
		if not blocker_ids.is_empty():
			print("debug marker blocked: target %s is occupied by %s" % [_format_cell(next_cell), ", ".join(blocker_ids)])
		else:
			print("debug marker blocked: target %s is not walkable" % _format_cell(next_cell))
		return true

	player_debug_cell = next_cell
	_update_player_debug_marker()
	print("debug marker moved %s to %s via %s%s" % [
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
	var area_id := _active_room_area()
	var area_changed := not _last_active_room_area.is_empty() and _last_active_room_area != area_id
	if area_changed:
		print("active room changed: %s -> %s" % [_last_active_room_area, area_id])
	_last_active_room_area = area_id
	_update_active_room_overlay()
	if area_changed and debug_auto_reveal_walls:
		_redraw_reveal_sensitive_layers()


func _player_debug_text() -> String:
	return "debug marker\ncell=%s\narea=%s" % [
		_format_cell(player_debug_cell),
		_active_room_area(),
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
	_draw_walls()
	_draw_doors_and_window_placeholders()
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
		"%s\nmode=%s state=%s" % [
			id,
			_render_mode_name(int(segment.get("render_mode", WallRenderMode.FULL))),
			_wall_render_state(segment),
		],
		center + Vector2(-76.0, 8.0),
		14
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
		"start %s" % _format_cell(start_cell_i),
		_iso(start_cell.x, start_cell.y) + Vector2(12.0, -8.0),
		12
	)
	_add_label_with_background(
		_wall_id_layer,
		"wall_end_label_%s" % id,
		"end %s" % _format_cell(end_cell_i),
		_iso(end_cell.x, end_cell.y) + Vector2(12.0, 8.0),
		12
	)
	_add_label_with_background(
		_wall_id_layer,
		"wall_id_%s" % id,
		_wall_id_label_text(id, start_cell_i, end_cell_i, axis, length_i, render_mode, segment),
		_iso(midpoint.x, midpoint.y) + label_offset,
		label_font_size
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
	var text := "%s\nedge from=%s to=%s\naxis=%s len=%d mode=%s state=%s" % [
		id,
		_format_cell(start_cell_i),
		_format_cell(end_cell_i),
		_wall_axis_name(axis),
		length_i,
		_render_mode_name(render_mode),
		_wall_render_state(segment),
	]
	if int(segment.get("doorway_width", 0)) > 0:
		text += "\ndoor %s" % _wall_doorway_text(segment)
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


func _add_label_with_background(parent: Node, label_name: String, text: String, position: Vector2, font_size := 15) -> Label:
	var lines := text.split("\n")
	var longest_line := 0
	for line in lines:
		longest_line = maxi(longest_line, line.length())

	var padding := Vector2(9.0, 6.0)
	var background := ColorRect.new()
	background.name = "%sBackground" % label_name
	background.position = position - padding
	background.size = Vector2(float(longest_line) * float(font_size) * 0.62 + padding.x * 2.0, float(lines.size()) * float(font_size + 5) + padding.y * 2.0)
	background.color = COLOR_WALL_ID_BACKGROUND
	parent.add_child(background)
	return _add_label(parent, label_name, text, position, font_size)


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
		_label_layer.visible = show_debug_labels
	if _object_layer != null:
		_object_layer.visible = show_object_placeholders or show_navigation_debug
	if _navigation_layer != null:
		_navigation_layer.visible = show_navigation_debug
	if _wall_id_layer != null:
		_wall_id_layer.visible = show_wall_ids
	if _grid_coord_layer != null:
		_grid_coord_layer.visible = show_floor_grid_coords
	if _wall_edge_coord_layer != null:
		_wall_edge_coord_layer.visible = show_wall_edge_coords
	if _occlusion_debug_layer != null:
		_occlusion_debug_layer.visible = show_occlusion_wall_debug
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
