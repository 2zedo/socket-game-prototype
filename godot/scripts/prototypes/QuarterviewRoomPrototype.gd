extends Node2D

var floor_points := PackedVector2Array([
	Vector2(245, 170),
	Vector2(965, 170),
	Vector2(1080, 555),
	Vector2(365, 650),
	Vector2(190, 360),
])

var back_wall_points := PackedVector2Array([
	Vector2(245, 70),
	Vector2(965, 70),
	Vector2(965, 170),
	Vector2(245, 170),
])

var left_wall_points := PackedVector2Array([
	Vector2(170, 150),
	Vector2(245, 70),
	Vector2(245, 170),
	Vector2(190, 360),
	Vector2(190, 610),
	Vector2(140, 565),
])

var right_wall_points := PackedVector2Array([
	Vector2(965, 70),
	Vector2(1045, 145),
	Vector2(1125, 495),
	Vector2(1080, 555),
	Vector2(965, 170),
])

const WALL_BLOCKERS := [
	{"name": "top_wall", "rect": Rect2(Vector2(220, 58), Vector2(790, 92))},
	{"name": "left_wall", "rect": Rect2(Vector2(132, 142), Vector2(82, 440))},
	{"name": "right_wall", "rect": Rect2(Vector2(1062, 145), Vector2(78, 430))},
	{"name": "bottom_wall", "rect": Rect2(Vector2(310, 626), Vector2(735, 54))},
	{"name": "upper_left_corner", "rect": Rect2(Vector2(175, 78), Vector2(96, 94))},
	{"name": "upper_right_corner", "rect": Rect2(Vector2(940, 78), Vector2(102, 96))},
]

const ROOM_OBJECTS := [
	{
		"key": "bed",
		"label": "BED",
		"pos": Vector2(370, 382),
		"size": Vector2(190, 124),
		"color": Color(0.22, 0.34, 0.25, 1.0),
		"blocker": Rect2(Vector2(280, 326), Vector2(210, 140)),
		"interact": Vector2(442, 492),
		"radius": 78.0,
		"sort_y": 460,
		"thickness": 24.0,
	},
	{
		"key": "desk",
		"label": "DESK",
		"pos": Vector2(704, 270),
		"size": Vector2(250, 86),
		"color": Color(0.36, 0.23, 0.13, 1.0),
		"blocker": Rect2(Vector2(575, 224), Vector2(270, 116)),
		"interact": Vector2(702, 365),
		"radius": 86.0,
		"sort_y": 338,
		"thickness": 18.0,
	},
	{
		"key": "laptop",
		"label": "LAPTOP",
		"pos": Vector2(710, 242),
		"size": Vector2(74, 36),
		"color": Color(0.08, 0.12, 0.15, 1.0),
		"interact": Vector2(704, 355),
		"radius": 74.0,
		"sort_y": 350,
		"thickness": 7.0,
	},
	{
		"key": "fridge",
		"label": "FRIDGE",
		"pos": Vector2(970, 274),
		"size": Vector2(72, 144),
		"color": Color(0.35, 0.38, 0.39, 1.0),
		"blocker": Rect2(Vector2(930, 202), Vector2(88, 164)),
		"interact": Vector2(900, 294),
		"radius": 78.0,
		"sort_y": 372,
		"thickness": 12.0,
	},
	{
		"key": "microwave",
		"label": "MICROWAVE",
		"pos": Vector2(936, 406),
		"size": Vector2(92, 42),
		"color": Color(0.23, 0.25, 0.27, 1.0),
		"blocker": Rect2(Vector2(880, 378), Vector2(134, 72)),
		"interact": Vector2(884, 438),
		"radius": 68.0,
		"sort_y": 450,
		"thickness": 10.0,
	},
	{
		"key": "air_conditioner",
		"label": "AC",
		"pos": Vector2(835, 120),
		"size": Vector2(128, 30),
		"color": Color(0.48, 0.50, 0.48, 1.0),
		"interact": Vector2(828, 185),
		"radius": 62.0,
		"sort_y": 168,
		"thickness": 6.0,
	},
	{
		"key": "power",
		"label": "POWER",
		"pos": Vector2(670, 475),
		"size": Vector2(118, 36),
		"color": Color(0.18, 0.18, 0.14, 1.0),
		"interact": Vector2(668, 532),
		"radius": 76.0,
		"sort_y": 512,
		"thickness": 8.0,
	},
	{
		"key": "communication_device",
		"label": "COMM",
		"pos": Vector2(915, 455),
		"size": Vector2(86, 46),
		"color": Color(0.15, 0.19, 0.22, 1.0),
		"interact": Vector2(870, 502),
		"radius": 70.0,
		"sort_y": 498,
		"thickness": 10.0,
	},
	{
		"key": "node_17",
		"label": "NODE-17",
		"pos": Vector2(850, 352),
		"size": Vector2(72, 72),
		"color": Color(0.16, 0.11, 0.20, 1.0),
		"interact": Vector2(808, 404),
		"radius": 74.0,
		"sort_y": 420,
		"thickness": 14.0,
	},
	{
		"key": "phone",
		"label": "PHONE",
		"pos": Vector2(790, 392),
		"size": Vector2(50, 30),
		"color": Color(0.04, 0.06, 0.08, 1.0),
		"interact": Vector2(760, 428),
		"radius": 58.0,
		"sort_y": 430,
		"thickness": 5.0,
	},
]

