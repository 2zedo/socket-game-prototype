extends Resource
class_name PowerModuleDefinition

const ROLE_POWER_MODULE := "power_module"
const ROLE_POWER_ADAPTER := "power_adapter"
const ROLE_POWER_ROUTING := "power_routing"
const ROLE_POWER_EFFICIENCY := "power_efficiency"

const ATLAS_SMALL_CORE := "small_core"
const ATLAS_LAPTOP_ADAPTER := "laptop_adapter"
const ATLAS_COMM_MODULE := "comm_module"
const ATLAS_ODD_EFFICIENCY_MODULE := "odd_efficiency_module"

@export_category("식별")
@export var key: String = ""
@export var display_name: String = ""
@export var role: String = ROLE_POWER_MODULE
@export_multiline var description: String = ""

@export_category("보드 후보")
@export var shape_cells: Array[Vector2i] = [Vector2i.ZERO]
@export var mock_power_label: String = ""
@export var mock_heat_label: String = ""
@export var bonus_label: String = ""
@export var candidate_action: String = ""

@export_category("표시 후보")
@export var atlas_region_name: String = ""
@export var inventory_position: Vector2 = Vector2.ZERO
@export var color: Color = Color(0.20, 0.28, 0.30, 0.94)

@export_category("상태")
@export var is_prototype: bool = true


func is_valid_definition() -> bool:
	if key.is_empty() or display_name.is_empty() or role.is_empty():
		return false
	if shape_cells.is_empty():
		return false

	var seen_cells := {}
	for cell in shape_cells:
		if cell.x < 0 or cell.y < 0:
			return false
		if seen_cells.has(cell):
			return false
		seen_cells[cell] = true

	return true


func get_shape_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in shape_cells:
		cells.append(cell)
	if cells.is_empty():
		cells.append(Vector2i.ZERO)
	return cells


func get_size_cells() -> Vector2i:
	var size_cells := Vector2i.ONE
	for cell in get_shape_cells():
		size_cells.x = maxi(size_cells.x, cell.x + 1)
		size_cells.y = maxi(size_cells.y, cell.y + 1)
	return size_cells


func get_shape_label() -> String:
	var size_cells := get_size_cells()
	var cells := get_shape_cells()
	if cells.size() == size_cells.x * size_cells.y:
		return "%dx%d" % [size_cells.x, size_cells.y]
	if cells.size() == 3 and size_cells == Vector2i(2, 2):
		return "L-shape 3 cells"
	return "%d cells / bbox %dx%d" % [cells.size(), size_cells.x, size_cells.y]


static func normalize_shape_cells(source_cells: Array[Vector2i]) -> Array[Vector2i]:
	if source_cells.is_empty():
		return [Vector2i.ZERO]

	var min_x := source_cells[0].x
	var min_y := source_cells[0].y
	for cell in source_cells:
		min_x = mini(min_x, cell.x)
		min_y = mini(min_y, cell.y)

	var normalized_cells: Array[Vector2i] = []
	for cell in source_cells:
		var normalized_cell := Vector2i(cell.x - min_x, cell.y - min_y)
		if not normalized_cells.has(normalized_cell):
			normalized_cells.append(normalized_cell)

	normalized_cells.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		if a.y == b.y:
			return a.x < b.x
		return a.y < b.y
	)
	return normalized_cells


static func rotate_shape_cells_clockwise(source_cells: Array[Vector2i]) -> Array[Vector2i]:
	var rotated_cells: Array[Vector2i] = []
	for cell in source_cells:
		rotated_cells.append(Vector2i(cell.y, -cell.x))
	return normalize_shape_cells(rotated_cells)


func get_candidate_action() -> String:
	if not candidate_action.is_empty():
		return candidate_action
	if key.is_empty():
		return "place_power_module_noop"
	return "place_%s_noop" % key


func get_effect_label() -> String:
	var labels: Array[String] = []
	if not mock_power_label.is_empty():
		labels.append(mock_power_label)
	if not mock_heat_label.is_empty():
		labels.append(mock_heat_label)
	if not bonus_label.is_empty():
		labels.append(bonus_label)

	if labels.is_empty():
		return "효과 후보 없음"
	return " / ".join(labels)


func get_debug_summary() -> String:
	return "%s / role=%s / shape=%s / atlas=%s / prototype=%s" % [
		key,
		role,
		get_shape_label(),
		atlas_region_name,
		str(is_prototype),
	]
