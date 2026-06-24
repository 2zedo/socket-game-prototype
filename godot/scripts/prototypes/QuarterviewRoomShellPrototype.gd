extends Control

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")

const FLOOR_BASE_PATH := "res://assets/rooms/quarterview/shell/qv_room_floor_base.png"
const WALLS_BACK_PATH := "res://assets/rooms/quarterview/shell/qv_room_walls_back.png"
const WALLS_SIDE_PATH := "res://assets/rooms/quarterview/shell/qv_room_walls_side.png"
const EXPECTED_CANVAS_SIZE := Vector2i(1920, 1080)

var guide_visible := true
var layer_visibility := {
	"floor": true,
	"back_wall": true,
	"side_wall": true,
}
var layer_loaded := {}

@onready var world_root: Control = $WorldRoot
@onready var room_shell_root: Control = $WorldRoot/RoomShellRoot
@onready var floor_layer: TextureRect = $WorldRoot/RoomShellRoot/FloorLayer
@onready var back_wall_layer: TextureRect = $WorldRoot/RoomShellRoot/BackWallLayer
@onready var side_wall_layer: TextureRect = $WorldRoot/RoomShellRoot/SideWallLayer
@onready var floor_fallback: ColorRect = $WorldRoot/RoomShellRoot/FloorFallback
@onready var missing_asset_label: Label = $WorldRoot/RoomShellRoot/FloorFallback/MissingAssetLabel
@onready var future_layer_guide: Control = $WorldRoot/RoomShellRoot/FutureLayerGuide
@onready var reference_guide_root: Control = $WorldRoot/ReferenceGuideRoot
@onready var title_label: Label = $UILayer/TitleLabel
@onready var status_label: Label = $UILayer/StatusLabel
@onready var layer_status_label: Label = $UILayer/LayerStatusLabel
@onready var help_label: Label = $UILayer/HelpLabel


func _ready() -> void:
	_configure_static_labels()
	_configure_canvas_nodes()
	_load_shell_layers()
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
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1:
			_toggle_layer("floor")
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_2:
			_toggle_layer("back_wall")
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_3:
			_toggle_layer("side_wall")
			get_viewport().set_input_as_handled()


func _configure_static_labels() -> void:
	title_label.text = "Quarterview Room Shell Prototype"
	help_label.text = "Expected canvas: 1920x1080\nLayers: floor / back wall / side wall\nPaths:\n%s\n%s\n%s\n1 Floor / 2 Back Wall / 3 Side Wall\nD: Toggle guide\nR: Reload prototype\nB / Backspace: Hub" % [
		FLOOR_BASE_PATH,
		WALLS_BACK_PATH,
		WALLS_SIDE_PATH,
	]


func _configure_canvas_nodes() -> void:
	for node in [room_shell_root, floor_layer, back_wall_layer, side_wall_layer, floor_fallback, future_layer_guide, reference_guide_root]:
		var control := node as Control
		control.position = Vector2.ZERO
		control.size = Vector2(EXPECTED_CANVAS_SIZE)
		control.custom_minimum_size = Vector2(EXPECTED_CANVAS_SIZE)

	for layer in [floor_layer, back_wall_layer, side_wall_layer]:
		layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		layer.stretch_mode = TextureRect.STRETCH_SCALE

	floor_fallback.color = Color(0.08, 0.11, 0.13, 1.0)
	missing_asset_label.text = "Room shell PNG layers are not installed yet.\nExpected floor path:\n%s" % FLOOR_BASE_PATH


