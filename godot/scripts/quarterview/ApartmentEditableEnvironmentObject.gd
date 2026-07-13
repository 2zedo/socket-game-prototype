@tool
extends Node2D
class_name ApartmentEditableEnvironmentObject

const VISUAL_PATH := NodePath("Visual")
const SPRITE_PATH := NodePath("Visual/Sprite2D")
const VISUAL_PREVIEW_PATH := NodePath("Visual/VisualPreview")
const BASE_POINT_PATH := NodePath("BasePoint")
const TOP_POINT_PATH := NodePath("TopPoint")
const BODY_PATH := NodePath("Body")
const BODY_POLYGON_PATH := NodePath("Body/BodyPolygon")
const SELECTION_AREA_PATH := NodePath("SelectionArea")
const SELECTION_POLYGON_PATH := NodePath("SelectionArea/SelectionPolygon")
const ATTACHMENT_SOCKETS_PATH := NodePath("AttachmentSockets")

@export var object_id: StringName = &""


func _ready() -> void:
	_sync_sort_from_base_point()
	if not Engine.is_editor_hint():
		var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
		if preview != null:
			preview.visible = false
	else:
		set_process(true)
		_sync_editor_visual_preview()
		_sync_editor_selection_guides()
		update_configuration_warnings()


func _process(_delta: float) -> void:
	_sync_sort_from_base_point()
	if Engine.is_editor_hint():
		_sync_editor_visual_preview()
		_sync_editor_selection_guides()


func visual_world_polygon() -> PackedVector2Array:
	var sprite := get_node_or_null(SPRITE_PATH) as Sprite2D
	if sprite != null and sprite.texture != null:
		return _rect_to_world(sprite, sprite.get_rect())
	var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
	if preview != null and preview.polygon.size() >= 3:
		return _points_to_world(preview, preview.polygon)
	return PackedVector2Array()


func visual_bounds_world() -> Rect2:
	return _polygon_bounds(visual_world_polygon())


func visual_center_world() -> Vector2:
	var bounds := visual_bounds_world()
	var visual := get_node_or_null(VISUAL_PATH) as Node2D
	return bounds.get_center() if bounds.has_area() else (visual.global_position if visual != null else global_position)


func visual_source() -> StringName:
	var sprite := get_node_or_null(SPRITE_PATH) as Sprite2D
	return &"SPRITE2D" if sprite != null and sprite.texture != null else &"VISUAL_PREVIEW"


func attachment_anchor_world() -> Vector2:
	var parent_socket := _mount_parent_socket()
	return parent_socket.global_position if parent_socket != null else base_point_world()


func mount_parent_socket_path() -> String:
	var parent_socket := _mount_parent_socket()
	return String(parent_socket.get_path()) if parent_socket != null else ""


func mount_parent_socket_world() -> Vector2:
	var parent_socket := _mount_parent_socket()
	return parent_socket.global_position if parent_socket != null else base_point_world()


func base_point_world() -> Vector2:
	var base_point := get_node_or_null(BASE_POINT_PATH) as Marker2D
	return base_point.global_position if base_point != null else global_position


func top_point_world() -> Vector2:
	var top_point := get_node_or_null(TOP_POINT_PATH) as Marker2D
	return top_point.global_position if top_point != null else global_position


func body_world_polygon() -> PackedVector2Array:
	return _collision_polygon_world(BODY_POLYGON_PATH)


func body_collision_active() -> bool:
	var body_polygon := get_node_or_null(BODY_POLYGON_PATH) as CollisionPolygon2D
	return body_polygon != null and not body_polygon.disabled and body_polygon.polygon.size() >= 3


func selection_world_polygon() -> PackedVector2Array:
	return _collision_polygon_world(SELECTION_POLYGON_PATH)


func placement_footprint_world_polygon() -> PackedVector2Array:
	return PackedVector2Array()


func floor_occupancy_world_polygon() -> PackedVector2Array:
	return body_world_polygon()


func attachment_socket_world_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var sockets := get_node_or_null(ATTACHMENT_SOCKETS_PATH) as Node2D
	if sockets == null:
		return positions
	for child in sockets.get_children():
		if child is Marker2D:
			positions.append((child as Marker2D).global_position)
	return positions


func attachment_socket_world() -> Vector2:
	var positions := attachment_socket_world_positions()
	return positions[0] if not positions.is_empty() else base_point_world()


