@tool
extends Node2D

const ROOM_GUIDES_PATH := NodePath("RoomGuides/RoomOutlineGuides")
const WALL_GUIDES_PATH := NodePath("WallGuides")
const OBJECT_GUIDES_PATH := NodePath("ObjectGuides")
const HEIGHT_GUIDES_PATH := NodePath("HeightAndSocketGuides")
const EDITOR_SYNC_INTERVAL := 0.15
const GUIDE_MODE_CLEAN := 0
const GUIDE_MODE_STRUCTURE := 1
const GUIDE_MODE_OBJECT := 2
const GUIDE_MODE_ALL := 3
const COLOR_GUIDE_WALL := Color(0.86, 0.88, 0.90, 0.34)
const COLOR_GUIDE_WALL_TOP := Color(1.0, 0.92, 0.58, 0.52)
const COLOR_GUIDE_DOOR := Color(0.28, 1.0, 0.54, 0.72)
const COLOR_GUIDE_WINDOW := Color(0.30, 0.70, 1.0, 0.72)
const COLOR_GUIDE_BODY := Color(1.0, 0.28, 0.22, 0.78)
const COLOR_GUIDE_SELECTION := Color(0.18, 0.92, 0.92, 0.82)
const COLOR_GUIDE_INTERACTION := Color(1.0, 0.52, 0.12, 0.84)
const COLOR_GUIDE_SOCKET := Color(0.94, 0.36, 1.0, 0.92)

var _sync_elapsed := 0.0
var _last_guide_signature := ""


func _ready() -> void:
	visible = Engine.is_editor_hint()
	set_process(Engine.is_editor_hint())
	if Engine.is_editor_hint():
		_sync_editor_guides(true)


func _process(delta: float) -> void:
	visible = Engine.is_editor_hint()
	if not Engine.is_editor_hint():
		return
	_sync_elapsed += delta
	if _sync_elapsed < EDITOR_SYNC_INTERVAL:
		return
	_sync_elapsed = 0.0
	_sync_editor_guides(false)


func _sync_editor_guides(force: bool) -> void:
	var scene_root := get_parent() as Node2D
	if scene_root == null:
		return
	var selected_nodes: Array[Node] = _editor_selected_nodes()
	var guide_mode := int(scene_root.get("editor_guide_mode"))
	var focus_object_id := String(scene_root.get("editor_focus_object_id"))
	var signature := _guide_signature(scene_root, selected_nodes, guide_mode, focus_object_id)
	if not force and signature == _last_guide_signature:
		return
	_last_guide_signature = signature
	_apply_guide_visibility(scene_root, guide_mode)
	_rebuild_room_guides(scene_root)
	_rebuild_wall_guides(scene_root, selected_nodes, guide_mode)
	_rebuild_object_guides(scene_root, selected_nodes, guide_mode, focus_object_id)
	_rebuild_height_and_socket_guides(scene_root, selected_nodes, guide_mode, focus_object_id)


func guide_visibility_for_mode(guide_mode: int) -> Dictionary:
	match guide_mode:
		GUIDE_MODE_STRUCTURE:
			return {"room": true, "wall": true, "object": true, "object_geometry": false, "height_socket": false}
		GUIDE_MODE_OBJECT:
			return {"room": false, "wall": false, "object": true, "object_geometry": true, "height_socket": true}
		GUIDE_MODE_ALL:
			return {"room": true, "wall": true, "object": true, "object_geometry": true, "height_socket": true}
		_:
			return {"room": false, "wall": false, "object": true, "object_geometry": false, "height_socket": false}


func _apply_guide_visibility(scene_root: Node2D, guide_mode: int) -> void:
	var policy := guide_visibility_for_mode(guide_mode)
	var room_guides := get_node_or_null("RoomGuides") as CanvasItem
	var wall_guides := get_node_or_null(WALL_GUIDES_PATH) as CanvasItem
	var object_guides := get_node_or_null(OBJECT_GUIDES_PATH) as CanvasItem
	var height_guides := get_node_or_null(HEIGHT_GUIDES_PATH) as CanvasItem
	if room_guides != null:
		room_guides.visible = bool(policy.get("room", false))
	if wall_guides != null:
		wall_guides.visible = bool(policy.get("wall", false))
	if object_guides != null:
		object_guides.visible = bool(policy.get("object", true))
	if height_guides != null:
		height_guides.visible = bool(policy.get("height_socket", false))
	var structure_visible := bool(policy.get("room", false)) and bool(policy.get("wall", false))
	var room_areas := scene_root.get_node_or_null("RoomAreas")
	if room_areas != null:
		for room_node in room_areas.get_children():
			var room_preview := room_node.get_node_or_null("EditorPreview") as CanvasItem
			if room_preview != null:
				room_preview.visible = structure_visible
	var openings := scene_root.get_node_or_null("Openings")
	if openings != null:
		for opening_node in openings.get_children():
			var opening_preview := opening_node.get_node_or_null("EditorPreview") as CanvasItem
			if opening_preview != null:
				opening_preview.visible = structure_visible
	var walls := scene_root.get_node_or_null("Walls")
	if walls != null:
		for wall_group in walls.get_children():
			if not wall_group.has_method("wall_cells"):
				continue
			for cell_value in Array(wall_group.call("wall_cells")):
				var cell := cell_value as Node
				if cell != null and cell.has_method("set_editor_structure_guides_visible"):
					cell.call("set_editor_structure_guides_visible", structure_visible)