func _load_shell_layers() -> void:
	var status_lines: Array[String] = []
	var warning_lines: Array[String] = []
	layer_loaded.clear()

	for spec in _get_layer_specs():
		var key := spec["key"] as String
		var label := spec["label"] as String
		var path := spec["path"] as String
		var layer := spec["node"] as TextureRect

		if not FileAccess.file_exists(path):
			layer.texture = null
			layer.visible = false
			layer_loaded[key] = false
			status_lines.append("%s: missing / %s" % [label, path.get_file()])
			continue

		var texture := load(path) as Texture2D
		if texture == null:
			layer.texture = null
			layer.visible = false
			layer_loaded[key] = false
			status_lines.append("%s: load failed / %s" % [label, path.get_file()])
			continue

		var image_size := texture.get_size()
		var expected_size := Vector2(EXPECTED_CANVAS_SIZE)
		var canvas_match := image_size == expected_size
		layer.texture = texture
		layer_loaded[key] = true
		layer.visible = layer_visibility.get(key, true)
		status_lines.append("%s: loaded / %d x %d / %s" % [
			label,
			int(image_size.x),
			int(image_size.y),
			"OK" if canvas_match else "SIZE WARNING",
		])
		if not canvas_match:
			warning_lines.append("Warning: %s is %d x %d, expected %d x %d." % [
				path.get_file(),
				int(image_size.x),
				int(image_size.y),
				EXPECTED_CANVAS_SIZE.x,
				EXPECTED_CANVAS_SIZE.y,
			])

	floor_fallback.visible = not layer_loaded.get("floor", false) and layer_visibility.get("floor", true)
	status_label.text = "Status: Shell layer check\nExpected: %d x %d\nLoaded layers: %d / %d" % [
		EXPECTED_CANVAS_SIZE.x,
		EXPECTED_CANVAS_SIZE.y,
		_count_loaded_layers(),
		_get_layer_specs().size(),
	]
	layer_status_label.text = "\n".join(status_lines + warning_lines)


func _update_guide_visibility() -> void:
	reference_guide_root.visible = guide_visible
	future_layer_guide.visible = guide_visible


func _toggle_layer(key: String) -> void:
	layer_visibility[key] = not layer_visibility.get(key, true)

	for spec in _get_layer_specs():
		var spec_key := spec["key"] as String
		if spec_key != key:
			continue

		var layer := spec["node"] as TextureRect
		layer.visible = layer_loaded.get(key, false) and layer_visibility[key]
		if key == "floor":
			floor_fallback.visible = not layer_loaded.get("floor", false) and layer_visibility[key]
		break

	_update_layer_visibility_status()


func _update_layer_visibility_status() -> void:
	var suffix := "\nVisibility: floor=%s / back=%s / side=%s" % [
		"on" if layer_visibility.get("floor", true) else "off",
		"on" if layer_visibility.get("back_wall", true) else "off",
		"on" if layer_visibility.get("side_wall", true) else "off",
	]
	if not layer_status_label.text.contains("Visibility:"):
		layer_status_label.text += suffix
		return

	var lines := layer_status_label.text.split("\n")
	var kept_lines: Array[String] = []
	for line in lines:
		if not line.begins_with("Visibility:"):
			kept_lines.append(line)
	layer_status_label.text = "\n".join(kept_lines) + suffix


func _fit_canvas_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var scale_factor: float = min(
		viewport_size.x / float(EXPECTED_CANVAS_SIZE.x),
		viewport_size.y / float(EXPECTED_CANVAS_SIZE.y)
	)
	var scaled_size: Vector2 = Vector2(EXPECTED_CANVAS_SIZE) * scale_factor
	world_root.scale = Vector2(scale_factor, scale_factor)
	world_root.position = (viewport_size - scaled_size) * 0.5


func _get_layer_specs() -> Array[Dictionary]:
	return [
		{
			"key": "floor",
			"label": "Floor",
			"path": FLOOR_BASE_PATH,
			"node": floor_layer,
		},
		{
			"key": "back_wall",
			"label": "Back wall",
			"path": WALLS_BACK_PATH,
			"node": back_wall_layer,
		},
		{
			"key": "side_wall",
			"label": "Side wall",
			"path": WALLS_SIDE_PATH,
			"node": side_wall_layer,
		},
	]


func _count_loaded_layers() -> int:
	var count := 0
	for key in layer_loaded.keys():
		if layer_loaded[key]:
			count += 1
	return count