func geometry_warnings() -> Array[String]:
	var warnings: Array[String] = []
	if String(object_id).is_empty():
		warnings.append("object_id is empty")
	_require_node_type(warnings, VISUAL_PATH, Node2D)
	_require_node_type(warnings, SPRITE_PATH, Sprite2D)
	_require_node_type(warnings, VISUAL_PREVIEW_PATH, Polygon2D)
	_require_node_type(warnings, BASE_POINT_PATH, Marker2D)
	_require_node_type(warnings, TOP_POINT_PATH, Marker2D)
	_require_node_type(warnings, BODY_PATH, StaticBody2D)
	_require_node_type(warnings, SELECTION_AREA_PATH, Area2D)
	_require_node_type(warnings, SELECTION_POLYGON_PATH, CollisionPolygon2D)
	_require_node_type(warnings, ATTACHMENT_SOCKETS_PATH, Node2D)

	for forbidden_path in [NodePath("InteractionArea"), NodePath("InteractionPolygon"), NodePath("UsePoint")]:
		if get_node_or_null(forbidden_path) != null:
			warnings.append("environment object must not contain %s" % forbidden_path)

	var config := _logical_resource_config()
	if config != null and int(config.get("anchor_type")) != 0 and _mount_parent_socket() == null:
		warnings.append("attached environment object requires a Marker2D parent socket")
	var body_required := config != null and bool(config.get("blocks_movement"))
	var body_polygon := get_node_or_null(BODY_POLYGON_PATH) as CollisionPolygon2D
	var selection_polygon := get_node_or_null(SELECTION_POLYGON_PATH) as CollisionPolygon2D
	if body_required and (body_polygon == null or body_polygon.disabled):
		warnings.append("blocks_movement requires Body/BodyPolygon")
	if body_polygon != null:
		_append_polygon_warning(warnings, "Body/BodyPolygon", body_polygon.polygon, body_polygon.scale)
	if selection_polygon == null or selection_polygon.disabled:
		warnings.append("SelectionArea/SelectionPolygon is required")
	else:
		_append_polygon_warning(warnings, "SelectionArea/SelectionPolygon", selection_polygon.polygon, selection_polygon.scale)

	var base_point := get_node_or_null(BASE_POINT_PATH) as Marker2D
	var top_point := get_node_or_null(TOP_POINT_PATH) as Marker2D
	if base_point != null and top_point != null and base_point.position.is_equal_approx(top_point.position):
		warnings.append("BasePoint and TopPoint must identify different height positions")
	var sprite := get_node_or_null(SPRITE_PATH) as Sprite2D
	var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
	if (sprite == null or sprite.texture == null) and (preview == null or preview.polygon.size() < 3):
		warnings.append("VisualPreview requires at least 3 points while Sprite2D has no texture")
	if preview != null:
		_append_polygon_warning(warnings, "Visual/VisualPreview", preview.polygon, preview.scale)

	var body := get_node_or_null(BODY_PATH)
	if body != null:
		for child in body.get_children():
			if child is CollisionShape2D:
				warnings.append("Body must not contain CollisionShape2D")
			elif child is CollisionPolygon2D and child.name != "BodyPolygon":
				warnings.append("Body collision polygon must be named BodyPolygon")
	var selection_area := get_node_or_null(SELECTION_AREA_PATH) as Area2D
	if selection_area != null:
		if selection_area.collision_layer != 0 or selection_area.collision_mask != 0 or selection_area.monitoring or selection_area.monitorable:
			warnings.append("SelectionArea must remain debug-only with physics and monitoring disabled")
		for child in selection_area.get_children():
			if child is CollisionShape2D:
				warnings.append("SelectionArea must not contain CollisionShape2D")
			elif child is CollisionPolygon2D and child.name != "SelectionPolygon":
				warnings.append("selection collision polygon must be named SelectionPolygon")
	if config != null and _resource_geometry_active(config):
		warnings.append("deprecated Resource geometry must remain disabled; Scene Node is authoritative")
	return warnings


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(geometry_warnings())


func _sync_sort_from_base_point() -> void:
	var base_point := get_node_or_null(BASE_POINT_PATH) as Marker2D
	if base_point == null:
		return
	z_as_relative = false
	z_index = int(round(base_point.global_position.y))


func _sync_editor_visual_preview() -> void:
	var sprite := get_node_or_null(SPRITE_PATH) as Sprite2D
	var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
	if preview != null:
		preview.visible = sprite == null or sprite.texture == null


func _sync_editor_selection_guides() -> void:
	var selected_nodes: Array[Node] = _editor_selected_nodes()
	var object_selected := _selection_targets_this_editable_root(selected_nodes)
	var body_selected := _selection_touches_branch(get_node_or_null(BODY_PATH), selected_nodes)
	var selection_selected := _selection_touches_branch(get_node_or_null(SELECTION_AREA_PATH), selected_nodes)
	_set_canvas_item_visible(get_node_or_null(BODY_PATH), body_selected)
	_set_canvas_item_visible(get_node_or_null(BODY_POLYGON_PATH), body_selected)
	_set_canvas_item_visible(get_node_or_null(SELECTION_AREA_PATH), selection_selected)
	_set_canvas_item_visible(get_node_or_null(SELECTION_POLYGON_PATH), selection_selected)
	_set_editor_marker_visible(get_node_or_null(BASE_POINT_PATH), object_selected)
	_set_editor_marker_visible(get_node_or_null(TOP_POINT_PATH), object_selected)
	var sockets := get_node_or_null(ATTACHMENT_SOCKETS_PATH) as Node2D
	if sockets != null:
		for child in sockets.get_children():
			_set_marker_gizmo(child, object_selected)


