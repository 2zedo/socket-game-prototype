extends Node2D

enum ViewOrientation {
	FRONT_RIGHT,
	FRONT_LEFT,
	BACK_RIGHT,
	BACK_LEFT,
}

const DEFAULT_TILE_WIDTH := 128.0
const DEFAULT_TILE_HEIGHT := 64.0
const DEFAULT_WALL_HEIGHT := 176.0
const DEFAULT_WALL_CAP_HEIGHT := 16.0
const DEFAULT_BASEBOARD_HEIGHT := 18.0
const DEFAULT_CUTAWAY_FRONT_STUB_HEIGHT := 42.0
const DEFAULT_MAP_ORIGIN := Vector2(420.0, 270.0)

const DEFAULT_WORK_ROOM_ORIGIN := Vector2i(1, 0)
const DEFAULT_WORK_ROOM_SIZE := Vector2i(8, 4)
const DEFAULT_LIVING_ROOM_ORIGIN := Vector2i(0, 4)
const DEFAULT_LIVING_ROOM_SIZE := Vector2i(11, 6)
const DEFAULT_BATHROOM_ROOM_ORIGIN := Vector2i(0, 7)
const DEFAULT_BATHROOM_ROOM_SIZE := Vector2i(2, 2)
const DEFAULT_SERVICE_ROOM_ORIGIN := Vector2i(0, 9)
const DEFAULT_SERVICE_ROOM_SIZE := Vector2i(2, 1)
const DEFAULT_NO_LARGE_OBJECT_ZONE_ORIGIN := Vector2i(2, 8)
const DEFAULT_NO_LARGE_OBJECT_ZONE_SIZE := Vector2i(8, 2)

const DEFAULT_CONNECTION_DOOR_A_START := 6.25
const DEFAULT_CONNECTION_DOOR_WIDTH := 1.4
const DEFAULT_ENTRANCE_DOOR_B_START := 5.2
const DEFAULT_ENTRANCE_DOOR_WIDTH := 1.25
const DEFAULT_BATHROOM_DOOR_A_START := 0.45
const DEFAULT_BATHROOM_DOOR_WIDTH := 0.85
const DEFAULT_SERVICE_DOOR_A_START := 0.45
const DEFAULT_SERVICE_DOOR_WIDTH := 0.85
const DEFAULT_LIVING_WINDOW_AXIS_A := 11.0
const DEFAULT_LIVING_WINDOW_B_START := 5.2
const DEFAULT_LIVING_WINDOW_WIDTH := 1.65

const DEFAULT_FULL_MAP_CAMERA_POSITION := Vector2(770.0, 380.0)
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

@export_group("View Orientation")
@export var view_orientation: ViewOrientation = ViewOrientation.FRONT_RIGHT
@export var map_origin := DEFAULT_MAP_ORIGIN

@export_group("Shell Dimensions")
@export var tile_width := DEFAULT_TILE_WIDTH
@export var tile_height := DEFAULT_TILE_HEIGHT
@export var wall_height := DEFAULT_WALL_HEIGHT
@export var wall_cap_height := DEFAULT_WALL_CAP_HEIGHT
@export var baseboard_height := DEFAULT_BASEBOARD_HEIGHT
@export var cutaway_front_stub_height := DEFAULT_CUTAWAY_FRONT_STUB_HEIGHT

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

@export_group("Door And Window Layout")
@export var connection_door_axis_a_start := DEFAULT_CONNECTION_DOOR_A_START
@export var connection_door_width := DEFAULT_CONNECTION_DOOR_WIDTH
@export var entrance_door_axis_b_start := DEFAULT_ENTRANCE_DOOR_B_START
@export var entrance_door_width := DEFAULT_ENTRANCE_DOOR_WIDTH
@export var bathroom_door_axis_a_start := DEFAULT_BATHROOM_DOOR_A_START
@export var bathroom_door_width := DEFAULT_BATHROOM_DOOR_WIDTH
@export var service_door_axis_a_start := DEFAULT_SERVICE_DOOR_A_START
@export var service_door_width := DEFAULT_SERVICE_DOOR_WIDTH
@export var living_window_axis_a := DEFAULT_LIVING_WINDOW_AXIS_A
@export var living_window_axis_b_start := DEFAULT_LIVING_WINDOW_B_START
@export var living_window_width := DEFAULT_LIVING_WINDOW_WIDTH

