@tool
extends Node2D
class_name QuarterviewReusableMapSample

const ApartmentWallCellScript := preload("res://scripts/quarterview/ApartmentWallCell.gd")

enum EditorGuideMode { CLEAN, STRUCTURE, OBJECT, ALL }
enum WallInspectionMode { NORMAL, TRANSPARENT, HIDDEN }

const FLOOR_ROOT_PATH := NodePath("Floor")
const ROOM_ROOT_PATH := NodePath("RoomAreas")
const WALL_ROOT_PATH := NodePath("Walls")
const OPENING_ROOT_PATH := NodePath("Openings")
const OBJECT_ROOT_PATH := NodePath("EditableObjectNodes")
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2i.LEFT,
	Vector2i.DOWN,
	Vector2i.UP,
]

const COLOR_FLOOR_GRID := Color(0.48, 0.62, 0.68, 0.42)
const COLOR_ROOM_A := Color(0.32, 0.80, 0.58, 0.12)
const COLOR_ROOM_B := Color(0.44, 0.58, 0.96, 0.12)
const COLOR_COLLISION := Color(1.0, 0.25, 0.20, 0.94)
const COLOR_SELECTION := Color(0.18, 0.92, 0.92, 0.92)
const COLOR_INTERACTION := Color(1.0, 0.52, 0.12, 0.94)
const COLOR_USE_POINT := Color(0.32, 1.0, 0.46, 0.96)
const COLOR_BASE_POINT := Color(0.62, 1.0, 0.48, 0.96)
const COLOR_TOP_POINT := Color(1.0, 0.88, 0.24, 0.96)
const COLOR_SOCKET := Color(0.94, 0.36, 1.0, 0.96)
const COLOR_VISUAL := Color(1.0, 1.0, 1.0, 0.90)
const COLOR_WALL_BASE := Color(0.88, 0.90, 0.92, 0.82)
const COLOR_WALL_TOP := Color(1.0, 0.92, 0.58, 0.82)
const COLOR_DOOR := Color(0.28, 1.0, 0.54, 0.96)
const COLOR_WINDOW := Color(0.30, 0.70, 1.0, 0.96)

@export_category("Sample Environment")
@export var object_footprint_set: Resource
@export_category("Environment Editor Guides")
@export var editor_guide_mode: EditorGuideMode = EditorGuideMode.CLEAN
@export var editor_focus_object_id: StringName = &""

var p_debug_enabled := false
var m_debug_enabled := false
var n_debug_enabled := false
var w_debug_enabled := false
var wall_inspection_mode: WallInspectionMode = WallInspectionMode.NORMAL
var selected_object_id := ""
var hovered_object_id := ""

var _debug_canvas: CanvasLayer
var _status_label: Label
var _detail_label: Label
var _feedback_label: Label
var _feedback_remaining := 0.0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_enable_sample_runtime_previews()
	_build_runtime_ui()
	_apply_wall_inspection_mode()
	_connect_gameplay_feedback()
	_update_runtime_ui()
	queue_redraw()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if p_debug_enabled:
		var next_hovered := _object_id_at_world_point(get_global_mouse_position())
		if next_hovered != hovered_object_id:
			hovered_object_id = next_hovered
			queue_redraw()
	if _feedback_remaining > 0.0:
		_feedback_remaining = maxf(0.0, _feedback_remaining - delta)
		if is_zero_approx(_feedback_remaining) and is_instance_valid(_feedback_label):
			_feedback_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_P:
				p_debug_enabled = not p_debug_enabled
			KEY_M:
				m_debug_enabled = not m_debug_enabled
			KEY_N:
				n_debug_enabled = not n_debug_enabled
			KEY_W:
				w_debug_enabled = not w_debug_enabled
			KEY_V:
				cycle_wall_inspection_mode()
			_:
				return
		_update_runtime_ui()
		queue_redraw()
		get_viewport().set_input_as_handled()
		return
	if p_debug_enabled and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected_object_id = _object_id_at_world_point(get_global_mouse_position())
		_update_runtime_ui()
		queue_redraw()
		get_viewport().set_input_as_handled()