func _editor_selected_nodes() -> Array[Node]:
	var result: Array[Node] = []
	if not Engine.is_editor_hint():
		return result
	var selection := EditorInterface.get_selection()
	if selection == null:
		return result
	for selected_node in selection.get_selected_nodes():
		if selected_node is Node:
			result.append(selected_node as Node)
	return result


func _selection_touches_branch(branch: Node, selected_nodes: Array[Node]) -> bool:
	if branch == null:
		return false
	for selected_node in selected_nodes:
		if selected_node == branch or branch.is_ancestor_of(selected_node):
			return true
	return false


func _selection_targets_this_editable_root(selected_nodes: Array[Node]) -> bool:
	for selected_node in selected_nodes:
		var cursor: Node = selected_node
		while cursor != null:
			if cursor.is_in_group("apartment_editable_object") or cursor.is_in_group("apartment_editable_environment_object"):
				if cursor == self:
					return true
				break
			cursor = cursor.get_parent()
	return false


func _set_canvas_item_visible(node: Node, value: bool) -> void:
	if node is CanvasItem:
		(node as CanvasItem).visible = value


func _set_marker_gizmo(node: Node, value: bool) -> void:
	if node is Marker2D:
		(node as Marker2D).gizmo_extents = 10.0 if value else 0.0


func _set_editor_marker_visible(node: Node, value: bool) -> void:
	if node is Marker2D:
		(node as Marker2D).visible = value
		(node as Marker2D).gizmo_extents = 10.0 if value else 0.0


func _collision_polygon_world(path: NodePath) -> PackedVector2Array:
	var polygon_node := get_node_or_null(path) as CollisionPolygon2D
	if polygon_node == null or polygon_node.disabled or polygon_node.polygon.size() < 3:
		return PackedVector2Array()
	return _points_to_world(polygon_node, polygon_node.polygon)


func _rect_to_world(owner_node: Node2D, rect: Rect2) -> PackedVector2Array:
	return _points_to_world(owner_node, PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	]))


func _points_to_world(owner_node: Node2D, local_points: PackedVector2Array) -> PackedVector2Array:
	var world_points := PackedVector2Array()
	for point in local_points:
		world_points.append(owner_node.to_global(point))
	return world_points


func _polygon_bounds(points: PackedVector2Array) -> Rect2:
	if points.is_empty():
		return Rect2()
	var bounds := Rect2(points[0], Vector2.ZERO)
	for point in points.slice(1):
		bounds = bounds.expand(point)
	return bounds


func _require_node_type(warnings: Array[String], path: NodePath, expected_type: Variant) -> void:
	var node := get_node_or_null(path)
	if node == null:
		warnings.append("required NodePath is missing: %s" % path)
	elif not is_instance_of(node, expected_type):
		warnings.append("required NodePath has wrong type: %s" % path)


func _append_polygon_warning(warnings: Array[String], label: String, points: PackedVector2Array, polygon_scale: Vector2) -> void:
	if points.size() < 3:
		warnings.append("%s requires at least 3 points" % label)
	if polygon_scale != Vector2.ONE:
		warnings.append("%s scale must remain (1, 1); edit vertices instead" % label)


func _logical_resource_config() -> Resource:
	var cursor: Node = self
	while cursor != null:
		if _node_has_property(cursor, &"object_footprint_set"):
			var footprint_set: Resource = cursor.get("object_footprint_set")
			if footprint_set != null:
				var configs: Array = footprint_set.get("objects")
				for config in configs:
					if config is Resource and String(config.get("id")) == String(object_id):
						return config
		cursor = cursor.get_parent()
	return null


func _mount_parent_socket() -> Marker2D:
	return get_parent() as Marker2D


func _node_has_property(node: Node, property_name: StringName) -> bool:
	for property in node.get_property_list():
		if StringName(property.get("name", "")) == property_name:
			return true
	return false


func _resource_geometry_active(config: Resource) -> bool:
	return (
		Vector2i(config.get("anchor_cell")) != Vector2i.ZERO
		or Vector2i(config.get("size_cells")) != Vector2i.ZERO
		or Vector2(config.get("position_offset_px")) != Vector2.ZERO
		or Vector2(config.get("visual_size_px")) != Vector2.ZERO
		or int(config.get("collision_shape_type")) != 0
		or Vector2(config.get("collision_size_px")) != Vector2.ZERO
		or Vector2(config.get("collision_offset_px")) != Vector2.ZERO
		or Vector2(config.get("interaction_size_px")) != Vector2.ZERO
		or Vector2(config.get("interaction_offset_px")) != Vector2.ZERO
		or Vector2(config.get("wall_offset_px")) != Vector2.ZERO
		or (int(config.get("anchor_type")) != 0 and not is_zero_approx(float(config.get("wall_position_ratio"))))
		or not Array(config.get("interaction_cells")).is_empty()
		or Vector2i(config.get("interaction_cell")) != Vector2i(-1, -1)
	)
