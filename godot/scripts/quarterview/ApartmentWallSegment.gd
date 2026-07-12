@tool
extends Node2D
class_name ApartmentWallSegment

enum DisplayType { FULL, CUTAWAY, OCCLUSION }

@export_group("벽 구간")
@export var wall_id: StringName
@export var korean_name := ""
@export var display_type: DisplayType = DisplayType.FULL
@export var enabled := true
@export var revealable := false
@export var logical_only := false
@export var opening_path: NodePath
@export var wall_color := Color(0.72, 0.68, 0.60, 1.0)
@export var collision_half_width := 6.0

@onready var start_point: Marker2D = $StartPoint
@onready var end_point: Marker2D = $EndPoint
@onready var base_point: Marker2D = $BasePoint
@onready var top_point: Marker2D = $TopPoint
@onready var visual: Polygon2D = $Visual
@onready var visual_after_opening: Polygon2D = $VisualAfterOpening
@onready var occlusion_visual: Polygon2D = $OcclusionVisual
@onready var collision_polygon: CollisionPolygon2D = $CollisionBody/CollisionPolygon2D
@onready var collision_after_opening: CollisionPolygon2D = $CollisionBody/CollisionAfterOpening

var _authority_active := true


func _ready() -> void:
	if Engine.is_editor_hint():
		_sync_geometry()
	else:
		_apply_collision_enabled()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_geometry()


func _sync_geometry() -> void:
	if not is_instance_valid(start_point) or not is_instance_valid(end_point):
		return
	base_point.position = (start_point.position + end_point.position) * 0.5
	var wall_height := maxf(8.0, base_point.position.y - top_point.position.y)
	var visual_spans := _local_solid_spans(true)
	var opening := get_node_or_null(opening_path) as ApartmentOpeningMarker
	var split_collision := opening != null and (opening.opening_type == ApartmentOpeningMarker.OpeningType.DOOR or opening.passable)
	var collision_spans := _local_solid_spans(split_collision)
	_apply_visual_span(visual, visual_spans[0] if visual_spans.size() > 0 else PackedVector2Array(), wall_height)
	_apply_visual_span(visual_after_opening, visual_spans[1] if visual_spans.size() > 1 else PackedVector2Array(), wall_height)
	_apply_collision_span(collision_polygon, collision_spans[0] if collision_spans.size() > 0 else PackedVector2Array())
	_apply_collision_span(collision_after_opening, collision_spans[1] if collision_spans.size() > 1 else PackedVector2Array())
	visual.color = wall_color
	visual_after_opening.color = wall_color
	visual.visible = enabled and not logical_only and display_type == DisplayType.FULL
	visual_after_opening.visible = visual.visible and not visual_after_opening.polygon.is_empty()
	occlusion_visual.visible = enabled and display_type != DisplayType.FULL
	if occlusion_visual.visible:
		occlusion_visual.polygon = _wall_quad(start_point.position, end_point.position, minf(wall_height, 42.0))
		occlusion_visual.color = Color(0.25, 0.26, 0.25, 0.9)
	_apply_collision_enabled()


func _local_solid_spans(split_opening: bool) -> Array[PackedVector2Array]:
	var spans: Array[PackedVector2Array] = []
	var opening := get_node_or_null(opening_path) as ApartmentOpeningMarker
	if opening == null or not split_opening:
		spans.append(PackedVector2Array([start_point.position, end_point.position]))
		return spans
	var open_start := to_local(opening.world_start())
	var open_end := to_local(opening.world_end())
	spans.append(PackedVector2Array([start_point.position, open_start]))
	spans.append(PackedVector2Array([open_end, end_point.position]))
	return spans


func _apply_visual_span(target_visual: Polygon2D, span: PackedVector2Array, wall_height: float) -> void:
	if span.size() < 2 or span[0].distance_to(span[1]) < 1.0:
		target_visual.polygon = PackedVector2Array()
		return
	target_visual.polygon = _wall_quad(span[0], span[1], wall_height)


func _apply_collision_span(target_collision: CollisionPolygon2D, span: PackedVector2Array) -> void:
	if span.size() < 2 or span[0].distance_to(span[1]) < 1.0:
		target_collision.polygon = PackedVector2Array()
		return
	target_collision.polygon = _edge_quad(span[0], span[1], collision_half_width)


func _apply_collision_enabled() -> void:
	var disabled := not _authority_active or not enabled or logical_only
	collision_polygon.disabled = disabled or collision_polygon.polygon.size() < 3
	collision_after_opening.disabled = disabled or collision_after_opening.polygon.size() < 3


func _wall_quad(from: Vector2, to: Vector2, height: float) -> PackedVector2Array:
	return PackedVector2Array([from, to, to - Vector2(0.0, height), from - Vector2(0.0, height)])


func _edge_quad(from: Vector2, to: Vector2, half_width: float) -> PackedVector2Array:
	var tangent := (to - from).normalized()
	var normal := Vector2(-tangent.y, tangent.x) * half_width
	return PackedVector2Array([from + normal, to + normal, to - normal, from - normal])


func set_inspection_transparent(active: bool) -> void:
	var alpha := 0.18 if active else 1.0
	for item in [visual, visual_after_opening, occlusion_visual]:
		if is_instance_valid(item):
			item.modulate.a = alpha


func set_authority_active(active: bool) -> void:
	_authority_active = active
	visible = active
	_apply_collision_enabled()


func set_revealed(active: bool) -> void:
	if not revealable:
		return
	visual.visible = _authority_active and enabled and active
	visual_after_opening.visible = visual.visible and not visual_after_opening.polygon.is_empty()
	occlusion_visual.visible = _authority_active and enabled and not active


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if wall_id.is_empty():
		warnings.append("wall_id가 비어 있습니다.")
	if not has_node("StartPoint") or not has_node("EndPoint") or not has_node("TopPoint"):
		warnings.append("StartPoint, EndPoint, TopPoint가 필요합니다.")
	return warnings