func _rebuild_room_guides(scene_root: Node2D) -> void:
	var guides := get_node_or_null(ROOM_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	var room_areas := scene_root.get_node_or_null("RoomAreas")
	if room_areas == null:
		return
	for room_node in room_areas.get_children():
		if not room_node.has_method("world_polygon"):
			continue
		var polygon_value: Variant = room_node.call("world_polygon")
		var points := PackedVector2Array(polygon_value)
		_add_world_outline(guides, "Room_%s" % room_node.name, points, Color(0.86, 0.94, 1.0, 0.46), 1.4)


func _rebuild_wall_guides(scene_root: Node2D, selected_nodes: Array[Node], guide_mode := GUIDE_MODE_STRUCTURE) -> void:
	var guides := get_node_or_null(WALL_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	if guide_mode != GUIDE_MODE_STRUCTURE and guide_mode != GUIDE_MODE_ALL:
		return
	var walls := scene_root.get_node_or_null("Walls")
	if walls == null:
		return
	for wall_group in walls.get_children():
		if not wall_group.has_method("wall_cells"):
			continue
		var cells_value: Variant = wall_group.call("wall_cells")
		var cells: Array = cells_value
		for cell_value in cells:
			var cell := cell_value as Node2D
			if cell == null or not cell.has_method("world_start") or not cell.has_method("world_end"):
				continue
			var from_world := Vector2(cell.call("world_start"))
			var to_world := Vector2(cell.call("world_end"))
			var height := maxf(8.0, float(cell.get("wall_height")))
			var opening_kind := int(cell.get("opening_kind"))
			var base_color := COLOR_GUIDE_WALL
			var top_color := COLOR_GUIDE_WALL_TOP
			if opening_kind == 1:
				base_color = COLOR_GUIDE_DOOR
				top_color = COLOR_GUIDE_DOOR
			elif opening_kind == 2:
				base_color = COLOR_GUIDE_WINDOW
				top_color = COLOR_GUIDE_WINDOW
			var selected := _selection_touches_branch(cell, selected_nodes)
			if selected:
				base_color = Color(1.0, 1.0, 1.0, 0.92)
				top_color = base_color
			var prefix := "%s_%s" % [wall_group.name, cell.name]
			_add_world_line(guides, "%sBase" % prefix, PackedVector2Array([from_world, to_world]), base_color, 2.6 if selected else 1.2)
			_add_world_line(guides, "%sTop" % prefix, PackedVector2Array([from_world - Vector2(0.0, height), to_world - Vector2(0.0, height)]), top_color, 2.6 if selected else 1.2)
			_add_world_line(guides, "%sEnds" % prefix, PackedVector2Array([from_world - Vector2(0.0, height), from_world, to_world, to_world - Vector2(0.0, height)]), base_color, 1.0)
			var socket := cell.get_node_or_null("AttachmentSocket") as Marker2D
			if socket != null:
				_add_world_cross(guides, "%sSocket" % prefix, socket.global_position, COLOR_GUIDE_SOCKET, 5.0)


func _rebuild_object_guides(scene_root: Node2D, selected_nodes: Array[Node], guide_mode := GUIDE_MODE_CLEAN, focus_object_id := "") -> void:
	var guides := get_node_or_null(OBJECT_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	var selected_object := _selected_editable_object(scene_root, selected_nodes)
	var policy := guide_visibility_for_mode(guide_mode)
	for object_node in _editable_object_roots(scene_root):
		if guide_mode == GUIDE_MODE_OBJECT and not focus_object_id.is_empty() and String(object_node.get("object_id")) != focus_object_id:
			continue
		if not object_node.has_method("visual_world_polygon"):
			continue
		var polygon_value: Variant = object_node.call("visual_world_polygon")
		var points := PackedVector2Array(polygon_value)
		var selected := object_node == selected_object
		var color := Color(0.95, 0.98, 1.0, 0.78 if selected else 0.34)
		_add_world_outline(guides, "Object_%s" % object_node.name, points, color, 2.4 if selected else 1.3)
		if not bool(policy.get("object_geometry", false)):
			continue
		var draw_geometry := guide_mode == GUIDE_MODE_ALL
		if guide_mode == GUIDE_MODE_OBJECT:
			draw_geometry = (
				(not focus_object_id.is_empty() and String(object_node.get("object_id")) == focus_object_id)
				or (focus_object_id.is_empty() and object_node == selected_object)
			)
		if not draw_geometry:
			continue
		_add_object_geometry_guide(guides, object_node, "body_world_polygon", "Body_%s" % object_node.name, COLOR_GUIDE_BODY, false)
		_add_object_geometry_guide(guides, object_node, "selection_world_polygon", "Selection_%s" % object_node.name, COLOR_GUIDE_SELECTION, true)
		_add_object_geometry_guide(guides, object_node, "interaction_world_polygon", "Interaction_%s" % object_node.name, COLOR_GUIDE_INTERACTION, true)


func _add_object_geometry_guide(guides: Node2D, object_node: Node2D, method_name: String, guide_name: String, color: Color, dashed: bool) -> void:
	if not object_node.has_method(method_name):
		return
	var polygon := PackedVector2Array(object_node.call(method_name))
	if polygon.size() < 3:
		return
	polygon.append(polygon[0])
	if dashed:
		_add_world_dashed_line(guides, guide_name, polygon, color, 1.8, 8.0)
	else:
		_add_world_line(guides, guide_name, polygon, color, 1.8)


func _rebuild_height_and_socket_guides(scene_root: Node2D, selected_nodes: Array[Node], guide_mode := GUIDE_MODE_OBJECT, focus_object_id := "") -> void:
	var guides := get_node_or_null(HEIGHT_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	if guide_mode != GUIDE_MODE_OBJECT and guide_mode != GUIDE_MODE_ALL:
		return
	if guide_mode == GUIDE_MODE_ALL:
		for object_node in _editable_object_roots(scene_root):
			_add_height_and_socket_guides_for_object(guides, object_node, String(object_node.name))
		return
	var selected_object := _selected_editable_object(scene_root, selected_nodes)
	if not focus_object_id.is_empty():
		selected_object = _editable_object_by_id(scene_root, focus_object_id)
	if selected_object == null:
		return
	_add_height_and_socket_guides_for_object(guides, selected_object, "Selected")


func _add_height_and_socket_guides_for_object(guides: Node2D, selected_object: Node2D, prefix: String) -> void:
	if selected_object.has_method("base_point_world") and selected_object.has_method("top_point_world"):
		var base := Vector2(selected_object.call("base_point_world"))
		var top := Vector2(selected_object.call("top_point_world"))
		_add_world_line(guides, "%sHeight" % prefix, PackedVector2Array([base, top]), Color(1.0, 0.88, 0.24, 0.9), 2.0)
		_add_world_cross(guides, "%sBase" % prefix, base, Color(0.58, 1.0, 0.52, 0.96), 7.0)
		_add_world_cross(guides, "%sTop" % prefix, top, Color(1.0, 0.88, 0.24, 0.96), 7.0)
	var socket_positions: Array[Vector2] = []
	if selected_object.has_method("attachment_socket_world_positions"):
		var sockets_value: Variant = selected_object.call("attachment_socket_world_positions")
		for socket_value in Array(sockets_value):
			socket_positions.append(Vector2(socket_value))
	elif selected_object.has_method("attachment_socket_world"):
		socket_positions.append(Vector2(selected_object.call("attachment_socket_world")))
	for socket_index in range(socket_positions.size()):
		_add_world_cross(guides, "%sSocket%d" % [prefix, socket_index], socket_positions[socket_index], Color(0.94, 0.36, 1.0, 0.96), 7.0)


func _guide_signature(scene_root: Node2D, selected_nodes: Array[Node], guide_mode := GUIDE_MODE_CLEAN, focus_object_id := "") -> String:
	var parts: Array[String] = []
	parts.append("mode:%d" % guide_mode)
	parts.append("focus:%s" % focus_object_id)
	for selected_node in selected_nodes:
		parts.append("selected:%s" % selected_node.get_path())
	for object_node in _editable_object_roots(scene_root):
		var visual_value: Variant = object_node.call("visual_world_polygon") if object_node.has_method("visual_world_polygon") else PackedVector2Array()
		parts.append("object:%s:%s:%s" % [object_node.get_path(), object_node.global_transform, visual_value])
		for geometry_method in ["body_world_polygon", "selection_world_polygon", "interaction_world_polygon"]:
			if object_node.has_method(geometry_method):
				parts.append("%s:%s:%s" % [geometry_method, object_node.get_path(), object_node.call(geometry_method)])
		if object_node.has_method("base_point_world"):
			parts.append("base:%s:%s" % [object_node.get_path(), object_node.call("base_point_world")])
		if object_node.has_method("top_point_world"):
			parts.append("top:%s:%s" % [object_node.get_path(), object_node.call("top_point_world")])
		if object_node.has_method("attachment_socket_world_positions"):
			parts.append("sockets:%s:%s" % [object_node.get_path(), object_node.call("attachment_socket_world_positions")])
		elif object_node.has_method("attachment_socket_world"):
			parts.append("socket:%s:%s" % [object_node.get_path(), object_node.call("attachment_socket_world")])
	var walls := scene_root.get_node_or_null("Walls")
	if walls != null:
		for wall_group in walls.get_children():
			if not wall_group.has_method("wall_cells"):
				continue
			var cells_value: Variant = wall_group.call("wall_cells")
			for cell_value in Array(cells_value):
				var cell := cell_value as Node2D
				if cell != null:
					parts.append("wall:%s:%s:%s:%s" % [cell.get_path(), cell.global_transform, cell.get("end_offset"), cell.get("wall_height")])
	return "|".join(parts)


func _editable_object_by_id(scene_root: Node, object_id: String) -> Node2D:
	for object_node in _editable_object_roots(scene_root):
		if String(object_node.get("object_id")) == object_id:
			return object_node
	return null


func _editable_object_roots(scene_root: Node) -> Array[Node2D]:
	var result: Array[Node2D] = []
	for group_name in ["apartment_editable_object", "apartment_editable_environment_object"]:
		for candidate in get_tree().get_nodes_in_group(group_name):
			if candidate is Node2D and scene_root.is_ancestor_of(candidate):
				result.append(candidate as Node2D)
	return result


func _selected_editable_object(scene_root: Node, selected_nodes: Array[Node]) -> Node2D:
	for selected_node in selected_nodes:
		var cursor: Node = selected_node
		while cursor != null and cursor != scene_root:
			if cursor is Node2D and _is_editable_object_root(cursor):
				return cursor as Node2D
			cursor = cursor.get_parent()
	return null


func _is_editable_object_root(node: Node) -> bool:
	return node.is_in_group("apartment_editable_object") or node.is_in_group("apartment_editable_environment_object")


func _editor_selected_nodes() -> Array[Node]:
	var result: Array[Node] = []
	var selection := EditorInterface.get_selection()
	if selection == null:
		return result
	for selected_node in selection.get_selected_nodes():
		if selected_node is Node:
			result.append(selected_node as Node)
	return result


func _selection_touches_branch(branch: Node, selected_nodes: Array[Node]) -> bool:
	for selected_node in selected_nodes:
		if selected_node == branch or branch.is_ancestor_of(selected_node):
			return true
	return false


func _add_world_outline(parent: Node2D, line_name: String, world_points: PackedVector2Array, color: Color, width: float) -> void:
	if world_points.size() < 3:
		return
	var closed_points := world_points.duplicate()
	closed_points.append(world_points[0])
	_add_world_line(parent, line_name, closed_points, color, width)


func _add_world_line(parent: Node2D, line_name: String, world_points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.name = line_name
	line.width = width
	line.default_color = color
	line.antialiased = true
	for world_point in world_points:
		line.add_point(parent.to_local(world_point))
	parent.add_child(line)


func _add_world_dashed_line(parent: Node2D, line_name: String, world_points: PackedVector2Array, color: Color, width: float, dash_length: float) -> void:
	var dash_index := 0
	for point_index in range(world_points.size() - 1):
		var from_world := world_points[point_index]
		var to_world := world_points[point_index + 1]
		var segment := to_world - from_world
		var segment_length := segment.length()
		if segment_length < 0.001:
			continue
		var direction := segment / segment_length
		var cursor := 0.0
		var draw_dash := true
		while cursor < segment_length:
			var next_cursor := minf(cursor + dash_length, segment_length)
			if draw_dash:
				_add_world_line(
					parent,
					"%sDash%03d" % [line_name, dash_index],
					PackedVector2Array([from_world + direction * cursor, from_world + direction * next_cursor]),
					color,
					width
				)
				dash_index += 1
			draw_dash = not draw_dash
			cursor = next_cursor


func _add_world_cross(parent: Node2D, marker_name: String, world_position: Vector2, color: Color, radius: float) -> void:
	_add_world_line(parent, "%sHorizontal" % marker_name, PackedVector2Array([world_position - Vector2(radius, 0.0), world_position + Vector2(radius, 0.0)]), color, 2.0)
	_add_world_line(parent, "%sVertical" % marker_name, PackedVector2Array([world_position - Vector2(0.0, radius), world_position + Vector2(0.0, radius)]), color, 2.0)


func _clear_generated_guides(parent: Node) -> void:
	for child in parent.get_children():
		child.free()