@export_group("Camera Presets")
@export var full_map_camera_position := DEFAULT_FULL_MAP_CAMERA_POSITION
@export var full_map_camera_zoom := DEFAULT_FULL_MAP_CAMERA_ZOOM
@export var living_camera_center_offset := DEFAULT_LIVING_CAMERA_CENTER_OFFSET
@export var living_camera_zoom := DEFAULT_LIVING_CAMERA_ZOOM
@export var work_camera_center_offset := DEFAULT_WORK_CAMERA_CENTER_OFFSET
@export var work_camera_zoom := DEFAULT_WORK_CAMERA_ZOOM
@export_enum("full_map", "living_area", "work_power_area") var camera_preset: String = "full_map"

@export_group("Debug")
@export var show_debug_labels := true

@onready var camera_2d: Camera2D = $Camera2D

var _background_layer: Node2D
var _floor_layer: Node2D
var _zone_layer: Node2D
var _edge_layer: Node2D
var _wall_layer: Node2D
var _door_layer: Node2D
var _label_layer: Node2D


func _ready() -> void:
	_create_layers()
	_build_shell()
	_apply_camera_preset(camera_preset)
	_update_label_visibility()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_L:
			show_debug_labels = not show_debug_labels
			_update_label_visibility()
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


func set_camera_preset(preset: String) -> void:
	camera_preset = preset
	_apply_camera_preset(camera_preset)


func _create_layers() -> void:
	_background_layer = _add_layer("BackgroundLayer", -30)
	_floor_layer = _add_layer("FloorTileLayer", -20)
	_zone_layer = _add_layer("DebugZoneLayer", -15)
	_edge_layer = _add_layer("FloorEdgeLayer", -10)
	_wall_layer = _add_layer("WallLayer", 0)
	_door_layer = _add_layer("DoorAndWindowLayer", 10)
	_label_layer = _add_layer("DebugLabelLayer", 40)


