extends Control

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")

const FLOOR_BASE_PATH := "res://assets/rooms/quarterview/shell/qv_room_floor_base.png"
const EXPECTED_CANVAS_SIZE := Vector2i(1920, 1080)

var guide_visible := true

@onready var world_root: Control = $WorldRoot
@onready var room_shell_root: Control = $WorldRoot/RoomShellRoot
@onready var floor_layer: TextureRect = $WorldRoot/RoomShellRoot/FloorLayer
@onready var floor_fallback: ColorRect = $WorldRoot/RoomShellRoot/FloorFallback
@onready var missing_asset_label: Label = $WorldRoot/RoomShellRoot/FloorFallback/MissingAssetLabel
@onready var future_layer_guide: Control = $WorldRoot/RoomShellRoot/FutureLayerGuide
@onready var reference_guide_root: Control = $WorldRoot/ReferenceGuideRoot
@onready var title_label: Label = $UILayer/TitleLabel
@onready var status_label: Label = $UILayer/StatusLabel
@onready var help_label: Label = $UILayer/HelpLabel


func _ready() -> void:
	_configure_static_labels()
	_configure_canvas_nodes()
	_load_floor_layer()
	_update_guide_visibility()
	_fit_canvas_to_viewport()
	get_viewport().size_changed.connect(_fit_canvas_to_viewport)


func _unhandled_input(event: InputEvent) -> void:
	if PROTOTYPE_UTILS.is_hub_back_event(event):
		PROTOTYPE_UTILS.go_to_hub(self)
		get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_restart_event(event):
		PROTOTYPE_UTILS.restart_current_scene(self)
		get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_debug_toggle_event(event):
		guide_visible = not guide_visible
		_update_guide_visibility()
		get_viewport().set_input_as_handled()


func _configure_static_labels() -> void:
	title_label.text = "Quarterview Room Shell Prototype"
	help_label.text = "Expected canvas: 1920x1080\nCurrent layer: qv_room_floor_base.png\nPath: %s\nB / Backspace: Hub\nR: Reload prototype\nD: Toggle guide" % FLOOR_BASE_PATH


func _configure_canvas_nodes() -> void:
	for node in [room_shell_root, floor_layer, floor_fallback, future_layer_guide, reference_guide_root]:
		var control := node as Control
		control.position = Vector2.ZERO
		control.size = Vector2(EXPECTED_CANVAS_SIZE)
		control.custom_minimum_size = Vector2(EXPECTED_CANVAS_SIZE)

	floor_layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	floor_layer.stretch_mode = TextureRect.STRETCH_SCALE
	floor_fallback.color = Color(0.08, 0.11, 0.13, 1.0)
	missing_asset_label.text = "qv_room_floor_base.png is not installed yet.\nExpected path:\n%s" % FLOOR_BASE_PATH


func _load_floor_layer() -> void:
	if not FileAccess.file_exists(FLOOR_BASE_PATH):
		floor_layer.texture = null
		floor_layer.visible = false
		floor_fallback.visible = true
		status_label.text = "Status: Missing\nExpected: %s\nPlace the exported 1920x1080 floor layer at this path." % FLOOR_BASE_PATH
		return

	var texture := load(FLOOR_BASE_PATH) as Texture2D
	if texture == null:
		floor_layer.texture = null
		floor_layer.visible = false
		floor_fallback.visible = true
		status_label.text = "Status: Load failed\nPath: %s\nFallback placeholder is shown." % FLOOR_BASE_PATH
		return

	var image_size := texture.get_size()
	var expected_size := Vector2(EXPECTED_CANVAS_SIZE)
	floor_layer.texture = texture
	floor_layer.visible = true
	floor_fallback.visible = false
	status_label.text = "Status: Loaded qv_room_floor_base.png\nImage size: %d x %d\nExpected: %d x %d\nCanvas match: %s" % [
		int(image_size.x),
		int(image_size.y),
		EXPECTED_CANVAS_SIZE.x,
		EXPECTED_CANVAS_SIZE.y,
		"yes" if image_size == expected_size else "no",
	]


func _update_guide_visibility() -> void:
	reference_guide_root.visible = guide_visible
	future_layer_guide.visible = guide_visible


func _fit_canvas_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var scale_factor: float = min(
		viewport_size.x / float(EXPECTED_CANVAS_SIZE.x),
		viewport_size.y / float(EXPECTED_CANVAS_SIZE.y)
	)
	var scaled_size: Vector2 = Vector2(EXPECTED_CANVAS_SIZE) * scale_factor
	world_root.scale = Vector2(scale_factor, scale_factor)
	world_root.position = (viewport_size - scaled_size) * 0.5
