extends Resource
class_name ApartmentObjectFootprintConfig

@export var id: StringName = &""
@export var enabled := true
@export var room_area_id: StringName = &""
@export var category: StringName = &""
@export var anchor_cell := Vector2i.ZERO
@export var size_cells := Vector2i.ONE
@export var blocks_movement := true
@export var interaction_cell := Vector2i(-1, -1)
@export var interaction_cells: Array[Vector2i] = []
@export var debug_color := Color(0.55, 0.74, 1.0, 0.38)
@export var display_name := ""
@export_multiline var note := ""
