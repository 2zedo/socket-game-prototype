extends Node2D

signal interaction_requested(object_key: String, action_key: String, payload: Dictionary)
signal nearest_interactable_changed(object_key: String, display_name: String)

const ACTION_PRIMARY := "primary"

const OBJECT_RESOURCE_PATHS := [
	"res://resources/rooms/quarterview/objects/bed.tres",
	"res://resources/rooms/quarterview/objects/desk.tres",
	"res://resources/rooms/quarterview/objects/laptop.tres",
	"res://resources/rooms/quarterview/objects/phone.tres",
	"res://resources/rooms/quarterview/objects/power.tres",
	"res://resources/rooms/quarterview/objects/fridge.tres",
	"res://resources/rooms/quarterview/objects/microwave.tres",
	"res://resources/rooms/quarterview/objects/door.tres",
]

const WALL_BLOCKERS := [
	{"name": "BackWallBlocker", "rect": Rect2(Vector2(222, 96), Vector2(820, 56))},
	{"name": "LeftWallBlocker", "rect": Rect2(Vector2(128, 162), Vector2(82, 430))},
	{"name": "RightWallBlocker", "rect": Rect2(Vector2(1066, 170), Vector2(76, 392))},
	{"name": "FrontLipBlocker", "rect": Rect2(Vector2(360, 650), Vector2(660, 48))},
]

var floor_points := PackedVector2Array([
	Vector2(250, 154),
	Vector2(1014, 154),
	Vector2(1118, 566),
	Vector2(356, 656),
	Vector2(154, 386),
])

var object_definitions: Array = []
var object_nodes: Dictionary = {}
var debug_nodes: Array[CanvasItem] = []
var nearest_key := ""
var debug_enabled := false

@onready var floor_layer: Node2D = $FloorLayer
@onready var wall_back_layer: Node2D = $WallBackLayer
@onready var wall_side_layer: Node2D = $WallSideLayer
@onready var object_back_layer: Node2D = $ObjectBackLayer
@onready var object_layer: Node2D = $ObjectLayer
@onready var player_layer: Node2D = $PlayerLayer
@onready var foreground_layer: Node2D = $ForegroundLayer
@onready var debug_layer: Node2D = $DebugLayer
@onready var prompt_layer: Node2D = $PromptLayer
@onready var player: CharacterBody2D = $PlayerLayer/Player

var prompt_label: Label


func _ready() -> void:
	_configure_layers()
	_build_room_shell()
	_build_prompt()
	_load_object_definitions()
	_build_object_placeholders()
	_build_wall_blockers()
	_set_debug_enabled(false)


func _process(_delta: float) -> void:
	_update_nearest_interactable()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_D:
			_set_debug_enabled(not debug_enabled)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_E or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_request_nearest_interaction()
			get_viewport().set_input_as_handled()


func _configure_layers() -> void:
	var ordered_layers := [
		floor_layer,
		wall_back_layer,
		wall_side_layer,
		object_back_layer,
		object_layer,
		player_layer,
		foreground_layer,
		debug_layer,
		prompt_layer,
	]
	for index in ordered_layers.size():
		var layer: Node2D = ordered_layers[index]
		layer.z_as_relative = false
		layer.z_index = index * 10


func _build_room_shell() -> void:
	_add_polygon(floor_layer, floor_points, Color(0.17, 0.14, 0.10, 1.0))
	_add_polyline(floor_layer, floor_points, Color(0.78, 0.61, 0.38, 0.55), 3.0)
	_add_floor_guides()

	var back_wall := PackedVector2Array([
		Vector2(250, 76),
		Vector2(1014, 76),
		Vector2(1014, 154),
		Vector2(250, 154),
	])
	_add_polygon(wall_back_layer, back_wall, Color(0.22, 0.21, 0.19, 1.0))
	_add_polyline(wall_back_layer, back_wall, Color(0.76, 0.67, 0.50, 0.40), 2.0)

	var left_wall := PackedVector2Array([
		Vector2(166, 160),
		Vector2(250, 76),
		Vector2(250, 154),
		Vector2(154, 386),
		Vector2(146, 604),
		Vector2(108, 550),
	])
	_add_polygon(wall_side_layer, left_wall, Color(0.13, 0.13, 0.12, 1.0))
	_add_polyline(wall_side_layer, left_wall, Color(0.68, 0.62, 0.48, 0.36), 2.0)

	var right_wall := PackedVector2Array([
		Vector2(1014, 76),
		Vector2(1092, 158),
		Vector2(1144, 512),
		Vector2(1118, 566),
		Vector2(1014, 154),
	])
	_add_polygon(wall_side_layer, right_wall, Color(0.15, 0.16, 0.15, 1.0))
	_add_polyline(wall_side_layer, right_wall, Color(0.68, 0.62, 0.48, 0.36), 2.0)

	var window := PackedVector2Array([
		Vector2(624, 94),
		Vector2(814, 94),
		Vector2(814, 142),
		Vector2(624, 142),
	])
	_add_polygon(wall_back_layer, window, Color(0.04, 0.15, 0.24, 1.0))
	_add_polyline(wall_back_layer, window, Color(0.32, 0.70, 0.95, 0.66), 2.0)

	var foreground_lip := Line2D.new()
	foreground_lip.points = PackedVector2Array([Vector2(356, 656), Vector2(1118, 566)])
	foreground_lip.width = 8.0
	foreground_lip.default_color = Color(0.08, 0.08, 0.07, 0.80)
	foreground_layer.add_child(foreground_lip)