func _draw() -> void:
	if Engine.is_editor_hint():
		return
	if m_debug_enabled:
		_draw_room_debug()
	if p_debug_enabled or m_debug_enabled or n_debug_enabled:
		_draw_floor_grid()
	if n_debug_enabled:
		_draw_navigation_debug()
	if w_debug_enabled:
		_draw_wall_debug()
	if p_debug_enabled:
		_draw_object_debug()


func playable_object_data(object_id: String) -> Dictionary:
	var object_node := playable_object_node(object_id)
	if object_node == null:
		return {}
	return _object_data_from_node(object_node)


func playable_object_node(object_id: String) -> Node2D:
	for object_node in _editable_object_nodes():
		if String(object_node.get("object_id")) == object_id:
			return object_node
	return null


func playable_direct_object_ids() -> Array[String]:
	var result: Array[String] = []
	for config in _object_configs():
		if String(config.get("category")) != "interaction":
			continue
		var object_id := String(config.get("id"))
		if playable_object_node(object_id) != null:
			result.append(object_id)
	return result


func playable_resolve_walk_target(world_position: Vector2) -> Vector2:
	var direct_cell := _world_to_floor_cell(world_position)
	var walkable := _walkable_floor_cells()
	if walkable.has(direct_cell):
		return world_position
	var nearest := _nearest_walkable_cell(world_position, walkable)
	return world_position if nearest == Vector2i(-9999, -9999) else _cell_center(nearest)


func playable_find_path(from_world: Vector2, to_world: Vector2) -> PackedVector2Array:
	var walkable := _walkable_floor_cells()
	var start := _nearest_walkable_cell(from_world, walkable)
	var target := _nearest_walkable_cell(to_world, walkable)
	if start == Vector2i(-9999, -9999) or target == Vector2i(-9999, -9999):
		return PackedVector2Array()
	var frontier: Array[Vector2i] = [start]
	var came_from: Dictionary = {start: start}
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		if current == target:
			break
		for direction in CARDINAL_DIRECTIONS:
			var next_cell := current + direction
			if not walkable.has(next_cell) or came_from.has(next_cell):
				continue
			if _segment_crosses_blocking_wall(_cell_center(current), _cell_center(next_cell)):
				continue
			came_from[next_cell] = current
			frontier.append(next_cell)
	if not came_from.has(target):
		return PackedVector2Array()
	var reversed_cells: Array[Vector2i] = []
	var cursor := target
	while cursor != start:
		reversed_cells.append(cursor)
		cursor = Vector2i(came_from[cursor])
	reversed_cells.append(start)
	reversed_cells.reverse()
	var result := PackedVector2Array()
	for cell in reversed_cells:
		result.append(_cell_center(cell))
	var resolved_target := playable_resolve_walk_target(to_world)
	if result.is_empty() or not result[result.size() - 1].is_equal_approx(resolved_target):
		result.append(resolved_target)
	else:
		result[result.size() - 1] = resolved_target
	return result


func playable_is_walkable_world_point(world_position: Vector2) -> bool:
	return _walkable_floor_cells().has(_world_to_floor_cell(world_position))


func cycle_wall_inspection_mode() -> void:
	wall_inspection_mode = ((int(wall_inspection_mode) + 1) % 3) as WallInspectionMode
	_apply_wall_inspection_mode()
	_update_runtime_ui()
	queue_redraw()


func set_debug_overlay(debug_key: StringName, enabled: bool) -> void:
	match String(debug_key).to_upper():
		"P":
			p_debug_enabled = enabled
		"M":
			m_debug_enabled = enabled
		"N":
			n_debug_enabled = enabled
		"W":
			w_debug_enabled = enabled
	_update_runtime_ui()
	queue_redraw()


func debug_overlay_state() -> Dictionary:
	return {
		"P": p_debug_enabled,
		"M": m_debug_enabled,
		"N": n_debug_enabled,
		"W": w_debug_enabled,
		"V": wall_inspection_mode_name(),
		"selected_object_id": selected_object_id,
	}


func wall_inspection_mode_name() -> String:
	match wall_inspection_mode:
		WallInspectionMode.TRANSPARENT:
			return "TRANSPARENT"
		WallInspectionMode.HIDDEN:
			return "HIDDEN"
		_:
			return "NORMAL"


