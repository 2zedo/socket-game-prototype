@tool
extends Node2D
class_name ApartmentRoomArea

@export_group("방 구역")
@export var room_id: StringName
@export var korean_name := ""
@export_range(0, 100, 1) var selection_priority := 0
@export var preview_color := Color(0.2, 0.8, 0.6, 0.06)

@onready var area_polygon: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var editor_preview: Polygon2D = $EditorPreview


func _ready() -> void:
	_sync_preview()
	if not Engine.is_editor_hint():
		editor_preview.visible = false


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_preview()
		_sync_editor_collision_visibility()


func _sync_preview() -> void:
	if not is_instance_valid(area_polygon) or not is_instance_valid(editor_preview):
		return
	editor_preview.polygon = area_polygon.polygon
	var readable_color := preview_color
	readable_color.a = minf(readable_color.a, 0.08)
	editor_preview.color = readable_color
	if Engine.is_editor_hint():
		_sync_editor_collision_visibility()


func _sync_editor_collision_visibility() -> void:
	var selection := EditorInterface.get_selection()
	var show_collision := false
	if selection != null:
		for selected_node in selection.get_selected_nodes():
			if selected_node == $Area2D or $Area2D.is_ancestor_of(selected_node):
				show_collision = true
				break
	$Area2D.visible = show_collision
	area_polygon.visible = show_collision


func world_polygon() -> PackedVector2Array:
	var result := PackedVector2Array()
	if not is_instance_valid(area_polygon):
		return result
	for point in area_polygon.polygon:
		result.append(area_polygon.to_global(point))
	return result


func contains_world_point(world_point: Vector2) -> bool:
	var polygon := world_polygon()
	return polygon.size() >= 3 and Geometry2D.is_point_in_polygon(world_point, polygon)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if room_id.is_empty():
		warnings.append("room_id가 비어 있습니다.")
	if not has_node("Area2D/CollisionPolygon2D"):
		warnings.append("논리 방 범위 CollisionPolygon2D가 필요합니다.")
	elif get_node("Area2D/CollisionPolygon2D").polygon.size() < 3:
		warnings.append("방 Polygon은 점이 3개 이상이어야 합니다.")
	return warnings