@onready var world: Node2D = $World
@onready var player: CharacterBody2D = $World/Player
@onready var prompt_label: Label = $UI/PromptLabel

var nearest_object: Dictionary = {}


func _ready() -> void:
	_build_collision()
	_build_placeholder_objects()
	_configure_labels()


func _process(_delta: float) -> void:
	_update_nearest_interactable()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not nearest_object.is_empty():
		print("Quarterview prototype interact: %s" % nearest_object["key"])


func _draw() -> void:
	_draw_room_shell()
	_draw_collision_guides()
	_draw_interaction_ranges()


func _build_collision() -> void:
	for wall_data in WALL_BLOCKERS:
		_add_blocker(wall_data["name"], wall_data["rect"])

	for object_data in ROOM_OBJECTS:
		if object_data.has("blocker"):
			_add_blocker("%s_blocker" % object_data["key"], object_data["blocker"])


func _build_placeholder_objects() -> void:
	for object_data in ROOM_OBJECTS:
		var object_node := Node2D.new()
		object_node.name = "%sPlaceholder" % object_data["key"].capitalize().replace("_", "")
		object_node.position = object_data["pos"]
		object_node.z_as_relative = false
		object_node.z_index = int(object_data["sort_y"])
		world.add_child(object_node)

		_add_placeholder_shape(object_node, object_data)
		_add_placeholder_label(object_node, object_data)


func _add_placeholder_shape(parent: Node2D, object_data: Dictionary) -> void:
	var size: Vector2 = object_data["size"]
	var half := size * 0.5
	var thickness := float(object_data.get("thickness", 10.0))
	var color: Color = object_data["color"]
	var outline_color := Color(0.92, 0.72, 0.40, 0.45)

	var shadow := Polygon2D.new()
	shadow.position = Vector2(8, 12)
	shadow.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	shadow.color = Color(0.01, 0.01, 0.01, 0.36)
	parent.add_child(shadow)

	var face := Polygon2D.new()
	face.polygon = PackedVector2Array([
		Vector2(-half.x, half.y),
		Vector2(half.x, half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	face.color = color.darkened(0.24)
	parent.add_child(face)

	var top := Polygon2D.new()
	top.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y),
		Vector2(-half.x, half.y),
	])
	top.color = color
	parent.add_child(top)

	var outline := Line2D.new()
	outline.closed = true
	outline.width = 2.0
	outline.default_color = outline_color
	outline.points = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	parent.add_child(outline)


func _add_placeholder_label(parent: Node2D, object_data: Dictionary) -> void:
	var size: Vector2 = object_data["size"]
	var label := Label.new()
	label.text = object_data["label"]
	label.position = Vector2(-size.x * 0.5, -size.y * 0.5 - 25.0)
	label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.66, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.02, 0.015, 0.01, 1.0))
	label.add_theme_constant_override("outline_size", 3)
	parent.add_child(label)


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


func _configure_labels() -> void:
	prompt_label.text = ""