func sample_contract_snapshot() -> Dictionary:
	return {
		"floor_layers": _floor_layers().size(),
		"floor_cells": _all_floor_cells().size(),
		"room_areas": _room_nodes().size(),
		"wall_groups": _wall_groups().size(),
		"wall_cells": _wall_cells().size(),
		"openings": _opening_nodes().size(),
		"interactive_ids": playable_direct_object_ids(),
		"objects": _editable_object_nodes().size(),
	}


func _build_runtime_ui() -> void:
	_debug_canvas = CanvasLayer.new()
	_debug_canvas.name = "SampleDebugUI"
	_debug_canvas.layer = 100
	add_child(_debug_canvas)
	_status_label = Label.new()
	_status_label.name = "Status"
	_status_label.position = Vector2(18.0, 14.0)
	_status_label.add_theme_font_size_override("font_size", 16)
	_status_label.add_theme_color_override("font_color", Color(0.96, 0.94, 0.84, 1.0))
	_status_label.add_theme_color_override("font_outline_color", Color(0.03, 0.035, 0.05, 1.0))
	_status_label.add_theme_constant_override("outline_size", 5)
	_debug_canvas.add_child(_status_label)
	_detail_label = Label.new()
	_detail_label.name = "ObjectDetail"
	_detail_label.position = Vector2(18.0, 72.0)
	_detail_label.add_theme_font_size_override("font_size", 15)
	_detail_label.add_theme_color_override("font_color", Color(0.84, 1.0, 0.98, 1.0))
	_detail_label.add_theme_color_override("font_outline_color", Color(0.03, 0.035, 0.05, 1.0))
	_detail_label.add_theme_constant_override("outline_size", 5)
	_debug_canvas.add_child(_detail_label)
	_feedback_label = Label.new()
	_feedback_label.name = "InteractionFeedback"
	_feedback_label.position = Vector2(18.0, 160.0)
	_feedback_label.add_theme_font_size_override("font_size", 18)
	_feedback_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.32, 1.0))
	_feedback_label.add_theme_color_override("font_outline_color", Color(0.03, 0.035, 0.05, 1.0))
	_feedback_label.add_theme_constant_override("outline_size", 5)
	_feedback_label.visible = false
	_debug_canvas.add_child(_feedback_label)


func _enable_sample_runtime_previews() -> void:
	for object_node in _editable_object_nodes():
		var sprite := object_node.get_node_or_null("Visual/Sprite2D") as Sprite2D
		var preview := object_node.get_node_or_null("Visual/VisualPreview") as Polygon2D
		if preview == null or (sprite != null and sprite.texture != null):
			continue
		preview.visible = true
		var runtime_color := preview.color
		runtime_color.a = 0.76
		preview.color = runtime_color


func _update_runtime_ui() -> void:
	if not is_instance_valid(_status_label):
		return
	_status_label.text = "재사용 검증 맵 | P 오브젝트:%s  M 방:%s  N 이동:%s  W 벽:%s  V:%s\n클릭 이동 · E/Enter 상호작용 · 외부문/연결문 통과 검증" % [
		_on_off(p_debug_enabled),
		_on_off(m_debug_enabled),
		_on_off(n_debug_enabled),
		_on_off(w_debug_enabled),
		wall_inspection_mode_name(),
	]
	_detail_label.visible = p_debug_enabled and not selected_object_id.is_empty()
	if _detail_label.visible:
		var data := playable_object_data(selected_object_id)
		_detail_label.text = "선택: %s | source=SCENE_NODE\n%s\nBody:%s Selection:%s Interaction:%s UsePoint:%s" % [
			String(data.get("display_name", selected_object_id)),
			String(data.get("node_path", "")),
			str(not Array(data.get("collision_polygons", [])).is_empty()),
			str(not Array(data.get("selection_polygons", [])).is_empty()),
			str(not Array(data.get("interaction_polygons", [])).is_empty()),
			str(not Array(data.get("use_points_world", [])).is_empty()),
		]


func _connect_gameplay_feedback() -> void:
	var gameplay := get_node_or_null("Gameplay")
	if gameplay == null or not gameplay.has_signal("interaction_requested"):
		return
	var callback := Callable(self, "_on_gameplay_interaction_requested")
	if not gameplay.is_connected("interaction_requested", callback):
		gameplay.connect("interaction_requested", callback)