func _add_floor_guides() -> void:
	for guide in [
		PackedVector2Array([Vector2(330, 232), Vector2(1050, 552)]),
		PackedVector2Array([Vector2(224, 386), Vector2(910, 184)]),
		PackedVector2Array([Vector2(442, 622), Vector2(1042, 230)]),
		PackedVector2Array([Vector2(560, 156), Vector2(238, 520)]),
	]:
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = Color(0.70, 0.58, 0.40, 0.18)
		line.points = guide
		floor_layer.add_child(line)


func _build_prompt() -> void:
	prompt_label = Label.new()
	prompt_label.name = "PromptLabel"
	prompt_label.visible = false
	prompt_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.48, 1.0))
	prompt_label.add_theme_color_override("font_outline_color", Color(0.02, 0.018, 0.012, 1.0))
	prompt_label.add_theme_constant_override("outline_size", 4)
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_layer.add_child(prompt_label)


func _load_object_definitions() -> void:
	object_definitions.clear()
	for path in OBJECT_RESOURCE_PATHS:
		var definition := load(path)
		if definition == null:
			push_warning("QuarterviewRoom could not load object definition: %s" % path)
			continue
		if not definition.is_valid_definition():
			push_warning("QuarterviewRoom skipped invalid object definition: %s" % path)
			continue
		object_definitions.append(definition)


func _build_object_placeholders() -> void:
	for definition in object_definitions:
		_add_object_placeholder(definition)
		if definition.blocks:
			_add_object_blocker(definition)
		_add_debug_for_definition(definition)


func _add_object_placeholder(definition) -> void:
	var parent := _get_layer_for_definition(definition)
	var node := Node2D.new()
	node.name = "%sPlaceholder" % definition.key.capitalize().replace("_", "")
	node.position = definition.position
	node.z_as_relative = false
	node.z_index = int(definition.sort_y if definition.sort_y != 0 else definition.position.y)
	parent.add_child(node)
	object_nodes[definition.key] = node

	var size: Vector2 = definition.size
	var half := size * 0.5
	var depth: float = max(float(definition.thickness), 8.0)
	var skew := Vector2(18, 12)
	var base_color: Color = definition.color

	var top_points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x + skew.x, half.y + skew.y),
		Vector2(-half.x + skew.x, half.y + skew.y),
	])
	var front_points := PackedVector2Array([
		top_points[3],
		top_points[2],
		top_points[2] + Vector2(0, depth),
		top_points[3] + Vector2(0, depth),
	])
	var side_points := PackedVector2Array([
		top_points[1],
		top_points[2],
		top_points[2] + Vector2(0, depth),
		top_points[1] + Vector2(0, depth),
	])

	_add_local_polygon(node, front_points, base_color.darkened(0.28))
	_add_local_polygon(node, side_points, base_color.darkened(0.16))
	_add_local_polygon(node, top_points, base_color)
	_add_local_polyline(node, top_points, Color(0.90, 0.72, 0.45, 0.42), 2.0)


func _add_object_blocker(definition) -> void:
	var rect: Rect2 = definition.blocker_rect if definition.has_blocker_rect() else Rect2(definition.position - definition.get_collision_size() * 0.5, definition.get_collision_size())
	_add_blocker("%sBlocker" % definition.key.capitalize().replace("_", ""), rect)


func _build_wall_blockers() -> void:
	for blocker in WALL_BLOCKERS:
		_add_blocker(blocker["name"], blocker["rect"])


