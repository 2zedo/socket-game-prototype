@tool
extends Node2D

const ROOM_GUIDES_PATH := NodePath("RoomGuides/RoomOutlineGuides")
const WALL_GUIDES_PATH := NodePath("WallGuides")
const OBJECT_GUIDES_PATH := NodePath("ObjectGuides")
const HEIGHT_GUIDES_PATH := NodePath("HeightAndSocketGuides")
const EDITOR_SYNC_INTERVAL := 0.15

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
	var signature := _guide_signature(scene_root, selected_nodes)
	if not force and signature == _last_guide_signature:
		return
	_last_guide_signature = signature
	_rebuild_room_guides(scene_root)
	_rebuild_wall_guides(scene_root, selected_nodes)
	_rebuild_object_guides(scene_root, selected_nodes)
	_rebuild_height_and_socket_guides(scene_root, selected_nodes)


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


func _rebuild_wall_guides(scene_root: Node2D, selected_nodes: Array[Node]) -> void:
	var guides := get_node_or_null(WALL_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
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
			var outline := PackedVector2Array([
				from_world,
				to_world,
				to_world - Vector2(0.0, height),
				from_world - Vector2(0.0, height),
			])
			var opening_kind := int(cell.get("opening_kind"))
			var color := Color(0.86, 0.88, 0.9, 0.34)
			if opening_kind == 1:
				color = Color(0.32, 1.0, 0.58, 0.62)
			elif opening_kind == 2:
				color = Color(0.34, 0.74, 1.0, 0.62)
			var selected := _selection_touches_branch(cell, selected_nodes)
			if selected:
				color = Color(1.0, 1.0, 1.0, 0.92)
			_add_world_outline(guides, "%s_%s" % [wall_group.name, cell.name], outline, color, 2.6 if selected else 1.2)


func _rebuild_object_guides(scene_root: Node2D, selected_nodes: Array[Node]) -> void:
	var guides := get_node_or_null(OBJECT_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	var selected_object := _selected_editable_object(scene_root, selected_nodes)
	for object_node in _editable_object_roots(scene_root):
		if not object_node.has_method("visual_world_polygon"):
			continue
		var polygon_value: Variant = object_node.call("visual_world_polygon")
		var points := PackedVector2Array(polygon_value)
		var selected := object_node == selected_object
		var color := Color(0.95, 0.98, 1.0, 0.78 if selected else 0.34)
		_add_world_outline(guides, "Object_%s" % object_node.name, points, color, 2.4 if selected else 1.3)


func _rebuild_height_and_socket_guides(scene_root: Node2D, selected_nodes: Array[Node]) -> void:
	var guides := get_node_or_null(HEIGHT_GUIDES_PATH) as Node2D
	if guides == null:
		return
	_clear_generated_guides(guides)
	var selected_object := _selected_editable_object(scene_root, selected_nodes)
	if selected_object == null:
		return
	if selected_object.has_method("base_point_world") and selected_object.has_method("top_point_world"):
		var base := Vector2(selected_object.call("base_point_world"))
		var top := Vector2(selected_object.call("top_point_world"))
		_add_world_line(guides, "SelectedHeight", PackedVector2Array([base, top]), Color(1.0, 0.88, 0.24, 0.9), 2.0)
		_add_world_cross(guides, "SelectedBase", base, Color(0.58, 1.0, 0.52, 0.96), 7.0)
		_add_world_cross(guides, "SelectedTop", top, Color(1.0, 0.88, 0.24, 0.96), 7.0)
	var socket_positions: Array[Vector2] = []
	if selected_object.has_method("attachment_socket_world_positions"):
		var sockets_value: Variant = selected_object.call("attachment_socket_world_positions")
		for socket_value in Array(sockets_value):
			socket_positions.append(Vector2(socket_value))
	elif selected_object.has_method("attachment_socket_world"):
		socket_positions.append(Vector2(selected_object.call("attachment_socket_world")))
	for socket_index in range(socket_positions.size()):
		_add_world_cross(guides, "SelectedSocket%d" % socket_index, socket_positions[socket_index], Color(0.94, 0.36, 1.0, 0.96), 7.0)


func _guide_signature(scene_root: Node2D, selected_nodes: Array[Node]) -> String:
	var parts: Array[String] = []
	for selected_node in selected_nodes:
		parts.append("selected:%s" % selected_node.get_path())
	for object_node in _editable_object_roots(scene_root):
		var visual_value: Variant = object_node.call("visual_world_polygon") if object_node.has_method("visual_world_polygon") else PackedVector2Array()
		parts.append("object:%s:%s:%s" % [object_node.get_path(), object_node.global_transform, visual_value])
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


func _add_world_cross(parent: Node2D, marker_name: String, world_position: Vector2, color: Color, radius: float) -> void:
	_add_world_line(parent, "%sHorizontal" % marker_name, PackedVector2Array([world_position - Vector2(radius, 0.0), world_position + Vector2(radius, 0.0)]), color, 2.0)
	_add_world_line(parent, "%sVertical" % marker_name, PackedVector2Array([world_position - Vector2(0.0, radius), world_position + Vector2(0.0, radius)]), color, 2.0)


func _clear_generated_guides(parent: Node) -> void:
	for child in parent.get_children():
		child.free()
