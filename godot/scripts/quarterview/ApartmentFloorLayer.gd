@tool
extends TileMapLayer
class_name ApartmentFloorLayer

@export_group("바닥 구역")
@export var floor_id: StringName
@export var korean_name := ""


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if floor_id.is_empty():
		warnings.append("floor_id가 비어 있습니다.")
	if tile_set == null:
		warnings.append("128×64 이소메트릭 TileSet이 필요합니다.")
	return warnings


func used_floor_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in get_used_cells():
		cells.append(cell)
	return cells
