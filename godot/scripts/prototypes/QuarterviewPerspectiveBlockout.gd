extends Node2D

const PROTOTYPE_HUB_SCENE := "res://scenes/prototypes/PrototypeHub.tscn"

const WALL_BLOCKERS := [
	{"name": "top_wall", "rect": Rect2(Vector2(220, 78), Vector2(810, 70))},
	{"name": "left_wall", "rect": Rect2(Vector2(165, 140), Vector2(80, 465))},
	{"name": "right_wall", "rect": Rect2(Vector2(1036, 145), Vector2(78, 430))},
	{"name": "bottom_wall", "rect": Rect2(Vector2(310, 632), Vector2(690, 52))},
]

const PSEUDO_BLOCKS := [
	{
		"key": "bed",
		"label": "BED",
		"position": Vector2(390, 360),
		"size": Vector2(240, 116),
		"height": 42.0,
		"color": Color(0.25, 0.34, 0.25, 1.0),
		"blocker": Rect2(Vector2(270, 318), Vector2(250, 134)),
	},
	{
		"key": "desk",
		"label": "DESK",
		"position": Vector2(790, 335),
		"size": Vector2(280, 92),
		"height": 46.0,
		"color": Color(0.38, 0.24, 0.13, 1.0),
		"blocker": Rect2(Vector2(650, 296), Vector2(304, 112)),
	},
	{
		"key": "chair",
		"label": "CHAIR",
		"position": Vector2(735, 446),
		"size": Vector2(74, 58),
		"height": 36.0,
		"color": Color(0.20, 0.29, 0.24, 1.0),
		"blocker": Rect2(Vector2(700, 424), Vector2(82, 68)),
	},
	{
		"key": "fridge",
		"label": "FRIDGE",
		"position": Vector2(984, 322),
		"size": Vector2(84, 92),
		"height": 138.0,
		"color": Color(0.37, 0.40, 0.40, 1.0),
		"blocker": Rect2(Vector2(940, 256), Vector2(104, 154)),
	},
	{
		"key": "microwave",
		"label": "MICRO",
		"position": Vector2(905, 468),
		"size": Vector2(116, 52),
		"height": 42.0,
		"color": Color(0.25, 0.27, 0.29, 1.0),
		"blocker": Rect2(Vector2(846, 442), Vector2(126, 66)),
	},
	{
		"key": "aircon",
		"label": "AIRCON",
		"position": Vector2(515, 138),
		"size": Vector2(150, 34),
		"height": 24.0,
		"color": Color(0.52, 0.53, 0.50, 1.0),
		"blocker": Rect2(Vector2(438, 118), Vector2(164, 44)),
	},
	{
		"key": "power",
		"label": "POWER",
		"position": Vector2(780, 560),
		"size": Vector2(150, 74),
		"height": 48.0,
		"color": Color(0.13, 0.16, 0.18, 1.0),
		"blocker": Rect2(Vector2(704, 530), Vector2(162, 92)),
	},
	{
		"key": "node17",
		"label": "NODE-17",
		"position": Vector2(910, 382),
		"size": Vector2(68, 58),
		"height": 64.0,
		"color": Color(0.16, 0.11, 0.23, 1.0),
		"blocker": Rect2(Vector2(876, 352), Vector2(80, 80)),
	},
]

var floor_points := PackedVector2Array([
	Vector2(280, 180),
	Vector2(958, 180),
	Vector2(1090, 566),
	Vector2(378, 664),
	Vector2(178, 392),
])

@onready var world: Node2D = $World
@onready var floor_layer: Node2D = $World/FloorLayer
@onready var wall_back_layer: Node2D = $World/WallBackLayer
@onready var wall_side_layer: Node2D = $World/WallSideLayer
@onready var furniture_back_layer: Node2D = $World/FurnitureBackLayer
@onready var player_layer: Node2D = $World/PlayerLayer
@onready var furniture_front_layer: Node2D = $World/FurnitureFrontLayer
@onready var debug_layer: Node2D = $World/DebugLayer

var debug_enabled := false


func _ready() -> void:
	_configure_layers()
	_build_room_shell()
	_build_collision()
	_build_furniture()
	debug_layer.visible = debug_enabled


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_B or event.keycode == KEY_BACKSPACE:
			print("Quarterview perspective blockout: PrototypeHub로 돌아갑니다.")
			get_tree().change_scene_to_file(PROTOTYPE_HUB_SCENE)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_D:
			debug_enabled = not debug_enabled
			debug_layer.visible = debug_enabled
			print("Quarterview perspective blockout debug: %s" % ("ON" if debug_enabled else "OFF"))
			get_viewport().set_input_as_handled()


func _configure_layers() -> void:
	for layer in [
		floor_layer,
		wall_back_layer,
		wall_side_layer,
		furniture_back_layer,
		player_layer,
		furniture_front_layer,
		debug_layer,
	]:
		layer.z_as_relative = false

	floor_layer.z_index = 0
	wall_back_layer.z_index = 10
	wall_side_layer.z_index = 12
	furniture_back_layer.z_index = 30
	player_layer.z_index = 40
	furniture_front_layer.z_index = 60
	debug_layer.z_index = 90


