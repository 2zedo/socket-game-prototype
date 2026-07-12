@tool
extends Node2D
class_name ApartmentEditableObject

const VISUAL_PATH := NodePath("Visual")
const SPRITE_PATH := NodePath("Visual/Sprite2D")
const VISUAL_PREVIEW_PATH := NodePath("Visual/VisualPreview")
const BASE_POINT_PATH := NodePath("BasePoint")
const TOP_POINT_PATH := NodePath("TopPoint")
const BODY_PATH := NodePath("Body")
const BODY_POLYGON_PATH := NodePath("Body/BodyPolygon")
const SELECTION_AREA_PATH := NodePath("SelectionArea")
const SELECTION_POLYGON_PATH := NodePath("SelectionArea/SelectionPolygon")
const INTERACTION_AREA_PATH := NodePath("InteractionArea")
const INTERACTION_POLYGON_PATH := NodePath("InteractionArea/InteractionPolygon")
const USE_POINT_PATH := NodePath("UsePoint")
const ATTACHMENT_SOCKET_PATH := NodePath("AttachmentSocket")
const PLACEMENT_FOOTPRINT_PATH := NodePath("PlacementFootprint")

@export var object_id: StringName = &""
@export_group("Optional Open State")
@export var supports_open_state := false
@export var is_open := false:
	set(value):
		if is_open == value:
			return
		is_open = value
		_sync_body_open_state()
		open_state_changed.emit(is_open)

signal open_state_changed(is_open: bool)


func _ready() -> void:
	_sync_body_open_state()
	if not Engine.is_editor_hint():
		set_process(false)
		var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
		if preview != null:
			preview.visible = false
		var placement_preview := get_node_or_null(PLACEMENT_FOOTPRINT_PATH) as CanvasItem
		if placement_preview != null:
			placement_preview.visible = false
	else:
		set_process(true)
		_sync_editor_visual_preview()
		update_configuration_warnings()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_editor_visual_preview()


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
	var parent_anchor := get_parent() as Node2D
	return parent_anchor.global_position if parent_anchor != null else global_position


func base_point_world() -> Vector2:
	var base_point := get_node_or_null(BASE_POINT_PATH) as Marker2D
	return base_point.global_position if base_point != null else global_position


func top_point_world() -> Vector2:
	var top_point := get_node_or_null(TOP_POINT_PATH) as Marker2D
	return top_point.global_position if top_point != null else global_position


func attachment_socket_world() -> Vector2:
	var socket := get_node_or_null(ATTACHMENT_SOCKET_PATH) as Marker2D
	return socket.global_position if socket != null else global_position


func use_point_world() -> Vector2:
	var use_point := get_node_or_null(USE_POINT_PATH) as Marker2D
	return use_point.global_position if use_point != null else global_position


func body_world_polygon() -> PackedVector2Array:
	return _collision_polygon_world(BODY_POLYGON_PATH)


func set_open(value: bool) -> void:
	is_open = value


func body_collision_active() -> bool:
	var body_polygon := get_node_or_null(BODY_POLYGON_PATH) as CollisionPolygon2D
	return body_polygon != null and not body_polygon.disabled and body_polygon.polygon.size() >= 3


func selection_world_polygon() -> PackedVector2Array:
	return _collision_polygon_world(SELECTION_POLYGON_PATH)


func interaction_world_polygon() -> PackedVector2Array:
	return _collision_polygon_world(INTERACTION_POLYGON_PATH)


func placement_footprint_world_polygon() -> PackedVector2Array:
	var footprint := get_node_or_null(PLACEMENT_FOOTPRINT_PATH)
	if footprint is Polygon2D:
		var polygon_node := footprint as Polygon2D
		return _points_to_world(polygon_node, polygon_node.polygon) if polygon_node.polygon.size() >= 3 else PackedVector2Array()
	if footprint is CollisionPolygon2D:
		var collision_polygon := footprint as CollisionPolygon2D
		return _points_to_world(collision_polygon, collision_polygon.polygon) if not collision_polygon.disabled and collision_polygon.polygon.size() >= 3 else PackedVector2Array()
	return PackedVector2Array()


