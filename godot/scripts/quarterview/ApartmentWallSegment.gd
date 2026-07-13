@tool
extends Node2D
class_name ApartmentWallSegment

const ApartmentWallCellScript := preload("res://scripts/quarterview/ApartmentWallCell.gd")

enum DisplayType { FULL, CUTAWAY, OCCLUSION }

@export_group("WallGroup")
@export var wall_id: StringName
@export var korean_name := ""
@export var room_name_ko := ""
@export var display_type: DisplayType = DisplayType.FULL
@export var enabled := true
@export var revealable := false
@export var logical_only := false
@export var opening_path: NodePath
@export var wall_color := Color(0.72, 0.68, 0.60, 1.0)

@onready var start_point: Marker2D = $StartPoint
@onready var end_point: Marker2D = $EndPoint
@onready var base_point: Marker2D = $BasePoint
@onready var top_point: Marker2D = $TopPoint
@onready var wall_cells_root: Node2D = $WallCells

var _authority_active := true
var _inspection_mode: int = ApartmentWallCellScript.InspectionMode.NORMAL
var _revealed := false


func _ready() -> void:
	_disable_retired_group_geometry()
	_sync_group_from_cells()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_sync_group_from_cells()
		_sync_editor_marker_visibility()


func wall_cells() -> Array[Node]:
	var cells: Array[Node] = []
	if not is_instance_valid(wall_cells_root):
		return cells
	for child in wall_cells_root.get_children():
		if child.has_method("world_start") and child.has_method("world_end"):
			cells.append(child)
	cells.sort_custom(func(a: Node, b: Node) -> bool:
		return int(a.get("cell_index")) < int(b.get("cell_index"))
	)
	return cells


func wall_cell(cell_index: int) -> Node2D:
	for cell in wall_cells():
		if int(cell.get("cell_index")) == cell_index:
			return cell as Node2D
	return null


func unit_edge_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for cell in wall_cells():
		entries.append({
			"cell_index": int(cell.get("cell_index")),
			"node_path": String(cell.get_path()),
			"from_world": cell.call("world_start"),
			"to_world": cell.call("world_end"),
			"opening_kind": int(cell.get("opening_kind")),
			"opening_id": String(cell.get("opening_id")),
			"opening_passable": bool(cell.get("opening_passable")),
			"enabled": bool(cell.get("enabled")),
		})
	return entries


func _sync_group_from_cells() -> void:
	var cells := wall_cells()
	if cells.is_empty():
		_disable_retired_group_geometry()
		return
	start_point.position = to_local(Vector2(cells[0].call("world_start")))
	end_point.position = to_local(Vector2(cells[-1].call("world_end")))
	base_point.position = (start_point.position + end_point.position) * 0.5
	var group_height := maxf(8.0, base_point.position.y - top_point.position.y)
	for cell in cells:
		cell.set("wall_color", wall_color)
		cell.call("set_group_context", wall_id, room_name_ko if not room_name_ko.is_empty() else korean_name, display_type, revealable, group_height)
		cell.call("set_authority_active", _authority_active and enabled and not logical_only)
		cell.call("set_inspection_mode", _inspection_mode)
		cell.call("set_revealed", _revealed)
	_sync_opening_marker_from_cells(cells)
	_disable_retired_group_geometry()
	if Engine.is_editor_hint():
		_sync_editor_marker_visibility()


func _sync_editor_marker_visibility() -> void:
	var selection := EditorInterface.get_selection()
	var group_selected := false
	if selection != null:
		for selected_node in selection.get_selected_nodes():
			if selected_node == self or is_ancestor_of(selected_node):
				group_selected = true
				break
	for marker in [start_point, end_point, base_point, top_point]:
		if marker is Marker2D:
			(marker as Marker2D).visible = group_selected
			(marker as Marker2D).gizmo_extents = 10.0 if group_selected else 0.0


func _sync_opening_marker_from_cells(cells: Array[Node]) -> void:
	if opening_path.is_empty():
		return
	var opening := get_node_or_null(opening_path) as ApartmentOpeningMarker
	if opening == null:
		return
	var opening_cells: Array[Node] = []
	for cell in cells:
		if int(cell.get("opening_kind")) != ApartmentWallCellScript.OpeningKind.NONE and bool(cell.get("enabled")):
			opening_cells.append(cell)
	if opening_cells.is_empty():
		return
	var first: Node = opening_cells.front()
	var last: Node = opening_cells.back()
	opening.opening_id = StringName(first.get("opening_id"))
	opening.owner_wall_id = wall_id
	opening.opening_type = ApartmentOpeningMarker.OpeningType.WINDOW if int(first.get("opening_kind")) == ApartmentWallCellScript.OpeningKind.WINDOW else ApartmentOpeningMarker.OpeningType.DOOR
	opening.passable = bool(first.get("opening_passable"))
	opening.start_point.position = opening.to_local(Vector2(first.call("world_start")))
	opening.end_point.position = opening.to_local(Vector2(last.call("world_end")))
	opening._sync_preview()


func _disable_retired_group_geometry() -> void:
	for path in ["Visual", "VisualAfterOpening", "OcclusionVisual"]:
		var item := get_node_or_null(path) as CanvasItem
		if item != null:
			item.visible = false
	for path in ["CollisionBody/CollisionPolygon2D", "CollisionBody/CollisionAfterOpening"]:
		var collision := get_node_or_null(path) as CollisionPolygon2D
		if collision != null:
			collision.disabled = true


func set_inspection_mode(mode: int) -> void:
	_inspection_mode = mode
	for cell in wall_cells():
		cell.call("set_inspection_mode", mode)


func set_inspection_transparent(active: bool) -> void:
	set_inspection_mode(ApartmentWallCellScript.InspectionMode.TRANSPARENT if active else ApartmentWallCellScript.InspectionMode.NORMAL)


func set_authority_active(active: bool) -> void:
	_authority_active = active
	visible = active
	for cell in wall_cells():
		cell.call("set_authority_active", active and enabled and not logical_only)
	_disable_retired_group_geometry()


func set_revealed(active: bool) -> void:
	_revealed = active
	for cell in wall_cells():
		cell.call("set_revealed", active)


func all_collisions_disabled() -> bool:
	for cell in wall_cells():
		var collision := cell.get_node_or_null("CollisionBody/CollisionPolygon2D") as CollisionPolygon2D
		if collision != null and not collision.disabled:
			return false
	return true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if wall_id.is_empty():
		warnings.append("wall_id가 비어 있습니다.")
	if not has_node("StartPoint") or not has_node("EndPoint") or not has_node("TopPoint"):
		warnings.append("WallGroup에는 StartPoint, EndPoint, TopPoint가 필요합니다.")
	if not has_node("WallCells") or wall_cells().is_empty():
		warnings.append("WallGroup에는 한 칸 단위 WallCell이 필요합니다.")
	var seen: Dictionary = {}
	for cell in wall_cells():
		var cell_index := int(cell.get("cell_index"))
		if seen.has(cell_index):
			warnings.append("WallCell cell_index %d가 중복됩니다." % cell_index)
		seen[cell_index] = true
	return warnings
