extends Node2D

const PROTOTYPE_HUB_SCENE := "res://scenes/prototypes/PrototypeHub.tscn"

const WALL_BLOCKERS := [
	{"name": "north_barrier", "rect": Rect2(Vector2(225, 104), Vector2(830, 76))},
	{"name": "west_barrier", "rect": Rect2(Vector2(160, 166), Vector2(76, 402))},
	{"name": "east_barrier", "rect": Rect2(Vector2(1040, 174), Vector2(82, 378))},
	{"name": "south_barrier", "rect": Rect2(Vector2(300, 620), Vector2(700, 58))},
]

const CYBER_BLOCKS := [
	{
		"key": "security_program",
		"label": "SECURITY",
		"layer": "EnemyLayer",
		"position": Vector2(775, 312),
		"size": Vector2(80, 58),
		"height": 54.0,
		"color": Color(0.88, 0.14, 0.34, 1.0),
		"blocker": Rect2(Vector2(738, 286), Vector2(92, 74)),
	},
	{
		"key": "sentry",
		"label": "SENTRY",
		"layer": "EnemyLayer",
		"position": Vector2(555, 330),
		"size": Vector2(68, 52),
		"height": 62.0,
		"color": Color(0.55, 0.10, 0.90, 1.0),
		"blocker": Rect2(Vector2(522, 304), Vector2(82, 76)),
	},
	{
		"key": "scan_line",
		"label": "SCAN",
		"layer": "HazardLayer",
		"position": Vector2(654, 410),
		"size": Vector2(325, 22),
		"height": 18.0,
		"color": Color(0.92, 0.08, 0.42, 1.0),
		"blocker": Rect2(Vector2(494, 396), Vector2(338, 38)),
	},
	{
		"key": "hazard_tile",
		"label": "HAZARD",
		"layer": "HazardLayer",
		"position": Vector2(430, 450),
		"size": Vector2(118, 74),
		"height": 24.0,
		"color": Color(0.78, 0.38, 0.06, 1.0),
		"blocker": Rect2(Vector2(370, 414), Vector2(134, 90)),
	},
	{
		"key": "data_node",
		"label": "DATA NODE",
		"layer": "ObjectiveLayer",
		"position": Vector2(890, 472),
		"size": Vector2(82, 70),
		"height": 74.0,
		"color": Color(0.05, 0.74, 0.95, 1.0),
		"blocker": Rect2(Vector2(850, 430), Vector2(96, 100)),
	},
	{
		"key": "exit_gate",
		"label": "EXIT",
		"layer": "ObjectiveLayer",
		"position": Vector2(330, 266),
		"size": Vector2(100, 48),
		"height": 86.0,
		"color": Color(0.22, 0.48, 0.96, 1.0),
		"blocker": Rect2(Vector2(280, 226), Vector2(112, 104)),
	},
	{
		"key": "firewall_barrier",
		"label": "BARRIER",
		"layer": "WallLayer",
		"position": Vector2(580, 238),
		"size": Vector2(210, 44),
		"height": 82.0,
		"color": Color(0.42, 0.10, 0.82, 1.0),
		"blocker": Rect2(Vector2(480, 210), Vector2(230, 92)),
	},
	{
		"key": "signal_relay",
		"label": "RELAY",
		"layer": "ObjectiveLayer",
		"position": Vector2(1012, 292),
		"size": Vector2(72, 60),
		"height": 88.0,
		"color": Color(0.04, 0.86, 0.74, 1.0),
		"blocker": Rect2(Vector2(976, 252), Vector2(88, 108)),
	},
	{
		"key": "foreground_firewall",
		"label": "FOREGROUND",
		"layer": "ForegroundLayer",
		"position": Vector2(666, 596),
		"size": Vector2(260, 40),
		"height": 70.0,
		"color": Color(0.12, 0.38, 0.68, 1.0),
		"blocker": Rect2(Vector2(536, 570), Vector2(280, 72)),
	},
]

var arena_floor := PackedVector2Array([
	Vector2(278, 172),
	Vector2(960, 172),
	Vector2(1096, 536),
	Vector2(412, 654),
	Vector2(178, 390),
])

var debug_enabled := false

@onready var world: Node2D = $World
@onready var floor_layer: Node2D = $World/FloorLayer
@onready var wall_layer: Node2D = $World/WallLayer
@onready var platform_layer: Node2D = $World/PlatformLayer
@onready var hazard_layer: Node2D = $World/HazardLayer
@onready var player_layer: Node2D = $World/PlayerLayer
@onready var enemy_layer: Node2D = $World/EnemyLayer
@onready var objective_layer: Node2D = $World/ObjectiveLayer
@onready var foreground_layer: Node2D = $World/ForegroundLayer
@onready var debug_layer: Node2D = $World/DebugLayer


func _ready() -> void:
	_configure_layers()
	_build_arena()
	_build_collision()
	_build_cyber_objects()
	debug_layer.visible = debug_enabled


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_B or event.keycode == KEY_BACKSPACE:
			print("Hacking perspective blockout: PrototypeHub로 돌아갑니다.")
			get_tree().change_scene_to_file(PROTOTYPE_HUB_SCENE)
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_D:
			debug_enabled = not debug_enabled
			debug_layer.visible = debug_enabled
			print("Hacking perspective blockout debug: %s" % ("ON" if debug_enabled else "OFF"))
			get_viewport().set_input_as_handled()


func _configure_layers() -> void:
	for layer in [
		floor_layer,
		wall_layer,
		platform_layer,
		hazard_layer,
		player_layer,
		enemy_layer,
		objective_layer,
		foreground_layer,
		debug_layer,
	]:
		layer.z_as_relative = false

	floor_layer.z_index = 0
	wall_layer.z_index = 12
	platform_layer.z_index = 22
	hazard_layer.z_index = 30
	player_layer.z_index = 40
	enemy_layer.z_index = 46
	objective_layer.z_index = 50
	foreground_layer.z_index = 64
	debug_layer.z_index = 90