func floor_occupancy_world_polygon() -> PackedVector2Array:
	var placement := placement_footprint_world_polygon()
	return placement if placement.size() >= 3 else body_world_polygon()


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
	_require_node_type(warnings, INTERACTION_AREA_PATH, Area2D)
	_require_node_type(warnings, USE_POINT_PATH, Marker2D)
	_require_node_type(warnings, ATTACHMENT_SOCKET_PATH, Marker2D)

	var config := _logical_resource_config()
	var interaction_required := config != null and String(config.get("category")) == "interaction"
	var body_required := config != null and bool(config.get("blocks_movement"))
	var body_polygon := get_node_or_null(BODY_POLYGON_PATH) as CollisionPolygon2D
	var selection_polygon := get_node_or_null(SELECTION_POLYGON_PATH) as CollisionPolygon2D
	var interaction_polygon := get_node_or_null(INTERACTION_POLYGON_PATH) as CollisionPolygon2D
	var expected_runtime_disabled_body := supports_open_state and is_open
	if body_required and (body_polygon == null or (body_polygon.disabled and not expected_runtime_disabled_body)):
		warnings.append("blocks_movement requires Body/BodyPolygon")
	if body_polygon != null:
		_append_polygon_warning(warnings, "Body/BodyPolygon", body_polygon.polygon, body_polygon.scale)
	if selection_polygon == null or selection_polygon.disabled:
		warnings.append("SelectionArea/SelectionPolygon is required")
	else:
		_append_polygon_warning(warnings, "SelectionArea/SelectionPolygon", selection_polygon.polygon, selection_polygon.scale)
	if interaction_required and (interaction_polygon == null or interaction_polygon.disabled):
		warnings.append("interactive object requires InteractionArea/InteractionPolygon")
	if interaction_polygon != null:
		_append_polygon_warning(warnings, "InteractionArea/InteractionPolygon", interaction_polygon.polygon, interaction_polygon.scale)
	if interaction_required and get_node_or_null(USE_POINT_PATH) == null:
		warnings.append("interactive object requires UsePoint")
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

	var placement := get_node_or_null(PLACEMENT_FOOTPRINT_PATH)
	if placement is Polygon2D:
		var polygon_node := placement as Polygon2D
		_append_polygon_warning(warnings, "PlacementFootprint", polygon_node.polygon, polygon_node.scale)
	elif placement is CollisionPolygon2D:
		var collision_polygon := placement as CollisionPolygon2D
		_append_polygon_warning(warnings, "PlacementFootprint", collision_polygon.polygon, collision_polygon.scale)
	elif placement != null:
		warnings.append("PlacementFootprint must be Polygon2D or CollisionPolygon2D")

	var body := get_node_or_null(BODY_PATH)
	if body != null:
		for child in body.get_children():
			if child is CollisionShape2D:
				warnings.append("Body must not contain legacy CollisionShape2D")
			elif child is CollisionPolygon2D and child.name != "BodyPolygon":
				warnings.append("Body collision polygon must be named BodyPolygon")
	var interaction_area := get_node_or_null(INTERACTION_AREA_PATH)
	if interaction_area != null:
		for child in interaction_area.get_children():
			if child is CollisionShape2D:
				warnings.append("InteractionArea must not contain CollisionShape2D")
			elif child is CollisionPolygon2D and child.name != "InteractionPolygon":
				warnings.append("interaction collision polygon must be named InteractionPolygon")
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
		warnings.append("migrated Resource geometry must remain disabled")
	return warnings


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(geometry_warnings())


func _collision_polygon_world(path: NodePath) -> PackedVector2Array:
	var polygon_node := get_node_or_null(path) as CollisionPolygon2D
	if polygon_node == null or polygon_node.disabled or polygon_node.polygon.size() < 3:
		return PackedVector2Array()
	return _points_to_world(polygon_node, polygon_node.polygon)


func _sync_editor_visual_preview() -> void:
	var sprite := get_node_or_null(SPRITE_PATH) as Sprite2D
	var preview := get_node_or_null(VISUAL_PREVIEW_PATH) as Polygon2D
	if preview != null:
		preview.visible = sprite == null or sprite.texture == null


func _sync_body_open_state() -> void:
	if not supports_open_state:
		return
	var body_polygon := get_node_or_null(BODY_POLYGON_PATH) as CollisionPolygon2D
	if body_polygon != null:
		body_polygon.disabled = is_open


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
		or not Array(config.get("interaction_cells")).is_empty()
		or Vector2i(config.get("interaction_cell")) != Vector2i(-1, -1)
	)
