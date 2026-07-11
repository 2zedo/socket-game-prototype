extends Resource
class_name ApartmentObjectFootprintConfig

enum CollisionShapeType {
	NONE,
	RECTANGLE,
	CIRCLE,
}

enum AnchorType {
	FLOOR,
	WALL_EDGE,
	CEILING,
	PARENT_OBJECT,
}

@export var id: StringName = &""
@export var enabled := true
@export var room_area_id: StringName = &""
@export var category: StringName = &""
@export var anchor_cell := Vector2i.ZERO
@export var size_cells := Vector2i.ONE
@export var position_offset_px := Vector2.ZERO
@export var visual_size_px := Vector2.ZERO
@export var collision_shape_type: CollisionShapeType = CollisionShapeType.RECTANGLE
@export var collision_size_px := Vector2.ZERO
@export var collision_offset_px := Vector2.ZERO
@export var interaction_size_px := Vector2.ZERO
@export var interaction_offset_px := Vector2.ZERO
@export var blocks_movement := true
@export var uses_floor_occupancy := true
@export var interaction_cell := Vector2i(-1, -1)
@export var interaction_cells: Array[Vector2i] = []
@export var anchor_type: AnchorType = AnchorType.FLOOR
@export var parent_object_id: StringName = &""
@export var wall_segment_id: StringName = &""
@export_range(0.0, 1.0, 0.01) var wall_position_ratio := 0.5
@export var wall_offset_px := Vector2.ZERO
@export_multiline var facing_description_ko := ""
@export var display_name_ko := ""
@export var expected_image_file := ""
@export var expected_scene_file := ""
@export var expected_audio_set_id := ""
@export var debug_color := Color(0.55, 0.74, 1.0, 0.38)
@export var display_name := ""
@export_multiline var note := ""
