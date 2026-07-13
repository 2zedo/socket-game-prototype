@tool
extends Node2D
class_name ApartmentWallCell

enum Direction { AXIS_A, AXIS_B }
enum OpeningKind { NONE, DOOR, WINDOW }
enum VisualMode { FULL, CUTAWAY, OCCLUSION }
enum InspectionMode { NORMAL, TRANSPARENT, HIDDEN }

@export_group("벽 한 칸")
@export var wall_id: StringName
@export var room_name_ko := ""
@export var direction: Direction = Direction.AXIS_A
@export_range(0, 64, 1) var cell_index := 0
@export var end_offset := Vector2(64.0, 32.0)
@export var wall_height := 176.0
@export var enabled := true
@export var visual_enabled := true
@export var collision_enabled := true
@export var visual_mode: VisualMode = VisualMode.FULL
@export var revealable := false
@export_group("개구부")
@export var opening_kind: OpeningKind = OpeningKind.NONE
@export var opening_id: StringName
@export var opening_passable := false
@export_group("표시")
@export var wall_color := Color(0.72, 0.68, 0.60, 1.0)
@export var collision_half_width := 6.0

@onready var start_point: Marker2D = $StartPoint
@onready var end_point: Marker2D = $EndPoint
@onready var base_point: Marker2D = $BasePoint
@onready var top_point: Marker2D = $TopPoint
@onready var visual: Polygon2D = $Visual
@onready var occlusion_visual: Polygon2D = $OcclusionVisual
@onready var collision_polygon: CollisionPolygon2D = $CollisionBody/CollisionPolygon2D
@onready var editor_opening_preview: Line2D = $EditorOpeningPreview

var _authority_active := true
var _inspection_mode: InspectionMode = InspectionMode.NORMAL
var _revealed := false


func _ready() -> void:
	_sync_geometry()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_geometry()
		_sync_editor_selection_guides()


func _sync_geometry() -> void:
	if not is_instance_valid(start_point):
		return
	start_point.position = Vector2.ZERO
	end_point.position = end_offset
	base_point.position = end_offset * 0.5
	top_point.position = base_point.position - Vector2(0.0, maxf(8.0, wall_height))
	visual.polygon = _wall_quad(Vector2.ZERO, end_offset, maxf(8.0, wall_height))
	occlusion_visual.polygon = _wall_quad(Vector2.ZERO, end_offset, minf(maxf(8.0, wall_height), 42.0))
	collision_polygon.polygon = _edge_quad(Vector2.ZERO, end_offset, collision_half_width)
	visual.color = wall_color
	occlusion_visual.color = Color(0.25, 0.26, 0.25, 0.9)
	editor_opening_preview.points = PackedVector2Array([Vector2.ZERO, end_offset])
	editor_opening_preview.default_color = Color(0.2, 0.95, 1.0, 0.95) if opening_kind == OpeningKind.WINDOW else Color(1.0, 0.72, 0.22, 0.95)
	editor_opening_preview.visible = Engine.is_editor_hint() and opening_kind != OpeningKind.NONE
	editor_description = "%s · %s · %s · Cell %02d. Root 이동은 Visual/Collision/Socket과 부착물을 함께 이동합니다. enabled·visual_enabled·V는 벽 시각/판정만 바꾸고 AttachmentSocket 자식은 유지하며, Root visible=false만 전체 부착 subtree를 의도적으로 숨깁니다." % [
		String(wall_id),
		room_name_ko,
		"AXIS_A" if direction == Direction.AXIS_A else "AXIS_B",
		cell_index,
	]
	if Engine.is_editor_hint():
		_sync_editor_selection_guides()
	_refresh_visual_state()
	_apply_collision_enabled()


func _sync_editor_selection_guides() -> void:
	var selection := EditorInterface.get_selection()
	var cell_selected := false
	var collision_selected := false
	if selection != null:
		for selected_node in selection.get_selected_nodes():
			if selected_node == self or is_ancestor_of(selected_node):
				cell_selected = true
			if selected_node == $CollisionBody or $CollisionBody.is_ancestor_of(selected_node):
				collision_selected = true
	for marker in [start_point, end_point, base_point, top_point]:
		if marker is Marker2D:
			(marker as Marker2D).visible = cell_selected
			(marker as Marker2D).gizmo_extents = 10.0 if cell_selected else 0.0
	var attachment_socket := get_node_or_null("AttachmentSocket") as Marker2D
	if attachment_socket != null:
		attachment_socket.gizmo_extents = 10.0 if cell_selected else 0.0
	$CollisionBody.visible = collision_selected
	collision_polygon.visible = collision_selected


func _wall_quad(from: Vector2, to: Vector2, height: float) -> PackedVector2Array:
	return PackedVector2Array([from, to, to - Vector2(0.0, height), from - Vector2(0.0, height)])


func _edge_quad(from: Vector2, to: Vector2, half_width: float) -> PackedVector2Array:
	var tangent := (to - from).normalized()
	var normal := Vector2(-tangent.y, tangent.x) * half_width
	return PackedVector2Array([from + normal, to + normal, to - normal, from - normal])


func _refresh_visual_state() -> void:
	var inspection_visible := _inspection_mode != InspectionMode.HIDDEN
	var solid_cell := opening_kind == OpeningKind.NONE
	var show_full := visual_mode == VisualMode.FULL or (revealable and _revealed)
	var show_stub := visual_mode != VisualMode.FULL and not (revealable and _revealed)
	var base_visible := _authority_active and enabled and visual_enabled and inspection_visible and solid_cell
	visual.visible = base_visible and show_full
	occlusion_visual.visible = base_visible and show_stub
	var alpha := 0.18 if _inspection_mode == InspectionMode.TRANSPARENT else 1.0
	visual.modulate.a = alpha
	occlusion_visual.modulate.a = alpha


func _apply_collision_enabled() -> void:
	var opening_blocks := opening_kind == OpeningKind.WINDOW and not opening_passable
	var solid_blocks := opening_kind == OpeningKind.NONE
	collision_polygon.disabled = not _authority_active or not enabled or not collision_enabled or not (solid_blocks or opening_blocks)


func set_group_context(group_wall_id: StringName, group_room_name: String, group_visual_mode: int, group_revealable: bool, group_height: float) -> void:
	wall_id = group_wall_id
	room_name_ko = group_room_name
	visual_mode = group_visual_mode as VisualMode
	revealable = group_revealable
	wall_height = group_height
	_sync_geometry()


func set_inspection_mode(mode: int) -> void:
	_inspection_mode = mode as InspectionMode
	_refresh_visual_state()


func set_authority_active(active: bool) -> void:
	_authority_active = active
	_refresh_visual_state()
	_apply_collision_enabled()


func set_revealed(active: bool) -> void:
	_revealed = active
	_refresh_visual_state()


func world_start() -> Vector2:
	return global_position


func world_end() -> Vector2:
	return to_global(end_offset)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if wall_id.is_empty():
		warnings.append("wall_id가 비어 있습니다.")
	if end_offset.length() < 1.0:
		warnings.append("벽 Cell의 end_offset이 비어 있습니다.")
	if not is_equal_approx(end_offset.length(), Vector2(64.0, 32.0).length()):
		warnings.append("한 WallCell은 128×64 이소메트릭 셀의 벽선 한 칸(화면 edge 64×32)이어야 합니다.")
	if opening_kind != OpeningKind.NONE and opening_id.is_empty():
		warnings.append("Opening Cell에는 opening_id가 필요합니다.")
	return warnings
