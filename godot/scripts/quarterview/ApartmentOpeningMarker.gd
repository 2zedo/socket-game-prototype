@tool
extends Node2D
class_name ApartmentOpeningMarker

enum OpeningType { DOOR, WINDOW }

@export_group("개구부")
@export var opening_id: StringName
@export var korean_name := ""
@export var opening_type: OpeningType = OpeningType.DOOR
@export var owner_wall_id: StringName
@export var passable := true

@onready var start_point: Marker2D = $StartPoint
@onready var end_point: Marker2D = $EndPoint
@onready var editor_preview: Line2D = $EditorPreview


func _ready() -> void:
	_sync_preview()
	if not Engine.is_editor_hint():
		editor_preview.visible = false


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_preview()


func _sync_preview() -> void:
	if not is_instance_valid(start_point) or not is_instance_valid(end_point) or not is_instance_valid(editor_preview):
		return
	editor_preview.points = PackedVector2Array([start_point.position, end_point.position])
	editor_preview.default_color = Color(0.2, 0.95, 1.0, 0.95) if opening_type == OpeningType.WINDOW else Color(1.0, 0.72, 0.22, 0.95)


func world_start() -> Vector2:
	return start_point.global_position


func world_end() -> Vector2:
	return end_point.global_position


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if opening_id.is_empty():
		warnings.append("opening_id가 비어 있습니다.")
	if owner_wall_id.is_empty():
		warnings.append("owner_wall_id가 비어 있습니다.")
	if not has_node("StartPoint") or not has_node("EndPoint"):
		warnings.append("StartPoint와 EndPoint가 필요합니다.")
	return warnings
