@tool
extends Node2D
class_name ApartmentEditableObject

@export var object_id: StringName = &""
@export var visual_size_px := Vector2.ZERO
@export var interaction_follows_use_point := true


func _ready() -> void:
	_sync_interaction_area()
	set_process(interaction_follows_use_point)


func _process(_delta: float) -> void:
	_sync_interaction_area()


func visual_center_world() -> Vector2:
	var visual_anchor := get_node_or_null("VisualAnchor") as Node2D
	return visual_anchor.global_position if visual_anchor != null else global_position


func attachment_anchor_world() -> Vector2:
	var parent_anchor := get_parent() as Node2D
	return parent_anchor.global_position if parent_anchor != null else global_position


func socket_world() -> Vector2:
	var socket := get_node_or_null("Socket") as Node2D
	return socket.global_position if socket != null else global_position


func use_point_world() -> Vector2:
	var use_point := get_node_or_null("UsePoint") as Node2D
	return use_point.global_position if use_point != null else global_position


func collision_world_polygons() -> Array[PackedVector2Array]:
	return _geometry_world_polygons(get_node_or_null("Body"))


func interaction_world_polygons() -> Array[PackedVector2Array]:
	return _geometry_world_polygons(get_node_or_null("InteractionArea"))


func geometry_warnings() -> Array[String]:
	var warnings: Array[String] = []
	if String(object_id).is_empty():
		warnings.append("object_id is empty")
	if get_node_or_null("VisualAnchor") == null:
		warnings.append("VisualAnchor is missing")
	if get_node_or_null("UsePoint") == null:
		warnings.append("UsePoint is missing")
	if get_node_or_null("Socket") == null:
		warnings.append("Socket is missing")
	_append_geometry_warnings(warnings, "Body")
	_append_geometry_warnings(warnings, "InteractionArea")
	return warnings


func _sync_interaction_area() -> void:
	if not interaction_follows_use_point:
		return
	var interaction_area := get_node_or_null("InteractionArea") as Node2D
	var use_point := get_node_or_null("UsePoint") as Node2D
	if interaction_area != null and use_point != null and interaction_area.position != use_point.position:
		interaction_area.position = use_point.position


func _geometry_world_polygons(container: Node) -> Array[PackedVector2Array]:
	var polygons: Array[PackedVector2Array] = []
	if container == null:
		return polygons
	for child in container.get_children():
		if child is CollisionPolygon2D:
			var polygon_node := child as CollisionPolygon2D
			if polygon_node.disabled or polygon_node.polygon.size() < 3:
				continue
			polygons.append(_points_to_world(polygon_node, polygon_node.polygon))
		elif child is CollisionShape2D:
			var shape_node := child as CollisionShape2D
			if shape_node.disabled or shape_node.shape == null:
				continue
			var local_points := _shape_local_polygon(shape_node.shape)
			if local_points.size() >= 3:
				polygons.append(_points_to_world(shape_node, local_points))
	return polygons


func _shape_local_polygon(shape: Shape2D) -> PackedVector2Array:
	if shape is RectangleShape2D:
		var half_size := (shape as RectangleShape2D).size * 0.5
		return PackedVector2Array([
			Vector2(-half_size.x, -half_size.y),
			Vector2(half_size.x, -half_size.y),
			Vector2(half_size.x, half_size.y),
			Vector2(-half_size.x, half_size.y),
		])
	return PackedVector2Array()


func _points_to_world(owner_node: Node2D, local_points: PackedVector2Array) -> PackedVector2Array:
	var world_points := PackedVector2Array()
	for point in local_points:
		world_points.append(owner_node.to_global(point))
	return world_points


func _append_geometry_warnings(warnings: Array[String], container_name: String) -> void:
	var container := get_node_or_null(container_name)
	if container == null:
		warnings.append("%s is missing" % container_name)
		return
	var active_geometry_count := 0
	for child in container.get_children():
		if child is CollisionPolygon2D:
			var polygon_node := child as CollisionPolygon2D
			if not polygon_node.disabled and polygon_node.polygon.size() >= 3:
				active_geometry_count += 1
		elif child is CollisionShape2D:
			var shape_node := child as CollisionShape2D
			if not shape_node.disabled and shape_node.shape != null:
				if _shape_local_polygon(shape_node.shape).size() < 3:
					warnings.append("%s/%s uses an unsupported Shape2D" % [container_name, child.name])
				else:
					active_geometry_count += 1
	if container_name == "InteractionArea" and active_geometry_count != 1:
		warnings.append("InteractionArea requires exactly one active geometry child")
	elif container_name == "Body" and active_geometry_count > 1:
		warnings.append("Body allows at most one active geometry child")