func _on_gameplay_interaction_requested(object_key: String, action_key: String, _payload: Dictionary) -> void:
	if not is_instance_valid(_feedback_label):
		return
	_feedback_label.text = "상호작용 확인: %s / %s" % [object_key, action_key]
	_feedback_label.visible = true
	_feedback_remaining = 2.5


func _apply_wall_inspection_mode() -> void:
	for wall_group in _wall_groups():
		if wall_group.has_method("set_inspection_mode"):
			wall_group.call("set_inspection_mode", int(wall_inspection_mode))


func _draw_floor_grid() -> void:
	for cell in _all_floor_cells():
		_draw_closed_polyline(_cell_polygon(cell), COLOR_FLOOR_GRID, 1.2)


func _draw_room_debug() -> void:
	for index in range(_room_nodes().size()):
		var room := _room_nodes()[index]
		var polygon := PackedVector2Array(room.call("world_polygon"))
		if polygon.size() < 3:
			continue
		var fill := COLOR_ROOM_A if index == 0 else COLOR_ROOM_B
		draw_colored_polygon(polygon, fill)
		_draw_closed_polyline(polygon, Color(fill.r, fill.g, fill.b, 0.92), 2.0)
		var label_position := _polygon_bounds(polygon).get_center()
		draw_string(ThemeDB.fallback_font, label_position, String(room.get("korean_name")), HORIZONTAL_ALIGNMENT_CENTER, 160.0, 18, Color(0.96, 0.96, 0.90, 0.94))


func _draw_navigation_debug() -> void:
	var walkable := _walkable_floor_cells()
	for cell in _all_floor_cells():
		var polygon := _cell_polygon(cell)
		if walkable.has(cell):
			_draw_closed_polyline(polygon, Color(0.30, 0.92, 0.62, 0.64), 1.6)
		else:
			draw_colored_polygon(polygon, Color(1.0, 0.20, 0.16, 0.22))
			_draw_closed_polyline(polygon, Color(1.0, 0.28, 0.22, 0.86), 2.0)


func _draw_wall_debug() -> void:
	for wall_group in _wall_groups():
		var cells: Array = wall_group.call("wall_cells")
		for value in cells:
			var cell := value as Node2D
			if cell == null or not bool(cell.get("enabled")):
				continue
			var start := Vector2(cell.call("world_start"))
			var finish := Vector2(cell.call("world_end"))
			var height := maxf(8.0, float(cell.get("wall_height")))
			var opening_kind := int(cell.get("opening_kind"))
			var base_color := COLOR_WALL_BASE
			if opening_kind == ApartmentWallCellScript.OpeningKind.DOOR:
				base_color = COLOR_DOOR
			elif opening_kind == ApartmentWallCellScript.OpeningKind.WINDOW:
				base_color = COLOR_WINDOW
			draw_line(start, finish, base_color, 2.5)
			draw_line(start - Vector2(0.0, height), finish - Vector2(0.0, height), COLOR_WALL_TOP, 2.0)
			draw_dashed_line(start, start - Vector2(0.0, height), base_color, 1.4, 8.0)
			draw_dashed_line(finish, finish - Vector2(0.0, height), base_color, 1.4, 8.0)
		var group_cells: Array = wall_group.call("wall_cells")
		if not group_cells.is_empty():
			var first := group_cells.front() as Node2D
			var last := group_cells.back() as Node2D
			var midpoint := (Vector2(first.call("world_start")) + Vector2(last.call("world_end"))) * 0.5 - Vector2(0.0, 12.0)
			draw_string(ThemeDB.fallback_font, midpoint, String(wall_group.get("korean_name")), HORIZONTAL_ALIGNMENT_CENTER, 180.0, 14, Color(0.92, 0.94, 0.96, 0.92))