func _add_blocker(blocker_name: String, rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.name = blocker_name
	body.position = rect.position + rect.size * 0.5
	add_child(body)

	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)

	var guide := Line2D.new()
	guide.name = "%sGuide" % blocker_name
	guide.closed = true
	guide.width = 2.0
	guide.default_color = Color(1.0, 0.24, 0.18, 0.72)
	guide.points = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y),
	])
	debug_layer.add_child(guide)
	debug_nodes.append(guide)


func _add_debug_for_definition(definition) -> void:
	var label := Label.new()
	label.name = "%sDebugLabel" % definition.key.capitalize().replace("_", "")
	label.text = "%s\n%s" % [definition.display_name, definition.role]
	label.position = definition.position + Vector2(-42, -definition.size.y * 0.5 - 34)
	label.add_theme_color_override("font_color", Color(0.55, 0.93, 0.96, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.01, 0.01, 0.02, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	debug_layer.add_child(label)
	debug_nodes.append(label)

	var radius := Line2D.new()
	radius.name = "%sInteractionRadius" % definition.key.capitalize().replace("_", "")
	radius.closed = true
	radius.width = 2.0
	radius.default_color = Color(0.28, 0.88, 0.76, 0.34)
	var points := PackedVector2Array()
	for index in 48:
		var angle := TAU * float(index) / 48.0
		points.append(definition.get_interaction_position() + Vector2(cos(angle), sin(angle)) * definition.interaction_radius)
	radius.points = points
	debug_layer.add_child(radius)
	debug_nodes.append(radius)


func _get_layer_for_definition(definition) -> Node2D:
	match definition.layer:
		"FloorLayer":
			return floor_layer
		"WallBackLayer":
			return wall_back_layer
		"WallSideLayer":
			return wall_side_layer
		"FurnitureBackLayer", "ObjectBackLayer":
			return object_back_layer
		"FurnitureFrontLayer", "ForegroundLayer":
			return foreground_layer
		_:
			return object_layer


func _update_nearest_interactable() -> void:
	var best_key := ""
	var best_display_name := ""
	var best_distance := INF

	for definition in object_definitions:
		if not definition.interactable:
			continue
		var distance := player.global_position.distance_to(definition.get_interaction_position())
		if distance <= definition.interaction_radius and distance < best_distance:
			best_key = definition.key
			best_display_name = definition.display_name
			best_distance = distance

	if best_key == nearest_key:
		_update_prompt()
		return

	nearest_key = best_key
	nearest_interactable_changed.emit(nearest_key, best_display_name)
	_update_prompt()


func _update_prompt() -> void:
	if nearest_key.is_empty():
		prompt_label.visible = false
		return

	var definition = _get_definition(nearest_key)
	if definition == null:
		prompt_label.visible = false
		return

	prompt_label.text = "[E] %s" % definition.display_name
	prompt_label.position = player.global_position + Vector2(-46, -74)
	prompt_label.visible = true


func _request_nearest_interaction() -> void:
	if nearest_key.is_empty():
		return
	var definition = _get_definition(nearest_key)
	if definition == null:
		return

	var payload := {
		"key": definition.key,
		"display_name": definition.display_name,
		"role": definition.role,
		"zone": definition.zone,
		"future_source": definition.future_source,
		"visual_state": definition.visual_state,
		"action": ACTION_PRIMARY,
	}
	interaction_requested.emit(definition.key, ACTION_PRIMARY, payload)


func _get_definition(object_key: String):
	for definition in object_definitions:
		if definition.key == object_key:
			return definition
	return null


func _set_debug_enabled(enabled: bool) -> void:
	debug_enabled = enabled
	debug_layer.visible = debug_enabled


func _add_polygon(parent: Node, points: PackedVector2Array, color: Color) -> void:
	var polygon := Polygon2D.new()
	polygon.polygon = points
	polygon.color = color
	parent.add_child(polygon)


func _add_polyline(parent: Node, points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.closed = true
	line.width = width
	line.default_color = color
	line.points = points
	parent.add_child(line)


func _add_local_polygon(parent: Node, points: PackedVector2Array, color: Color) -> void:
	var polygon := Polygon2D.new()
	polygon.polygon = points
	polygon.color = color
	parent.add_child(polygon)


func _add_local_polyline(parent: Node, points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.closed = true
	line.width = width
	line.default_color = color
	line.points = points
	parent.add_child(line)