func _build_shell() -> void:
	_draw_background()
	_draw_floor_tiles(_living_room_rect(), COLOR_FLOOR, "living")
	_draw_floor_tiles(_work_room_rect(), COLOR_FLOOR_WORK, "work_power")
	_draw_floor_tiles(_bathroom_room_rect(), COLOR_FLOOR_BATH, "bathroom")
	_draw_floor_tiles(_service_room_rect(), COLOR_FLOOR_BATH.darkened(0.08), "service")
	_draw_no_large_object_zone()
	_draw_floor_edges()
	_draw_walls()
	_draw_doors_and_window_placeholders()
	_draw_debug_labels()


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
	var living_room := _living_room_rect()
	var work_room := _work_room_rect()
	var bathroom_room := _bathroom_room_rect()
	var service_room := _service_room_rect()
	var living_left := float(living_room.position.x)
	var living_right := float(living_room.position.x + living_room.size.x)
	var living_top := float(living_room.position.y)
	var living_bottom := float(living_room.position.y + living_room.size.y)
	var work_left := float(work_room.position.x)
	var work_right := float(work_room.position.x + work_room.size.x)
	var work_top := float(work_room.position.y)
	var work_bottom := float(work_room.position.y + work_room.size.y)

	# Work room outer walls.
	_draw_wall_axis_a(work_left, work_top, float(work_room.size.x), "WorkBackWall")
	_draw_wall_axis_b(work_left, work_top, float(work_room.size.y), "WorkLeftWall")
	_draw_wall_axis_b(work_right, work_top, float(work_room.size.y), "WorkRightWall")

	# Living room outer walls. The left wall has an entrance-door opening.
	_draw_wall_axis_b(living_left, living_top, entrance_door_axis_b_start - living_top, "LivingLeftWallUpper")
	_draw_wall_axis_b(living_left, entrance_door_axis_b_start + entrance_door_width, living_bottom - (entrance_door_axis_b_start + entrance_door_width), "LivingLeftWallLower")
	_draw_wall_axis_b(living_right, living_top, float(living_room.size.y), "LivingRightWall")
	_draw_wall_axis_a(living_left, living_bottom, float(living_room.size.x), "LivingFrontCutawayStub", cutaway_front_stub_height)

	# Shared wall between the two rooms. The doorway is the only gap.
	_draw_wall_axis_a(living_left, work_bottom, connection_door_axis_a_start - living_left, "SharedWallLeft")
	var right_start := connection_door_axis_a_start + connection_door_width
	_draw_wall_axis_a(right_start, work_bottom, living_right - right_start, "SharedWallRight")

	# Bathroom / service partitions remain structural placeholders, not furniture.
	_draw_wall_axis_a(float(bathroom_room.position.x), float(bathroom_room.position.y), float(bathroom_room.size.x), "BathroomUpperPartition")
	_draw_wall_axis_a(float(service_room.position.x), float(service_room.position.y), float(service_room.size.x), "ServiceUpperPartition")
	_draw_wall_axis_b(float(service_room.position.x + service_room.size.x), float(bathroom_room.position.y), float(service_room.position.y + service_room.size.y - bathroom_room.position.y), "ServiceRightPartition")


func _draw_doors_and_window_placeholders() -> void:
	var living_room := _living_room_rect()
	var bathroom_room := _bathroom_room_rect()
	var service_room := _service_room_rect()
	_draw_doorway_axis_a(connection_door_axis_a_start, float(living_room.position.y), connection_door_width, "InternalConnectionDoor", COLOR_INNER_DOOR)
	_draw_doorway_axis_b(float(living_room.position.x), entrance_door_axis_b_start, entrance_door_width, "EntranceDoor", COLOR_ENTRANCE_DOOR)
	_draw_doorway_axis_a(bathroom_door_axis_a_start, float(bathroom_room.position.y), bathroom_door_width, "BathroomDoor", COLOR_SERVICE_DOOR)
	_draw_doorway_axis_a(service_door_axis_a_start, float(service_room.position.y), service_door_width, "ServiceDoor", COLOR_SERVICE_DOOR.darkened(0.08))
	_draw_window_axis_b(living_window_axis_a, living_window_axis_b_start, living_window_width, "LivingWindowPlaceholder")


func _draw_debug_labels() -> void:
	var living_room := _living_room_rect()
	_add_debug_label("living_label", "생활공간", _room_center(living_room) + Vector2(-30, 8))
	_add_debug_label("work_label", "작업공간+전력공간", _room_center(_work_room_rect()) + Vector2(-76, -8))
	_add_debug_label("bath_label", "욕실", _room_center(_bathroom_room_rect()) + Vector2(-18, -8))
	_add_debug_label("service_label", "서비스 구획", _room_center(_service_room_rect()) + Vector2(-42, 8))
	_add_debug_label("connection_label", "연결문", _iso(connection_door_axis_a_start + connection_door_width * 0.5, float(living_room.position.y)) + Vector2(-32, -104))
	_add_debug_label("entrance_label", "현관문", _iso(float(living_room.position.x), entrance_door_axis_b_start + entrance_door_width * 0.5) + Vector2(-72, -84))
	_add_debug_label("no_object_zone_label", "camera foreground no-large-object zone", _room_center(_no_large_object_zone_rect()) + Vector2(-148, 20))
	_add_debug_label("camera_help_label", "1 full_map / 2 living_area / 3 work_power_area / L labels", Vector2(250, 42))