func _build_arena() -> void:
	_add_polygon(floor_layer, arena_floor, Color(0.025, 0.08, 0.12, 1.0))
	_add_polyline(floor_layer, arena_floor, Color(0.00, 0.85, 0.94, 0.55), 3.0)
	_add_floor_grid()

	var rear_wall := PackedVector2Array([
		Vector2(278, 82),
		Vector2(960, 82),
		Vector2(960, 172),
		Vector2(278, 172),
	])
	_add_polygon(wall_layer, rear_wall, Color(0.04, 0.10, 0.16, 1.0))
	_add_polyline(wall_layer, rear_wall, Color(0.16, 0.92, 1.0, 0.45), 2.0)

	var left_wall := PackedVector2Array([
		Vector2(198, 156),
		Vector2(278, 82),
		Vector2(278, 172),
		Vector2(178, 390),
		Vector2(178, 596),
		Vector2(128, 552),
	])
	_add_polygon(wall_layer, left_wall, Color(0.035, 0.07, 0.12, 1.0))
	_add_polyline(wall_layer, left_wall, Color(0.16, 0.92, 1.0, 0.34), 2.0)

	var right_wall := PackedVector2Array([
		Vector2(960, 82),
		Vector2(1042, 160),
		Vector2(1130, 490),
		Vector2(1096, 536),
		Vector2(960, 172),
	])
	_add_polygon(wall_layer, right_wall, Color(0.03, 0.06, 0.11, 1.0))
	_add_polyline(wall_layer, right_wall, Color(0.16, 0.92, 1.0, 0.34), 2.0)

	_add_platform(Vector2(620, 510), Vector2(330, 92), Color(0.05, 0.18, 0.23, 1.0), "LOWER PLATFORM")


func _add_floor_grid() -> void:
	for guide in [
		PackedVector2Array([Vector2(300, 238), Vector2(1032, 520)]),
		PackedVector2Array([Vector2(248, 364), Vector2(904, 198)]),
		PackedVector2Array([Vector2(420, 638), Vector2(1040, 236)]),
		PackedVector2Array([Vector2(532, 176), Vector2(244, 504)]),
		PackedVector2Array([Vector2(712, 178), Vector2(386, 642)]),
	]:
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = Color(0.00, 0.78, 0.95, 0.20)
		line.points = guide
		floor_layer.add_child(line)


func _add_platform(center: Vector2, size: Vector2, color: Color, label_text: String) -> void:
	var node := Node2D.new()
	node.position = center
	node.z_as_relative = false
	node.z_index = int(center.y)
	platform_layer.add_child(node)

	var half := size * 0.5
	var skew := Vector2(32, 18)
	var points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x + skew.x, half.y + skew.y),
		Vector2(-half.x + skew.x, half.y + skew.y),
	])
	_add_local_polygon(node, points, color)
	_add_local_polyline(node, points, Color(0.0, 0.90, 1.0, 0.55), 2.0)

	var label := Label.new()
	label.text = label_text
	label.position = Vector2(-half.x + 12, -half.y + 8)
	label.add_theme_color_override("font_color", Color(0.48, 1.0, 1.0, 0.72))
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.04, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	node.add_child(label)


func _build_collision() -> void:
	for wall_data in WALL_BLOCKERS:
		_add_blocker(wall_data["name"], wall_data["rect"])


func _build_cyber_objects() -> void:
	for block in CYBER_BLOCKS:
		_add_cyber_block(block)
		_add_blocker("%s_blocker" % block["key"], block["blocker"])
		_add_debug_label(block)


func _add_cyber_block(block: Dictionary) -> void:
	var node := Node2D.new()
	node.name = "%sBlockout" % String(block["key"]).capitalize()
	node.position = block["position"]
	node.z_as_relative = false
	node.z_index = int(node.position.y + float(block["height"]))
	_get_block_layer(String(block["layer"])).add_child(node)

	var size: Vector2 = block["size"]
	var height := float(block["height"])
	var half := size * 0.5
	var skew := Vector2(26, 16)
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

	_add_local_polygon(node, front_points, base_color.darkened(0.32))
	_add_local_polygon(node, side_points, base_color.darkened(0.20))
	_add_local_polygon(node, top_points, base_color)
	_add_local_polyline(node, top_points, Color(0.92, 1.0, 1.0, 0.65), 2.0)

	var label := Label.new()
	label.text = block["label"]
	label.position = Vector2(-half.x, -half.y - 24.0)
	label.add_theme_color_override("font_color", Color(0.76, 1.0, 0.98, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.04, 1.0))
	label.add_theme_constant_override("outline_size", 2)
	node.add_child(label)


func _get_block_layer(layer_name: String) -> Node2D:
	match layer_name:
		"WallLayer":
			return wall_layer
		"PlatformLayer":
			return platform_layer
		"HazardLayer":
			return hazard_layer
		"EnemyLayer":
			return enemy_layer
		"ObjectiveLayer":
			return objective_layer
		"ForegroundLayer":
			return foreground_layer
		_:
			return platform_layer


func _add_debug_label(block: Dictionary) -> void:
	var label := Label.new()
	label.text = "%s\nz=%d" % [block["key"], int(Vector2(block["position"]).y + float(block["height"]))]
	label.position = Vector2(block["position"]) + Vector2(-42, 44)
	label.add_theme_color_override("font_color", Color(0.36, 0.92, 1.0, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.04, 1.0))
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
	guide.default_color = Color(1.0, 0.14, 0.38, 0.72)
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