func _draw_object_debug() -> void:
	for object_node in _editable_object_nodes():
		var object_id := String(object_node.get("object_id"))
		var data := _object_data_from_node(object_node)
		var is_selected := object_id == selected_object_id
		var is_hovered := object_id == hovered_object_id
		for polygon_value in Array(data.get("selection_polygons", [])):
			var polygon := PackedVector2Array(polygon_value)
			_draw_dashed_polygon(polygon, Color(COLOR_SELECTION, 0.96 if is_selected or is_hovered else 0.46), 2.8 if is_selected else 1.6)
		if not is_selected:
			continue
		for polygon_value in Array(data.get("collision_polygons", [])):
			_draw_closed_polyline(PackedVector2Array(polygon_value), COLOR_COLLISION, 3.0)
		for polygon_value in Array(data.get("interaction_polygons", [])):
			_draw_dashed_polygon(PackedVector2Array(polygon_value), COLOR_INTERACTION, 2.6)
		for polygon_value in Array(data.get("visual_polygons", [])):
			_draw_dashed_polygon(PackedVector2Array(polygon_value), COLOR_VISUAL, 2.0)
		var base := Vector2(data.get("base_point_world", object_node.global_position))
		var top := Vector2(data.get("top_point_world", object_node.global_position))
		draw_line(base, top, COLOR_TOP_POINT, 2.0)
		_draw_cross(base, COLOR_BASE_POINT, 7.0)
		_draw_cross(top, COLOR_TOP_POINT, 7.0)
		for use_point_value in Array(data.get("use_points_world", [])):
			_draw_cross(Vector2(use_point_value), COLOR_USE_POINT, 8.0)
		for socket_value in Array(data.get("attachment_sockets_world", [])):
			_draw_cross(Vector2(socket_value), COLOR_SOCKET, 7.0)


func _draw_closed_polyline(points: PackedVector2Array, color: Color, width: float) -> void:
	if points.size() < 2:
		return
	var closed := points.duplicate()
	closed.append(points[0])
	draw_polyline(closed, color, width, true)


func _draw_dashed_polygon(points: PackedVector2Array, color: Color, width: float) -> void:
	if points.size() < 2:
		return
	for index in range(points.size()):
		draw_dashed_line(points[index], points[(index + 1) % points.size()], color, width, 8.0)


func _draw_cross(point: Vector2, color: Color, half_size: float) -> void:
	draw_line(point - Vector2(half_size, 0.0), point + Vector2(half_size, 0.0), color, 2.2)
	draw_line(point - Vector2(0.0, half_size), point + Vector2(0.0, half_size), color, 2.2)


func _object_id_at_world_point(world_point: Vector2) -> String:
	var candidates: Array[Dictionary] = []
	for object_node in _editable_object_nodes():
		var polygon := PackedVector2Array(object_node.call("selection_world_polygon"))
		if polygon.size() >= 3 and Geometry2D.is_point_in_polygon(world_point, polygon):
			candidates.append({
				"id": String(object_node.get("object_id")),
				"area": absf(_polygon_signed_area(polygon)),
			})
	candidates.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a.area) < float(b.area))
	return "" if candidates.is_empty() else String(candidates[0].id)