func _build_room_shell() -> void:
	_add_polygon(floor_layer, floor_points, Color(0.20, 0.16, 0.12, 1.0))
	_add_polyline(floor_layer, floor_points, Color(0.78, 0.60, 0.38, 0.55), 3.0)
	_add_floor_guides()

	var back_wall := PackedVector2Array([
		Vector2(280, 86),
		Vector2(958, 86),
		Vector2(958, 180),
		Vector2(280, 180),
	])
	_add_polygon(wall_back_layer, back_wall, Color(0.24, 0.23, 0.21, 1.0))
	_add_polyline(wall_back_layer, back_wall, Color(0.80, 0.72, 0.58, 0.42), 2.0)

	var left_wall := PackedVector2Array([
		Vector2(196, 170),
		Vector2(280, 86),
		Vector2(280, 180),
		Vector2(178, 392),
		Vector2(178, 620),
		Vector2(132, 560),
	])
	_add_polygon(wall_side_layer, left_wall, Color(0.18, 0.18, 0.17, 1.0))
	_add_polyline(wall_side_layer, left_wall, Color(0.74, 0.68, 0.58, 0.35), 2.0)

	var right_wall := PackedVector2Array([
		Vector2(958, 86),
		Vector2(1040, 168),
		Vector2(1132, 512),
		Vector2(1090, 566),
		Vector2(958, 180),
	])
	_add_polygon(wall_side_layer, right_wall, Color(0.16, 0.17, 0.17, 1.0))
	_add_polyline(wall_side_layer, right_wall, Color(0.74, 0.68, 0.58, 0.35), 2.0)

	var window := PackedVector2Array([
		Vector2(620, 106),
		Vector2(790, 106),
		Vector2(790, 166),
		Vector2(620, 166),
	])
	_add_polygon(wall_back_layer, window, Color(0.08, 0.18, 0.28, 1.0))
	_add_polyline(wall_back_layer, window, Color(0.35, 0.72, 0.95, 0.70), 2.0)


func _add_floor_guides() -> void:
	for guide in [
		PackedVector2Array([Vector2(330, 238), Vector2(1010, 552)]),
		PackedVector2Array([Vector2(238, 374), Vector2(928, 208)]),
		PackedVector2Array([Vector2(420, 628), Vector2(1044, 226)]),
		PackedVector2Array([Vector2(540, 182), Vector2(260, 496)]),
	]:
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = Color(0.68, 0.55, 0.38, 0.22)
		line.points = guide
		floor_layer.add_child(line)


func _build_collision() -> void:
	for wall_data in WALL_BLOCKERS:
		_add_blocker(wall_data["name"], wall_data["rect"])


func _build_furniture() -> void:
	for block in PSEUDO_BLOCKS:
		_add_pseudo_block(block)
		_add_blocker("%s_blocker" % block["key"], block["blocker"])
		_add_debug_label(block)


func _add_pseudo_block(block: Dictionary) -> void:
	var parent := furniture_front_layer if String(block["key"]) in ["microwave", "power"] else furniture_back_layer
	var node := Node2D.new()
	node.name = "%sBlockout" % String(block["key"]).capitalize()
	node.position = block["position"]
	node.z_as_relative = false
	node.z_index = int(node.position.y + float(block["height"]))
	parent.add_child(node)

	var size: Vector2 = block["size"]
	var height := float(block["height"])
	var half := size * 0.5
	var skew := Vector2(28, 18)
	var base_color: Color = block["color"]

	var top_points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x + skew.x, half.y + skew.y),
		Vector2(-half.x + skew.x, half.y + skew.y),
	])
	var front_points := PackedVector2Array([
		top_points[3],
		top_points[2],
		top_points[2] + Vector2(0, height),
		top_points[3] + Vector2(0, height),
	])
	var side_points := PackedVector2Array([
		top_points[1],
		top_points[2],
		top_points[2] + Vector2(0, height),
		top_points[1] + Vector2(0, height),
	])

	_add_local_polygon(node, front_points, base_color.darkened(0.28))
	_add_local_polygon(node, side_points, base_color.darkened(0.18))
	_add_local_polygon(node, top_points, base_color)
	_add_local_polyline(node, top_points, Color(0.96, 0.78, 0.48, 0.48), 2.0)

	var label := Label.new()
	label.text = block["label"]
	label.position = Vector2(-half.x, -half.y - 24.0)
	label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.66, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.02, 0.016, 0.01, 1.0))
	label.add_theme_constant_override("outline_size", 3)
	node.add_child(label)


func _add_debug_label(block: Dictionary) -> void:
	var label := Label.new()
	label.text = "%s\nz=%d" % [block["key"], int(Vector2(block["position"]).y + float(block["height"]))]
	label.position = Vector2(block["position"]) + Vector2(-38, 42)
	label.add_theme_color_override("font_color", Color(0.36, 0.82, 0.98, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.01, 0.01, 0.02, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	debug_layer.add_child(label)


func _add_blocker(blocker_name: String, rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.name = blocker_name
	body.position = rect.position + rect.size * 0.5
	world.add_child(body)

	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)

	var guide := Line2D.new()
	guide.closed = true
	guide.width = 2.0
	guide.default_color = Color(1.0, 0.28, 0.18, 0.72)
	guide.points = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y),
	])
	debug_layer.add_child(guide)


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