func _update_nearest_interactable() -> void:
	var next_nearest: Dictionary = {}
	var closest_distance := INF

	for object_data in ROOM_OBJECTS:
		var interaction_position: Vector2 = object_data["interact"]
		var radius := float(object_data["radius"])
		var distance := player.global_position.distance_to(interaction_position)
		if distance <= radius and distance < closest_distance:
			next_nearest = object_data
			closest_distance = distance

	nearest_object = next_nearest

	if nearest_object.is_empty():
		prompt_label.text = ""
	else:
		prompt_label.text = "E: %s" % nearest_object["label"]


func _draw_room_shell() -> void:
	draw_colored_polygon(left_wall_points, Color(0.14, 0.12, 0.14, 1.0))
	draw_colored_polygon(right_wall_points, Color(0.13, 0.115, 0.13, 1.0))
	draw_colored_polygon(back_wall_points, Color(0.20, 0.17, 0.15, 1.0))
	draw_colored_polygon(floor_points, Color(0.24, 0.16, 0.10, 1.0))

	draw_polyline(_closed_points(floor_points), Color(0.78, 0.58, 0.32, 0.65), 2.0, true)
	draw_line(Vector2(245, 170), Vector2(965, 170), Color(0.95, 0.72, 0.42, 0.55), 3.0)
	draw_line(Vector2(245, 82), Vector2(965, 82), Color(0.06, 0.055, 0.05, 0.95), 6.0)

	_draw_window_placeholder()
	_draw_door_placeholder()
	_draw_floor_guides()


func _draw_window_placeholder() -> void:
	var window_rect := Rect2(Vector2(480, 96), Vector2(210, 50))
	draw_rect(window_rect, Color(0.025, 0.06, 0.12, 1.0), true)
	draw_rect(window_rect, Color(0.68, 0.82, 1.0, 0.42), false, 2.0)
	draw_line(window_rect.position + Vector2(window_rect.size.x * 0.5, 0), window_rect.position + Vector2(window_rect.size.x * 0.5, window_rect.size.y), Color(0.68, 0.82, 1.0, 0.35), 1.5)
	draw_line(window_rect.position + Vector2(0, window_rect.size.y * 0.52), window_rect.position + Vector2(window_rect.size.x, window_rect.size.y * 0.52), Color(0.68, 0.82, 1.0, 0.35), 1.5)


func _draw_door_placeholder() -> void:
	var door_points := PackedVector2Array([
		Vector2(1010, 205),
		Vector2(1065, 240),
		Vector2(1100, 390),
		Vector2(1042, 364),
	])
	draw_colored_polygon(door_points, Color(0.18, 0.12, 0.09, 1.0))
	draw_polyline(_closed_points(door_points), Color(0.84, 0.64, 0.38, 0.52), 2.0, true)


func _draw_floor_guides() -> void:
	for index in range(7):
		var t := float(index) / 6.0
		var left := Vector2(220, 350).lerp(Vector2(365, 650), t)
		var right := Vector2(965, 170).lerp(Vector2(1080, 555), t)
		draw_line(left, right, Color(0.10, 0.075, 0.055, 0.35), 1.0)


func _draw_collision_guides() -> void:
	for wall_data in WALL_BLOCKERS:
		draw_rect(wall_data["rect"], Color(0.95, 0.18, 0.12, 0.14), true)
		draw_rect(wall_data["rect"], Color(1.0, 0.26, 0.18, 0.55), false, 2.0)

	for object_data in ROOM_OBJECTS:
		if object_data.has("blocker"):
			draw_rect(object_data["blocker"], Color(1.0, 0.42, 0.10, 0.10), true)
			draw_rect(object_data["blocker"], Color(1.0, 0.42, 0.10, 0.58), false, 2.0)


func _draw_interaction_ranges() -> void:
	for object_data in ROOM_OBJECTS:
		var interaction_position: Vector2 = object_data["interact"]
		var radius := float(object_data["radius"])
		var color := Color(0.15, 0.95, 0.46, 0.30)
		var width := 1.5

		if not nearest_object.is_empty() and nearest_object["key"] == object_data["key"]:
			color = Color(1.0, 0.86, 0.22, 0.70)
			width = 3.0

		draw_arc(interaction_position, radius, 0.0, TAU, 56, color, width)
		draw_circle(interaction_position, 4.0, color)


func _closed_points(points: PackedVector2Array) -> PackedVector2Array:
	var closed := PackedVector2Array(points)
	if not closed.is_empty():
		closed.append(closed[0])
	return closed