func _object_data_from_node(object_node: Node2D) -> Dictionary:
	var object_id := String(object_node.get("object_id"))
	var config := _config_for_object_id(object_id)
	var visual_polygon := PackedVector2Array(object_node.call("visual_world_polygon"))
	var body_polygon := PackedVector2Array(object_node.call("body_world_polygon"))
	var selection_polygon := PackedVector2Array(object_node.call("selection_world_polygon"))
	var interaction_polygon := PackedVector2Array()
	if object_node.has_method("interaction_world_polygon"):
		interaction_polygon = PackedVector2Array(object_node.call("interaction_world_polygon"))
	var collision_polygons: Array[PackedVector2Array] = []
	var selection_polygons: Array[PackedVector2Array] = []
	var interaction_polygons: Array[PackedVector2Array] = []
	var visual_polygons: Array[PackedVector2Array] = []
	var body_active := body_polygon.size() >= 3
	if object_node.has_method("body_collision_active"):
		body_active = bool(object_node.call("body_collision_active"))
	if body_active:
		collision_polygons.append(body_polygon)
	if selection_polygon.size() >= 3:
		selection_polygons.append(selection_polygon)
	if interaction_polygon.size() >= 3:
		interaction_polygons.append(interaction_polygon)
	if visual_polygon.size() >= 3:
		visual_polygons.append(visual_polygon)
	var use_points: Array[Vector2] = []
	if object_node.has_method("use_point_world"):
		use_points.append(Vector2(object_node.call("use_point_world")))
	var sockets: Array[Vector2] = []
	if object_node.has_method("attachment_socket_world_positions"):
		for socket_value in Array(object_node.call("attachment_socket_world_positions")):
			sockets.append(Vector2(socket_value))
	elif object_node.has_method("attachment_socket_world"):
		sockets.append(Vector2(object_node.call("attachment_socket_world")))
	var visual_bounds := _polygon_bounds(visual_polygon)
	var base_point := Vector2(object_node.call("base_point_world"))
	return {
		"id": object_id,
		"display_name": String(config.get("display_name_ko")) if config != null else object_id,
		"category": String(config.get("category")) if config != null else "environment",
		"room_area_id": String(config.get("room_area_id")) if config != null else "",
		"source": "scene_node",
		"geometry_source": "SCENE_NODE",
		"node_backed": true,
		"node_path": String(object_node.get_path()),
		"visual_source": String(object_node.call("visual_source")),
		"visual_center_world": visual_bounds.get_center() if visual_bounds.has_area() else object_node.global_position,
		"visual_size_px": visual_bounds.size,
		"visual_polygons": visual_polygons,
		"collision_polygons": collision_polygons,
		"selection_polygons": selection_polygons,
		"interaction_polygons": interaction_polygons,
		"floor_polygons": collision_polygons,
		"use_points_world": use_points,
		"base_point_world": base_point,
		"top_point_world": Vector2(object_node.call("top_point_world")),
		"attachment_sockets_world": sockets,
		"parent_socket_path": String(object_node.call("mount_parent_socket_path")) if object_node.has_method("mount_parent_socket_path") else "",
		"anchor_cell": _world_to_floor_cell(base_point),
		"blocks_movement": body_active,
	}


func _walkable_floor_cells() -> Dictionary:
	var walkable: Dictionary = {}
	for cell in _all_floor_cells():
		if not _body_blocks_cell(cell):
			walkable[cell] = true
	return walkable


func _body_blocks_cell(cell: Vector2i) -> bool:
	var center := _cell_center(cell)
	for object_node in _editable_object_nodes():
		if object_node.has_method("body_collision_active") and not bool(object_node.call("body_collision_active")):
			continue
		var polygon := PackedVector2Array(object_node.call("body_world_polygon"))
		if polygon.size() >= 3 and Geometry2D.is_point_in_polygon(center, polygon):
			return true
	return false


func _segment_crosses_blocking_wall(from_world: Vector2, to_world: Vector2) -> bool:
	for cell in _wall_cells():
		if not bool(cell.get("enabled")) or not bool(cell.get("collision_enabled")):
			continue
		var opening_kind := int(cell.get("opening_kind"))
		if opening_kind == ApartmentWallCellScript.OpeningKind.DOOR and bool(cell.get("opening_passable")):
			continue
		var intersection: Variant = Geometry2D.segment_intersects_segment(
			from_world,
			to_world,
			Vector2(cell.call("world_start")),
			Vector2(cell.call("world_end"))
		)
		if intersection != null:
			return true
	return false


func _nearest_walkable_cell(world_position: Vector2, walkable: Dictionary) -> Vector2i:
	var direct := _world_to_floor_cell(world_position)
	if walkable.has(direct):
		return direct
	var nearest := Vector2i(-9999, -9999)
	var nearest_distance := INF
	for cell_value in walkable.keys():
		var cell := Vector2i(cell_value)
		var distance := _cell_center(cell).distance_squared_to(world_position)
		if distance < nearest_distance:
			nearest = cell
			nearest_distance = distance
	return nearest


func _world_to_floor_cell(world_position: Vector2) -> Vector2i:
	var layers := _floor_layers()
	if layers.is_empty():
		return Vector2i(-9999, -9999)
	var layer := layers[0]
	return layer.local_to_map(layer.to_local(world_position))


func _cell_center(cell: Vector2i) -> Vector2:
	var layers := _floor_layers()
	return Vector2.ZERO if layers.is_empty() else layers[0].to_global(layers[0].map_to_local(cell))


