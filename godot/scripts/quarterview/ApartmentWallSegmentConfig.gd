extends Resource
class_name ApartmentWallSegmentConfig

enum Axis {
	AXIS_A,
	AXIS_B,
}

enum WallType {
	NORMAL,
	DOORWAY_EMPTY,
	DOORWAY_FRAME,
	CUTAWAY_STUB,
	END,
	CORNER,
}

enum HeightMode {
	DEFAULT,
	CUSTOM,
	CUTAWAY,
}

enum RenderMode {
	FULL,
	CUTAWAY_STUB,
	HIDDEN_STUB,
	LOGICAL_ONLY,
	REVEALABLE,
}

@export var id: StringName = &""
@export var enabled := true
@export var axis: Axis = Axis.AXIS_A
@export var start_cell := Vector2i.ZERO
@export_range(0, 64, 1) var length := 1
@export var wall_type: WallType = WallType.NORMAL
@export_range(-1, 64, 1) var doorway_offset := -1
@export_range(0, 64, 1) var doorway_width := 0
@export var height_mode: HeightMode = HeightMode.DEFAULT
@export var custom_height := -1.0
@export var doorway_color := Color.TRANSPARENT
@export var render_mode: RenderMode = RenderMode.FULL
# Future reveal wiring can switch REVEALABLE segments from stub/hidden display to full wall.
@export var reveal_area_id := ""
@export var reveal_when_area_active := false