func _draw_wall_axis_a(a_start: float, b: float, length: float, wall_name: String, height := -1.0) -> void:
	if length <= 0.0:
		return
	_draw_wall_segment(_iso(a_start, b), _iso(a_start + length, b), wall_name, _resolve_wall_height(height))


func _draw_wall_axis_b(a: float, b_start: float, length: float, wall_name: String, height := -1.0) -> void:
	if length <= 0.0:
		return
	_draw_wall_segment(_iso(a, b_start), _iso(a, b_start + length), wall_name, _resolve_wall_height(height))


func _draw_wall_segment(p0: Vector2, p1: Vector2, wall_name: String, height: float) -> void:
	var up := Vector2(0.0, -height)
	var wall_color := COLOR_WALL if p1.y <= p0.y else COLOR_WALL_SIDE
	_add_polygon(_wall_layer, wall_name, [p0, p1, p1 + up, p0 + up], wall_color)
	_add_wall_cap(p0, p1, up, "%sCap" % wall_name)
	_add_polygon(_wall_layer, "%sBaseboard" % wall_name, [
		p0,
		p1,
		p1 + Vector2(0.0, -baseboard_height),
		p0 + Vector2(0.0, -baseboard_height),
	], COLOR_BASEBOARD)


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
	], COLOR_WALL_CAP)


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
	_add_line(_door_layer, "%sFrameLeft" % door_name, [p0, p0 + up], color, 5.0)
	_add_line(_door_layer, "%sFrameRight" % door_name, [p1, p1 + up], color, 5.0)
	_add_line(_door_layer, "%sFrameTop" % door_name, [p0 + up, p1 + up], color.lightened(0.12), 5.0)
	_add_line(_door_layer, "%sThreshold" % door_name, [p0, p1], color.lightened(0.20), 4.0)


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


func _draw_front_stub_axis_a(a_start: float, b: float, length: float, stub_name: String) -> void:
	var p0 := _iso(a_start, b)
	var p1 := _iso(a_start + length, b)
	_add_polygon(_edge_layer, stub_name, [
		p0,
		p1,
		p1 + Vector2(0.0, cutaway_front_stub_height),
		p0 + Vector2(0.0, cutaway_front_stub_height),
	], COLOR_FRONT_STUB)


func _draw_front_stub_axis_b(a: float, b_start: float, length: float, stub_name: String) -> void:
	var p0 := _iso(a, b_start)
	var p1 := _iso(a, b_start + length)
	_add_polygon(_edge_layer, stub_name, [
		p0,
		p1,
		p1 + Vector2(0.0, cutaway_front_stub_height),
		p0 + Vector2(0.0, cutaway_front_stub_height),
	], COLOR_FRONT_STUB.darkened(0.08))


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
	return [
		_iso(a, b),
		_iso(a + 1.0, b),
		_iso(a + 1.0, b + 1.0),
		_iso(a, b + 1.0),
	]


func _rect_points(room: Rect2i) -> Array[Vector2]:
	var a := float(room.position.x)
	var b := float(room.position.y)
	var w := float(room.size.x)
	var h := float(room.size.y)
	return [
		_iso(a, b),
		_iso(a + w, b),
		_iso(a + w, b + h),
		_iso(a, b + h),
	]


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
	return map_origin + _axis_a() * a + _axis_b() * b


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


func _add_debug_label(label_name: String, text: String, position: Vector2) -> Label:
	var label := Label.new()
	label.name = label_name
	label.text = text
	label.position = position
	label.modulate = COLOR_LABEL
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_shadow_color", COLOR_LABEL_SHADOW)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_to_group("apartment_shell_debug_labels")
	_label_layer.add_child(label)
	return label


func _update_label_visibility() -> void:
	if _label_layer == null:
		return
	_label_layer.visible = show_debug_labels


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
			camera_2d.position = full_map_camera_position
			camera_2d.zoom = full_map_camera_zoom