func _cell_polygon(cell: Vector2i) -> PackedVector2Array:
	var center := _cell_center(cell)
	var layers := _floor_layers()
	var tile_size := Vector2(128.0, 64.0)
	if not layers.is_empty() and layers[0].tile_set != null:
		tile_size = Vector2(layers[0].tile_set.tile_size)
	var half_w := tile_size.x * 0.5
	var half_h := tile_size.y * 0.5
	return PackedVector2Array([
		center + Vector2(0.0, -half_h),
		center + Vector2(half_w, 0.0),
		center + Vector2(0.0, half_h),
		center + Vector2(-half_w, 0.0),
	])


func _all_floor_cells() -> Array[Vector2i]:
	var unique: Dictionary = {}
	for layer in _floor_layers():
		for cell in layer.get_used_cells():
			unique[Vector2i(cell)] = true
	var result: Array[Vector2i] = []
	for cell_value in unique.keys():
		result.append(Vector2i(cell_value))
	result.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: return a.y < b.y or (a.y == b.y and a.x < b.x))
	return result


func _floor_layers() -> Array[TileMapLayer]:
	var result: Array[TileMapLayer] = []
	var root := get_node_or_null(FLOOR_ROOT_PATH)
	if root == null:
		return result
	for child in root.get_children():
		if child is TileMapLayer:
			result.append(child as TileMapLayer)
	return result


func _room_nodes() -> Array[Node2D]:
	var result: Array[Node2D] = []
	var root := get_node_or_null(ROOM_ROOT_PATH)
	if root == null:
		return result
	for child in root.get_children():
		if child is Node2D and child.has_method("world_polygon"):
			result.append(child as Node2D)
	return result


func _wall_groups() -> Array[Node2D]:
	var result: Array[Node2D] = []
	var root := get_node_or_null(WALL_ROOT_PATH)
	if root == null:
		return result
	for child in root.get_children():
		if child is Node2D and child.has_method("wall_cells"):
			result.append(child as Node2D)
	return result


func _wall_cells() -> Array[Node2D]:
	var result: Array[Node2D] = []
	for wall_group in _wall_groups():
		for value in Array(wall_group.call("wall_cells")):
			if value is Node2D:
				result.append(value as Node2D)
	return result


func _opening_nodes() -> Array[Node2D]:
	var result: Array[Node2D] = []
	var root := get_node_or_null(OPENING_ROOT_PATH)
	if root == null:
		return result
	for child in root.get_children():
		if child is Node2D and child.has_method("world_start"):
			result.append(child as Node2D)
	return result


func _editable_object_nodes() -> Array[Node2D]:
	var result: Array[Node2D] = []
	if not is_inside_tree():
		return result
	for group_name in ["apartment_editable_object", "apartment_editable_environment_object"]:
		for candidate in get_tree().get_nodes_in_group(group_name):
			if candidate is Node2D and is_ancestor_of(candidate) and candidate.has_method("selection_world_polygon"):
				result.append(candidate as Node2D)
	return result


func _object_configs() -> Array[Resource]:
	var result: Array[Resource] = []
	if object_footprint_set == null:
		return result
	for value in Array(object_footprint_set.get("objects")):
		if value is Resource:
			result.append(value as Resource)
	return result


func _config_for_object_id(object_id: String) -> Resource:
	for config in _object_configs():
		if String(config.get("id")) == object_id:
			return config
	return null


func _polygon_bounds(points: PackedVector2Array) -> Rect2:
	if points.is_empty():
		return Rect2()
	var bounds := Rect2(points[0], Vector2.ZERO)
	for point in points.slice(1):
		bounds = bounds.expand(point)
	return bounds


func _polygon_signed_area(points: PackedVector2Array) -> float:
	var result := 0.0
	for index in range(points.size()):
		var current := points[index]
		var next := points[(index + 1) % points.size()]
		result += current.x * next.y - next.x * current.y
	return result * 0.5


func _on_off(value: bool) -> String:
	return "ON" if value else "OFF"


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	for path in [FLOOR_ROOT_PATH, ROOM_ROOT_PATH, WALL_ROOT_PATH, OPENING_ROOT_PATH, OBJECT_ROOT_PATH]:
		if get_node_or_null(path) == null:
			warnings.append("Required sample hierarchy is missing: %s" % path)
	if object_footprint_set == null:
		warnings.append("The sample object footprint set is required for logical metadata.")
	return warnings
